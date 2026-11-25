<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String currentRole = (String) session.getAttribute("role");
    String currentUsername = (String) session.getAttribute("username");
%>