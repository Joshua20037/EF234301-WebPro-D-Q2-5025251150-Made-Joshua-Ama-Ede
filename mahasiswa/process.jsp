<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String action = request.getParameter("action");

    try {
        if ("create".equals(action)) {
            String nim = request.getParameter("nim");
            String pass = request.getParameter("password");
            if (pass == null || pass.trim().isEmpty()) {
                pass = "123456";
            }

            PreparedStatement psUser = conn.prepareStatement(
                "INSERT INTO users (username, password_hash, role) VALUES (?, md5(?), 'mahasiswa') RETURNING id_user"
            );
            psUser.setString(1, nim);
            psUser.setString(2, pass);
            ResultSet rsUser = psUser.executeQuery();
            int newUserId = 0;
            if (rsUser.next()) {
                newUserId = rsUser.getInt("id_user");
            }
            rsUser.close();
            psUser.close();

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO mahasiswa (nim, nama, tgl_lahir, jenis_kelamin, alamat, angkatan, id_jurusan, id_dosen_wali, status, id_user) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, nim);
            ps.setString(2, request.getParameter("nama"));

            String tgl = request.getParameter("tgl_lahir");
            if (tgl != null && !tgl.isEmpty()) ps.setDate(3, java.sql.Date.valueOf(tgl));
            else ps.setNull(3, Types.DATE);

            ps.setString(4, request.getParameter("jenis_kelamin"));
            ps.setString(5, request.getParameter("alamat"));
            ps.setInt(6, Integer.parseInt(request.getParameter("angkatan")));
            ps.setInt(7, Integer.parseInt(request.getParameter("id_jurusan")));

            String dw = request.getParameter("id_dosen_wali");
            if (dw != null && !dw.isEmpty()) ps.setInt(8, Integer.parseInt(dw));
            else ps.setNull(8, Types.INTEGER);

            ps.setString(9, request.getParameter("status"));
            ps.setInt(10, newUserId);
            ps.executeUpdate();
            ps.close();

        } else if ("update".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE mahasiswa SET nim=?, nama=?, tgl_lahir=?, jenis_kelamin=?, alamat=?, angkatan=?, id_jurusan=?, id_dosen_wali=?, status=? WHERE id_mhs=?"
            );
            ps.setString(1, request.getParameter("nim"));
            ps.setString(2, request.getParameter("nama"));

            String tgl = request.getParameter("tgl_lahir");
            if (tgl != null && !tgl.isEmpty()) ps.setDate(3, java.sql.Date.valueOf(tgl));
            else ps.setNull(3, Types.DATE);

            ps.setString(4, request.getParameter("jenis_kelamin"));
            ps.setString(5, request.getParameter("alamat"));
            ps.setInt(6, Integer.parseInt(request.getParameter("angkatan")));
            ps.setInt(7, Integer.parseInt(request.getParameter("id_jurusan")));

            String dw = request.getParameter("id_dosen_wali");
            if (dw != null && !dw.isEmpty()) ps.setInt(8, Integer.parseInt(dw));
            else ps.setNull(8, Types.INTEGER);

            ps.setString(9, request.getParameter("status"));
            ps.setInt(10, Integer.parseInt(request.getParameter("id_mhs")));
            ps.executeUpdate();
            ps.close();

        } else if ("delete".equals(action)) {
            int idMhs = Integer.parseInt(request.getParameter("id"));

            int idUser = 0;
            PreparedStatement psGet = conn.prepareStatement("SELECT id_user FROM mahasiswa WHERE id_mhs=?");
            psGet.setInt(1, idMhs);
            ResultSet rsGet = psGet.executeQuery();
            if (rsGet.next()) idUser = rsGet.getInt("id_user");
            rsGet.close();
            psGet.close();

            PreparedStatement ps = conn.prepareStatement("DELETE FROM mahasiswa WHERE id_mhs=?");
            ps.setInt(1, idMhs);
            ps.executeUpdate();
            ps.close();

            if (idUser > 0) {
                PreparedStatement psDelUser = conn.prepareStatement("DELETE FROM users WHERE id_user=?");
                psDelUser.setInt(1, idUser);
                psDelUser.executeUpdate();
                psDelUser.close();
            }
        }

        response.sendRedirect("index.jsp");
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>Terjadi Error: " + e.getMessage() + "</h3>");
        out.println("<a href='index.jsp'>Kembali</a>");
    }
%>