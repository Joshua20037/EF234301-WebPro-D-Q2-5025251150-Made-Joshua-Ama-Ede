<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String idParam = request.getParameter("id");
    boolean isEdit = (idParam != null && !idParam.isEmpty());

    String hari = "Senin", jamMulai = "08:00", jamSelesai = "10:00";
    int idKelas = 0, idRuangan = 0;

    if (isEdit) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM jadwal WHERE id_jadwal = ?");
        ps.setInt(1, Integer.parseInt(idParam));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            idKelas = rs.getInt("id_kelas");
            idRuangan = rs.getInt("id_ruangan");
            hari = rs.getString("hari");
            jamMulai = rs.getTime("jam_mulai").toString().substring(0, 5);
            jamSelesai = rs.getTime("jam_selesai").toString().substring(0, 5);
        }
        rs.close();
        ps.close();
    }
    String[] daftarHari = {"Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"};
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "Tambah" %> Jadwal - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-lg mx-auto bg-white p-6 rounded-xl shadow">
            <h1 class="text-xl font-bold text-gray-800 mb-6">
                <%= isEdit ? "Edit Jadwal Kuliah" : "Tambah Jadwal Baru" %>
            </h1>

            <form action="process.jsp" method="POST" class="space-y-4">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id_jadwal" value="<%= idParam %>">
                <% } %>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kelas (Mata Kuliah)</label>
                    <select name="id_kelas" required class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">Pilih Kelas</option>
                        <%
                            Statement stKls = conn.createStatement();
                            ResultSet rsKls = stKls.executeQuery(
                                "SELECT k.id_kelas, k.nama_kelas, mk.nama_mk, d.nama AS nama_dosen " +
                                "FROM kelas k JOIN mata_kuliah mk ON k.id_mk = mk.id_mk " +
                                "JOIN dosen d ON k.id_dosen = d.id_dosen ORDER BY mk.nama_mk"
                            );
                            while (rsKls.next()) {
                                int kId = rsKls.getInt("id_kelas");
                        %>
                            <option value="<%= kId %>" <%= (kId == idKelas) ? "selected" : "" %>>
                                <%= rsKls.getString("nama_mk") %> - Kelas <%= rsKls.getString("nama_kelas") %> (<%= rsKls.getString("nama_dosen") %>)
                            </option>
                        <% } rsKls.close(); stKls.close(); %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Ruangan</label>
                    <select name="id_ruangan" required class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">Pilih Ruangan</option>
                        <%
                            Statement stRu = conn.createStatement();
                            ResultSet rsRu = stRu.executeQuery("SELECT id_ruangan, nama_ruangan, gedung FROM ruangan ORDER BY nama_ruangan");
                            while (rsRu.next()) {
                                int rId = rsRu.getInt("id_ruangan");
                        %>
                            <option value="<%= rId %>" <%= (rId == idRuangan) ? "selected" : "" %>>
                                <%= rsRu.getString("nama_ruangan") %> - <%= rsRu.getString("gedung") %>
                            </option>
                        <% } rsRu.close(); stRu.close(); %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Hari</label>
                    <select name="hari" class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <% for (String h : daftarHari) { %>
                            <option value="<%= h %>" <%= h.equals(hari) ? "selected" : "" %>><%= h %></option>
                        <% } %>
                    </select>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Jam Mulai</label>
                        <input type="time" name="jam_mulai" value="<%= jamMulai %>" required
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Jam Selesai</label>
                        <input type="time" name="jam_selesai" value="<%= jamSelesai %>" required
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