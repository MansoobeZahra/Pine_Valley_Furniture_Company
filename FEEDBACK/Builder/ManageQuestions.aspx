<%@ Page Language="VB" MasterPageFile="/FEEDBACK/Site.master" AutoEventWireup="false"
    CodeFile="ManageQuestions.aspx.vb" Inherits="Builder_ManageQuestions" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">Manage Questions</asp:Content>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
<style>
.q-type-card {
    border: 2px solid var(--border);
    border-radius: var(--radius);
    padding: 1rem;
    cursor: pointer;
    transition: var(--transition);
    text-align: center;
}
.q-type-card:hover, .q-type-card.selected {
    border-color: var(--blue);
    background: rgba(37,150,190,.05);
}
.q-type-card .type-icon { font-size: 2rem; margin-bottom: .4rem; }
.q-type-card .type-name { font-weight: 700; font-size: .9rem; }
.options-area { display:none; }
.options-area.show { display:block; }
</style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrapper">

    <!-- Header -->
    <div class="page-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;">
        <div>
            <h1>Manage <span>Questions</span></h1>
            <p id="surveyTitleP" runat="server">Loading survey</p>
        </div>
        <div style="display:flex;gap:.75rem;">
            <a href="Dashboard.aspx" class="btn btn-outline"><- Back</a>
            <a id="lnkResults" runat="server" href="#" class="btn btn-warning"> View Results</a>
        </div>
    </div>

    <!-- Success/Error -->
    <asp:Panel ID="pnlMsg" runat="server" Visible="false">
        <div class="alert alert-success">(Done) <asp:Literal ID="litMsg" runat="server" /></div>
    </asp:Panel>
    <asp:Panel ID="pnlError" runat="server" Visible="false">
        <div class="alert alert-danger"> <asp:Literal ID="litError" runat="server" /></div>
    </asp:Panel>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;align-items:start;">

        <!-- ===== ADD QUESTION FORM ===== -->
        <div class="card">
            <div class="card-header">
                <h2><span class="icon blue">+</span> Add Question</h2>
            </div>
            <div class="card-body">

                <!-- Question Text -->
                <div class="form-group">
                    <label class="form-label">Question Statement <span style="color:var(--red)">*</span></label>
                    <asp:TextBox ID="txtQuestion" runat="server" TextMode="MultiLine" Rows="3"
                        CssClass="form-control" placeholder="Type your question here" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtQuestion"
                        Display="Dynamic" CssClass="field-error" ErrorMessage="Question text required." />
                </div>

                <!-- Question Type -->
                <div class="form-group">
                    <label class="form-label">Question Type <span style="color:var(--red)">*</span></label>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlType_Changed">
                        <asp:ListItem Value="">-- Select Type --</asp:ListItem>
                        <asp:ListItem Value="MCQ">Multiple Choice (MCQ)</asp:ListItem>
                        <asp:ListItem Value="TrueFalse">True / False</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlType"
                        Display="Dynamic" CssClass="field-error" ErrorMessage="Please select a type." />
                </div>

                <!-- MCQ Options Panel -->
                <asp:Panel ID="pnlMCQ" runat="server" Visible="false">
                    <div style="background:rgba(37,150,190,.04);border-radius:var(--radius-sm);padding:1rem;border:1px dashed var(--border);">
                        <label class="form-label">Answer Options (min 2)</label>
                        <div class="form-group" style="margin-bottom:.6rem;">
                            <asp:TextBox ID="txtOpt1" runat="server" CssClass="form-control" placeholder="Option A" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtOpt1"
                                Display="Dynamic" CssClass="field-error" ErrorMessage="Option A required."
                                Enabled="false" ID="rfvOpt1" />
                        </div>
                        <div class="form-group" style="margin-bottom:.6rem;">
                            <asp:TextBox ID="txtOpt2" runat="server" CssClass="form-control" placeholder="Option B" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtOpt2"
                                Display="Dynamic" CssClass="field-error" ErrorMessage="Option B required."
                                Enabled="false" ID="rfvOpt2" />
                        </div>
                        <div class="form-group" style="margin-bottom:.6rem;">
                            <asp:TextBox ID="txtOpt3" runat="server" CssClass="form-control" placeholder="Option C (optional)" />
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <asp:TextBox ID="txtOpt4" runat="server" CssClass="form-control" placeholder="Option D (optional)" />
                        </div>
                    </div>
                </asp:Panel>

                <!-- True/False info -->
                <asp:Panel ID="pnlTF" runat="server" Visible="false">
                    <div class="alert alert-info">
                         True / False options will be added automatically.
                    </div>
                </asp:Panel>

                <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question +"
                    CssClass="btn btn-danger btn-full" style="margin-top:1rem;"
                    OnClick="btnAddQuestion_Click" />
            </div>
        </div>

        <!-- ===== EXISTING QUESTIONS LIST ===== -->
        <div>
            <div class="card">
                <div class="card-header">
                    <h2><span class="icon orange"></span> Questions
                        <span class="badge badge-blue" style="margin-left:.5rem;">
                            <asp:Literal ID="litQCount" runat="server">0</asp:Literal>
                        </span>
                    </h2>
                </div>
                <div class="card-body" style="padding:.75rem;">
                    <asp:Repeater ID="rptQuestions" runat="server"
                        OnItemCommand="rptQuestions_ItemCommand">
                        <ItemTemplate>
                            <div class="question-item">
                                <div class="question-item-header">
                                    <div style="display:flex;align-items:center;gap:.6rem;">
                                        <div class="question-number"><%# Container.ItemIndex + 1 %></div>
                                        <span class="badge <%# If(Eval("QuestionType").ToString()="MCQ","badge-blue","badge-orange") %>">
                                            <%# If(Eval("QuestionType").ToString()="MCQ","MCQ","True/False") %>
                                        </span>
                                    </div>
                                    <asp:LinkButton runat="server" CommandName="Delete"
                                        CommandArgument='<%# Eval("QuestionID") %>'
                                        CssClass="btn btn-sm btn-danger"
                                        OnClientClick="return confirm('Delete this question?');"></asp:LinkButton>
                                </div>
                                <div class="question-item-body">
                                    <p style="font-weight:600;font-size:.9rem;margin-bottom:.6rem;">
                                        <%# Server.HtmlEncode(Eval("QuestionText").ToString()) %>
                                    </p>
                                    <!-- Options sub-list via nested repeater placeholder -->
                                    <asp:Repeater ID="rptOptions" runat="server"
                                        DataSource='<%# GetOptions(CInt(Eval("QuestionID"))) %>'>
                                        <ItemTemplate>
                                            <div class="option-row">
                                                <div class="option-bullet"></div>
                                                <span style="font-size:.83rem;color:#444;"><%# Server.HtmlEncode(Eval("OptionText").ToString()) %></span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel ID="pnlNoQ" runat="server"
                                Visible='<%# CInt(rptQuestions.Items.Count) = 0 %>'>
                                <div class="empty-state" style="padding:2rem 1rem;">
                                    <div class="empty-icon"></div>
                                    <h3>No Questions Yet</h3>
                                    <p>Add your first question on the left.</p>
                                </div>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>

    </div>
</div>
</asp:Content>

