<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Menu.aspx.vb" Inherits="MenuPage" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Management - QUICK byte</title>
    <link rel="stylesheet" href="menu-management.css">
    <link rel="stylesheet" href="index.css">
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <div class="nav-container">
                <a href="Default.aspx" class="nav-logo">
                    <img src="assets/logo.png" alt="QuickByte Logo" style="height:40px;" />
                    QuickByte
                </a>
                <ul class="nav-menu">
                    <li><a href="Default.aspx">Home</a></li>
                    <% If User.Identity.IsAuthenticated Then %>
                        <% If Session("Role") = "Customer" Then %>
                            <li><a href="Search.aspx">Search</a></li>
                            <li><a href="Orders.aspx">My Orders</a></li>
                        <% ElseIf Session("Role") = "RestaurantManager" Then %>
                            <li><a href="Menu.aspx">Manage Menu</a></li>
                            <li><a href="Orders.aspx">Orders</a></li>
                        <% ElseIf Session("Role") = "Rider" Then %>
                            <li><a href="RiderDashboard.aspx">Dashboard</a></li>
                        <% ElseIf Session("Role") = "Admin" Or Session("Role") = "PlatformManager" Then %>
                            <li><a href="Orders.aspx">All Orders</a></li>
                            <li><a href="AdminDashboard.aspx">Segmentation Dashboard</a></li>
                        <% End If %>
                        <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                        <li class="user-welcome"><b><%= Session("Role") %>: <%= User.Identity.Name %></b></li>
                    <% Else %>
                        <li><a href="Register.aspx">Register</a></li>
                        <li><a href="Login.aspx">Login</a></li>
                        <li><a href="Search.aspx">Search</a></li>
                    <% End If %>
                </ul>
            </div>
        </nav>
        <div class="container">
            <div class="menu-wrapper">
                <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                <h1>Menu Management</h1>
                <p class="subtitle">Add and manage your restaurant's menu</p>

                <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Visible="false" Font-Bold="true"></asp:Label>

                <div class="add-item-section">
                    <h2>Add New Menu Item</h2>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtItemName">Item Name:</label>
                            <asp:TextBox ID="txtItemName" runat="server" required="required"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtPrice">Price (Rs.):</label>
                            <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" step="0.01" required="required"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="txtDescription">Description:</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label class="checkbox-label">
                            <asp:CheckBox ID="chkAvailable" runat="server" Checked="true" />
                            Available for Order
                        </label>
                    </div>
                    <asp:Button ID="btnAdd" runat="server" Text="Add Item" CssClass="btn-add" OnClick="btnAdd_Click" />
                </div>

                <div class="menu-items-section">
                    <h2>Current Menu Items</h2>
                    <asp:GridView ID="gvMenuItems" runat="server" AutoGenerateColumns="False" CssClass="menu-table" GridLines="None" DataKeyNames="ItemID" OnRowCommand="gvMenuItems_RowCommand" OnRowDeleting="gvMenuItems_RowDeleting">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Item Name" />
                            <asp:BoundField DataField="Description" HeaderText="Description" />
                            <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Availability">
                                <ItemTemplate>
                                    <span style='<%# If(Convert.ToBoolean(Eval("Available")), "color:green;", "color:red;") %>'>
                                        <%# If(Convert.ToBoolean(Eval("Available")), "Active", "Hidden") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnToggle" runat="server" Text='<%# If(Convert.ToBoolean(Eval("Available")), "Hide", "Show") %>' 
                                        CommandName="ToggleAvailable" CommandArgument='<%# Eval("ItemID") %>' CssClass="btn-view" style="padding:5px 10px; font-size:0.8rem;" />
                                    <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="Delete" CssClass="btn-delete" style="padding:5px 10px; font-size:0.8rem;" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="no-results">No menu items found. Start by adding one above.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
        <footer>
            <p>&copy; 2026 QUICK byte - Taste the speed</p>
            <p>Internet application development</p>
            <p>Mansoob-e-Zahra</p>
        </footer>
    </form>
</body>
</html>
