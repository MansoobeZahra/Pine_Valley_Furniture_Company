<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Signup.aspx.vb" Inherits="SignupPage" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Sign Up - PVFC Lab 06</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f0f0; }
        .header { background-color: #583937; color: white; padding: 20px; text-align: center; }
        .header h1 { margin: 0; font-size: 22px; }
        .header p  { margin: 4px 0 0; font-size: 13px; }
        .box { width: 420px; margin: 40px auto; background: white; border: 1px solid #ccc;
               border-radius: 6px; padding: 28px; box-shadow: 0 2px 8px rgba(0,0,0,0.12); }
        .box h2 { margin-top: 0; color: #583937; }
        table td { padding: 6px 4px; vertical-align: top; }
        table td:first-child { font-weight: bold; width: 120px; }
        input[type=text], input[type=password] { width: 200px; padding: 4px; }
        .btn { background:#583937; color:white; border:none; padding:8px 22px;
               cursor:pointer; border-radius:3px; margin-top:8px; }
        .btn:hover { background:#7a504e; }
        hr { margin: 16px 0; border-color: #ddd; }
        small { color: #777; }
    </style>
</head>
<body>
    <div class="header">
        <h1><img src="logo.png" alt="PVFC" height="40" style="vertical-align:middle;" />
            Pine Valley Furniture Company</h1>
        <p>Mansoob-e-Zahra | Lab 07</p>
    </div>
    <form id="form1" runat="server">
        <div class="box">
            <h2>New Customer Sign Up</h2>
            <asp:Label ID="lblMessage" runat="server" Font-Bold="true" Visible="false" />
            <br />
            <hr />
            <b>Login Credentials</b>
            <table>
                <tr>
                    <td>Username:</td>
                    <td>
                        <asp:TextBox ID="txtUsername" runat="server" Width="200px" />
                        <asp:RequiredFieldValidator ID="rfvUser" runat="server"
                            ControlToValidate="txtUsername" ErrorMessage=" *" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="200px" />
                        <asp:RequiredFieldValidator ID="rfvPass" runat="server"
                            ControlToValidate="txtPassword" ErrorMessage=" *" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
            </table>
            <hr />
            <b>Customer Information</b>
            <table>
                <tr>
                    <td>First Name:</td>
                    <td>
                        <asp:TextBox ID="txtFirstName" runat="server" Width="140px" />
                        <asp:RequiredFieldValidator ID="rfvFN" runat="server"
                            ControlToValidate="txtFirstName" ErrorMessage=" *" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>Last Name:</td>
                    <td>
                        <asp:TextBox ID="txtLastName" runat="server" Width="140px" />
                        <asp:RequiredFieldValidator ID="rfvLN" runat="server"
                            ControlToValidate="txtLastName" ErrorMessage=" *" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>Address:</td>
                    <td>
                        <asp:TextBox ID="txtAddress" runat="server" Width="200px" />
                        <asp:RequiredFieldValidator ID="rfvAddr" runat="server"
                            ControlToValidate="txtAddress" ErrorMessage=" *" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>City:</td>
                    <td>
                        <asp:TextBox ID="txtCity" runat="server" Width="140px" />
                        <asp:RequiredFieldValidator ID="rfvCity" runat="server"
                            ControlToValidate="txtCity" ErrorMessage=" *" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>State:</td>
                    <td>
                        <asp:TextBox ID="txtState" runat="server" MaxLength="2" Width="35px" />
                        <asp:RequiredFieldValidator ID="rfvState" runat="server"
                            ControlToValidate="txtState" ErrorMessage=" *" ForeColor="Red" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revState" runat="server"
                            ControlToValidate="txtState" ValidationExpression="^[A-Z]{2}$"
                            ErrorMessage=" (2 uppercase letters)" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>Postal Code:</td>
                    <td>
                        <asp:TextBox ID="txtPostalCode" runat="server" Width="100px" />
                        <asp:RequiredFieldValidator ID="rfvPC" runat="server"
                            ControlToValidate="txtPostalCode" ErrorMessage=" *" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
            </table>
            <br />
            <asp:Button ID="btnSignup" runat="server" Text="Create Account" CssClass="btn"
                OnClick="btnSignup_Click" />
            <br /><br />
            <small>Already have an account? <a href="Login.aspx">Login here</a></small>
        </div>
    </form>
</body>
</html>
