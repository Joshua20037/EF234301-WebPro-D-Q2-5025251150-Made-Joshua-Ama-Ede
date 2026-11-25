<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Data Dosen - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-6xl mx-auto bg-white p-6 rounded-xl shadow">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Daftar Dosen</h1>
                <a href="form.jsp" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium">
                    + Tambah Dosen
                </a>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b text-gray-600 text-sm">
                            <th class="p-3">NIDN</th>
                            <th class="p-3">Nama Dosen</th>
                            <th class="p-3">Email</th>
                            <th class="p-3">No. HP</th>
                            <th class="p-3">Jurusan</th>
                            <th class="p-3 text-center"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y text-sm">
                        <%
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(
                                "SELECT d.*, j.nama_jurusan FROM dosen d " +
                                "JOIN jurusan j ON d.id_jurusan = j.id_jurusan ORDER BY d.id_dosen ASC"
                            );
                            while (rs.next()) {
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3 font-semibold"><%= rs.getString("nidn") %></td>
                            <td class="p-3"><%= rs.getString("nama") %></td>
                            <td class="p-3"><%= rs.getString("email") != null ? rs.getString("email") : "-" %></td>
                            <td class="p-3"><%= rs.getString("no_hp") != null ? rs.getString("no_hp") : "-" %></td>
                            <td class="p-3"><%= rs.getString("nama_jurusan") %></td>
                            <td class="p-3 text-center space-x-2">
                                <a href="form.jsp?id=<%= rs.getInt("id_dosen") %>" class="text-amber-600 hover:underline font-medium">Edit</a>
                                <a href="process.jsp?action=delete&id=<%= rs.getInt("id_dosen") %>" 
                                   onclick="return confirm('Yakin ingin menghapus dosen ini?')" 
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