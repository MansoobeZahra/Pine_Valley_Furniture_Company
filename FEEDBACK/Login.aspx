<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Feedback_Login" Debug="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="FeedBACK - Sign in to your survey account" />
    <title>FeedBACK - Login</title>
    <link rel="stylesheet" href="Styles/Site.css" />
</head>
<body>
<form id="frmLogin" runat="server">
<div class="login-page">
    <div class="login-card">

        <!-- Header -->
        <div class="login-header">
            <div class="logo"></div>
            <h1>FeedBACK</h1>
            <p>Online Survey Platform - Sign in to continue</p>
        </div>

        <!-- Body -->
        <div class="login-body">

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="alert alert-danger">
                     <asp:Literal ID="litError" runat="server" />
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                <div class="alert alert-success">
                    (Done) <asp:Literal ID="litSuccess" runat="server" />
                </div>
            </asp:Panel>

            <!-- Username -->
            <div class="form-group">
                <label class="form-label" for="txtUsername">Username</label>
                <div class="input-icon">
                    <span class="icon"></span>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"
                        placeholder="Enter your username" ClientIDMode="Static" />
                </div>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                    ControlToValidate="txtUsername" Display="Dynamic"
                    CssClass="field-error" ErrorMessage="Username is required." />
            </div>

            <!-- Password -->
            <div class="form-group">
                <label class="form-label" for="txtPassword">Password</label>
                <div class="input-icon">
                    <span class="icon"></span>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                        CssClass="form-control" placeholder="Enter your password" ClientIDMode="Static" />
                </div>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                    ControlToValidate="txtPassword" Display="Dynamic"
                    CssClass="field-error" ErrorMessage="Password is required." />
            </div>

            <!-- Submit -->
            <asp:Button ID="btnLogin" runat="server" Text="Sign In ->" CssClass="btn btn-danger btn-full btn-lg"
                OnClick="btnLogin_Click" style="margin-top:.5rem;" />

            <!-- Divider -->
            <div style="text-align:center;margin:1.25rem 0;color:#ccc;font-size:.85rem;">- or -</div>

            <a href="Register.aspx" class="btn btn-outline btn-full">
                 Create New Account
            </a>
        </div>

        <!-- Footer -->
        <div class="login-footer">
            <p>Default credentials: <strong>admin / Admin@123</strong></p>
        </div>
    </div>
</div>
</form>
</body>
</html>

