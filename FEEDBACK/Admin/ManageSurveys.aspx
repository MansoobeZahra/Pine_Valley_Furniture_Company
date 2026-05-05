<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="ManageSurveys.aspx.vb" Inherits="Admin_ManageSurveys" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">Manage Surveys</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrapper">

    <div class="page-header">
        <h1>Manage <span>Surveys</span></h1>
        <p>Control survey status and anonymity settings across the platform.</p>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false">
        <div class="alert alert-success">(Done) <asp:Literal ID="litMsg" runat="server" /></div>
    </asp:Panel>

    <div class="card">
        <div class="card-header">
            <h2><span class="icon red"></span> All Surveys</h2>
        </div>
        <div class="card-body" style="padding:0;">
            <div class="table-wrapper">
                <asp:GridView ID="gvSurveys" runat="server" CssClass="data-table"
                    AutoGenerateColumns="false" GridLines="None" DataKeyNames="SurveyID"
                    OnRowCommand="gvSurveys_RowCommand"
                    EmptyDataText="No surveys found.">
                    <Columns>
                        <asp:BoundField DataField="Title"         HeaderText="Survey Title" />
                        <asp:BoundField DataField="CreatedBy"     HeaderText="Builder" />
                        <asp:BoundField DataField="QuestionCount" HeaderText="Qs" />
                        <asp:BoundField DataField="ResponseCount" HeaderText="Responses" />
                        <asp:BoundField DataField="CreatedDate"   HeaderText="Created"
                            DataFormatString="{0:MMM dd, yyyy}" />

                        <asp:TemplateField HeaderText="Anonymous">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbAnon" runat="server"
                                    CommandName="ToggleAnon"
                                    CommandArgument='<%# Eval("SurveyID") & "|" & Eval("IsAnonymous") %>'
                                    CssClass='<%# If(CBool(Eval("IsAnonymous")), "btn btn-sm btn-primary", "btn btn-sm btn-outline") %>'>
                                    <%# If(CBool(Eval("IsAnonymous")), " Yes", " No") %>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Active">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbActive" runat="server"
                                    CommandName="ToggleActive"
                                    CommandArgument='<%# Eval("SurveyID") & "|" & Eval("IsActive") %>'
                                    CssClass='<%# If(CBool(Eval("IsActive")), "btn btn-sm btn-success", "btn btn-sm btn-outline") %>'>
                                    <%# If(CBool(Eval("IsActive")), "(Active) Active", " Off") %>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Results">
                            <ItemTemplate>
                                <a href='../Results/SurveyResults.aspx?sid=<%# Eval("SurveyID") %>'
                                   class="btn btn-sm btn-warning"></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</div>
</asp:Content>

