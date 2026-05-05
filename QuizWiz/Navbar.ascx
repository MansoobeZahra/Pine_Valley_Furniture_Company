<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Navbar.ascx.vb" Inherits="Navbar" %>
<div class="top-nav" style="display:flex; align-items:center;">
    <img src='<%= ResolveUrl("Assets/discard.png") %>' alt="QuizWiz" style="height:60px; margin-right:15px;" />
    <span style="margin-left:15px;">User: <%=SessionFullName%> (<%=SessionRole%>)</span>
    <a href="Logout.aspx" style="margin-left:auto;">Logout</a>
</div>

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
