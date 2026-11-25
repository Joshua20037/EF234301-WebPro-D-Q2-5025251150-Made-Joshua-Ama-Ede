<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String idParam = request.getParameter("id");
    boolean isEdit = (idParam != null && !idParam.isEmpty());

    int idMhs = 0, idKelas = 0;
    String tahunAjaran = "2026/2027", status = "diajukan";

    if (isEdit) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM krs WHERE id_krs = ?");
        ps.setInt(1, Integer.parseInt(idParam));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            idMhs = rs.getInt("id_mhs");
            idKelas = rs.getInt("id_kelas");
            tahunAjaran = rs.getString("tahun_ajaran");
            status = rs.getString("status");
        }
        rs.close();
        ps.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "Ambil" %> KRS - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-lg mx-auto bg-white p-6 rounded-xl shadow">
            <h1 class="text-xl font-bold text-gray-800 mb-6">
                <%= isEdit ? "Edit Data KRS" : "Form Pengambilan KRS" %>
            </h1>

            <form action="process.jsp" method="POST" class="space-y-4">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id_krs" value="<%= idParam %>">
                <% } %>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Mahasiswa</label>
                    <select name="id_mhs" required class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">Pilih Mahasiswa</option>
                        <%
                            Statement stMhs = conn.createStatement();
                            ResultSet rsMhs = stMhs.executeQuery("SELECT id_mhs, nim, nama FROM mahasiswa ORDER BY nim");
                            while (rsMhs.next()) {
                                int mId = rsMhs.getInt("id_mhs");
                        %>
                            <option value="<%= mId %>" <%= (mId == idMhs) ? "selected" : "" %>>
                                <%= rsMhs.getString("nim") %> - <%= rsMhs.getString("nama") %>
                            </option>
                        <% } rsMhs.close(); stMhs.close(); %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kelas (Mata Kuliah)</label>
                    <select name="id_kelas" required class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">Pilih Kelas</option>
                        <%
                            Statement stKls = conn.createStatement();
                            ResultSet rsKls = stKls.executeQuery(
                                "SELECT k.id_kelas, k.nama_kelas, k.kuota, mk.kode_mk, mk.nama_mk, mk.sks " +
                                "FROM kelas k JOIN mata_kuliah mk ON k.id_mk = mk.id_mk ORDER BY mk.nama_mk"
                            );
                            while (rsKls.next()) {
                                int kId = rsKls.getInt("id_kelas");
                        %>
                            <option value="<%= kId %>" <%= (kId == idKelas) ? "selected" : "" %>>
                                <%= rsKls.getString("kode_mk") %> - <%= rsKls.getString("nama_mk") %> (Kelas <%= rsKls.getString("nama_kelas") %> | <%= rsKls.getInt("sks") %> SKS | Kuota: <%= rsKls.getInt("kuota") %>)
                            </option>
                        <% } rsKls.close(); stKls.close(); %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tahun Ajaran</label>
                    <input type="text" name="tahun_ajaran" value="<%= tahunAjaran %>" required
                           class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <% if (isEdit) { %>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select name="status" class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="diajukan" <%= "diajukan".equals(status) ? "selected" : "" %>>Diajukan</option>
                        <option value="disetujui" <%= "disetujui".equals(status) ? "selected" : "" %>>Disetujui</option>
                        <option value="ditolak" <%= "ditolak".equals(status) ? "selected" : "" %>>Ditolak</option>
                    </select>
                </div>
                <% } %>

                <div class="flex justify-end space-x-2 pt-4">
                    <a href="index.jsp" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm">Batal</a>
                    <button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-medium">Simpan</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>