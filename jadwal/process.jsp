<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String action = request.getParameter("action");

    try {
        if ("create".equals(action) || "update".equals(action)) {
            int idKelas = Integer.parseInt(request.getParameter("id_kelas"));
            int idRuangan = Integer.parseInt(request.getParameter("id_ruangan"));
            String hari = request.getParameter("hari");
            java.sql.Time jamMulai = java.sql.Time.valueOf(request.getParameter("jam_mulai") + ":00");
            java.sql.Time jamSelesai = java.sql.Time.valueOf(request.getParameter("jam_selesai") + ":00");
            int excludeId = "update".equals(action) ? Integer.parseInt(request.getParameter("id_jadwal")) : -1;

            // 1. Cek bentrok ruangan
            PreparedStatement psCekRuang = conn.prepareStatement(
                "SELECT COUNT(*) FROM jadwal WHERE id_ruangan = ? AND hari = ? AND id_jadwal <> ? " +
                "AND (jam_mulai < ? AND jam_selesai > ?)"
            );
            psCekRuang.setInt(1, idRuangan);
            psCekRuang.setString(2, hari);
            psCekRuang.setInt(3, excludeId);
            psCekRuang.setTime(4, jamSelesai);
            psCekRuang.setTime(5, jamMulai);
            ResultSet rsR = psCekRuang.executeQuery();
            if (rsR.next() && rsR.getInt(1) > 0) {
                out.println("<h3 style='color:red;'>Gagal: Jadwal bentrok dengan kelas lain di ruangan yang sama!</h3><a href='javascript:history.back()'>Kembali</a>");
                return;
            }
            rsR.close(); psCekRuang.close();

            // 2. Cek bentrok dosen
            PreparedStatement psCekDosen = conn.prepareStatement(
                "SELECT COUNT(*) FROM jadwal jd JOIN kelas k ON jd.id_kelas = k.id_kelas " +
                "WHERE k.id_dosen = (SELECT id_dosen FROM kelas WHERE id_kelas = ?) " +
                "AND jd.hari = ? AND jd.id_jadwal <> ? AND (jd.jam_mulai < ? AND jd.jam_selesai > ?)"
            );
            psCekDosen.setInt(1, idKelas);
            psCekDosen.setString(2, hari);
            psCekDosen.setInt(3, excludeId);
            psCekDosen.setTime(4, jamSelesai);
            psCekDosen.setTime(5, jamMulai);
            ResultSet rsD = psCekDosen.executeQuery();
            if (rsD.next() && rsD.getInt(1) > 0) {
                out.println("<h3 style='color:red;'>Gagal: Dosen pengampu sudah memiliki jadwal mengajar di jam tersebut!</h3><a href='javascript:history.back()'>Kembali</a>");
                return;
            }
            rsD.close(); psCekDosen.close();

            if ("create".equals(action)) {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO jadwal (id_kelas, id_ruangan, hari, jam_mulai, jam_selesai) VALUES (?, ?, ?, ?, ?)"
                );
                ps.setInt(1, idKelas);
                ps.setInt(2, idRuangan);
                ps.setString(3, hari);
                ps.setTime(4, jamMulai);
                ps.setTime(5, jamSelesai);
                ps.executeUpdate();
                ps.close();
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE jadwal SET id_kelas=?, id_ruangan=?, hari=?, jam_mulai=?, jam_selesai=? WHERE id_jadwal=?"
                );
                ps.setInt(1, idKelas);
                ps.setInt(2, idRuangan);
                ps.setString(3, hari);
                ps.setTime(4, jamMulai);
                ps.setTime(5, jamSelesai);
                ps.setInt(6, excludeId);
                ps.executeUpdate();
                ps.close();
            }

        } else if ("delete".equals(action)) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM jadwal WHERE id_jadwal=?");
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