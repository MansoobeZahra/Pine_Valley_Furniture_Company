<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Student_Dashboard.aspx.vb" Inherits="Student_Dashboard" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>
<%@ Register Src="~/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>QuizWiz - Student Dashboard</title>
    <link href="Styles/site.css" rel="stylesheet" />
</head>
<body style="margin:0; padding:0;">
<form id="form1" runat="server">
    <uc:Header runat="server" ID="Header" />
    <div class="layout-container">
        <uc:Navbar runat="server" ID="Navbar" />
        <div class="main-area">
            <h1>Student Dashboard</h1>
            <hr />

            <h2>Welcome Student!</h2>
            <div style="background-color:#f4f4f4; padding:10px; border-left:3px solid #0078d4; margin-bottom:10px;">
                <b>My Stats:</b><br />
                Quizzes: <asp:Literal ID="litAvailable" runat="server">0</asp:Literal> |
                Done: <asp:Literal ID="litAttempted" runat="server">0</asp:Literal> |
                Avg: <asp:Literal ID="litAvgScore" runat="server">-</asp:Literal> |
                Notifs: <asp:Literal ID="litNotifs" runat="server">0</asp:Literal>
            </div>

            <asp:Panel ID="pnlNotifs" runat="server" Visible="false" style="border:1px solid #ffc107; background:#fff9e6; padding:10px; margin-bottom:10px;">
                <h3 style="color:#856404; margin-top:0;">Notifications</h3>
                <asp:LinkButton ID="btnMarkRead" runat="server" Text="Mark All Read" OnClick="btnMarkRead_Click" />
                <asp:Repeater ID="rptNotifs" runat="server">
                    <ItemTemplate>
                        <div style="border-bottom:1px solid #eee; padding:3px;"><%# Eval("Message") %></div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

            <h3>Available Quizzes</h3>
            <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="false" Width="100%">
                <Columns>
                    <asp:BoundField DataField="QuizTitle" HeaderText="Quiz" />
                    <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span style='color:<%# If(CBool(Eval("AlreadyAttempted")), "gray", "green") %>'>
                                <%# If(CBool(Eval("AlreadyAttempted")), "Completed", "Available") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <%# If(CBool(Eval("AlreadyAttempted")), "<a href='Student_Results.aspx?quizid=" & Eval("QuizID") & "'>Result</a>", "<a href='Student_Quiz.aspx?quizid=" & Eval("QuizID") & "' class='btn btn-blue'>Start</a>") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</form>
</body>
</html>
