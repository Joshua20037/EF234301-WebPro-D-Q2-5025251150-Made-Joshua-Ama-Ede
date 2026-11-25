<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../koneksi.jsp" %>
<%
    String idParam = request.getParameter("id");
    boolean isEdit = (idParam != null && !idParam.isEmpty());

    String kode = "", namaJurusan = "", jenjang = "S1", ketuaJurusan = "";

    if (isEdit) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM jurusan WHERE id_jurusan = ?");
        ps.setInt(1, Integer.parseInt(idParam));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            kode = rs.getString("kode");
            namaJurusan = rs.getString("nama_jurusan");
            jenjang = rs.getString("jenjang");
            ketuaJurusan = rs.getString("ketua_jurusan");
        }
        rs.close();
        ps.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "Tambah" %> Jurusan - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-lg mx-auto bg-white p-6 rounded-xl shadow">
        <h1 class="text-xl font-bold text-gray-800 mb-6">
            <%= isEdit ? "Edit Data Jurusan" : "Tambah Jurusan Baru" %>
        </h1>

        <form action="process.jsp" method="POST" class="space-y-4">
            <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
            <% if (isEdit) { %>
                <input type="hidden" name="id_jurusan" value="<%= idParam %>">
            <% } %>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Kode Jurusan</label>
                <input type="text" name="kode" value="<%= kode %>" required
                       class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Contoh: IF">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nama Jurusan</label>
                <input type="text" name="nama_jurusan" value="<%= namaJurusan %>" required
                       class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Contoh: Teknik Informatika">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jenjang</label>
                <select name="jenjang" class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="S1" <%= "S1".equals(jenjang) ? "selected" : "" %>>S1</option>
                    <option value="D3" <%= "D3".equals(jenjang) ? "selected" : "" %>>D3</option>
                </select>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Ketua Jurusan</label>
                <input type="text" name="ketua_jurusan" value="<%= ketuaJurusan %>"
                       class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Nama Ketua Jurusan">
            </div>

            <div class="flex justify-end space-x-2 pt-4">
                <a href="index.jsp" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm">Batal</a>
                <button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-medium">
                    Simpan
                </button>
            </div>
        </form>
    </div>
</body>
</html>