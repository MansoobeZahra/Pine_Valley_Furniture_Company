<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Search.aspx.vb" Inherits="Search" %>

    <!DOCTYPE html>
    <html lang="en">

    <head runat="server">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Search Orders - QUICK byte</title>
        <link rel="stylesheet" href="search.css">
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
            <div class="container">
                <div class="search-wrapper">
                    <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                    <h1>QuickByte Search</h1>
                    <p class="subtitle">Find your favorite food</p>

                    <div class="search-box"
                        style="background: #fcf8ec; padding: 25px; border-radius: 10px; border: 1px solid #ba1010;">
                        <div style="margin-bottom: 20px;">
                            <label
                                style="font-weight: bold; color: #ba1010; display: block; margin-bottom: 10px;">Select
                                Your City:</label>
                            <asp:DropDownList ID="ddlRegion" runat="server" CssClass="search-input" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlRegion_SelectedIndexChanged"
                                style="width: 100%; border: 1px solid #ba1010;">
                                <asp:ListItem Value="Karachi">Karachi</asp:ListItem>
                                <asp:ListItem Value="Lahore">Lahore</asp:ListItem>
                                <asp:ListItem Value="Islamabad">Islamabad</asp:ListItem>
                                <asp:ListItem Value="Rawalpindi">Rawalpindi</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div style="display: flex; gap: 10px;">
                            <asp:TextBox ID="txtSearch" runat="server"
                                placeholder="What are you craving? (e.g. Pizza, Biryani)" CssClass="search-input"
                                style="flex:1;"></asp:TextBox>
                            <asp:Button ID="btnSearch" runat="server" Text="Search Menu" CssClass="btn-search"
                                OnClick="btnSearch_Click" style="background:#ba1010;" />
                        </div>
                    </div>

                    <div class="results-section">
                        <h2>Available Food Near You</h2>

                        <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Visible="false"
                            style="display:block; margin-bottom:10px; font-weight:bold;"></asp:Label>

                        <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False" CssClass="results-table"
                            GridLines="None" DataKeyNames="ItemID,RestaurantID" OnRowCommand="gvResults_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="ItemName" HeaderText="Menu Item" />
                                <asp:BoundField DataField="RestaurantName" HeaderText="Restaurant" />
                                <asp:TemplateField HeaderText="Rating">
                                    <ItemTemplate>
                                        <span style="color:#f8be2c; font-weight:bold;">
                                            <%# Eval("AvgRating", "{0:F1}" ) %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                                <asp:BoundField DataField="Description" HeaderText="Description" />
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:Button ID="btnOrder" runat="server" Text="Order Now" CommandName="Order"
                                            CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn-search"
                                            style="padding: 5px 15px; font-size: 0.8rem;" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="no-results">No results in your region. Try searching for something else!
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>

                    <div class="links">
                        <a href="Default.aspx">Back to Home</a>
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