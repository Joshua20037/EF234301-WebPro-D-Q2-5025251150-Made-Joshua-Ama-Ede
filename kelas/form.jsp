<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String idParam = request.getParameter("id");
    boolean isEdit = (idParam != null && !idParam.isEmpty());

    String namaKelas = "", tahunAjaran = "2026/2027", semester = "ganjil";
    int idMk = 0, idDosen = 0, kuota = 40;

    if (isEdit) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM kelas WHERE id_kelas = ?");
        ps.setInt(1, Integer.parseInt(idParam));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            namaKelas = rs.getString("nama_kelas");
            idMk = rs.getInt("id_mk");
            idDosen = rs.getInt("id_dosen");
            tahunAjaran = rs.getString("tahun_ajaran");
            semester = rs.getString("semester");
            kuota = rs.getInt("kuota");
        }
        rs.close();
        ps.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "Tambah" %> Kelas - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-lg mx-auto bg-white p-6 rounded-xl shadow">
            <h1 class="text-xl font-bold text-gray-800 mb-6">
                <%= isEdit ? "Edit Data Kelas" : "Tambah Kelas Baru" %>
            </h1>

            <form action="process.jsp" method="POST" class="space-y-4">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id_kelas" value="<%= idParam %>">
                <% } %>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Mata Kuliah</label>
                    <select name="id_mk" required class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">Pilih Mata Kuliah</option>
                        <%
                            Statement stMk = conn.createStatement();
                            ResultSet rsMk = stMk.executeQuery("SELECT id_mk, kode_mk, nama_mk FROM mata_kuliah ORDER BY nama_mk");
                            while (rsMk.next()) {
                                int mId = rsMk.getInt("id_mk");
                        %>
                            <option value="<%= mId %>" <%= (mId == idMk) ? "selected" : "" %>>
                                <%= rsMk.getString("kode_mk") %> - <%= rsMk.getString("nama_mk") %>
                            </option>
                        <% } rsMk.close(); stMk.close(); %>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Dosen Pengampu</label>
                    <select name="id_dosen" required class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">Pilih Dosen</option>
                        <%
                            Statement stDos = conn.createStatement();
                            ResultSet rsDos = stDos.executeQuery("SELECT id_dosen, nama FROM dosen ORDER BY nama");
                            while (rsDos.next()) {
                                int dId = rsDos.getInt("id_dosen");
                        %>
                            <option value="<%= dId %>" <%= (dId == idDosen) ? "selected" : "" %>>
                                <%= rsDos.getString("nama") %>
                            </option>
                        <% } rsDos.close(); stDos.close(); %>
                    </select>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Kode Kelas</label>
                        <input type="text" name="nama_kelas" value="<%= namaKelas %>" required
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Cth: A">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Kuota</label>
                        <input type="number" name="kuota" value="<%= kuota %>" min="1" required
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tahun Ajaran</label>
                        <input type="text" name="tahun_ajaran" value="<%= tahunAjaran %>" required
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="2026/2027">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Semester</label>
                        <select name="semester" class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="ganjil" <%= "ganjil".equals(semester) ? "selected" : "" %>>Ganjil</option>
                            <option value="genap" <%= "genap".equals(semester) ? "selected" : "" %>>Genap</option>
                        </select>
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