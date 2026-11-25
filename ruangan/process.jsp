<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String action = request.getParameter("action");

    try {
        if ("create".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO ruangan (nama_ruangan, gedung, kapasitas, jenis) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, request.getParameter("nama_ruangan"));
            ps.setString(2, request.getParameter("gedung"));
            ps.setInt(3, Integer.parseInt(request.getParameter("kapasitas")));
            ps.setString(4, request.getParameter("jenis"));
            ps.executeUpdate();
            ps.close();

        } else if ("update".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE ruangan SET nama_ruangan=?, gedung=?, kapasitas=?, jenis=? WHERE id_ruangan=?"
            );
            ps.setString(1, request.getParameter("nama_ruangan"));
            ps.setString(2, request.getParameter("gedung"));
            ps.setInt(3, Integer.parseInt(request.getParameter("kapasitas")));
            ps.setString(4, request.getParameter("jenis"));
            ps.setInt(5, Integer.parseInt(request.getParameter("id_ruangan")));
            ps.executeUpdate();
            ps.close();

        } else if ("delete".equals(action)) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM ruangan WHERE id_ruangan=?");
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