<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ include file="../auth_check.jsp" %>
<%@ include file="../koneksi.jsp" %>
<%
    String filterMhs = request.getParameter("id_mhs");
    if (filterMhs == null) filterMhs = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Nilai & KHS - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @media print {
            aside, .no-print { display: none !important; }
            main { padding: 0 !important; }
        }
    </style>
</head>
<body class="bg-gray-100 flex min-h-screen">
    <%@ include file="../components/sidebar.jsp" %>

    <main class="flex-1 p-8">
        <div class="max-w-6xl mx-auto">

            <% if ("mahasiswa".equals(currentRole)) {
                int userId = (Integer) session.getAttribute("user_id");
                int myMhsId = -1;
                String myNim = "", myNama = "", myJurusan = "";

                PreparedStatement psMhs = conn.prepareStatement(
                    "SELECT m.id_mhs, m.nim, m.nama, j.nama_jurusan " +
                    "FROM mahasiswa m JOIN jurusan j ON m.id_jurusan = j.id_jurusan " +
                    "WHERE m.id_user = ?"
                );
                psMhs.setInt(1, userId);
                ResultSet rsMhs = psMhs.executeQuery();
                if (rsMhs.next()) {
                    myMhsId = rsMhs.getInt("id_mhs");
                    myNim = rsMhs.getString("nim");
                    myNama = rsMhs.getString("nama");
                    myJurusan = rsMhs.getString("nama_jurusan");
                }
                rsMhs.close();
                psMhs.close();
            %>
                <div class="bg-white p-6 rounded-xl shadow mb-6 flex flex-wrap justify-between items-center gap-4">
                    <div>
                        <h1 class="text-2xl font-bold text-gray-800">Kartu Hasil Studi (KHS)</h1>
                        <% if (myMhsId != -1) { %>
                            <p class="text-sm text-gray-600 mt-1">
                                <span class="font-semibold"><%= myNim %></span> - <%= myNama %> (<%= myJurusan %>)
                            </p>
                        <% } %>
                    </div>
                    <button onclick="window.print()" class="no-print bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium">
                        Cetak KHS (PDF)
                    </button>
                </div>

                <% if (myMhsId == -1) { %>
                    <div class="bg-amber-50 border border-amber-200 text-amber-800 p-4 rounded-xl text-sm">
                        Akun Anda belum terhubung ke data mahasiswa. Silakan hubungi Admin.
                    </div>
                <% } else {
                    Map<String, List<Map<String, Object>>> perSemester = new LinkedHashMap<String, List<Map<String, Object>>>();

                    PreparedStatement psNilai = conn.prepareStatement(
                        "SELECT n.*, krs.tahun_ajaran, k.semester AS sem_kelas, mk.kode_mk, mk.nama_mk, mk.sks " +
                        "FROM nilai n " +
                        "JOIN krs ON n.id_krs = krs.id_krs " +
                        "JOIN kelas k ON krs.id_kelas = k.id_kelas " +
                        "JOIN mata_kuliah mk ON k.id_mk = mk.id_mk " +
                        "WHERE krs.id_mhs = ? " +
                        "ORDER BY krs.tahun_ajaran ASC, k.semester ASC, mk.kode_mk ASC"
                    );
                    psNilai.setInt(1, myMhsId);
                    ResultSet rsNilai = psNilai.executeQuery();

                    while (rsNilai.next()) {
                        String semLabel = rsNilai.getString("sem_kelas");
                        semLabel = semLabel.substring(0, 1).toUpperCase() + semLabel.substring(1);
                        String key = "Tahun Ajaran " + rsNilai.getString("tahun_ajaran") + " - Semester " + semLabel;

                        Map<String, Object> row = new HashMap<String, Object>();
                        row.put("kode_mk", rsNilai.getString("kode_mk"));
                        row.put("nama_mk", rsNilai.getString("nama_mk"));
                        row.put("sks", rsNilai.getInt("sks"));
                        row.put("tugas", rsNilai.getDouble("tugas"));
                        row.put("uts", rsNilai.getDouble("uts"));
                        row.put("uas", rsNilai.getDouble("uas"));
                        row.put("nilai_akhir", rsNilai.getDouble("nilai_akhir"));
                        row.put("nilai_huruf", rsNilai.getString("nilai_huruf"));

                        if (!perSemester.containsKey(key)) {
                            perSemester.put(key, new ArrayList<Map<String, Object>>());
                        }
                        perSemester.get(key).add(row);
                    }
                    rsNilai.close();
                    psNilai.close();

                    if (perSemester.isEmpty()) {
                %>
                    <div class="bg-white p-6 rounded-xl shadow text-center text-gray-500 text-sm">
                        Belum ada data nilai yang masuk.
                    </div>
                <%
                    } else {
                        int grandTotalSks = 0;
                        double grandTotalBobot = 0.0;

                        for (Map.Entry<String, List<Map<String, Object>>> entry : perSemester.entrySet()) {
                            String semesterTitle = entry.getKey();
                            List<Map<String, Object>> rows = entry.getValue();

                            int semSks = 0;
                            double semBobot = 0.0;
                %>
                    <div class="bg-white rounded-xl shadow mb-6 overflow-hidden">
                        <div class="bg-slate-800 text-white px-6 py-3 flex justify-between items-center">
                            <h2 class="font-semibold text-sm"><%= semesterTitle %></h2>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-gray-50 border-b text-gray-600 text-xs uppercase">
                                        <th class="p-3">Kode MK</th>
                                        <th class="p-3">Mata Kuliah</th>
                                        <th class="p-3">SKS</th>
                                        <th class="p-3">Tugas</th>
                                        <th class="p-3">UTS</th>
                                        <th class="p-3">UAS</th>
                                        <th class="p-3">Akhir</th>
                                        <th class="p-3">Huruf</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y text-sm">
                                    <%
                                        for (Map<String, Object> r : rows) {
                                            int sks = (Integer) r.get("sks");
                                            String huruf = (String) r.get("nilai_huruf");
                                            double bobot = "A".equals(huruf) ? 4.0 : "B".equals(huruf) ? 3.0 :
                                                           "C".equals(huruf) ? 2.0 : "D".equals(huruf) ? 1.0 : 0.0;
                                            semSks += sks;
                                            semBobot += (bobot * sks);
                                    %>
                                    <tr class="hover:bg-gray-50">
                                        <td class="p-3 font-semibold text-blue-700"><%= r.get("kode_mk") %></td>
                                        <td class="p-3"><%= r.get("nama_mk") %></td>
                                        <td class="p-3"><%= sks %></td>
                                        <td class="p-3"><%= r.get("tugas") %></td>
                                        <td class="p-3"><%= r.get("uts") %></td>
                                        <td class="p-3"><%= r.get("uas") %></td>
                                        <td class="p-3 font-semibold"><%= String.format("%.2f", (Double) r.get("nilai_akhir")) %></td>
                                        <td class="p-3">
                                            <span class="px-2 py-1 rounded text-xs font-bold bg-blue-100 text-blue-700"><%= huruf %></span>
                                        </td>
                                    </tr>
                                    <% }
                                        grandTotalSks += semSks;
                                        grandTotalBobot += semBobot;
                                        double ips = (semSks > 0) ? (semBobot / semSks) : 0.0;
                                    %>
                                </tbody>
                            </table>
                        </div>
                        <div class="bg-gray-50 px-6 py-3 border-t flex justify-between items-center text-sm">
                            <span class="text-gray-600">Total SKS Semester: <b class="text-gray-800"><%= semSks %> SKS</b></span>
                            <span class="text-gray-600">IPS: <b class="text-blue-700 text-base"><%= String.format("%.2f", ips) %></b></span>
                        </div>
                    </div>
                <%
                        }
                        double ipk = (grandTotalSks > 0) ? (grandTotalBobot / grandTotalSks) : 0.0;
                %>
                    <div class="bg-blue-600 text-white p-6 rounded-xl shadow flex justify-between items-center">
                        <div>
                            <p class="text-sm uppercase tracking-wide opacity-90">Kumulatif Seluruh Semester</p>
                            <p class="text-lg font-semibold mt-1">Total SKS Ditempuh: <%= grandTotalSks %> SKS</p>
                        </div>
                        <div class="text-right">
                            <p class="text-xs uppercase tracking-wide opacity-90">Indeks Prestasi Kumulatif (IPK)</p>
                            <p class="text-4xl font-bold mt-1"><%= String.format("%.2f", ipk) %></p>
                        </div>
                    </div>
                <%
                    }
                }
            %>

            <% } else { %>
                <div class="bg-white p-6 rounded-xl shadow">
                    <div class="flex justify-between items-center mb-6">
                        <h1 class="text-2xl font-bold text-gray-800">Daftar Nilai & KHS</h1>
                        <div class="space-x-2 no-print">
                            <button onclick="window.print()" class="bg-gray-200 hover:bg-gray-300 text-gray-800 px-4 py-2 rounded-lg text-sm font-medium">
                                Cetak KHS (PDF)
                            </button>
                            <a href="form.jsp" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium">
                                + Input Nilai
                            </a>
                        </div>
                    </div>

                    <form method="GET" class="flex flex-wrap gap-3 mb-6 bg-gray-50 p-4 rounded-lg no-print">
                        <select name="id_mhs" class="border rounded-lg px-3 py-2 text-sm bg-white flex-1">
                            <option value="">Semua Mahasiswa</option>
                            <%
                                Statement stM = conn.createStatement();
                                ResultSet rsM = stM.executeQuery("SELECT id_mhs, nim, nama FROM mahasiswa ORDER BY nim");
                                while (rsM.next()) {
                                    String mId = String.valueOf(rsM.getInt("id_mhs"));
                            %>
                                <option value="<%= mId %>" <%= mId.equals(filterMhs) ? "selected" : "" %>>
                                    <%= rsM.getString("nim") %> - <%= rsM.getString("nama") %>
                                </option>
                            <% } rsM.close(); stM.close(); %>
                        </select>
                        <button type="submit" class="bg-slate-800 hover:bg-slate-900 text-white px-4 py-2 rounded-lg text-sm">Tampilkan KHS</button>
                        <a href="index.jsp" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-lg text-sm">Reset</a>
                    </form>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-gray-50 border-b text-gray-600 text-sm">
                                    <th class="p-3">Mahasiswa</th>
                                    <th class="p-3">Mata Kuliah</th>
                                    <th class="p-3">SKS</th>
                                    <th class="p-3">Tugas</th>
                                    <th class="p-3">UTS</th>
                                    <th class="p-3">UAS</th>
                                    <th class="p-3">Akhir</th>
                                    <th class="p-3">Huruf</th>
                                    <th class="p-3 text-center no-print">Aksi</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y text-sm">
                                <%
                                    String sql = "SELECT n.*, krs.tahun_ajaran, m.nim, m.nama AS nama_mhs, mk.kode_mk, mk.nama_mk, mk.sks " +
                                                 "FROM nilai n " +
                                                 "JOIN krs ON n.id_krs = krs.id_krs " +
                                                 "JOIN mahasiswa m ON krs.id_mhs = m.id_mhs " +
                                                 "JOIN kelas k ON krs.id_kelas = k.id_kelas " +
                                                 "JOIN mata_kuliah mk ON k.id_mk = mk.id_mk ";
                                    if (!filterMhs.isEmpty()) sql += "WHERE m.id_mhs = ? ";
                                    sql += "ORDER BY m.nim, mk.kode_mk";

                                    PreparedStatement ps = conn.prepareStatement(sql);
                                    if (!filterMhs.isEmpty()) ps.setInt(1, Integer.parseInt(filterMhs));

                                    ResultSet rs = ps.executeQuery();
                                    int totalSks = 0;
                                    double totalBobotSks = 0.0;

                                    while (rs.next()) {
                                        int sks = rs.getInt("sks");
                                        String huruf = rs.getString("nilai_huruf");
                                        double bobot = "A".equals(huruf) ? 4.0 : "B".equals(huruf) ? 3.0 :
                                                       "C".equals(huruf) ? 2.0 : "D".equals(huruf) ? 1.0 : 0.0;
                                        totalSks += sks;
                                        totalBobotSks += (bobot * sks);
                                %>
                                <tr class="hover:bg-gray-50">
                                    <td class="p-3"><%= rs.getString("nim") %> - <%= rs.getString("nama_mhs") %></td>
                                    <td class="p-3"><%= rs.getString("kode_mk") %> - <%= rs.getString("nama_mk") %></td>
                                    <td class="p-3"><%= sks %></td>
                                    <td class="p-3"><%= rs.getDouble("tugas") %></td>
                                    <td class="p-3"><%= rs.getDouble("uts") %></td>
                                    <td class="p-3"><%= rs.getDouble("uas") %></td>
                                    <td class="p-3 font-semibold"><%= String.format("%.2f", rs.getDouble("nilai_akhir")) %></td>
                                    <td class="p-3">
                                        <span class="px-2 py-1 rounded text-xs font-bold bg-blue-100 text-blue-700"><%= huruf %></span>
                                    </td>
                                    <td class="p-3 text-center space-x-2 no-print">
                                        <a href="form.jsp?id=<%= rs.getInt("id_nilai") %>" class="text-amber-600 hover:underline font-medium">Edit</a>
                                        <a href="process.jsp?action=delete&id=<%= rs.getInt("id_nilai") %>" 
                                           onclick="return confirm('Yakin ingin menghapus nilai ini?')" 
                                           class="text-red-600 hover:underline font-medium">Hapus</a>
                                    </td>
                                </tr>
                                <%
                                    }
                                    rs.close();
                                    ps.close();
                                    double ips = (totalSks > 0) ? (totalBobotSks / totalSks) : 0.0;
                                %>
                            </tbody>
                        </table>
                    </div>

                    <% if (!filterMhs.isEmpty() && totalSks > 0) { %>
                    <div class="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg flex justify-between items-center">
                        <div>
                            <p class="text-sm text-blue-800 font-medium">Ringkasan KHS Mahasiswa</p>
                            <p class="text-xs text-blue-600">Total SKS Diambil: <b><%= totalSks %> SKS</b></p>
                        </div>
                        <div class="text-right">
                            <p class="text-xs text-blue-600">Indeks Prestasi (IPS/IPK)</p>
                            <p class="text-2xl font-bold text-blue-800"><%= String.format("%.2f", ips) %></p>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } %>

        </div>
    </main>
</body>
</html>