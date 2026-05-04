<%@ Page Language="VB" MasterPageFile="/FEEDBACK/Site.master" AutoEventWireup="false"
    CodeFile="Dashboard.aspx.vb" Inherits="Admin_Dashboard" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">Admin Dashboard</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrapper">

    <div class="page-header">
        <h1>Administrator <span>Dashboard</span></h1>
        <p>Oversee all users, surveys, and anonymity settings from one place.</p>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon blue"></div>
            <div>
                <div class="stat-value"><asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal></div>
                <div class="stat-label">Total Users</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red"></div>
            <div>
                <div class="stat-value"><asp:Literal ID="litTotalSurveys" runat="server">0</asp:Literal></div>
                <div class="stat-label">Total Surveys</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon orange"></div>
            <div>
                <div class="stat-value"><asp:Literal ID="litTotalResponses" runat="server">0</asp:Literal></div>
                <div class="stat-label">Total Responses</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">(Active)</div>
            <div>
                <div class="stat-value"><asp:Literal ID="litActiveSurveys" runat="server">0</asp:Literal></div>
                <div class="stat-label">Active Surveys</div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="card" style="margin-bottom:2rem;">
        <div class="card-header">
            <h2><span class="icon blue"></span> Quick Actions</h2>
        </div>
        <div class="card-body" style="display:flex;gap:1rem;flex-wrap:wrap;">
            <a href="ManageUsers.aspx"   class="btn btn-primary"> Manage Users</a>
            <a href="ManageSurveys.aspx" class="btn btn-danger"> Manage Surveys</a>
            <a href="../Results/SurveyResults.aspx" class="btn btn-warning"> View Results</a>
            <a href="../Register.aspx"   class="btn btn-outline">+ Add User</a>
        </div>
    </div>

    <!-- Recent Surveys -->
    <div class="card">
        <div class="card-header">
            <h2><span class="icon red"></span> Recent Surveys</h2>
            <a href="ManageSurveys.aspx" class="btn btn-sm btn-outline">View All</a>
        </div>
        <div class="card-body" style="padding:0;">
            <div class="table-wrapper">
                <asp:GridView ID="gvSurveys" runat="server" CssClass="data-table"
                    AutoGenerateColumns="false" GridLines="None"
                    EmptyDataText="No surveys found.">
                    <Columns>
                        <asp:BoundField DataField="Title"         HeaderText="Survey Title" />
                        <asp:BoundField DataField="CreatedBy"     HeaderText="Created By" />
                        <asp:BoundField DataField="QuestionCount" HeaderText="Questions" />
                        <asp:BoundField DataField="ResponseCount" HeaderText="Responses" />
                        <asp:TemplateField HeaderText="Anonymous">
                            <ItemTemplate>
                                <%# If(CBool(Eval("IsAnonymous")), "<span class='badge badge-blue'>Yes</span>", "<span class='badge badge-gray'>No</span>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%# If(CBool(Eval("IsActive")), "<span class='badge badge-green'>Active</span>", "<span class='badge badge-gray'>Inactive</span>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</div>
</asp:Content>

