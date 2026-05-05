<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CreateSurvey.aspx.vb" Inherits="CreateSurvey" %>
<%@ Register TagPrefix="uc" TagName="Navbar" Src="~/Navbar.ascx" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FeedBACK - Create Survey</title>
    <link rel="stylesheet" href="Site.css" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <uc:Navbar ID="Navbar1" runat="server" />
        <div class="page-wrapper">
            <div class="page-header">
                <h1>Create <span>Survey</span></h1>
                <p>Define your survey title and basic settings.</p>
            </div>
            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="alert alert-danger"><asp:Literal ID="litError" runat="server" /></div>
            </asp:Panel>

            <div class="card" style="max-width:600px;margin:0 auto;">
                <div class="card-body">
                    <div class="form-group">
                        <label class="form-label">Survey Title</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Enter survey title..." />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle"
                            Display="Dynamic" CssClass="field-error" ErrorMessage="Title is required." />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Description (Optional)</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3" placeholder="Briefly describe what this survey is about..." />
                    </div>
                    <div class="form-group">
                        <label class="checkbox-container">
                            <asp:CheckBox ID="chkActive" runat="server" Checked="true" />
                            Enable Survey (Active)
                        </label>
                    </div>
                    <div style="display:flex;gap:.75rem;margin-top:1.5rem;">
                        <asp:Button ID="btnCreate" runat="server" Text="Create Survey & Add Questions ->"
                            CssClass="btn btn-danger" OnClick="btnCreate_Click" />
                        <a href="BuilderDashboard.aspx" class="btn btn-outline">Cancel</a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

