<%@page import="models.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="java.sql.*" %>

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

        String sql = "SELECT * FROM inventory WHERE status = 'IN STOCK'";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();

        // Loop through the result set and create a map for each item
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", rs.getInt("id"));
            item.put("quantity", rs.getInt("quantity"));
            item.put("item_name", rs.getString("item_name"));
            item.put("description", rs.getString("description"));
            

            // Add the map (item) to the list
            items.add(item);
        }

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
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
        <%
            String successMessage = request.getParameter("success");
            String errorMessage = request.getParameter("error");

            if (successMessage != null) {
        %>
            <script>
                Swal.fire({
                    icon: 'success',
                    title: 'Success!',
                    text: '<%= successMessage %>',
                    
                });
            </script>
        <%
            } else if (errorMessage != null) {
        %>
            <script>
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: '<%= errorMessage %>',
                    
                });
            </script>
        <%
            }
        %>

        <!-- Main Content -->
        <%
            if (items != null && !items.isEmpty()) {
        %>
        <div class="container mt-5">
            <h2 class="mb-4">Available Items</h2>
            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        
                        <th>Item Name</th>
                        <th>Description</th>
                        <th>Quantity</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Loop through each item and display its details
                        for (Map<String, Object> item : items) {
                    %>
                    <tr>
                        
                        <td><%= item.get("item_name") %></td>
                        <td><%= item.get("description") %></td>
                        <td><%= item.get("quantity") %></td>
                        <td>
                            <button class="btn btn-primary btn-sm" data-bs-toggle="modal" 
                                    data-bs-target="#getItemModal" 
                                    data-item-id="<%= item.get("id") %>" 
                                    data-item-user_id="<%= session.getAttribute("id") %>" 
                                    data-item-name="<%= item.get("item_name") %>" 
                                    data-item-quantity="<%= item.get("quantity") %>" 
                                    data-user-id="<%= session.getAttribute("user_id") %>">
                                <i class="fa fa-cart-plus"></i> Get Item
                            </button>
                        </td>
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

        <!-- Modal Script to pass data to select_item.jsp -->
        <script>
            const getItemButtons = document.querySelectorAll('.btn-primary');
            getItemButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Get data attributes
                    const itemId = button.getAttribute('data-item-id');
                    const userId = button.getAttribute('data-item-user_id');
                    const itemName = button.getAttribute('data-item-name');
                    const itemQuantity = button.getAttribute('data-item-quantity');
                    
                    // Pass data to select_item.jsp through a redirect
                    window.location.href = 'select_item.jsp?itemId=' + itemId + '&itemName=' + encodeURIComponent(itemName) + '&itemQuantity=' + itemQuantity + '&userId=' + userId;
                });
            });
        </script>
    </body>
</html>
