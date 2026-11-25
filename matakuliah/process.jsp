<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String action = request.getParameter("action");

    try {
        if ("create".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO mata_kuliah (kode_mk, nama_mk, sks, semester, id_jurusan) VALUES (?, ?, ?, ?, ?)"
            );
            ps.setString(1, request.getParameter("kode_mk"));
            ps.setString(2, request.getParameter("nama_mk"));
            ps.setInt(3, Integer.parseInt(request.getParameter("sks")));
            ps.setInt(4, Integer.parseInt(request.getParameter("semester")));
            ps.setInt(5, Integer.parseInt(request.getParameter("id_jurusan")));
            ps.executeUpdate();
            ps.close();

        } else if ("update".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE mata_kuliah SET kode_mk=?, nama_mk=?, sks=?, semester=?, id_jurusan=? WHERE id_mk=?"
            );
            ps.setString(1, request.getParameter("kode_mk"));
            ps.setString(2, request.getParameter("nama_mk"));
            ps.setInt(3, Integer.parseInt(request.getParameter("sks")));
            ps.setInt(4, Integer.parseInt(request.getParameter("semester")));
            ps.setInt(5, Integer.parseInt(request.getParameter("id_jurusan")));
            ps.setInt(6, Integer.parseInt(request.getParameter("id_mk")));
            ps.executeUpdate();
            ps.close();

        } else if ("delete".equals(action)) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM mata_kuliah WHERE id_mk=?");
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