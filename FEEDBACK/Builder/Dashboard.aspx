<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="Dashboard.aspx.vb" Inherits="Builder_Dashboard" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">Builder Dashboard</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrapper">

    <div class="page-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;">
        <div>
            <h1>Survey <span>Builder</span></h1>
            <p>Create and manage your surveys below.</p>
        </div>
        <a href="CreateSurvey.aspx" class="btn btn-danger btn-lg">+ New Survey</a>
    </div>

    <!-- Stats -->
    <div class="stats-grid" style="grid-template-columns:repeat(3,1fr);">
        <div class="stat-card">
            <div class="stat-icon red"></div>
            <div>
                <div class="stat-value"><asp:Literal ID="litMySurveys" runat="server">0</asp:Literal></div>
                <div class="stat-label">My Surveys</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon blue"></div>
            <div>
                <div class="stat-value"><asp:Literal ID="litMyQuestions" runat="server">0</asp:Literal></div>
                <div class="stat-label">Total Questions</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon orange"></div>
            <div>
                <div class="stat-value"><asp:Literal ID="litMyResponses" runat="server">0</asp:Literal></div>
                <div class="stat-label">Total Responses</div>
            </div>
        </div>
    </div>

    <!-- Surveys Table -->
    <div class="card">
        <div class="card-header">
            <h2><span class="icon red"></span> My Surveys</h2>
        </div>
        <div class="card-body" style="padding:0;">
            <div class="table-wrapper">
                <asp:GridView ID="gvSurveys" runat="server" CssClass="data-table"
                    AutoGenerateColumns="false" GridLines="None" DataKeyNames="SurveyID"
                    EmptyDataText="You haven't created any surveys yet.">
                    <Columns>
                        <asp:BoundField DataField="Title"         HeaderText="Title" />
                        <asp:BoundField DataField="QuestionCount" HeaderText="Questions" />
                        <asp:BoundField DataField="ResponseCount" HeaderText="Responses" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%# If(CBool(Eval("IsActive")), "<span class='badge badge-green'>Active</span>", "<span class='badge badge-gray'>Inactive</span>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedDate" HeaderText="Created" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <a href='ManageQuestions.aspx?sid=<%# Eval("SurveyID") %>' class="btn btn-sm btn-primary"> Questions</a>
                                <a href='../Results/SurveyResults.aspx?sid=<%# Eval("SurveyID") %>' class="btn btn-sm btn-warning" style="margin-left:.3rem;"> Results</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</div>
</asp:Content>

