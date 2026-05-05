<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="DefaultPage" %>
<%@ Register TagPrefix="uc" TagName="Navbar" Src="~/Navbar.ascx" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FeedBACK - Home</title>
    <link rel="stylesheet" href="Site.css" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <uc:Navbar ID="Navbar1" runat="server" />
        <div class="page-wrapper">
            <div class="empty-state" style="padding:5rem 2rem;">
                <div class="empty-icon"></div>
                <h3>Redirecting</h3>
                <p>Please wait while we load your dashboard.</p>
            </div>
        </div>
    </form>
</body>
</html>

