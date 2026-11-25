<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String q = request.getParameter("q");
    String filterJurusan = request.getParameter("jurusan");
    String filterAngkatan = request.getParameter("angkatan");
    if (q == null) q = "";
    if (filterJurusan == null) filterJurusan = "";
    if (filterAngkatan == null) filterAngkatan = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Data Mahasiswa - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-6xl mx-auto bg-white p-6 rounded-xl shadow">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Daftar Mahasiswa</h1>
                <a href="form.jsp" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium">
                    + Tambah Mahasiswa
                </a>
            </div>

            <form method="GET" class="flex flex-wrap gap-3 mb-6 bg-gray-50 p-4 rounded-lg">
                <input type="text" name="q" value="<%= q %>" placeholder="Cari Nama atau NIM"
                       class="border rounded-lg px-3 py-2 text-sm bg-white flex-1 min-w-[200px]">

                <select name="jurusan" class="border rounded-lg px-3 py-2 text-sm bg-white">
                    <option value="">Semua Jurusan</option>
                    <%
                        Statement stJur = conn.createStatement();
                        ResultSet rsJur = stJur.executeQuery("SELECT id_jurusan, nama_jurusan FROM jurusan ORDER BY nama_jurusan");
                        while (rsJur.next()) {
                            String jId = String.valueOf(rsJur.getInt("id_jurusan"));
                    %>
                        <option value="<%= jId %>" <%= jId.equals(filterJurusan) ? "selected" : "" %>>
                            <%= rsJur.getString("nama_jurusan") %>
                        </option>
                    <% } rsJur.close(); stJur.close(); %>
                </select>

                <input type="number" name="angkatan" value="<%= filterAngkatan %>" placeholder="Angkatan"
                       class="border rounded-lg px-3 py-2 text-sm bg-white w-44">

                <button type="submit" class="bg-slate-800 hover:bg-slate-900 text-white px-4 py-2 rounded-lg text-sm">Cari</button>
                <a href="index.jsp" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm">Reset</a>
            </form>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b text-gray-600 text-sm">
                            <th class="p-3">NIM</th>
                            <th class="p-3">Nama</th>
                            <th class="p-3">Angkatan</th>
                            <th class="p-3">Jurusan</th>
                            <th class="p-3">Dosen Wali</th>
                            <th class="p-3">Status</th>
                            <th class="p-3 text-center"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y text-sm">
                        <%
                            StringBuilder sql = new StringBuilder(
                                "SELECT m.*, j.nama_jurusan, d.nama AS nama_dosen " +
                                "FROM mahasiswa m " +
                                "JOIN jurusan j ON m.id_jurusan = j.id_jurusan " +
                                "LEFT JOIN dosen d ON m.id_dosen_wali = d.id_dosen WHERE 1=1 "
                            );
                            if (!q.isEmpty()) sql.append("AND (m.nama ILIKE ? OR m.nim ILIKE ?) ");
                            if (!filterJurusan.isEmpty()) sql.append("AND m.id_jurusan = ? ");
                            if (!filterAngkatan.isEmpty()) sql.append("AND m.angkatan = ? ");
                            sql.append("ORDER BY m.nim ASC");

                            PreparedStatement ps = conn.prepareStatement(sql.toString());
                            int idx = 1;
                            if (!q.isEmpty()) {
                                ps.setString(idx++, "%" + q + "%");
                                ps.setString(idx++, "%" + q + "%");
                            }
                            if (!filterJurusan.isEmpty()) ps.setInt(idx++, Integer.parseInt(filterJurusan));
                            if (!filterAngkatan.isEmpty()) ps.setInt(idx++, Integer.parseInt(filterAngkatan));

                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                                String status = rs.getString("status");
                                String badgeClass = "aktif".equals(status) ? "bg-green-100 text-green-700" :
                                                    "cuti".equals(status) ? "bg-amber-100 text-amber-700" : "bg-blue-100 text-blue-700";
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3 font-semibold"><%= rs.getString("nim") %></td>
                            <td class="p-3"><%= rs.getString("nama") %></td>
                            <td class="p-3"><%= rs.getInt("angkatan") %></td>
                            <td class="p-3"><%= rs.getString("nama_jurusan") %></td>
                            <td class="p-3"><%= rs.getString("nama_dosen") != null ? rs.getString("nama_dosen") : "-" %></td>
                            <td class="p-3">
                                <span class="uppercase px-2 py-1 rounded text-xs font-semibold <%= badgeClass %>">
                                    <%= status %>
                                </span>
                            </td>
                            <td class="p-3 text-center space-x-2">
                                <a href="form.jsp?id=<%= rs.getInt("id_mhs") %>" class="text-amber-600 hover:underline font-medium">Edit</a>
                                <a href="process.jsp?action=delete&id=<%= rs.getInt("id_mhs") %>" 
                                   onclick="return confirm('Yakin ingin menghapus mahasiswa ini?')" 
                                   class="text-red-600 hover:underline font-medium">Hapus</a>
                            </td>
                        </tr>
                        <%
                            }
                            rs.close();
                            ps.close();
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>
</html>