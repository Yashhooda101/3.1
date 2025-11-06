<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head><title>Student Attendance</title></head>
<body>
  <h2>Attendance Form</h2>
  <form action="AttendanceServlet" method="post">
    Student ID: <input type="text" name="studentId"><br>
    Date: <input type="date" name="date"><br>
    Status: 
    <select name="status">
      <option value="Present">Present</option>
      <option value="Absent">Absent</option>
    </select><br>
    <input type="submit" value="Submit Attendance">
  </form>
</body>
</html>
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/your_database";
    private static final String JDBC_USER = "your_username";
    private static final String JDBC_PASS = "your_password";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentId = request.getParameter("studentId");
        String date = request.getParameter("date");
        String status = request.getParameter("status");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

            String query = "INSERT INTO Attendance (StudentID, Date, Status) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, studentId);
            ps.setString(2, date);
            ps.setString(3, status);

            int result = ps.executeUpdate();
            if (result > 0) {
                out.println("<h3>Attendance recorded successfully!</h3>");
            } else {
                out.println("<h3>Failed to record attendance.</h3>");
            }

            conn.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
}CREATE TABLE Attendance (
    StudentID VARCHAR(20),
    Date DATE,
    Status VARCHAR(10)
);
