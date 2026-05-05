<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Header.ascx.vb" Inherits="Header" %>
<nav class="navbar">
    <a href="~/Default.aspx" runat="server" class="navbar-brand">
        <span class="brand-icon"></span>
        FeedBACK
    </a>

    <div class="navbar-nav" id="navMenu" runat="server">
        <!-- Injected by code-behind based on role -->
    </div>

    <div style="display:flex;align-items:center;gap:.75rem;">
        <div class="user-badge" id="userBadge" runat="server" visible="false">
            <div class="avatar" id="avatarDiv" runat="server">?</div>
            <span id="userNameSpan" runat="server">User</span>
            <span class="badge badge-blue" id="roleSpan" runat="server" style="margin-left:.25rem;"></span>
        </div>
        <asp:Button ID="btnLogout" runat="server" Text=" Logout" CssClass="btn btn-logout"
            OnClick="btnLogout_Click" Visible="false" />
    </div>
</nav>
