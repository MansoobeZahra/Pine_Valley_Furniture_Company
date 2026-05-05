<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="DefaultPage" Title="Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" runat="server">Home</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrapper">
    <div class="empty-state" style="padding:5rem 2rem;">
        <div class="empty-icon"></div>
        <h3>Redirecting</h3>
        <p>Please wait while we load your dashboard.</p>
    </div>
</div>
</asp:Content>

