<%@page import="models.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="java.sql.*" %>
<%@page import="models.stockPDFGenerator" %>


<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("../login.jsp");
    }

    // Fetching items from the database
    List<Map<String, Object>> items = new ArrayList<>();
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Establish the database connection
        connection = DBConnection.dbConn();  // Assuming DBConnection is your class for DB connection

        String sql = "SELECT * FROM inventory ";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();

        // Loop through the result set and create a map for each item
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", rs.getInt("id"));
            item.put("quantity", rs.getInt("quantity"));
            item.put("item_name", rs.getString("item_name"));
            item.put("description", rs.getString("description"));
            item.put("img_path", rs.getString("img_path"));
            item.put("status", rs.getString("status"));

            // Add the map (item) to the list
            items.add(item);
        }

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Handle PDF or Excel download based on the request type
    String type = request.getParameter("type");
    if (type != null) {
        if (type.equals("pdf")) {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=inventory.pdf");
            stockPDFGenerator.generatePDF(items, response);

        }
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Home Page</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>
        <!-- Include Navbar -->
<jsp:include page="/components/navbar.jsp"/>

        <!-- Check for success or error messages passed via URL parameters -->
        <!-- Main Content -->
        <%
            if (items != null && !items.isEmpty()) {
        %>
        <div class="container mt-5">
            <h2 class="mb-4">All Stock Items</h2>

            <!-- Export Buttons -->
            <div class="mb-3">
                <%
                    if ("Admin".equals(session.getAttribute("role"))) {
                %>
                <a href="stock.jsp?type=pdf" class="btn btn-danger">Download PDF</a>
                <%
                    }
                %>

                <!-- Table displaying items -->
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            
                            <th>Item Name</th>
                            <th>Description</th>
                            <th>Quantity</th>
                            <th>Availability</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // Loop through each item and display its details
                            for (Map<String, Object> item : items) {
                        %>
                        <tr>
                            <td><%= item.get("item_name")%></td>
                            <td><%= item.get("description")%></td>
                            <td><%= item.get("quantity")%></td>
                            <td><%= item.get("status")%></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <%
            } else {
            %>
            <div class="container mt-5">
                <p class="alert alert-warning">No items available at the moment.</p>
            </div>
            <%
                }
            %>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
