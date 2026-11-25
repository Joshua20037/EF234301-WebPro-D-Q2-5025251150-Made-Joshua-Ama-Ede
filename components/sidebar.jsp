<%
    String base = request.getContextPath();
    String role = (String) session.getAttribute("role");
%>
<aside class="w-64 bg-slate-900 text-slate-200 min-h-screen flex flex-col justify-between p-4 shrink-0">
    <div>
        <div class="px-3 py-4 border-b border-slate-700 mb-4">
            <h2 class="text-xl font-bold text-white">DASHBOARD AKADEMIK</h2>
            <p class="text-xs text-slate-400 mt-1">
                <%= session.getAttribute("username") %> 
                <span class="uppercase bg-blue-600 text-white px-1.5 py-0.5 rounded ml-1"><%= role %></span>
            </p>
        </div>

        <nav class="space-y-1 text-sm">
            <a href="<%= base %>/dashboard.jsp" class="block px-3 py-2 rounded-lg hover:bg-slate-800">Dashboard</a>

            <% if ("admin".equals(role)) { %>
                <p class="px-3 pt-4 pb-1 text-xs font-semibold text-slate-500 uppercase">Master Data</p>
                <a href="<%= base %>/jurusan/" class="block px-3 py-2 rounded-lg hover:bg-slate-800">Jurusan</a>
                <a href="<%= base %>/dosen/" class="block px-3 py-2 rounded-lg hover:bg-slate-800">Dosen</a>
                <a href="<%= base %>/mahasiswa/" class="block px-3 py-2 rounded-lg hover:bg-slate-800">Mahasiswa</a>
                <a href="<%= base %>/matakuliah/" class="block px-3 py-2 rounded-lg hover:bg-slate-800">Mata Kuliah</a>
                <a href="<%= base %>/ruangan/" class="block px-3 py-2 rounded-lg hover:bg-slate-800">Ruangan</a>
                <a href="<%= base %>/kelas/" class="block px-3 py-2 rounded-lg hover:bg-slate-800">Kelas</a>
                <a href="<%= base %>/jadwal/" class="block px-3 py-2 rounded-lg hover:bg-slate-800">Jadwal</a>
            <% } %>

            <p class="px-3 pt-4 pb-1 text-xs font-semibold text-slate-500 uppercase">Akademik</p>
            <% if ("admin".equals(role) || "dosen".equals(role) || "mahasiswa".equals(role)) { %>
                <a href="<%= base %>/krs/" class="block px-3 py-2 rounded-lg hover:bg-slate-800">KRS</a>
                <a href="<%= base %>/nilai/" class="block px-3 py-2 rounded-lg hover:bg-slate-800">Nilai & KHS</a>
            <% } %>
        </nav>
    </div>

    <a href="<%= base %>/logout.jsp" class="block text-center bg-red-600/20 text-red-400 hover:bg-red-600 hover:text-white py-2 rounded-lg text-sm font-medium transition">
        Logout
    </a>
</aside>