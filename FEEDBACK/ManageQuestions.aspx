<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ManageQuestions.aspx.vb" Inherits="ManageQuestions" %>
<%@ Register TagPrefix="uc" TagName="Navbar" Src="~/Navbar.ascx" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FeedBACK - Manage Questions</title>
    <link rel="stylesheet" href="Site.css" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <uc:Navbar ID="Navbar1" runat="server" />
        <div class="page-wrapper">
            <div class="page-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;">
                <div>
                    <h1 style="font-size:1.5rem;"><asp:Literal ID="litSurveyTitle" runat="server">Manage Survey</asp:Literal></h1>
                    <p>Add, edit, or remove questions from this survey.</p>
                </div>
                <div style="display:flex;gap:.5rem;">
                    <a href="BuilderDashboard.aspx" class="btn btn-outline">Back to Dashboard</a>
                </div>
            </div>

            <asp:Panel ID="pnlMsg" runat="server" Visible="false">
                <div class="alert alert-success">(Done) <asp:Literal ID="litMsg" runat="server" /></div>
            </asp:Panel>

            <div style="display:grid;grid-template-columns: 1.5fr 1fr; gap: 2rem; align-items: start;">
                <!-- Existing Questions -->
                <div class="card">
                    <div class="card-header">
                        <h2><span class="icon red"></span> Survey Questions</h2>
                    </div>
                    <div class="card-body" style="padding:0;">
                        <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
                            <HeaderTemplate><div class="question-list"></HeaderTemplate>
                            <ItemTemplate>
                                <div class="question-item" style="padding:1.25rem; border-bottom:1px solid var(--border);">
                                    <div style="display:flex;justify-content:space-between;align-items:flex-start;">
                                        <div style="flex:1;">
                                            <div style="font-size:.8rem;color:var(--muted);margin-bottom:.25rem;">
                                                Question <%# Container.ItemIndex + 1 %> • <%# Eval("QuestionType") %>
                                            </div>
                                            <div style="font-weight:600;color:var(--dark);"><%# Eval("QuestionText") %></div>
                                        </div>
                                        <asp:LinkButton ID="btnDel" runat="server" CommandName="DeleteQ" CommandArgument='<%# Eval("QuestionID") %>'
                                            CssClass="btn btn-sm btn-outline" style="color:var(--red);border-color:var(--red);"
                                            OnClientClick="return confirm('Delete this question?');">Delete</asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate></div></FooterTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlNoQs" runat="server" Visible="false" style="padding:3rem 1rem;text-align:center;">
                            <p style="color:var(--muted);">No questions added yet.</p>
                        </asp:Panel>
                    </div>
                </div>

                <!-- Add Question Form -->
                <div class="card" style="position:sticky;top:2rem;">
                    <div class="card-header">
                        <h2><span class="icon blue"></span> Add Question</h2>
                    </div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label">Question Text</label>
                            <asp:TextBox ID="txtQText" runat="server" CssClass="form-control" placeholder="What would you like to ask?" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtQText" ValidationGroup="addQ"
                                Display="Dynamic" CssClass="field-error" ErrorMessage="Question text is required." />
                        </div>
                        <div class="form-group">
                            <label class="form-label">Question Type</label>
                            <asp:DropDownList ID="ddlQType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlQType_SelectedIndexChanged">
                                <asp:ListItem Value="Rating">Star Rating (1-5)</asp:ListItem>
                                <asp:ListItem Value="Text">Open Text / Feedback</asp:ListItem>
                                <asp:ListItem Value="Choice">Multiple Choice</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Options for Multiple Choice -->
                        <asp:Panel ID="pnlOptions" runat="server" Visible="false" style="margin-top:1rem;padding:1rem;background:#f8f9fa;border-radius:var(--radius);">
                            <label class="form-label" style="font-size:.8rem;">Choice Options (One per line)</label>
                            <asp:TextBox ID="txtOptions" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control"
                                placeholder="Yes&#10;No&#10;Maybe" />
                            <p style="font-size:.7rem;color:var(--muted);margin-top:.4rem;">Enter each option on a new line.</p>
                        </asp:Panel>

                        <asp:Button ID="btnAddQ" runat="server" Text="Add Question" CssClass="btn btn-primary btn-full"
                            style="margin-top:1.5rem;" OnClick="btnAddQ_Click" ValidationGroup="addQ" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

