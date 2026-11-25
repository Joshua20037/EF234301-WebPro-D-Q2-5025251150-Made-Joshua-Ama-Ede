<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Data Kelas - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-6xl mx-auto bg-white p-6 rounded-xl shadow">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Daftar Kelas</h1>
                <a href="form.jsp" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium">
                    + Tambah Kelas
                </a>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b text-gray-600 text-sm">
                            <th class="p-3">Mata Kuliah</th>
                            <th class="p-3">Kelas</th>
                            <th class="p-3">Dosen Pengampu</th>
                            <th class="p-3">Tahun Ajaran</th>
                            <th class="p-3">Semester</th>
                            <th class="p-3">Kuota</th>
                            <th class="p-3 text-center"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y text-sm">
                        <%
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(
                                "SELECT k.*, mk.kode_mk, mk.nama_mk, d.nama AS nama_dosen " +
                                "FROM kelas k " +
                                "JOIN mata_kuliah mk ON k.id_mk = mk.id_mk " +
                                "JOIN dosen d ON k.id_dosen = d.id_dosen " +
                                "ORDER BY k.tahun_ajaran DESC, mk.nama_mk ASC, k.nama_kelas ASC"
                            );
                            while (rs.next()) {
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3">
                                <span class="font-semibold text-blue-700"><%= rs.getString("kode_mk") %></span> - <%= rs.getString("nama_mk") %>
                            </td>
                            <td class="p-3 font-semibold"><%= rs.getString("nama_kelas") %></td>
                            <td class="p-3"><%= rs.getString("nama_dosen") %></td>
                            <td class="p-3"><%= rs.getString("tahun_ajaran") %></td>
                            <td class="p-3 capitalize"><%= rs.getString("semester") %></td>
                            <td class="p-3"><%= rs.getInt("kuota") %> mhs</td>
                            <td class="p-3 text-center space-x-2">
                                <a href="form.jsp?id=<%= rs.getInt("id_kelas") %>" class="text-amber-600 hover:underline font-medium">Edit</a>
                                <a href="process.jsp?action=delete&id=<%= rs.getInt("id_kelas") %>" 
                                   onclick="return confirm('Yakin ingin menghapus kelas ini?')" 
                                   class="text-red-600 hover:underline font-medium">Hapus</a>
                            </td>
                        </tr>
                        <%
                            }
                            rs.close();
                            stmt.close();
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>
</html>