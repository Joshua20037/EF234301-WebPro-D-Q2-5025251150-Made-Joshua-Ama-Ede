<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../koneksi.jsp" %>
<%
    String action = request.getParameter("action");

    try {
        if ("create".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO jurusan (kode, nama_jurusan, jenjang, ketua_jurusan) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, request.getParameter("kode"));
            ps.setString(2, request.getParameter("nama_jurusan"));
            ps.setString(3, request.getParameter("jenjang"));
            ps.setString(4, request.getParameter("ketua_jurusan"));
            ps.executeUpdate();
            ps.close();

        } else if ("update".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE jurusan SET kode=?, nama_jurusan=?, jenjang=?, ketua_jurusan=? WHERE id_jurusan=?"
            );
            ps.setString(1, request.getParameter("kode"));
            ps.setString(2, request.getParameter("nama_jurusan"));
            ps.setString(3, request.getParameter("jenjang"));
            ps.setString(4, request.getParameter("ketua_jurusan"));
            ps.setInt(5, Integer.parseInt(request.getParameter("id_jurusan")));
            ps.executeUpdate();
            ps.close();

        } else if ("delete".equals(action)) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM jurusan WHERE id_jurusan=?");
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