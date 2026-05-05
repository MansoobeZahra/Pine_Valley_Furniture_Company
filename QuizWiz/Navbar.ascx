<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Navbar.ascx.vb" Inherits="Navbar" %>
<div class="sidebar">
    <div style="padding: 15px; font-size: 12px; color: #888; text-transform: uppercase; font-weight: bold; border-bottom: 1px solid #ddd;">Navigation</div>
    <asp:Panel ID="pnlAdminNav" runat="server" Visible="false">
        <a href='<%= ResolveUrl("~/Admin_Dashboard.aspx") %>'>Dashboard</a>
        <a href='<%= ResolveUrl("~/Admin_Users.aspx") %>'>Manage Users</a>
    </asp:Panel>
    <asp:Panel ID="pnlTeacherNav" runat="server" Visible="false">
        <a href='<%= ResolveUrl("~/Teacher_Dashboard.aspx") %>'>Dashboard</a>
        <a href='<%= ResolveUrl("~/Teacher_AddQ.aspx") %>'>Add Question</a>
        <a href='<%= ResolveUrl("~/Teacher_Bank.aspx") %>'>Question Bank</a>
        <a href='<%= ResolveUrl("~/Teacher_CreateQuiz.aspx") %>'>Create Quiz</a>
        <a href='<%= ResolveUrl("~/Teacher_Results.aspx") %>'>Quiz Results</a>
    </asp:Panel>
    <asp:Panel ID="pnlStudentNav" runat="server" Visible="false">
        <a href='<%= ResolveUrl("~/Student_Dashboard.aspx") %>'>Dashboard</a>
        <a href='<%= ResolveUrl("~/Student_Results.aspx") %>'>My Results</a>
    </asp:Panel>
</div>
