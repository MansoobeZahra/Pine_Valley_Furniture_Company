<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ManageUsers.aspx.vb" Inherits="ManageUsers" %>
<%@ Register TagPrefix="uc" TagName="Navbar" Src="~/Navbar.ascx" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FeedBACK - Manage Users</title>
    <link rel="stylesheet" href="Site.css" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
        <uc:Navbar ID="Navbar1" runat="server" />
        <div class="page-wrapper">
            <div class="page-header" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;">
                <div>
                    <h1>Manage <span>Users</span></h1>
                    <p>View, activate/deactivate users and control their roles.</p>
                </div>
                <a href="~/Register.aspx" runat="server" class="btn btn-danger">+ Add New User</a>
            </div>
            <asp:Panel ID="pnlMsg" runat="server" Visible="false">
                <div class="alert alert-success">(Done) <asp:Literal ID="litMsg" runat="server" /></div>
            </asp:Panel>
            <div class="card">
                <div class="card-header">
                    <h2><span class="icon blue"></span> All Users</h2>
                    <div style="display:flex;gap:.5rem;">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                            placeholder="Search by name or username" style="width:220px;" />
                        <asp:Button ID="btnSearch" runat="server" Text="" CssClass="btn btn-outline"
                            OnClick="btnSearch_Click" />
                    </div>
                </div>
                <div class="card-body" style="padding:0;">
                    <div class="table-wrapper">
                        <asp:GridView ID="gvUsers" runat="server" CssClass="data-table"
                            AutoGenerateColumns="false" GridLines="None" DataKeyNames="UserID"
                            OnRowCommand="gvUsers_RowCommand"
                            EmptyDataText="No users found.">
                            <Columns>
                                <asp:BoundField DataField="FullName"    HeaderText="Full Name" />
                                <asp:BoundField DataField="Username"    HeaderText="Username" />
                                <asp:BoundField DataField="Email"       HeaderText="Email" />
                                <asp:BoundField DataField="RoleName"    HeaderText="Role" />
                                <asp:BoundField DataField="CreatedDate" HeaderText="Joined"
                                    DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <%# If(CBool(Eval("IsActive")),
                                            "<span class='badge badge-green'>* Active</span>",
                                            "<span class='badge badge-gray'>* Inactive</span>") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbToggle" runat="server"
                                            CommandName="ToggleStatus"
                                            CommandArgument='<%# Eval("UserID") & "|" & Eval("IsActive") %>'
                                            CssClass='<%# If(CBool(Eval("IsActive")), "btn btn-sm btn-warning", "btn btn-sm btn-success") %>'
                                            OnClientClick="return confirm(&quot;Change user status?&quot;);">
                                            <%# If(CBool(Eval("IsActive")), " Deactivate", "> Activate") %>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

