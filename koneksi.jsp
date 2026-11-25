<%@ page import="java.sql.*" %>
<%
    String dbUrl = "jdbc:postgresql://localhost:5432/siakad_db";
    String dbUser = "postgres";
    String dbPass = "7o$h123ed";

    Connection conn = null;
    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
    } catch (Exception e){
        out.println("Failted to connect database: " + e.getMessage());
    }
%>