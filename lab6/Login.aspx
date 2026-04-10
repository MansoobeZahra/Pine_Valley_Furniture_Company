<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Login.aspx.vb" Inherits="LoginPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Login - PVFC Lab 06</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f0f0f0;
            }

            .header {
                background-color: #583937;
                color: white;
                padding: 20px;
                text-align: center;
            }

            .header h1 {
                margin: 0;
            }

            .header p {
                margin: 5px 0 0;
            }

            .login-box {
                width: 340px;
                margin: 60px auto;
                background: white;
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 30px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            }

            .login-box h2 {
                margin-top: 0;
                color: #583937;
            }

            table td {
                padding: 8px 4px;
            }

            .login-box input[type=text],
            .login-box input[type=password] {
                width: 190px;
                padding: 5px;
            }

            .btn {
                background: #583937;
                color: white;
                border: none;
                padding: 8px 20px;
                cursor: pointer;
                border-radius: 3px;
            }

            .btn:hover {
                background: #7a504e;
            }
        </style>
    </head>

    <body>
        <div class="header">
            <h1><img src="logo.png" alt="PVFC" height="45" style="vertical-align:middle;" />
                Pine Valley Furniture Company</h1>
            <p>Mansoob-e-Zahra | Lab 06</p>
        </div>
        <form id="form1" runat="server">
            <div class="login-box">
                <h2>&nbsp;User Login</h2>
                <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false" Font-Bold="true" />
                <br />
                <table>
                    <tr>
                        <td>Username:</td>
                        <td>
                            <asp:TextBox ID="txtUser" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td>
                            <asp:TextBox ID="txtPass" runat="server" TextMode="Password" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-top:12px;">
                            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn"
                                OnClick="btnLogin_Click" />
                        </td>
                    </tr>
                </table>
                <br />
                <small style="color:gray;">Admin: full access &nbsp;|&nbsp; User: read/order access</small>
            </div>
        </form>
    </body>

    </html>