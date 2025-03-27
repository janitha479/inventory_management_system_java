<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
</head>
<body>
    <jsp:include page="components/navbar.jsp" />
    <section class="vh-100" style="background-color: #eee;">
        <div class="container h-100">
            <div class="row d-flex justify-content-center align-items-center h-100">
                <div class="col-lg-12 col-xl-11">
                    <div class="card text-black" style="border-radius: 25px;">
                        <div class="card-body p-md-5">
                            <div class="row justify-content-center">
                                <div class="col-md-10 col-lg-6 col-xl-5 order-2 order-lg-1">
                                    <p class="text-center h1 fw-bold mb-5 mx-1 mx-md-4 mt-4">Sign Up</p>

                                    <form action="SignIn" method="POST" class="mx-1 mx-md-4">
                                        <!-- Full Name -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                                            <div data-mdb-input-init class="form-outline flex-fill mb-0">
                                                <input type="text" class="form-control" id="fullName" name="fullName" required />
                                                <label class="form-label" for="fullName">Your Name</label>
                                            </div>
                                        </div>

                                        <!-- Username For Login -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-user-circle fa-lg me-3 fa-fw"></i>
                                            <div data-mdb-input-init class="form-outline flex-fill mb-0">
                                                <input type="text" class="form-control" id="username" name="username" required />
                                                <label class="form-label" for="username">Username For Login</label>
                                            </div>
                                        </div>

                                        <!-- Email Address -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-envelope fa-lg me-3 fa-fw"></i>
                                            <div data-mdb-input-init class="form-outline flex-fill mb-0">
                                                <input type="email" class="form-control" id="email" name="email" required />
                                                <label class="form-label" for="email">Your Email</label>
                                            </div>
                                        </div>

                                        <!-- Password -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-lock fa-lg me-3 fa-fw"></i>
                                            <div data-mdb-input-init class="form-outline flex-fill mb-0">
                                                <input type="password" class="form-control" id="password" name="password" required />
                                                <label class="form-label" for="password">Password</label>
                                            </div>
                                        </div>

                                        <!-- Repeat Password -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-key fa-lg me-3 fa-fw"></i>
                                            <div data-mdb-input-init class="form-outline flex-fill mb-0">
                                                <input type="password" class="form-control" id="repeatPassword" name="repeatPassword" required />
                                                <label class="form-label" for="repeatPassword">Repeat your password</label>
                                            </div>
                                        </div>

                                        <!-- Department -->
                                        <div class="d-flex flex-row align-items-center mb-4">
                                            <i class="fas fa-briefcase fa-lg me-3 fa-fw"></i>
                                            <div data-mdb-input-init class="form-outline flex-fill mb-0">
                                                <select class="form-select" id="department" name="department" required>
                                                    <option value="1">HR</option>
                                                    <option value="2">Finance</option>
                                                    <option value="3">Sales</option>
                                                    <option value="4">Marketing</option>
                                                    <option value="5">IT Support</option>
                                                </select>
                                                <label class="form-label" for="department">Department</label>
                                            </div>
                                        </div>

                                        <!-- Terms and Conditions -->
                                        <div class="form-check d-flex justify-content-center mb-5">
                                            <input class="form-check-input me-2" type="checkbox" value="" id="terms" required />
                                            <label class="form-check-label" for="terms">
                                                I agree all statements in <a href="#!">Terms of service</a>
                                            </label>
                                        </div>

                                        <!-- Submit Button -->
                                        <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                                            <button type="submit" class="btn btn-primary btn-lg">Register</button>
                                        </div>
                                    </form>

                                </div>
                                <div class="col-md-10 col-lg-6 col-xl-7 d-flex align-items-center order-1 order-lg-2">
                                    <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-registration/draw1.webp"
                                        class="img-fluid" alt="Sample image">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Optional JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    

    <!-- Display error message from the server (if any) -->
    <script>
        // Example: Displaying error messages, if any
        const errorMessage = '<%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>';
        if (errorMessage) {
            Swal.fire({
                icon: "error",
                title: "Oops...",
                text: errorMessage,
            });
        }
    </script>
</body>
</html>
