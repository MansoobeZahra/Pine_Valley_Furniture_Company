<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RiderDashboard.aspx.vb" Inherits="RiderDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rider Dashboard - QUICK byte</title>
    <link rel="stylesheet" href="rider-dashboard.css">
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
            <div class="dashboard-wrapper">
                <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                <h1>Rider Portal</h1>
                <p class="subtitle">Manage your deliveries</p>

                <div class="rider-info">
                    <h2>Rider Profile</h2>
                    <div class="info-row">
                        <span class="label">Region:</span>
                        <span class="value"><asp:Label ID="lblRegion" runat="server" Font-Bold="true"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="label">Availability:</span>
                        <span class="value">
                            <label class="toggle-label">
                                <asp:CheckBox ID="chkAvailability" runat="server" AutoPostBack="true" OnCheckedChanged="chkAvailability_CheckedChanged" />
                                <asp:Label ID="lblStatusText" runat="server"></asp:Label>
                            </label>
                        </span>
                    </div>
                </div>

                <!-- NEW: Available Orders in Region -->
                <div class="assigned-orders" style="margin-top: 30px; border-top: 2px solid #ba1010; padding-top: 20px;">
                    <h2>Available Orders in <asp:Label ID="lblRegionTitle" runat="server"></asp:Label></h2>
                    <asp:GridView ID="gvAvailableOrders" runat="server" AutoGenerateColumns="False" CssClass="orders-table" GridLines="None" DataKeyNames="OrderID" OnRowCommand="gvAvailableOrders_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="Order #" />
                            <asp:BoundField DataField="RestaurantName" HeaderText="Restaurant" />
                            <asp:BoundField DataField="Items" HeaderText="Items" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnPickOrder" runat="server" Text="Pick Up Order" CommandName="PickOrder" CommandArgument='<%# Eval("OrderID") %>' CssClass="btn-update" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="no-results">No orders available in your region.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <div class="assigned-orders">
                    <h2>Active Deliveries (Assigned to You)</h2>
                    <asp:GridView ID="gvAssignedOrders" runat="server" AutoGenerateColumns="False" CssClass="orders-table" GridLines="None" DataKeyNames="OrderID">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                            <asp:BoundField DataField="CustomerInfo" HeaderText="Customer" HtmlEncode="false" />
                            <asp:BoundField DataField="RestaurantInfo" HeaderText="Restaurant" HtmlEncode="false" />
                            <asp:TemplateField HeaderText="Update Status">
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="status-select">
                                        <asp:ListItem Value="Assigned" Text="Assigned"></asp:ListItem>
                                        <asp:ListItem Value="Picked Up" Text="Picked Up"></asp:ListItem>
                                        <asp:ListItem Value="Delivered" Text="Delivered"></asp:ListItem>
                                    </asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn-update" OnClick="btnUpdate_Click" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="no-results">You have no active deliveries.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <div class="delivery-history">
                    <h2>Completed & Confirmed History</h2>
                    <asp:GridView ID="gvDeliveryHistory" runat="server" AutoGenerateColumns="False" CssClass="history-table" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                            <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                            <asp:BoundField DataField="Status" HeaderText="Final Status" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
        <footer>
            <p>&copy; 2026 QUICK byte - Taste the speed</p>
        </footer>
    </form>
</body>
</html>
