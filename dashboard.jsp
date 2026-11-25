<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="auth_check.jsp" %>
<%@ include file="koneksi.jsp" %>
<%
    int mhsAktif = 0, mhsLaki = 0, mhsPerempuan = 0, totalDosen = 0;
    int sudahKrs = 0, belumKrs = 0;
    double ipkTertinggi = 0.0;

    StringBuilder chartLabels = new StringBuilder();
    StringBuilder chartData = new StringBuilder();

    Statement st = conn.createStatement();

    ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM mahasiswa WHERE status = 'aktif'");
    if (rs.next()) mhsAktif = rs.getInt(1);
    rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM mahasiswa WHERE jenis_kelamin = 'L'");
    if (rs.next()) mhsLaki = rs.getInt(1);
    rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM mahasiswa WHERE jenis_kelamin = 'P'");
    if (rs.next()) mhsPerempuan = rs.getInt(1);
    rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM dosen");
    if (rs.next()) totalDosen = rs.getInt(1);
    rs.close();

    rs = st.executeQuery("SELECT COUNT(DISTINCT id_mhs) FROM krs WHERE status <> 'ditolak'");
    if (rs.next()) sudahKrs = rs.getInt(1);
    rs.close();

    rs = st.executeQuery(
        "SELECT COUNT(*) FROM mahasiswa WHERE status = 'aktif' " +
        "AND id_mhs NOT IN (SELECT DISTINCT id_mhs FROM krs WHERE status <> 'ditolak')"
    );
    if (rs.next()) belumKrs = rs.getInt(1);
    rs.close();

    rs = st.executeQuery(
        "SELECT COALESCE(MAX(ip), 0) FROM (" +
        "  SELECT SUM(CASE n.nilai_huruf " +
        "    WHEN 'A' THEN 4.0 WHEN 'B' THEN 3.0 WHEN 'C' THEN 2.0 WHEN 'D' THEN 1.0 ELSE 0.0 END * mk.sks) " +
        "    / NULLIF(SUM(mk.sks), 0) AS ip " +
        "  FROM nilai n " +
        "  JOIN krs ON n.id_krs = krs.id_krs " +
        "  JOIN kelas k ON krs.id_kelas = k.id_kelas " +
        "  JOIN mata_kuliah mk ON k.id_mk = mk.id_mk " +
        "  GROUP BY krs.id_mhs" +
        ") sub"
    );
    if (rs.next()) ipkTertinggi = rs.getDouble(1);
    rs.close();

    rs = st.executeQuery(
        "SELECT angkatan, COUNT(*) AS jml FROM mahasiswa " +
        "WHERE status = 'aktif' GROUP BY angkatan ORDER BY angkatan ASC"
    );
    boolean first = true;
    while (rs.next()) {
        if (!first) {
            chartLabels.append(",");
            chartData.append(",");
        }
        chartLabels.append("'").append(rs.getInt("angkatan")).append("'");
        chartData.append(rs.getInt("jml"));
        first = false;
    }
    rs.close();
    st.close();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Akademik</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-100 flex min-h-screen">
    <%@ include file="components/sidebar.jsp" %>

    <main class="flex-1 p-6">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-5">
            <div class="bg-[#C1FF94] text-black rounded shadow overflow-hidden">
                <div class="p-4 flex justify-between items-center">
                    <div>
                        <p class="text-xs font-semibold uppercase tracking-wide opacity-90">MAHASISWA AKTIF</p>
                        <p class="text-3xl font-bold mt-2"><%= mhsAktif %></p>
                    </div>
                    <i class="fa-solid fa-graduation-cap text-5xl opacity-25"></i>
                </div>
                <div class="bg-black/10 h-5"></div>
            </div>

            <div class="bg-[#94FBFF] text-gray-900 rounded shadow overflow-hidden">
                <div class="p-4 flex justify-between items-center">
                    <div>
                        <p class="text-xs font-semibold uppercase tracking-wide">MAHASISWA LAKI-LAKI</p>
                        <p class="text-3xl font-bold mt-2"><%= mhsLaki %></p>
                    </div>
                    <i class="fa-solid fa-person text-5xl opacity-25"></i>
                </div>
                <div class="bg-black/10 h-5"></div>
            </div>

            <div class="bg-[#F2A6F7] text-gray-900 rounded shadow overflow-hidden">
                <div class="p-4 flex justify-between items-center">
                    <div>
                        <p class="text-xs font-semibold uppercase tracking-wide">MAHASISWA PEREMPUAN</p>
                        <p class="text-3xl font-bold mt-2"><%= mhsPerempuan %></p>
                    </div>
                    <i class="fa-solid fa-person-dress text-5xl opacity-25"></i>
                </div>
                <div class="bg-black/10 h-5"></div>
            </div>

            <div class="bg-[#5475EB] text-gray-900 rounded shadow overflow-hidden">
                <div class="p-4 flex justify-between items-center">
                    <div>
                        <p class="text-xs font-semibold uppercase tracking-wide">DOSEN AKTIF</p>
                        <p class="text-3xl font-bold mt-2"><%= totalDosen %></p>
                    </div>
                    <i class="fa-solid fa-users text-5xl opacity-25"></i>
                </div>
                <div class="bg-black/10 h-5"></div>
            </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-6">
            <div class="bg-white rounded shadow flex overflow-hidden h-24">
                <div class="w-24 bg-[#C1FF94] text-black flex items-center justify-center shrink-0">
                    <i class="fa-regular fa-copy text-4xl"></i>
                </div>
                <div class="p-3 flex flex-col justify-between flex-1">
                    <p class="text-[11px] font-semibold text-gray-600 leading-tight uppercase">MAHASISWA TELAH KRS</p>
                    <p class="text-xl font-bold text-gray-800 text-right"><%= sudahKrs %></p>
                </div>
            </div>

            <div class="bg-white rounded shadow flex overflow-hidden h-24">
                <div class="w-24 bg-[#EB5454] text-gray-900 flex items-center justify-center shrink-0">
                    <i class="fa-regular fa-file text-4xl"></i>
                </div>
                <div class="p-3 flex flex-col justify-between flex-1">
                    <p class="text-[11px] font-semibold text-gray-600 leading-tight uppercase">MAHASISWA BELUM KRS</p>
                    <p class="text-xl font-bold text-gray-800 text-right"><%= belumKrs %></p>
                </div>
            </div>

            <div class="bg-white rounded shadow flex overflow-hidden h-24">
                <div class="w-24 bg-[#f0a843] text-gray-900 flex items-center justify-center shrink-0">
                    <i class="fa-regular fa-star text-4xl"></i>
                </div>
                <div class="p-3 flex flex-col justify-between flex-1">
                    <p class="text-[11px] font-semibold text-gray-600 leading-tight uppercase">IPS TERTINGGI</p>
                    <p class="text-xl font-bold text-gray-800 text-right"><%= String.format("%.2f", ipkTertinggi) %></p>
                </div>
            </div>

            <div class="bg-white rounded shadow flex overflow-hidden h-24">
                <div class="w-24 bg-[#EBC854] text-gray-900 flex items-center justify-center shrink-0">
                    <i class="fa-solid fa-star text-4xl"></i>
                </div>
                <div class="p-3 flex flex-col justify-between flex-1">
                    <p class="text-[11px] font-semibold text-gray-600 leading-tight uppercase">IPK TERTINGGI</p>
                    <p class="text-xl font-bold text-gray-800 text-right"><%= String.format("%.2f", ipkTertinggi) %></p>
                </div>
            </div>
        </div>

        <div class="bg-white rounded shadow border-t-4 border-[#3c8dbc] p-5">
            <div class="flex items-center justify-between border-b pb-3 mb-4">
                <h2 class="text-base font-semibold text-gray-700 flex items-center gap-2">
                    <i class="fa-solid fa-chart-column text-gray-600"></i>
                    Grafik Mahasiswa Aktif
                </h2>
            </div>
            <p class="text-center text-sm font-semibold text-gray-600 mb-4">GRAFIK JUMLAH MAHASISWA AKTIF PER ANGKATAN</p>
            <div class="h-72">
                <canvas id="trendChart"></canvas>
            </div>
        </div>
    </main>

    <script>
        const ctx = document.getElementById('trendChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: [<%= chartLabels.toString() %>],
                datasets: [{
                    label: 'Jumlah Mahasiswa Aktif',
                    data: [<%= chartData.toString() %>],
                    borderColor: '#6cb2eb',
                    backgroundColor: 'rgba(108, 178, 235, 0.15)',
                    pointBackgroundColor: '#6cb2eb',
                    pointRadius: 5,
                    borderWidth: 2,
                    tension: 0.2,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
    </script>
</body>
</html>