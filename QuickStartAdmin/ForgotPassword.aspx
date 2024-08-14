<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="QuickStartAdmin.ForgotPassword" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Quick Start Admin</title>
    <meta charset="UTF-8">
    <link rel="icon" href="/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
               
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

                        <div id="divnotify" runat="server" visible="false" style="font-size:1.5rem">
                            &nbsp;  An reset link is send to your registered email id.
                        </div>
                        <div id="divforgotpassword" runat="server" visible="true">
                            <img src="/img/qsalogo.png" class="mobile-logo">
                            <span class="login100-form-title">Forgot Password
                            </span>
                            <p class="login-text">Please enter your Username we will sent you reset instructionon on your registered email Id.</p>
                            <div class="wrap-input100 validate-input">
                                <asp:TextBox ID="txtLoginID" runat="server" placeholder="Username" CssClass="input100" ClientIDMode="Static"></asp:TextBox>
                                <span class="focus-input100"></span>
                                <span class="symbol-input100">
                                    <i class="fa fa-user" aria-hidden="true"></i>
                                </span>
                            </div>

                            <div class="clearfix"></div>
                            <div class="alert-danger" id="validLoginID" style="display: none;">
                                &nbsp; Enter Username!
                            </div>
                            <div class="alert-danger" id="diverror" runat="server" visible="false">
                                &nbsp;  User not registered
                            </div>
                            <div class="container-login100-form-btn">

                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="login100-form-btn" OnClientClick="return ValidateUser();" OnClick="btnSubmit_Click" />

                            </div>
                            <div class="text-center p-t-12">
                                <span class="txt1">Back to 
                                </span>
                              <a class="txt2" href="Login.aspx">Login</a>

                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script type="text/javascript">
        function ValidateUser() {
            var status = 1;
            if ($("#txtLoginID").val() == "") {
                $("#validLoginID").show();
                status = 0;
            }
            else {
                $("#validLoginID").hide();
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

