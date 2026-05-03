<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>QuizWiz Login</title>
    <style>
        body { font-family: sans-serif; background-color: #eee; margin: 0; padding: 0; }
        .login-box { width:350px; margin: 100px auto; border: 1px solid #0078d4; padding: 20px; background-color: white; }
        .btn { padding: 7px 20px; background-color: #0078d4; color: white; border: 1px solid #005a9e; cursor: pointer; }
        input[type=text], input[type=password] { border: 1px solid #999; padding: 5px; width: 100%; box-sizing: border-box; margin-bottom: 10px; }
    </style>
</head>
<body style="background-color:#eee;">
    <div style="width:350px; margin: 100px auto; border: 1px solid #0078d4; padding: 20px; background-color: white;">
        <div style="text-align:center; margin-bottom:20px;">
            <img src='<%= ResolveUrl("~/Assets/discar.png") %>' alt="QuizWiz" style="max-width:300px;" />
        </div>
        <form id="form1" runat="server">
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-err">
                <asp:Literal ID="litError" runat="server" />
            </asp:Panel>
            
            <div class="form-item">
                <label>Username:</label><br />
                <asp:TextBox ID="txtUsername" runat="server" style="width:100%; box-sizing:border-box;" />
            </div>
            
            <div class="form-item">
                <label>Password:</label><br />
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" style="width:100%; box-sizing:border-box;" />
            </div>
            
            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="btn btn-blue" style="width:100%;" />
            
            <div style="margin-top:15px; font-size:11px; color:#666;">
                admin / Admin@123<br />
                t_ali / Teacher@1<br />
                s_usman / Student@1
            </div>
        </form>
    </div>
</body>
</html>
