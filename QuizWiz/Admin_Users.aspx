<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Admin_Users.aspx.vb" Inherits="Admin_ManageUsers" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="ctTitle" ContentPlaceHolderID="PageTitle" runat="server">Manage Users</asp:Content>

<asp:Content ID="ctMain" ContentPlaceHolderID="MainContent" runat="server">

<h2>Manage Users</h2>

<asp:Panel ID="pnlForm" runat="server" Visible="false" style="border:1px solid #0078d4; padding:10px; background:#f0f7ff; margin-bottom:10px;">
    <asp:HiddenField ID="hfEditID" runat="server" Value="0" />
    Name: <asp:TextBox ID="txtFullName" runat="server" /><br />
    Username: <asp:TextBox ID="txtUsername" runat="server" /><br />
    Password: <asp:TextBox ID="txtPassword" runat="server" /><br />
    Role: <asp:DropDownList ID="ddlRole" runat="server">
        <asp:ListItem>Student</asp:ListItem>
        <asp:ListItem>Teacher</asp:ListItem>
        <asp:ListItem>Admin</asp:ListItem>
    </asp:DropDownList><br /><br />
    <asp:Button ID="btnSaveUser" runat="server" Text="Save" OnClick="btnSaveUser_Click" CssClass="btn btn-blue" />
    <asp:Button ID="btnCancelForm" runat="server" Text="Cancel" OnClick="btnCancelForm_Click" CssClass="btn" />
</asp:Panel>

<div style="margin-bottom:10px;">
    <asp:Button ID="btnShowAdd" runat="server" Text="Add New User" OnClick="btnShowAdd_Click" CssClass="btn btn-blue" />
    Filter: <asp:DropDownList ID="ddlFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFilter_Changed">
        <asp:ListItem Value="">All</asp:ListItem>
        <asp:ListItem>Admin</asp:ListItem>
        <asp:ListItem>Teacher</asp:ListItem>
        <asp:ListItem>Student</asp:ListItem>
    </asp:DropDownList>
</div>

<asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" Width="100%" DataKeyNames="UserID" OnRowCommand="gvUsers_RowCommand">
    <Columns>
        <asp:BoundField DataField="UserID" HeaderText="ID" />
        <asp:BoundField DataField="FullName" HeaderText="Name" />
        <asp:BoundField DataField="Username" HeaderText="User" />
        <asp:BoundField DataField="Role" HeaderText="Role" />
        <asp:TemplateField HeaderText="Status">
            <ItemTemplate>
                <%# If(CBool(Eval("IsActive")), "Active", "Disabled") %>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:LinkButton CommandName="EditUser" runat="server" CommandArgument='<%# Eval("UserID") %>' Text="Edit" /> |
                <asp:LinkButton CommandName="ToggleActive" runat="server" CommandArgument='<%# Eval("UserID") %>' Text='<%# If(CBool(Eval("IsActive")), "Disable", "Enable") %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

</asp:Content>
