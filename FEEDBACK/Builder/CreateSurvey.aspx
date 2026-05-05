<%@ Page Language="VB" MasterPageFile="/FEEDBACK/Site.master" AutoEventWireup="false"
    CodeFile="CreateSurvey.aspx.vb" Inherits="Builder_CreateSurvey" %>

<asp:Content ContentPlaceHolderID="PageTitle" runat="server">Create Survey</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrapper" style="max-width:720px;">

    <div class="page-header">
        <h1>Create New <span>Survey</span></h1>
        <p>Fill in the survey details below, then add your questions.</p>
    </div>

    <asp:Panel ID="pnlError" runat="server" Visible="false">
        <div class="alert alert-danger"> <asp:Literal ID="litError" runat="server" /></div>
    </asp:Panel>

    <div class="card">
        <div class="card-header">
            <h2><span class="icon red"></span> Survey Details</h2>
        </div>
        <div class="card-body">

            <div class="form-group">
                <label class="form-label">Survey Title <span style="color:var(--red)">*</span></label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"
                    placeholder="e.g. Customer Satisfaction Survey 2026" MaxLength="200" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle"
                    Display="Dynamic" CssClass="field-error" ErrorMessage="Title is required." />
            </div>

            <div class="form-group">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"
                    CssClass="form-control" placeholder="Brief description of this survey"
                    Rows="3" MaxLength="500" />
            </div>

            <div class="form-group">
                <div class="form-check">
                    <asp:CheckBox ID="chkActive" runat="server" Checked="true" />
                    <label class="form-label" style="margin:0;cursor:pointer;">Make survey active immediately</label>
                </div>
            </div>

            <div style="display:flex;gap:1rem;margin-top:1.5rem;">
                <asp:Button ID="btnCreate" runat="server" Text="Create Survey &amp; Add Questions ->"
                    CssClass="btn btn-danger btn-lg" OnClick="btnCreate_Click" />
                <a href="Dashboard.aspx" class="btn btn-outline btn-lg">Cancel</a>
            </div>
        </div>
    </div>

</div>
</asp:Content>

