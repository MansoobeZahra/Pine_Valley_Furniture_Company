<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="SurveyResults.aspx.vb" Inherits="Results_SurveyResults" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">Survey Results</asp:Content>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
<style>
.survey-selector {
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 1.5rem;
    margin-bottom: 2rem;
    box-shadow: var(--shadow);
    display: flex;
    align-items: center;
    gap: 1rem;
    flex-wrap: wrap;
}
.results-summary-bar {
    display: flex;
    gap: 1rem;
    margin-bottom: 2rem;
    flex-wrap: wrap;
}
.rsb-item {
    flex: 1;
    min-width: 160px;
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 1.25rem 1.5rem;
    text-align: center;
    box-shadow: var(--shadow);
}
.rsb-item .rsb-val { font-size: 2rem; font-weight: 800; color: var(--red); }
.rsb-item .rsb-lbl { font-size: .8rem; color: var(--muted); margin-top: .2rem; }
</style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrapper">

    <div class="page-header">
        <h1>Survey <span>Results</span></h1>
        <p>Visual analysis of responses for the selected survey.</p>
    </div>

    <!-- Survey selector -->
    <div class="survey-selector">
        <label class="form-label" style="margin:0;white-space:nowrap;font-size:.9rem;">Select Survey:</label>
        <asp:DropDownList ID="ddlSurvey" runat="server" CssClass="form-control" style="flex:1;min-width:240px;" />
        <asp:Button ID="btnLoad" runat="server" Text="Load Results ->"
            CssClass="btn btn-danger" OnClick="btnLoad_Click" />
    </div>

    <asp:Panel ID="pnlResults" runat="server" Visible="false">

        <!-- Summary bar -->
        <div class="results-summary-bar">
            <div class="rsb-item">
                <div class="rsb-val"><asp:Literal ID="litTotalResp" runat="server">0</asp:Literal></div>
                <div class="rsb-lbl">Total Responses</div>
            </div>
            <div class="rsb-item">
                <div class="rsb-val"><asp:Literal ID="litTotalQ" runat="server">0</asp:Literal></div>
                <div class="rsb-lbl">Questions</div>
            </div>
            <div class="rsb-item">
                <div class="rsb-val"><asp:Literal ID="litAnonMode" runat="server">-</asp:Literal></div>
                <div class="rsb-lbl">Anonymity</div>
            </div>
        </div>

        <!-- Per-question result blocks -->
        <asp:PlaceHolder ID="phResults" runat="server" />

        <asp:Panel ID="pnlNoData" runat="server" Visible="false">
            <div class="empty-state">
                <div class="empty-icon"></div>
                <h3>No Responses Yet</h3>
                <p>No one has taken this survey yet. Share it with surveyors!</p>
            </div>
        </asp:Panel>

    </asp:Panel>

</div>
</asp:Content>

