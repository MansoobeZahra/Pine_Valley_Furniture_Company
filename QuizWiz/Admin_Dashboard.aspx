<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Admin_Dashboard.aspx.vb" Inherits="Admin_Dashboard" %>
<%@ Register TagPrefix="uc" TagName="Header" Src="Header.ascx" %>
<%@ Register TagPrefix="uc" TagName="Sidebar" Src="Sidebar.ascx" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Dashboard - QuizWiz</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>
<body>
<form id="form1" runat="server">
    <uc:Header runat="server" ID="Header1" />
    <div class="layout-container">
        <uc:Sidebar runat="server" ID="Sidebar1" />
        <div class="main-area">
            <h1>Admin Dashboard</h1>

            <div style="display:flex; flex-wrap:wrap; gap:15px; margin-bottom:25px;">
                <div style="flex:1; min-width:150px; border:1px solid #ccc; padding:15px; background:white; border-top:5px solid #0078d4; text-align:center;">
                    <span style="font-size:12px; color:#666;">Users</span><br />
                    <strong style="font-size:24px; color:#0078d4;"><asp:Literal ID="litUsers" runat="server" /></strong>
                </div>
                <div style="flex:1; min-width:150px; border:1px solid #ccc; padding:15px; background:white; border-top:5px solid #28a745; text-align:center;">
                    <span style="font-size:12px; color:#666;">Teachers</span><br />
                    <strong style="font-size:24px; color:#28a745;"><asp:Literal ID="litTeachers" runat="server" /></strong>
                </div>
                <div style="flex:1; min-width:150px; border:1px solid #ccc; padding:15px; background:white; border-top:5px solid #17a2b8; text-align:center;">
                    <span style="font-size:12px; color:#666;">Students</span><br />
                    <strong style="font-size:24px; color:#17a2b8;"><asp:Literal ID="litStudents" runat="server" /></strong>
                </div>
                <div style="flex:1; min-width:150px; border:1px solid #ccc; padding:15px; background:white; border-top:5px solid #ffc107; text-align:center;">
                    <span style="font-size:12px; color:#666;">Quizzes</span><br />
                    <strong style="font-size:24px; color:#856404;"><asp:Literal ID="litQuizzes" runat="server" /></strong>
                </div>
                <div style="flex:1; min-width:150px; border:1px solid #ccc; padding:15px; background:white; border-top:5px solid #6c757d; text-align:center;">
                    <span style="font-size:12px; color:#666;">Questions</span><br />
                    <strong style="font-size:24px; color:#343a40;"><asp:Literal ID="litQuestions" runat="server" /></strong>
                </div>
                <div style="flex:1; min-width:150px; border:1px solid #ccc; padding:15px; background:white; border-top:5px solid #17a2b8; text-align:center;">
                    <span style="font-size:12px; color:#666;">Attempts</span><br />
                    <strong style="font-size:24px; color:#0c5460;"><asp:Literal ID="litAttempts" runat="server" /></strong>
                </div>
            </div>

            <div style="display:flex; gap:20px;">
                <div style="flex:1;">
                    <h3 style="color:#0078d4;">Recent Quizzes</h3>
                    <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="false" Width="100%" BorderStyle="Solid" BorderWidth="1px">
                        <Columns>
                            <asp:BoundField DataField="QuizTitle" HeaderText="Title" />
                            <asp:BoundField DataField="CreatorName" HeaderText="Teacher" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='<%# If(CBool(Eval("IsPublished")), "text-green", "text-gray") %>'>
                                        <%# If(CBool(Eval("IsPublished")), "Published", "Draft") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Attempts" HeaderText="Attempts" />
                        </Columns>
                    </asp:GridView>
                </div>

                <div style="flex:1;">
                    <h3 style="color:#0078d4;">Recent Results</h3>
                    <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="false" Width="100%" BorderStyle="Solid" BorderWidth="1px">
                        <Columns>
                            <asp:BoundField DataField="StudentName" HeaderText="Student" />
                            <asp:BoundField DataField="QuizTitle" HeaderText="Quiz" />
                            <asp:TemplateField HeaderText="Score">
                                <ItemTemplate>
                                    <strong class='<%# If(Eval("Percentage") >= 50, "text-green", "text-red") %>'>
                                        <%# Eval("Percentage") %>%
                                    </strong>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="AttemptDate" HeaderText="Date" DataFormatString="{0:dd-MMM}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
