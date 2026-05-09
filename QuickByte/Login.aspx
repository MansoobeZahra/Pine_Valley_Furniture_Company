<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - QUICK byte</title>
    <link rel="stylesheet" href="login.css">
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="login-wrapper">
                <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                <h1>QuickByte</h1>
                <p class="subtitle">Taste the speed</p>
                
                <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>

                <div class="form-group">
                    <label for="txtEmail">Email:</label>
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="Enter your email" required="required"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password:</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" required="required"></asp:TextBox>
                </div>

                <div class="remember-forgot">
                    <label class="checkbox-label">
                        <asp:CheckBox ID="chkRememberMe" runat="server" />
                        Remember Me
                    </label>
                    <a href="#">Forgot Password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />

                <div class="links">
                    <p>Don't have an account? <a href="Register.aspx">Register here</a></p>
                    <p><a href="Default.aspx">Back to Home</a></p>
                </div>

                <div style="margin-top: 20px; padding: 15px; background: #fcf8ec; border: 1px solid #ba1010; border-radius: 10px; font-size: 13px; text-align: left;">
                    <h3 style="color: #ba1010; margin-bottom: 10px; font-size: 15px;">Test Credentials:</h3>
                    <p><strong>Admin:</strong> admin@quickbyte.com / Admin@123</p>
                    <p><strong>Customer:</strong> ali@example.com / Customer@123</p>
                    <p><strong>Restaurant:</strong> pizzapalace@quickbyte.com / Rest@123</p>
                    <p><strong>Rider:</strong> ahmed@rider.com / Rider@123</p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
