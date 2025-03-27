
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="Yinka Enoch Adedokun">
    <title>Login Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

     <style>
            .main-content {
                width: 60%; /* Increased the width of the container */
                height: 70%;
                border-radius: 20px;
                box-shadow: 0 5px 5px rgba(0,0,0,.4);
                margin: 10em auto;
                display: flex;
            }

            .company__info {
                background-color: #008080;
                border-top-left-radius: 20px;
                border-bottom-left-radius: 20px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                color: #fff;
                align-items: center; /* Centering the content */
                padding: 20px;
            }

            .company__logo img {
                max-width: 80%; /* Adjusts the logo image size */
                height: auto;
            }

            .fa-android {
                font-size: 3em;
            }

            @media screen and (max-width: 640px) {
                .main-content {
                    width: 90%;
                }

                .company__info {
                    display: none;
                }

                .login_form {
                    border-top-left-radius: 20px;
                    border-bottom-left-radius: 20px;
                }
            }

            @media screen and (min-width: 642px) and (max-width: 800px) {
                .main-content {
                    width: 70%;
                }
            }

            .row > h2 {
                color: #008080;
                margin-top: 2em; /* Added top margin to "Log In" title */
            }

            .login_form {
                background-color: #fff;
                border-top-right-radius: 20px;
                border-bottom-right-radius: 20px;
                border-top: 1px solid #ccc;
                border-right: 1px solid #ccc;
            }

            form {
                padding: 0 2em;
            }

            .form__input {
                width: 100%;
                border: 0px solid transparent;
                border-radius: 0;
                border-bottom: 1px solid #aaa;
                padding: 1em .5em .5em;
                padding-left: 2em;
                outline: none;
                margin: 1.5em auto;
                transition: all .5s ease;
            }

            .form__input:focus {
                border-bottom-color: #008080;
                box-shadow: 0 0 5px rgba(0,80,80,.4); 
                border-radius: 4px;
            }

            .btn {
                transition: all .5s ease;
                width: 70%;
                border-radius: 30px;
                color: #008080;
                font-weight: 600;
                background-color: #fff;
                border: 1px solid #008080;
                margin-top: 1.5em;
                margin-bottom: 1em;
            }

            .btn:hover, .btn:focus {
                background-color: #008080;
                color: #fff;
            }

            .center-submit-btn {
                display: flex;
                justify-content: center;
            }
        </style>
</head>
<body>

<!-- Main Content -->
<div class="container-fluid">
    <div class="row main-content bg-success text-center">
        <div class="col-md-4 text-center company__info">
            <div class="company__logo">
                <img src="img/login.png" alt="Company Logo">
            </div>
            <h4 class="company_title">Inventory Management System</h4>
        </div>
        <div class="col-md-8 col-xs-12 col-sm-12 login_form">
            <div class="container-fluid">
                <div class="row">
                    <h2>Log In</h2>
                </div>
                <div class="row">
                    <form action="Login" method="POST" class="form-group">
                        <div class="row">
                            <label for="username" class="sr-only">Username</label>
                            <input type="text" name="username" id="username" class="form__input" placeholder="Username" aria-label="Username" required>
                        </div>
                        <div class="row">
                            <label for="password" class="sr-only">Password</label>
                            <input type="password" name="password" id="password" class="form__input" placeholder="Password" aria-label="Password" required>
                        </div>

                        <div class="row center-submit-btn">
                            <input type="submit" value="Submit" class="btn">
                        </div>
                    </form>
                </div>
                
            </div>
        </div>
    </div>
</div>

<script>
// Assuming you want to show an alert if login fails
const loginError = false;  // Set this flag based on your login check
if (loginError) {
    Swal.fire({
        icon: 'error',
        title: 'Invalid username or password',
        text: 'Please try again.'
    });
}
</script>

</body>
</html>
