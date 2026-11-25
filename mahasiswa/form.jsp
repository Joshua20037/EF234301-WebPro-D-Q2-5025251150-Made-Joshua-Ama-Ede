<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String idParam = request.getParameter("id");
    boolean isEdit = (idParam != null && !idParam.isEmpty());

    String nim = "", nama = "", tglLahir = "", jk = "L", alamat = "", status = "aktif";
    int angkatan = 2025, idJurusan = 0, idDosenWali = 0;

    if (isEdit) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM mahasiswa WHERE id_mhs = ?");
        ps.setInt(1, Integer.parseInt(idParam));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            nim = rs.getString("nim");
            nama = rs.getString("nama");
            tglLahir = rs.getDate("tgl_lahir") != null ? rs.getDate("tgl_lahir").toString() : "";
            jk = rs.getString("jenis_kelamin") != null ? rs.getString("jenis_kelamin") : "L";
            alamat = rs.getString("alamat") != null ? rs.getString("alamat") : "";
            angkatan = rs.getInt("angkatan");
            idJurusan = rs.getInt("id_jurusan");
            idDosenWali = rs.getInt("id_dosen_wali");
            status = rs.getString("status");
        }
        rs.close();
        ps.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "Tambah" %> Mahasiswa - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-xl mx-auto bg-white p-6 rounded-xl shadow">
            <h1 class="text-xl font-bold text-gray-800 mb-6">
                <%= isEdit ? "Edit Data Mahasiswa" : "Tambah Mahasiswa Baru" %>
            </h1>

            <form action="process.jsp" method="POST" class="space-y-4">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id_mhs" value="<%= idParam %>">
                <% } %>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">NIM</label>
                        <input type="text" name="nim" value="<%= nim %>" required
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Angkatan</label>
                        <input type="number" name="angkatan" value="<%= angkatan %>" required
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nama Lengkap</label>
                    <input type="text" name="nama" value="<%= nama %>" required
                           class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <% if (!isEdit) { %>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Password Akun Login</label>
                    <input type="password" name="password" required
                           class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                           placeholder="Masukkan password untuk login mahasiswa">
                    <p class="text-xs text-gray-500 mt-1">Username login otomatis menggunakan NIM.</p>
                </div>
                <% } %>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Lahir</label>
                        <input type="date" name="tgl_lahir" value="<%= tglLahir %>"
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Jenis Kelamin</label>
                        <select name="jenis_kelamin" class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="L" <%= "L".equals(jk) ? "selected" : "" %>>Laki-laki</option>
                            <option value="P" <%= "P".equals(jk) ? "selected" : "" %>>Perempuan</option>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Alamat</label>
                    <textarea name="alamat" rows="2" class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"><%= alamat %></textarea>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Jurusan</label>
                        <select name="id_jurusan" required class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="">Pilih Jurusan</option>
                            <%
                                Statement stJur = conn.createStatement();
                                ResultSet rsJur = stJur.executeQuery("SELECT id_jurusan, nama_jurusan FROM jurusan ORDER BY nama_jurusan");
                                while (rsJur.next()) {
                                    int jId = rsJur.getInt("id_jurusan");
                            %>
                                <option value="<%= jId %>" <%= (jId == idJurusan) ? "selected" : "" %>>
                                    <%= rsJur.getString("nama_jurusan") %>
                                </option>
                            <% } rsJur.close(); stJur.close(); %>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Dosen Wali</label>
                        <select name="id_dosen_wali" class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="">Pilih Dosen Wali</option>
                            <%
                                Statement stDos = conn.createStatement();
                                ResultSet rsDos = stDos.executeQuery("SELECT id_dosen, nama FROM dosen ORDER BY nama");
                                while (rsDos.next()) {
                                    int dId = rsDos.getInt("id_dosen");
                            %>
                                <option value="<%= dId %>" <%= (dId == idDosenWali) ? "selected" : "" %>>
                                    <%= rsDos.getString("nama") %>
                                </option>
                            <% } rsDos.close(); stDos.close(); %>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select name="status" class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="aktif" <%= "aktif".equals(status) ? "selected" : "" %>>Aktif</option>
                        <option value="cuti" <%= "cuti".equals(status) ? "selected" : "" %>>Cuti</option>
                        <option value="lulus" <%= "lulus".equals(status) ? "selected" : "" %>>Lulus</option>
                    </select>
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