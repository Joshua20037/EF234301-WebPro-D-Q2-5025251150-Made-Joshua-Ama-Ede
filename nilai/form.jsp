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
    String idParam = request.getParameter("id");
    boolean isEdit = (idParam != null && !idParam.isEmpty());

    int idKrs = 0;
    double tugas = 0, uts = 0, uas = 0;

    if (isEdit) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM nilai WHERE id_nilai = ?");
        ps.setInt(1, Integer.parseInt(idParam));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            idKrs = rs.getInt("id_krs");
            tugas = rs.getDouble("tugas");
            uts = rs.getDouble("uts");
            uas = rs.getDouble("uas");
        }
        rs.close();
        ps.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "Input" %> Nilai - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-lg mx-auto bg-white p-6 rounded-xl shadow">
            <h1 class="text-xl font-bold text-gray-800 mb-2">
                <%= isEdit ? "Edit Nilai Mahasiswa" : "Input Nilai Baru" %>
            </h1>

            <form action="process.jsp" method="POST" class="space-y-4">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id_nilai" value="<%= idParam %>">
                <% } %>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Data KRS</label>
                    <select name="id_krs" required class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">Pilih KRS Mahasiswa</option>
                        <%
                            Statement stKrs = conn.createStatement();
                            ResultSet rsKrs = stKrs.executeQuery(
                                "SELECT krs.id_krs, m.nim, m.nama, mk.nama_mk, k.nama_kelas " +
                                "FROM krs JOIN mahasiswa m ON krs.id_mhs = m.id_mhs " +
                                "JOIN kelas k ON krs.id_kelas = k.id_kelas " +
                                "JOIN mata_kuliah mk ON k.id_mk = mk.id_mk " +
                                "ORDER BY m.nim"
                            );
                            while (rsKrs.next()) {
                                int krsId = rsKrs.getInt("id_krs");
                        %>
                            <option value="<%= krsId %>" <%= (krsId == idKrs) ? "selected" : "" %>>
                                <%= rsKrs.getString("nim") %> (<%= rsKrs.getString("nama") %>) - <%= rsKrs.getString("nama_mk") %> [<%= rsKrs.getString("nama_kelas") %>]
                            </option>
                        <% } rsKrs.close(); stKrs.close(); %>
                    </select>
                </div>

                <div class="grid grid-cols-3 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tugas (30%)</label>
                        <input type="number" step="0.01" min="0" max="100" name="tugas" value="<%= tugas %>" required
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">UTS (30%)</label>
                        <input type="number" step="0.01" min="0" max="100" name="uts" value="<%= uts %>" required
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">UAS (40%)</label>
                        <input type="number" step="0.01" min="0" max="100" name="uas" value="<%= uas %>" required
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>

                <div class="flex justify-end space-x-2 pt-4">
                    <a href="index.jsp" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm">Batal</a>
                    <button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-medium">Simpan</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>