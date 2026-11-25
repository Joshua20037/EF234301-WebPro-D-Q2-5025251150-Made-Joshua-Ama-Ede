<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String filterJurusan = request.getParameter("jurusan");
    String filterSemester = request.getParameter("semester");
    if (filterJurusan == null) filterJurusan = "";
    if (filterSemester == null) filterSemester = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Data Mata Kuliah - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-5xl mx-auto bg-white p-6 rounded-xl shadow">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">Daftar Mata Kuliah</h1>
                <a href="form.jsp" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium">
                    + Tambah Mata Kuliah
                </a>
            </div>

            <form method="GET" class="flex flex-wrap gap-3 mb-6 bg-gray-50 p-4 rounded-lg">
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

                <select name="semester" class="border rounded-lg px-3 py-2 text-sm bg-white">
                    <option value="">Semua Semester</option>
                    <% for (int s = 1; s <= 8; s++) { String sStr = String.valueOf(s); %>
                        <option value="<%= sStr %>" <%= sStr.equals(filterSemester) ? "selected" : "" %>>Semester <%= s %></option>
                    <% } %>
                </select>

                <button type="submit" class="bg-slate-800 hover:bg-slate-900 text-white px-4 py-2 rounded-lg text-sm">Filter</button>
                <a href="index.jsp" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm">Reset</a>
            </form>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b text-gray-600 text-sm">
                            <th class="p-3">Kode MK</th>
                            <th class="p-3">Nama Mata Kuliah</th>
                            <th class="p-3">SKS</th>
                            <th class="p-3">Semester</th>
                            <th class="p-3">Jurusan</th>
                            <th class="p-3 text-center"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y text-sm">
                        <%
                            StringBuilder sql = new StringBuilder(
                                "SELECT mk.*, j.nama_jurusan FROM mata_kuliah mk " +
                                "JOIN jurusan j ON mk.id_jurusan = j.id_jurusan WHERE 1=1 "
                            );
                            if (!filterJurusan.isEmpty()) sql.append("AND mk.id_jurusan = ? ");
                            if (!filterSemester.isEmpty()) sql.append("AND mk.semester = ? ");
                            sql.append("ORDER BY mk.semester ASC, mk.kode_mk ASC");

                            PreparedStatement ps = conn.prepareStatement(sql.toString());
                            int idx = 1;
                            if (!filterJurusan.isEmpty()) ps.setInt(idx++, Integer.parseInt(filterJurusan));
                            if (!filterSemester.isEmpty()) ps.setInt(idx++, Integer.parseInt(filterSemester));

                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                        %>
                        <tr class="hover:bg-gray-50">
                            <td class="p-3 font-semibold"><%= rs.getString("kode_mk") %></td>
                            <td class="p-3"><%= rs.getString("nama_mk") %></td>
                            <td class="p-3"><%= rs.getInt("sks") %></td>
                            <td class="p-3">Semester <%= rs.getInt("semester") %></td>
                            <td class="p-3"><%= rs.getString("nama_jurusan") %></td>
                            <td class="p-3 text-center space-x-2">
                                <a href="form.jsp?id=<%= rs.getInt("id_mk") %>" class="text-amber-600 hover:underline font-medium">Edit</a>
                                <a href="process.jsp?action=delete&id=<%= rs.getInt("id_mk") %>" 
                                   onclick="return confirm('Yakin ingin menghapus mata kuliah ini?')" 
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