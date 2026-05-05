<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SurveyorDashboard.aspx.vb" Inherits="SurveyorDashboard" %>
<%@ Register TagPrefix="uc" TagName="Navbar" Src="~/Navbar.ascx" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FeedBACK - Available Surveys</title>
    <link rel="stylesheet" href="Site.css" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <uc:Navbar ID="Navbar1" runat="server" />
        <div class="page-wrapper">
            <div class="page-header">
                <h1>Available <span>Surveys</span></h1>
                <p>Browse and complete the surveys below. Your voice matters!</p>
            </div>

            <asp:Panel ID="pnlMsg" runat="server" Visible="false">
                <div class="alert alert-success">(Done) <asp:Literal ID="litMsg" runat="server" /></div>
            </asp:Panel>

            <div class="surveys-grid">
                <asp:Repeater ID="rptSurveys" runat="server">
                    <ItemTemplate>
                        <div class="survey-card">
                            <div class="survey-card-header">
                                <div style="display:flex;gap:.5rem;margin-bottom:.5rem;flex-wrap:wrap;">
                                    <%# If(CBool(Eval("IsAnonymous")), "<span class='badge badge-blue'> Anonymous</span>", "<span class='badge badge-orange'> Identified</span>") %>
                                    <%# If(CBool(Eval("AlreadyTaken")), "<span class='badge badge-green'>(Done) Completed</span>", "") %>
                                </div>
                                <h3><%# Server.HtmlEncode(Eval("Title").ToString()) %></h3>
                            </div>
                            <div class="survey-card-body">
                                <div class="survey-meta">
                                    <span> <%# Eval("CreatedBy") %></span>
                                    <span class="dot"></span>
                                    <span> <%# Eval("QuestionCount") %> questions</span>
                                    <span class="dot"></span>
                                    <span> <%# CDate(Eval("CreatedDate")).ToString("MMM dd") %></span>
                                </div>
                                <p style="font-size:.875rem;color:#6c757d;margin-top:.4rem;
                                    display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;">
                                    <%# If(String.IsNullOrEmpty(Eval("Description").ToString()), "No description provided.", Server.HtmlEncode(Eval("Description").ToString())) %>
                                </p>
                            </div>
                            <div class="survey-card-footer">
                                <%# If(CBool(Eval("AlreadyTaken")),
                                    "<a href='" & ResolveUrl("~/SurveyResults.aspx?sid=" & Eval("SurveyID")) & "' class='btn btn-sm btn-outline'> View Results</a>",
                                    "<a href='TakeSurvey.aspx?sid=" & Eval("SurveyID") & "' class='btn btn-sm btn-danger'>Start Survey -></a>") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                <div class="empty-state">
                    <div class="empty-icon"></div>
                    <h3>No Surveys Available</h3>
                    <p>There are no active surveys at this time. Check back later!</p>
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>

