<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.SQLException" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@page import="models.DBConnection" %>
<%@page import="models.IssuedItem" %>
<%@page import="models.PDFGenerator" %>
<%@page import="models.ExcelGenerator" %>


<%
    // Ensure user is logged in and has "Admin" role
    if (session.getAttribute("username") == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        response.sendRedirect("../login.jsp"); // Redirect if not logged in or not an admin
    }

    // List to hold all issued items
    List<IssuedItem> issuedItems = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.dbConn(); // Get the DB connection
        String query = "SELECT * FROM issued_items_view";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        // Process the result set and store the issued items
        while (rs.next()) {
            IssuedItem item = new IssuedItem();
            item.setStatus(rs.getString("status"));
            item.setQuantity(rs.getInt("quantity"));
            item.setCreatedAt(rs.getTimestamp("created_at"));
            item.setItemName(rs.getString("item_name"));
            item.setFullName(rs.getString("full_name"));
            issuedItems.add(item);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendRedirect("USER/dashboard.jsp?error=database_error");
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Handle PDF or Excel download based on the request type
    String type = request.getParameter("type");
    
        // Handle PDF or Excel download based on the request type
    
    if (type != null) {
        if (type.equals("pdf")) {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=issued_items.pdf");
            PDFGenerator.generatePDF(issuedItems, response);
        } else if (type.equals("excel")) {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=issued_items.xlsx");
            ExcelGenerator.generateExcel(issuedItems, response);
        }
    }
    
%>

<%
    // Declare variables for counting users
    int userCount = 0;

    // Database connection setup
    try {
        conn = DBConnection.dbConn(); // Get the DB connection
        String query = "SELECT COUNT(id) AS user_count FROM users";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            userCount = rs.getInt("user_count"); // Get the count of users
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendRedirect("USER/dashboard.jsp?error=database_error");
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<%
    // Declare variables for counting total inventory items and counts for each status
    int totalInventoryCount = 0;
    int inStockCount = 0;
    int outOfStockCount = 0;

    // Database connection setup
    try {
        conn = DBConnection.dbConn(); // Get the DB connection

        // Query to count total items and count items by status
        String query = "SELECT status, COUNT(id) AS status_count FROM inventory GROUP BY status";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        // Process the result set to get the counts for total and each status
        while (rs.next()) {
            String status = rs.getString("status");
            int count = rs.getInt("status_count");

            if ("IN STOCK".equals(status)) {
                inStockCount = count; // Set the count for "IN STOCK"
            } else if ("OUT OF STOCK".equals(status)) {
                outOfStockCount = count; // Set the count for "OUT OF STOCK"
            }
        }

        // Query to get the total inventory items count
        String totalQuery = "SELECT COUNT(id) AS total_count FROM inventory";
        pstmt = conn.prepareStatement(totalQuery);
        rs = pstmt.executeQuery();

        // Get the total count
        if (rs.next()) {
            totalInventoryCount = rs.getInt("total_count");
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendRedirect("USER/dashboard.jsp?error=database_error");
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <style>
            .card {
                border-radius: 15px;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            }
            .card-body {
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
                height: 100%;
            }
            .table-responsive {
                max-height: 400px;
                overflow-y: auto;
            }
        </style>
    </head>
    <body>
        <%
            int userId = (int) session.getAttribute("id");
            String fullName = (String) session.getAttribute("full_name");
        %>
        <jsp:include page="/components/navbar.jsp"/>

        <div class="container mt-4">
            <h2>Welcome to <%= session.getAttribute("role")%> dashboard</h2>

            <!-- Dashboard cards -->
            <div class="row mt-4">
                <div class="col-sm-3">
                    <div class="card bg-success text-white mb-3">
                        <div class="card-header">Total Users</div>
                        <div class="card-body">
                            <h5 class="card-title">Total Users: <%= userCount%></h5>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card bg-primary text-white mb-3">
                        <div class="card-header">Total Inventory Items</div>
                        <div class="card-body">
                            <h5 class="card-title">Total Inventory Items: <%= totalInventoryCount%></h5>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card bg-warning text-white mb-3">
                        <div class="card-header">Items In Stock</div>
                        <div class="card-body">
                            <h5 class="card-title">Items In Stock: <%= inStockCount%></h5>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card bg-info text-white mb-3">
                        <div class="card-header">Items Out of Stock</div>
                        <div class="card-body">
                            <h5 class="card-title">Items Out of Stock: <%= outOfStockCount%></h5>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Issued items table -->
            <h3 class="mt-4">Issued Items</h3>
            <div class="mb-3">
                <a href="dashboard.jsp?type=pdf" class="btn btn-danger">Download PDF</a>
                
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>Item Status</th>
                            <th>Quantity</th>
                            <th>Issued/Returned At</th>
                            <th>Item</th>
                            <th>Full Name</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                            for (IssuedItem item : issuedItems) {
                        %>
                        <tr>
                            <td><%= item.getStatus()%></td>
                            <td><%= item.getQuantity()%></td>
                            <td><%= dateFormat.format(item.getCreatedAt())%></td>
                            <td><%= item.getItemName()%></td>
                            <td><%= item.getFullName()%></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
