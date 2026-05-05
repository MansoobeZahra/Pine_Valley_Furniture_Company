<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="DefaultPage" %>
<%@ Register TagPrefix="uc" TagName="Header" Src="Header.ascx" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Home - FeedBACK</title>
    <link rel="stylesheet" href="Styles/Site.css" />
</head>
<body>
<form id="form1" runat="server">
    <uc:Header runat="server" ID="Header1" />
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

