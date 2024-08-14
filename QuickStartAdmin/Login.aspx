<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="QuickStartAdmin.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Quick Start Admin</title>
    <meta charset="UTF-8">
    <link rel="icon" href="/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100&display=swap" rel="stylesheet">
    <!-- link href="https://fonts.cdnfonts.com/css/lato" rel="stylesheet" -->                
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/login.css?version=07042022">
</head>
<body>
    <div id="divloc"></div>
    <div class="login_form">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-8 col-md-12 col-sm-12 login_bg">
                    <div class="side_logo swingimage">
                        <img src="/img/qsalogo.png" style="max-width: 200px;">
                       
                    </div>
                </div>

                <div class="col-lg-4 col-md-12 col-sm-12 login-right-bg">
                    <form id="form1" runat="server" class="login100-form">
                        <img src="/img/qsalogo.png" class="mobile-logo">
                        <span class="login100-form-title">User Login
                        </span>
                        <p class="login-text">Please Enter your Username and Password to Sign in.</p>
                        <div class="wrap-input100 validate-input">
                            <asp:TextBox ID="txtLoginID" runat="server" placeholder="Username" CssClass="input100" ClientIDMode="Static"></asp:TextBox>
                            <span class="focus-input100"></span>
                            <span class="symbol-input100">
                                <i class="fa fa-user" aria-hidden="true"></i>
                            </span>
                        </div>

                        <div class="wrap-input100 validate-input">
                            <asp:TextBox ID="txtPassword" runat="server" placeholder="Password" TextMode="Password" CssClass="input100" ClientIDMode="Static"></asp:TextBox>
                            <span class="focus-input100"></span>
                            <span class="symbol-input100">
                                <i class="fa fa-lock" aria-hidden="true"></i>
                            </span>

                        </div>
                        <div class="clearfix"></div>
                        <div class="alert-danger" id="validLoginID" style="display: none;">
                            &nbsp; Enter Username!
                        </div>
                        <div class="alert-danger" id="validPwd" style="display: none;">
                            &nbsp;  Enter Password!
                        </div>
                        <div class="alert-danger" id="diverror" runat="server" visible="false">
                            &nbsp;  Invalid Username or Password!
                        </div>
                        <div class="container-login100-form-btn">

                            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="login100-form-btn" OnClientClick="return ValidateLogin();" OnClick="btnLogin_Click" />

                        </div>

                        <div class="text-center p-t-12">
                            <span class="txt1">Forgot
                            </span>
                          <a class="txt2" href="ForgotPassword.aspx">Password?</a>

                        </div>

                        <div class="text-center go_web">
                            <p>
                                For more information about product<br />
                                go to <a href="http://www.quickstartadmin.com/">www.quickstartadmin.com</a>
                            </p>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script type="text/javascript">
        function ValidateLogin() {
            var status = 1;
            if ($("#txtLoginID").val() == "") {
                $("#validLoginID").show();
                status = 0;
            }
            else {
                $("#validLoginID").hide();
            }
            if ($("#txtPassword").val() == "") {
                $("#validPwd").show();
                status = 0;
            }
            else {
                $("#validPwd").hide();
            }

            if (status == 0) {
                return false;
            }
            else {
                return true;
            }
        }
        var x = document.getElementById("divloc");
        function getLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(showPosition);
            } else {
                x.innerHTML = "Geolocation is not supported by this browser.";
            }
        }
        function showPosition(position) {
            x.innerHTML = "Latitude: " + position.coords.latitude +
                "<br>Longitude: " + position.coords.longitude;
        }
       // getLocation();

    </script>

</body>
</html>

