import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EmployeeServlet")
public class EmployeeServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/your_database";
    private static final String JDBC_USER = "your_username";
    private static final String JDBC_PASS = "your_password";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String empIdParam = request.getParameter("empId");
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
            Statement stmt = conn.createStatement();

            if (empIdParam != null && !empIdParam.isEmpty()) {
                // Search by Employee ID
                String query = "SELECT * FROM Employee WHERE EmpID = " + empIdParam;
                ResultSet rs = stmt.executeQuery(query);

                out.println("<h2>Employee Details</h2>");
                if (rs.next()) {
                    out.println("<table border='1'><tr><th>EmpID</th><th>Name</th><th>Salary</th></tr>");
                    out.println("<tr><td>" + rs.getInt("EmpID") + "</td><td>" +
                                rs.getString("Name") + "</td><td>" +
                                rs.getDouble("Salary") + "</td></tr></table>");
                } else {
                    out.println("No employee found with ID: " + empIdParam);
                }
            } else {
                // Display all employees
                String query = "SELECT * FROM Employee";
                ResultSet rs = stmt.executeQuery(query);

                out.println("<h2>All Employees</h2>");
                out.println("<table border='1'><tr><th>EmpID</th><th>Name</th><th>Salary</th></tr>");
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getInt("EmpID") + "</td><td>" +
                                rs.getString("Name") + "</td><td>" +
                                rs.getDouble("Salary") + "</td></tr>");
                }
                out.println("</table>");
            }

            conn.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }

        // Search form
        out.println("<h3>Search Employee by ID</h3>");
        out.println("<form method='get' action='EmployeeServlet'>");
        out.println("Enter EmpID: <input type='text' name='empId'>");
        out.println("<input type='submit' value='Search'>");
        out.println("</form>");
    }
}CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(100),
    Salary DOUBLE
);
