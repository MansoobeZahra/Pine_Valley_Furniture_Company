<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Register.aspx.vb" Inherits="Register" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FeedBACK - Register</title>
    <link rel="stylesheet" href="Styles/Site.css" />
</head>
<body>
<form id="frmRegister" runat="server">
<div class="login-page">
    <div class="login-card" style="max-width:520px;">

        <div class="login-header">
            <div class="logo"></div>
            <h1>Create Account</h1>
            <p>Join FeedBACK and start surveying today</p>
        </div>

        <div class="login-body">

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="alert alert-danger"> <asp:Literal ID="litError" runat="server" /></div>
            </asp:Panel>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Your full name" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                        Display="Dynamic" CssClass="field-error" ErrorMessage="Required." />
                </div>
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose username" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUsername"
                        Display="Dynamic" CssClass="field-error" ErrorMessage="Required." />
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="you@email.com" TextMode="Email" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                    Display="Dynamic" CssClass="field-error" ErrorMessage="Required." />
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Min 6 characters" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                        Display="Dynamic" CssClass="field-error" ErrorMessage="Required." />
                </div>
                <div class="form-group">
                    <label class="form-label">Confirm Password</label>
                    <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" CssClass="form-control" placeholder="Repeat password" />
                    <asp:CompareValidator runat="server" ControlToValidate="txtConfirm"
                        ControlToCompare="txtPassword" Display="Dynamic"
                        CssClass="field-error" ErrorMessage="Passwords do not match." />
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Role</label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                    <asp:ListItem Value="3">Surveyor</asp:ListItem>
                    <asp:ListItem Value="2">Survey Builder</asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Create Account ->"
                CssClass="btn btn-danger btn-full btn-lg"
                OnClick="btnRegister_Click" style="margin-top:.5rem;" />

            <div style="text-align:center;margin-top:1rem;font-size:.875rem;color:#6c757d;">
                Already have an account? <a href="Login.aspx" style="color:#F73B31;font-weight:600;">Sign in</a>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>

