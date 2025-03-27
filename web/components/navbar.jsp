<%@page import="models.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Retrieve session data
    Integer userId = (Integer) session.getAttribute("id");
    String userImagePath = null;
    String userRole = (String) session.getAttribute("role"); // Fetch role from session

    if (userId != null) {
        // Database connection and query
        try (Connection connection = DBConnection.dbConn()) {
            String query = "SELECT img_path FROM users WHERE id = ?";
            try (PreparedStatement ps = connection.prepareStatement(query)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        userImagePath = rs.getString("img_path");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Default image if no user image path is found
    String profileImage = userImagePath != null ? "../" + userImagePath : "https://mdbcdn.b-cdn.net/img/new/avatars/2.webp";

    
    String homeLink = "User".equals(userRole) ? 
        request.getContextPath() + "/USER/items.jsp" : 
        request.getContextPath() + "/USER/dashboard.jsp";




%>

<nav class="navbar navbar-expand-lg navbar-light bg-body-tertiary">
    <div class="container-fluid">
        <!-- Toggle button -->
        <button
            class="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent"
            aria-expanded="false"
            aria-label="Toggle navigation"
            >
            <i class="fas fa-bars"></i>
        </button>

        <!-- Collapsible wrapper -->
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <!-- Navbar brand -->
            <a class="navbar-brand mt-2 mt-lg-0" href="<%= homeLink%>">IMS
                <img
                    src="${pageContext.request.contextPath}/img/logo.png"
                    height="25"
                    alt="MDB Logo"
                    loading="lazy"
                    />
            </a>
            <!-- Left links -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/USER/issued_items.jsp">Issued Items</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/USER/stock.jsp">Stock</a>
                </li>

                <!-- Show Add User and Manage User dropdown if role is Admin -->
                <% if ("Admin".equals(userRole)) { %>
                
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/USER/items.jsp">Available Items</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/InventoryController">inventory managment</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        User Management
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/signIn.jsp">Add User</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/UserController">Manage Users</a></li>
                    </ul>
                </li>

                <% }%>
            </ul>
        </div>

        <!-- Right elements -->
        <div class="d-flex align-items-center">
            <label><%= session.getAttribute("full_name")%></label>
            <!-- Avatar -->
            <div class="dropdown">
                <a
                    class="dropdown-toggle d-flex align-items-center hidden-arrow"
                    href="#"
                    id="navbarDropdownMenuAvatar"
                    role="button"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                    >
                    <img
                        src="<%= profileImage%>"
                        class="rounded-circle"
                        height="25"
                        alt="User Avatar"
                        loading="lazy"
                        />
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdownMenuAvatar">
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/USER/profile.jsp">My Profile</a>
                    </li>
                    <li>
                        <a class="dropdown-item btn btn-danger" onclick="confirmLogout()">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<script>
    function confirmLogout() {
        Swal.fire({
            title: 'Are you sure?',
            text: "You will be logged out.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, logout!'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '${pageContext.request.contextPath}/Logout'; // Redirect to logout
            }
        });
    }
</script>
