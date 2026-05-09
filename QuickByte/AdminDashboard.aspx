<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminDashboard.aspx.vb" Inherits="AdminDashboard" %>

    <!DOCTYPE html>
    <html lang="en">

    <head runat="server">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - QUICK byte</title>
        <link rel="stylesheet" href="index.css">
        <style>
            .dashboard-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-top: 20px;
            }

            .stat-card {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                border-top: 4px solid #ba1010;
            }

            .stat-card h2 {
                color: #ba1010;
                margin-bottom: 15px;
                font-size: 1.2rem;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }

            .admin-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 0.9rem;
            }

            .admin-table th {
                background: #fcf8ec;
                text-align: left;
                padding: 10px;
                border-bottom: 2px solid #ba1010;
            }

            .admin-table td {
                padding: 10px;
                border-bottom: 1px solid #eee;
            }

            .segment-premium {
                color: gold;
                font-weight: bold;
            }

            .segment-regular {
                color: #555;
            }

            .segment-bulk {
                color: #ba1010;
                font-weight: bold;
            }

            .full-width {
                grid-column: 1 / -1;
            }
        </style>
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
                            <% If Session("Role")="Customer" Then %>
                                <li><a href="Search.aspx">Search</a></li>
                                <li><a href="Orders.aspx">My Orders</a></li>
                                <% ElseIf Session("Role")="RestaurantManager" Then %>
                                    <li><a href="Menu.aspx">Manage Menu</a></li>
                                    <li><a href="Orders.aspx">Orders</a></li>
                                    <% ElseIf Session("Role")="Rider" Then %>
                                        <li><a href="RiderDashboard.aspx">Dashboard</a></li>
                                        <% ElseIf Session("Role")="Admin" Or Session("Role")="PlatformManager" Then %>
                                            <li><a href="Orders.aspx">All Orders</a></li>
                                            <li><a href="AdminDashboard.aspx">Segmentation Dashboard</a></li>
                                            <% End If %>
                                                <li>
                                                    <asp:LinkButton ID="lnkLogout" runat="server"
                                                        OnClick="lnkLogout_Click">Logout</asp:LinkButton>
                                                </li>
                                                <li class="user-welcome"><b>
                                                        <%= Session("Role") %>: <%= User.Identity.Name %>
                                                    </b></li>
                                                <% Else %>
                                                    <li><a href="Register.aspx">Register</a></li>
                                                    <li><a href="Login.aspx">Login</a></li>
                                                    <li><a href="Search.aspx">Search</a></li>
                                                    <% End If %>
                    </ul>
                </div>
            </nav>

            <div class="container" style="max-width: 1200px;">
                <div class="search-wrapper" style="background:transparent; padding:0; box-shadow:none;">
                    <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                    <h1 style="color: #ba1010; font-size: 2.5rem; margin-bottom: 5px;">Business Segmentation Dashboard
                    </h1>
                    <p class="subtitle" style="margin-bottom: 30px;">Network-wide stakeholder analytics & logistics</p>

                    <!-- Admin Only: Add Restaurant -->
                    <div class="stat-card full-width" style="margin-bottom: 30px; border: 1px solid #eee;">
                        <h2
                            style="background: #fcf8ec; padding: 10px; margin: -20px -20px 20px -20px; border-radius: 10px 10px 0 0;">
                            Add New Restaurant Partner</h2>
                        <div
                            style="display:grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                            <asp:TextBox ID="txtNewRestName" runat="server" placeholder="Restaurant Name"
                                CssClass="form-input"></asp:TextBox>
                            <asp:TextBox ID="txtNewRestEmail" runat="server" placeholder="Manager Email"
                                CssClass="form-input"></asp:TextBox>
                            <asp:TextBox ID="txtNewRestPhone" runat="server" placeholder="Contact Number"
                                CssClass="form-input"></asp:TextBox>
                            <asp:DropDownList ID="ddlNewRestRegion" runat="server" CssClass="form-input">
                                <asp:ListItem Value="" Text="Select City/Region"></asp:ListItem>
                                <asp:ListItem Value="Karachi" Text="Karachi"></asp:ListItem>
                                <asp:ListItem Value="Lahore" Text="Lahore"></asp:ListItem>
                                <asp:ListItem Value="Islamabad" Text="Islamabad"></asp:ListItem>
                                <asp:ListItem Value="Rawalpindi" Text="Rawalpindi"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtNewRestAddress" runat="server" placeholder="Street Address"
                                CssClass="form-input"></asp:TextBox>
                            <asp:Button ID="btnAddRestaurant" runat="server" Text="Register Restaurant"
                                CssClass="btn-add" style="background:#ba1010;" OnClick="btnAddRestaurant_Click" />
                        </div>
                        <asp:Label ID="lblAdminMessage" runat="server" ForeColor="Green" Visible="false"
                            style="display:block; margin-top:10px; font-weight:bold;"></asp:Label>
                    </div>

                    <div class="dashboard-grid">
                        <!-- Customers Segmentation -->
                        <div class="stat-card full-width">
                            <h2>Customer Segmentation</h2>
                            <asp:GridView ID="gvCustomerSegments" runat="server" AutoGenerateColumns="False"
                                CssClass="admin-table" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                                    <asp:BoundField DataField="Region" HeaderText="Region" />
                                    <asp:BoundField DataField="TotalOrders" HeaderText="Orders" />
                                    <asp:BoundField DataField="TotalSpent" HeaderText="Total Spent"
                                        DataFormatString="{0:C}" />
                                    <asp:TemplateField HeaderText="Segment">
                                        <ItemTemplate>
                                            <span class='<%# GetSegmentClass(Eval("Segment")) %>'>
                                                <%# Eval("Segment") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>

                        <!-- Restaurants Performance -->
                        <div class="stat-card full-width">
                            <h2>Restaurant Revenue & Account Status</h2>
                            <asp:GridView ID="gvRestaurants" runat="server" AutoGenerateColumns="False"
                                CssClass="admin-table" GridLines="None" DataKeyNames="RestaurantID"
                                OnRowCommand="gvRestaurants_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="Name" HeaderText="Restaurant" />
                                    <asp:BoundField DataField="Region" HeaderText="Region" />
                                    <asp:BoundField DataField="OrderCount" HeaderText="Orders" />
                                    <asp:BoundField DataField="Revenue" HeaderText="Current Revenue"
                                        DataFormatString="{0:C}" />
                                    <asp:TemplateField HeaderText="Rating">
                                        <ItemTemplate>
                                            <b style="color:#f8be2c;">
                                                <%# Eval("AvgRating", "{0:F1}" ) %>
                                            </b>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span
                                                class='<%# If(Convert.ToBoolean(Eval("IsActive")), "status-active", "status-disabled") %>'>
                                                <%# If(Convert.ToBoolean(Eval("IsActive")), "Active" , "Disabled" ) %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:Button ID="btnToggleRest" runat="server"
                                                Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Disable", "Enable") %>'
                                                CommandName="ToggleStatus" CommandArgument='<%# Eval("RestaurantID") %>'
                                                CssClass="btn-view" style="padding:4px 8px; font-size:0.75rem;" />
                                            <asp:Button ID="btnResetRest" runat="server" Text="Reset Revenue"
                                                CommandName="ResetRevenue" CommandArgument='<%# Eval("RestaurantID") %>'
                                                CssClass="btn-reset" style="padding:4px 8px; font-size:0.75rem;"
                                                OnClientClick="return confirm('Clear revenue for this restaurant?');" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>

                        <!-- Riders Activity -->
                        <div class="stat-card full-width">
                            <h2>Rider Earnings & Dispatch Status</h2>
                            <asp:GridView ID="gvRiders" runat="server" AutoGenerateColumns="False"
                                CssClass="admin-table" GridLines="None" DataKeyNames="RiderID"
                                OnRowCommand="gvRiders_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="Name" HeaderText="Rider" />
                                    <asp:BoundField DataField="Region" HeaderText="Region" />
                                    <asp:BoundField DataField="Deliveries" HeaderText="Deliveries" />
                                    <asp:BoundField DataField="Revenue" HeaderText="Earnings"
                                        DataFormatString="{0:C}" />
                                    <asp:TemplateField HeaderText="Rating">
                                        <ItemTemplate>
                                            <b style="color:#f8be2c;">
                                                <%# Eval("AvgRating", "{0:F1}" ) %>
                                            </b>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Availability">
                                        <ItemTemplate>
                                            <span
                                                class='<%# "badge " & If(Convert.ToBoolean(Eval("Availability")), "badge-available", "badge-offline") %>'>
                                                <%# If(Convert.ToBoolean(Eval("Availability")), "Available" , "Offline"
                                                    ) %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:Button ID="btnToggleRider" runat="server"
                                                Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Disable", "Enable") %>'
                                                CommandName="ToggleStatus" CommandArgument='<%# Eval("RiderID") %>'
                                                CssClass="btn-view" style="padding:4px 8px; font-size:0.75rem;" />
                                            <asp:Button ID="btnResetRider" runat="server" Text="Reset Earnings"
                                                CommandName="ResetRevenue" CommandArgument='<%# Eval("RiderID") %>'
                                                CssClass="btn-reset" style="padding:4px 8px; font-size:0.75rem;"
                                                OnClientClick="return confirm('Clear earnings for this rider?');" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>

                        <!-- Stakeholder Feedback -->
                        <div class="stat-card full-width" style="border-top: 2px solid #ba1010; margin-top: 20px;">
                            <h2 style="color:#ba1010;">Stakeholder Ratings & Reviews</h2>
                            <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="False"
                                CssClass="admin-table" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="TargetName" HeaderText="Rated Entity" />
                                    <asp:BoundField DataField="TargetType" HeaderText="Role" />
                                    <asp:TemplateField HeaderText="Rating">
                                        <ItemTemplate>
                                            <span
                                                class='<%# "badge " & If(Convert.ToInt32(Eval("Rating")) >= 4, "badge-high", "badge-low") %>'>
                                                <%# Eval("Rating") %> / 5
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Comment" HeaderText="Review Comment" />
                                    <asp:BoundField DataField="Reviewer" HeaderText="By" />
                                    <asp:BoundField DataField="Region" HeaderText="City" />
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="no-results">No feedback submitted yet.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

        </form>
        <footer>
    </body>
    <p>&copy; 2026 QUICK byte - Taste the speed</p>
    <p>Internet application development</p>
    <p>Mansoob-e-Zahra</p>
    </footer>

    </html>