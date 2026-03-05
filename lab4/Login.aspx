<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="LoginPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Login - PVFC</title>
    </head>

    <body style="font-family: Arial, sans-serif;">
        <div style="background-color: #583937; color: white; padding: 20px; text-align: center;">
            <h1>Pine Valley Furniture Company</h1>
            <p>Mansoob-e-Zahra | Lab 04</p>
        </div>
        <hr />
        <form id="form1" runat="server">
            <div style="width: 300px; margin: 50px auto; border: 1px solid #ccc; padding: 20px;">
                <h3>User Login</h3>
                <asp:Label ID="lblMessage" runat="server" ForeColor="Red" Visible="false"></asp:Label>
                <table>
                    <tr>
                        <td>Username:</td>
                        <td>
                            <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </form>
        <hr />
        <div style="text-align: center;">
            <a href="Default.aspx">Back to Home</a>
        </div>
    </body>

    </html>