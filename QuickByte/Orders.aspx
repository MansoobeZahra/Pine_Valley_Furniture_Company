<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Orders.aspx.vb" Inherits="Orders" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - QUICK byte</title>
    <link rel="stylesheet" href="order-management.css">
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
            <div class="order-wrapper">
                <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                <h1>QuickByte Orders</h1>
                <p class="subtitle">Your order history and status</p>

                <div class="orders-table-section">
                    <h2><asp:Label ID="lblTitle" runat="server" Text="All Orders"></asp:Label></h2>
                    <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="orders-table" GridLines="None" OnRowCommand="gvOrders_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="Order #" />
                            <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                            <asp:BoundField DataField="RestaurantName" HeaderText="Restaurant" />
                            <asp:BoundField DataField="Items" HeaderText="Items" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                            <asp:BoundField DataField="Region" HeaderText="City" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnConfirm" runat="server" Text="Confirm Receipt" CommandName="ConfirmOrder" CommandArgument='<%# Eval("OrderID") %>' 
                                        Visible='<%# Convert.ToString(Eval("Status")) = "Delivered" AndAlso Convert.ToString(Session("Role")) = "Customer" %>' CssClass="btn-view" style="background:#28a745;" />
                                    <asp:Label ID="lblConfirmed" runat="server" Text="Completed" Visible='<%# Convert.ToString(Eval("Status")) = "Confirmed" %>' ForeColor="Green" Font-Bold="true"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="no-results">No orders found.</div>
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
