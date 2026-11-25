<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String action = request.getParameter("action");

    try {
        if ("create".equals(action)) {
            int idMhs = Integer.parseInt(request.getParameter("id_mhs"));
            int idKelas = Integer.parseInt(request.getParameter("id_kelas"));
            String tahunAjaran = request.getParameter("tahun_ajaran");

            PreparedStatement psKuota = conn.prepareStatement(
                "SELECT k.kuota, (SELECT COUNT(*) FROM krs WHERE id_kelas = k.id_kelas AND status <> 'ditolak') AS terisi " +
                "FROM kelas k WHERE k.id_kelas = ?"
            );
            psKuota.setInt(1, idKelas);
            ResultSet rsK = psKuota.executeQuery();
            if (rsK.next() && rsK.getInt("terisi") >= rsK.getInt("kuota")) {
                out.println("<h3 style='color:red;'>Gagal: Kuota kelas sudah penuh!</h3><a href='javascript:history.back()'>Kembali</a>");
                return;
            }
            rsK.close(); psKuota.close();

            PreparedStatement psSks = conn.prepareStatement(
                "SELECT COALESCE(SUM(mk.sks), 0) AS total_sks FROM krs " +
                "JOIN kelas k ON krs.id_kelas = k.id_kelas " +
                "JOIN mata_kuliah mk ON k.id_mk = mk.id_mk " +
                "WHERE krs.id_mhs = ? AND krs.tahun_ajaran = ? AND krs.status <> 'ditolak'"
            );
            psSks.setInt(1, idMhs);
            psSks.setString(2, tahunAjaran);
            ResultSet rsS = psSks.executeQuery();
            int currentSks = rsS.next() ? rsS.getInt("total_sks") : 0;
            rsS.close(); psSks.close();

            PreparedStatement psNewSks = conn.prepareStatement(
                "SELECT mk.sks FROM kelas k JOIN mata_kuliah mk ON k.id_mk = mk.id_mk WHERE k.id_kelas = ?"
            );
            psNewSks.setInt(1, idKelas);
            ResultSet rsNS = psNewSks.executeQuery();
            int addSks = rsNS.next() ? rsNS.getInt("sks") : 0;
            rsNS.close(); psNewSks.close();

            if (currentSks + addSks > 24) {
                out.println("<h3 style='color:red;'>Gagal: Total SKS melebihi batas maksimal 24 SKS! (Saat ini: " + currentSks + " SKS)</h3><a href='javascript:history.back()'>Kembali</a>");
                return;
            }

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO krs (id_mhs, id_kelas, tahun_ajaran, status) VALUES (?, ?, ?, 'diajukan')"
            );
            ps.setInt(1, idMhs);
            ps.setInt(2, idKelas);
            ps.setString(3, tahunAjaran);
            ps.executeUpdate();
            ps.close();

        } else if ("update".equals(action)) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE krs SET id_mhs=?, id_kelas=?, tahun_ajaran=?, status=? WHERE id_krs=?"
            );
            ps.setInt(1, Integer.parseInt(request.getParameter("id_mhs")));
            ps.setInt(2, Integer.parseInt(request.getParameter("id_kelas")));
            ps.setString(3, request.getParameter("tahun_ajaran"));
            ps.setString(4, request.getParameter("status"));
            ps.setInt(5, Integer.parseInt(request.getParameter("id_krs")));
            ps.executeUpdate();
            ps.close();

        } else if ("approve".equals(action) || "reject".equals(action)) {
            String newStatus = "approve".equals(action) ? "disetujui" : "ditolak";
            PreparedStatement ps = conn.prepareStatement("UPDATE krs SET status=? WHERE id_krs=?");
            ps.setString(1, newStatus);
            ps.setInt(2, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
            ps.close();

        } else if ("delete".equals(action)) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM krs WHERE id_krs=?");
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