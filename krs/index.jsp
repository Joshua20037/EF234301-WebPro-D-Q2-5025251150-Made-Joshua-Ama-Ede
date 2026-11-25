<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Data KRS - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-6xl mx-auto bg-white p-6 rounded-xl shadow">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Kartu Rencana Studi (KRS)</h1>
                <a href="form.jsp" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium">
                    + Ambil KRS
                </a>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b text-gray-600 text-sm">
                            <th class="p-3">Mahasiswa</th>
                            <th class="p-3">Mata Kuliah & Kelas</th>
                            <th class="p-3">SKS</th>
                            <th class="p-3">Tahun Ajaran</th>
                            <th class="p-3">Status</th>
                            <th class="p-3 text-center"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y text-sm">
                        <%
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(
                                "SELECT krs.*, m.nim, m.nama AS nama_mhs, k.nama_kelas, mk.kode_mk, mk.nama_mk, mk.sks " +
                                "FROM krs " +
                                "JOIN mahasiswa m ON krs.id_mhs = m.id_mhs " +
                                "JOIN kelas k ON krs.id_kelas = k.id_kelas " +
                                "JOIN mata_kuliah mk ON k.id_mk = mk.id_mk " +
                                "ORDER BY krs.id_krs DESC"
                            );
                            while (rs.next()) {
                                String st = rs.getString("status");
                                String badge = "disetujui".equals(st) ? "bg-green-100 text-green-700" :
                                               "ditolak".equals(st) ? "bg-red-100 text-red-700" : "bg-amber-100 text-amber-700";
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3">
                                <span class="font-semibold"><%= rs.getString("nim") %></span> - <%= rs.getString("nama_mhs") %>
                            </td>
                            <td class="p-3">
                                <span class="font-semibold text-blue-700"><%= rs.getString("kode_mk") %></span>
                                <%= rs.getString("nama_mk") %> (Kelas <%= rs.getString("nama_kelas") %>)
                            </td>
                            <td class="p-3"><%= rs.getInt("sks") %></td>
                            <td class="p-3"><%= rs.getString("tahun_ajaran") %></td>
                            <td class="p-3">
                                <span class="uppercase px-2 py-1 rounded text-xs font-semibold <%= badge %>"><%= st %></span>
                            </td>
                            <td class="p-3 text-center space-x-2">
                                <% if ("admin".equals(currentRole) || "dosen".equals(currentRole)) { %>
                                    <% if (!"disetujui".equals(st)) { %>
                                        <a href="process.jsp?action=approve&id=<%= rs.getInt("id_krs") %>" class="text-green-600 hover:underline font-medium">Setujui</a>
                                    <% } %>
                                    <% if (!"ditolak".equals(st)) { %>
                                        <a href="process.jsp?action=reject&id=<%= rs.getInt("id_krs") %>" class="text-orange-600 hover:underline font-medium">Tolak</a>
                                    <% } %>
                                    <a href="form.jsp?id=<%= rs.getInt("id_krs") %>" class="text-amber-600 hover:underline font-medium">Edit</a>
                                    <a href="process.jsp?action=delete&id=<%= rs.getInt("id_krs") %>" 
                                    onclick="return confirm('Yakin ingin menghapus KRS ini?')" 
                                    class="text-red-600 hover:underline font-medium">Hapus</a>
                                <% } else if ("mahasiswa".equals(currentRole) && "diajukan".equals(st)) { %>
                                    <a href="process.jsp?action=delete&id=<%= rs.getInt("id_krs") %>" 
                                    onclick="return confirm('Batalkan pengajuan KRS ini?')" 
                                    class="text-red-600 hover:underline font-medium">Batalkan</a>
                                <% } else { %>
                                    <span class="text-gray-400 text-xs">-</span>
                                <% } %>
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