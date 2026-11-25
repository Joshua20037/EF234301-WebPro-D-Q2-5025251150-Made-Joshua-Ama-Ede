<%@ page import="java.sql.*" %>
<%
    String dbHost = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "aws-0-ap-south-1.pooler.supabase.com";
    String dbPort = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "5432";
    String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "postgres";
    String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "postgres.gsthzfwshmkkqeqcohed";
    String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "7o$h123ed123";

    String sslMode = "localhost".equals(dbHost) ? "" : "?sslmode=require";
    String url = "jdbc:postgresql://" + dbHost + ":" + dbPort + "/" + dbName + sslMode;

    Connection conn = null;
    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);
    } catch (Exception e) {
        out.println("Koneksi database gagal: " + e.getMessage());
    }
%>