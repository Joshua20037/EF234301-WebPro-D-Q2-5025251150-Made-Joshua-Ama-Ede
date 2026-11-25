<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String action = request.getParameter("action");

    try {
        if ("create".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO kelas (nama_kelas, id_mk, id_dosen, tahun_ajaran, semester, kuota) VALUES (?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, request.getParameter("nama_kelas"));
            ps.setInt(2, Integer.parseInt(request.getParameter("id_mk")));
            ps.setInt(3, Integer.parseInt(request.getParameter("id_dosen")));
            ps.setString(4, request.getParameter("tahun_ajaran"));
            ps.setString(5, request.getParameter("semester"));
            ps.setInt(6, Integer.parseInt(request.getParameter("kuota")));
            ps.executeUpdate();
            ps.close();

        } else if ("update".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE kelas SET nama_kelas=?, id_mk=?, id_dosen=?, tahun_ajaran=?, semester=?, kuota=? WHERE id_kelas=?"
            );
            ps.setString(1, request.getParameter("nama_kelas"));
            ps.setInt(2, Integer.parseInt(request.getParameter("id_mk")));
            ps.setInt(3, Integer.parseInt(request.getParameter("id_dosen")));
            ps.setString(4, request.getParameter("tahun_ajaran"));
            ps.setString(5, request.getParameter("semester"));
            ps.setInt(6, Integer.parseInt(request.getParameter("kuota")));
            ps.setInt(7, Integer.parseInt(request.getParameter("id_kelas")));
            ps.executeUpdate();
            ps.close();

        } else if ("delete".equals(action)) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM kelas WHERE id_kelas=?");
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