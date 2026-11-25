<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%
    if ("mahasiswa".equals(currentRole)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<%@ include file="../koneksi.jsp" %>
<%
    String action = request.getParameter("action");

    try {
        if ("create".equals(action) || "update".equals(action)) {
            int idKrs = Integer.parseInt(request.getParameter("id_krs"));
            double tugas = Double.parseDouble(request.getParameter("tugas"));
            double uts = Double.parseDouble(request.getParameter("uts"));
            double uas = Double.parseDouble(request.getParameter("uas"));

            double nilaiAkhir = (0.30 * tugas) + (0.30 * uts) + (0.40 * uas);
            String nilaiHuruf = (nilaiAkhir >= 85) ? "A" :
                                (nilaiAkhir >= 70) ? "B" :
                                (nilaiAkhir >= 55) ? "C" :
                                (nilaiAkhir >= 40) ? "D" : "E";

            if ("create".equals(action)) {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO nilai (id_krs, tugas, uts, uas, nilai_akhir, nilai_huruf) VALUES (?, ?, ?, ?, ?, ?)"
                );
                ps.setInt(1, idKrs);
                ps.setDouble(2, tugas);
                ps.setDouble(3, uts);
                ps.setDouble(4, uas);
                ps.setDouble(5, nilaiAkhir);
                ps.setString(6, nilaiHuruf);
                ps.executeUpdate();
                ps.close();
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE nilai SET id_krs=?, tugas=?, uts=?, uas=?, nilai_akhir=?, nilai_huruf=? WHERE id_nilai=?"
                );
                ps.setInt(1, idKrs);
                ps.setDouble(2, tugas);
                ps.setDouble(3, uts);
                ps.setDouble(4, uas);
                ps.setDouble(5, nilaiAkhir);
                ps.setString(6, nilaiHuruf);
                ps.setInt(7, Integer.parseInt(request.getParameter("id_nilai")));
                ps.executeUpdate();
                ps.close();
            }

        } else if ("delete".equals(action)) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM nilai WHERE id_nilai=?");
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