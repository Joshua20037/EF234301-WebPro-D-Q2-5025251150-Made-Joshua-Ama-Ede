<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Data Ruangan - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-5xl mx-auto bg-white p-6 rounded-xl shadow">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Daftar Ruangan</h1>
                <a href="form.jsp" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium">
                    + Tambah Ruangan
                </a>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b text-gray-600 text-sm">
                            <th class="p-3">Nama Ruangan</th>
                            <th class="p-3">Gedung</th>
                            <th class="p-3">Kapasitas</th>
                            <th class="p-3">Jenis</th>
                            <th class="p-3 text-center"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y text-sm">
                        <%
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM ruangan ORDER BY id_ruangan ASC");
                            while (rs.next()) {
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3 font-semibold"><%= rs.getString("nama_ruangan") %></td>
                            <td class="p-3"><%= rs.getString("gedung") %></td>
                            <td class="p-3"><%= rs.getInt("kapasitas") %> orang</td>
                            <td class="p-3">
                                <span class="uppercase px-2 py-1 rounded text-xs font-semibold <%= "lab".equals(rs.getString("jenis")) ? "bg-purple-100 text-purple-700" : "bg-blue-100 text-blue-700" %>">
                                    <%= rs.getString("jenis") %>
                                </span>
                            </td>
                            <td class="p-3 text-center space-x-2">
                                <a href="form.jsp?id=<%= rs.getInt("id_ruangan") %>" class="text-amber-600 hover:underline font-medium">Edit</a>
                                <a href="process.jsp?action=delete&id=<%= rs.getInt("id_ruangan") %>" 
                                   onclick="return confirm('Yakin ingin menghapus ruangan ini?')" 
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