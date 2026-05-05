<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Sidebar.ascx.vb" Inherits="Sidebar" %>
<div class="sidebar">
    <asp:Panel ID="pnlAdminNav" runat="server" Visible="false">
        <a href="Admin_Dashboard.aspx">Dashboard</a>
        <a href="Admin_Users.aspx">Users</a>
    </asp:Panel>
    <asp:Panel ID="pnlTeacherNav" runat="server" Visible="false">
        <a href="Teacher_Dashboard.aspx">Dashboard</a>
        <a href="Teacher_AddQ.aspx">Add Q</a>
        <a href="Teacher_Bank.aspx">Bank</a>
        <a href="Teacher_CreateQuiz.aspx">Create Quiz</a>
        <a href="Teacher_Results.aspx">Results</a>
    </asp:Panel>
    <asp:Panel ID="pnlStudentNav" runat="server" Visible="false">
        <a href="Student_Dashboard.aspx">Dashboard</a>
        <a href="Student_Results.aspx">Results</a>
    </asp:Panel>
</div>
