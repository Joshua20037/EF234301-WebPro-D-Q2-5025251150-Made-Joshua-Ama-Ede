<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Data Jadwal - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-6xl mx-auto bg-white p-6 rounded-xl shadow">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Daftar Jadwal Kuliah</h1>
                <div class="space-x-2">
                    <a href="form.jsp" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium">
                        + Tambah Jadwal
                    </a>
                </div>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b text-gray-600 text-sm">
                            <th class="p-3">Hari</th>
                            <th class="p-3">Jam</th>
                            <th class="p-3">Mata Kuliah & Kelas</th>
                            <th class="p-3">Dosen</th>
                            <th class="p-3">Ruangan</th>
                            <th class="p-3 text-center"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y text-sm">
                        <%
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(
                                "SELECT jd.*, k.nama_kelas, mk.kode_mk, mk.nama_mk, d.nama AS nama_dosen, r.nama_ruangan, r.gedung " +
                                "FROM jadwal jd " +
                                "JOIN kelas k ON jd.id_kelas = k.id_kelas " +
                                "JOIN mata_kuliah mk ON k.id_mk = mk.id_mk " +
                                "JOIN dosen d ON k.id_dosen = d.id_dosen " +
                                "JOIN ruangan r ON jd.id_ruangan = r.id_ruangan " +
                                "ORDER BY jd.hari, jd.jam_mulai ASC"
                            );
                            while (rs.next()) {
                                String jamMulai = rs.getTime("jam_mulai").toString().substring(0, 5);
                                String jamSelesai = rs.getTime("jam_selesai").toString().substring(0, 5);
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3 font-semibold"><%= rs.getString("hari") %></td>
                            <td class="p-3"><%= jamMulai %> - <%= jamSelesai %></td>
                            <td class="p-3">
                                <span class="font-semibold text-blue-700"><%= rs.getString("kode_mk") %></span>
                                <%= rs.getString("nama_mk") %> (Kelas <%= rs.getString("nama_kelas") %>)
                            </td>
                            <td class="p-3"><%= rs.getString("nama_dosen") %></td>
                            <td class="p-3"><%= rs.getString("nama_ruangan") %> (<%= rs.getString("gedung") %>)</td>
                            <td class="p-3 text-center space-x-2">
                                <a href="form.jsp?id=<%= rs.getInt("id_jadwal") %>" class="text-amber-600 hover:underline font-medium">Edit</a>
                                <a href="process.jsp?action=delete&id=<%= rs.getInt("id_jadwal") %>" 
                                   onclick="return confirm('Yakin ingin menghapus jadwal ini?')" 
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