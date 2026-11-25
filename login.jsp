<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="koneksi.jsp" %>
<%
    if (session.getAttribute("user_id") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String errorMsg = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        PreparedStatement ps = conn.prepareStatement(
            "SELECT id_user, username, role FROM users WHERE username = ? AND password_hash = md5(?)"
        );
        ps.setString(1, user);
        ps.setString(2, pass);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("user_id", rs.getInt("id_user"));
            session.setAttribute("username", rs.getString("username"));
            session.setAttribute("role", rs.getString("role"));
            response.sendRedirect("dashboard.jsp");
            return;
        } else {
            errorMsg = "Username atau password salah!";
        }
        rs.close();
        ps.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - SIAKAD</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-900 min-h-screen flex items-center justify-center p-4">
    <div class="bg-white w-full max-w-md p-8 rounded-2xl shadow-xl">
        <h1 class="text-2xl font-bold text-slate-800 text-center">DASHBOARD AKADEMIK</h1>
        <p class="text-sm text-slate-500 text-center mt-1 mb-6">Silakan masuk menggunakan akun Anda</p>

        <% if (!errorMsg.isEmpty()) { %>
            <div class="bg-red-100 text-red-700 px-4 py-2 rounded-lg text-sm mb-4">
                <%= errorMsg %>
            </div>
        <% } %>

        <form method="POST" class="space-y-4">
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Username</label>
                <input type="text" name="username" required
                       class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Password</label>
                <input type="password" name="password" required
                       class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white py-2.5 rounded-lg font-medium transition">
                Masuk
            </button>
        </form>
    </div>
</body>
</html>