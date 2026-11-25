<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String action = request.getParameter("action");

    try {
        if ("create".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO dosen (nidn, nama, email, no_hp, alamat, id_jurusan) VALUES (?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, request.getParameter("nidn"));
            ps.setString(2, request.getParameter("nama"));
            ps.setString(3, request.getParameter("email"));
            ps.setString(4, request.getParameter("no_hp"));
            ps.setString(5, request.getParameter("alamat"));
            ps.setInt(6, Integer.parseInt(request.getParameter("id_jurusan")));
            ps.executeUpdate();
            ps.close();

        } else if ("update".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE dosen SET nidn=?, nama=?, email=?, no_hp=?, alamat=?, id_jurusan=? WHERE id_dosen=?"
            );
            ps.setString(1, request.getParameter("nidn"));
            ps.setString(2, request.getParameter("nama"));
            ps.setString(3, request.getParameter("email"));
            ps.setString(4, request.getParameter("no_hp"));
            ps.setString(5, request.getParameter("alamat"));
            ps.setInt(6, Integer.parseInt(request.getParameter("id_jurusan")));
            ps.setInt(7, Integer.parseInt(request.getParameter("id_dosen")));
            ps.executeUpdate();
            ps.close();

        } else if ("delete".equals(action)) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM dosen WHERE id_dosen=?");
            ps.setInt(1, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
            ps.close();
        }

        response.sendRedirect("index.jsp");
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>Terjadi Error: " + e.getMessage() + "</h3>");
        out.println("<a href='index.jsp'>Kembali</a>");
    }
%>