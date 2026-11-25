<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String idParam = request.getParameter("id");
    boolean isEdit = (idParam != null && !idParam.isEmpty());

    String nidn = "", nama = "", email = "", noHp = "", alamat = "";
    int idJurusan = 0;

    if (isEdit) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM dosen WHERE id_dosen = ?");
        ps.setInt(1, Integer.parseInt(idParam));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            nidn = rs.getString("nidn");
            nama = rs.getString("nama");
            email = rs.getString("email") != null ? rs.getString("email") : "";
            noHp = rs.getString("no_hp") != null ? rs.getString("no_hp") : "";
            alamat = rs.getString("alamat") != null ? rs.getString("alamat") : "";
            idJurusan = rs.getInt("id_jurusan");
        }
        rs.close();
        ps.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit" : "Tambah" %> Dosen - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-lg mx-auto bg-white p-6 rounded-xl shadow">
            <h1 class="text-xl font-bold text-gray-800 mb-6">
                <%= isEdit ? "Edit Data Dosen" : "Tambah Dosen Baru" %>
            </h1>

            <form action="process.jsp" method="POST" class="space-y-4">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id_dosen" value="<%= idParam %>">
                <% } %>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">NIDN</label>
                    <input type="text" name="nidn" value="<%= nidn %>" required
                           class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nama Lengkap</label>
                    <input type="text" name="nama" value="<%= nama %>" required
                           class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                        <input type="email" name="email" value="<%= email %>"
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">No. HP</label>
                        <input type="text" name="no_hp" value="<%= noHp %>"
                               class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Alamat</label>
                    <textarea name="alamat" rows="2" class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"><%= alamat %></textarea>
                </div>

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

                <div class="flex justify-end space-x-2 pt-4">
                    <a href="index.jsp" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm">Batal</a>
                    <button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-medium">Simpan</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>