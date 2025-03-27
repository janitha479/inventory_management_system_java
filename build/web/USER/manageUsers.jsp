<%@page import="models.User"%>
<%@page import="java.util.List"%>
<%
    // Ensure user is logged in and has "Admin" role
    if (session.getAttribute("username") == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        response.sendRedirect("../login.jsp"); // Redirect if not logged in or not an admin
    }
%>
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>
        <%
            int userId = (int) session.getAttribute("id");
            String fullName = (String) session.getAttribute("full_name");
        %>
       <jsp:include page="/components/navbar.jsp"/>

        <div class="container mt-5">
            <h1 class="mb-4">Manage Users</h1>
            <form action="UserController" method="GET" class="d-inline">
                <input type="hidden" name="action" value="add">
                <button type="submit" class="btn btn-success btn-sm">
                    <i class="fas fa-user-plus"></i> Add Admin
                </button>
            </form>
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Email</th>
                        <th>Full Name</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (users != null) {
                            for (User user : users) {
                    %>
                    <tr>
                        <td><%= user.getId()%></td>
                        <td><%= user.getUsername()%></td>
                        <td><%= user.getRole()%></td>
                        <td><%= user.getEmail()%></td>
                        <td><%= user.getFullName()%></td>
                        <td><%= user.getStatus()%></td>
                        <td>
                            <!-- Edit Button -->
                            <form action="UserController" method="GET" class="d-inline">
                                <input type="hidden" name="id" value="<%= user.getId()%>">
                                <input type="hidden" name="action" value="edit">
                                <button type="submit" class="btn btn-warning btn-sm">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                            </form>

                            <!-- Delete Button with SweetAlert -->
                            <button type="button" class="btn btn-danger btn-sm" onclick="confirmDelete(<%= user.getId()%>)">
                                <i class="fas fa-trash-alt"></i> Delete
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="7" class="text-center">No users found.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- JavaScript for SweetAlert -->
        <script>
            function confirmDelete(userId) {
                Swal.fire({
                    title: 'Are you sure?',
                    text: "You won't be able to revert this!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Yes, delete it!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Create a form dynamically and submit it
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = 'UserController';

                        // Hidden fields
                        const idField = document.createElement('input');
                        idField.type = 'hidden';
                        idField.name = 'id';
                        idField.value = userId;
                        form.appendChild(idField);

                        const actionField = document.createElement('input');
                        actionField.type = 'hidden';
                        actionField.name = 'action';
                        actionField.value = 'delete';
                        form.appendChild(actionField);

                        document.body.appendChild(form);
                        form.submit();
                    }
                });
            }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
