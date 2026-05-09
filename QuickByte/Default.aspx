<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

    <!DOCTYPE html>
    <html lang="en">

    <head runat="server">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>QUICK byte - Home</title>
        <link rel="stylesheet" href="index.css">
    </head>

    <body>
        <form id="form1" runat="server">
            <!-- Navigation Bar -->
            <nav class="navbar">
                <div class="nav-container">
                    <a href="Default.aspx" class="nav-logo">
                        <img src="assets/logo.png" alt="QuickByte Logo" style="height:40px;" /> QuickByte
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
                <!-- Hero Section -->
                <section class="hero">
                    <img src="assets/logo.png" alt="QuickByte Logo" class="hero-logo" />
                    <h1>Taste the speed</h1>
                    <p class="subtitle">Food Delivery App - IAD Project</p>
                    <div class="hero-buttons">
                        <% If Not User.Identity.IsAuthenticated Then %>
                            <a href="Register.aspx" class="btn-primary">Get Started</a>
                            <% End If %>
                                <% If Session("Role") <> "Admin" And Session("Role") <> "PlatformManager" Then %>
                                        <a href="Search.aspx" class="btn-secondary">Browse Restaurants</a>
                                        <% End If %>
                    </div>

                    <% If Not User.Identity.IsAuthenticated Then %>
                        <div class="card-grid">
                            <div class="card">
                                <h3>Welcome to QuickByte</h3>
                                <p>Register now to start ordering food or join as a partner.</p>
                                <a href="Register.aspx" class="btn">Get Started</a>
                            </div>
                        </div>
                        <% Else %>
                            <% If Session("Role")="Customer" Then %>
                                <div class="card-grid">
                                    <div class="card">
                                        <h3>Search & Order</h3>
                                        <p>Browse regional menus and place orders instantly.</p>
                                        <a href="Search.aspx" class="btn">Start Ordering</a>
                                    </div>
                                    <div class="card">
                                        <h3>My Orders</h3>
                                        <p>Track your food from the kitchen to your doorstep.</p>
                                        <a href="Orders.aspx" class="btn">Track Orders</a>
                                    </div>
                                </div>
                                <% ElseIf Session("Role")="RestaurantManager" Then %>
                                    <div class="card-grid">
                                        <div class="card">
                                            <h3>Menu Management</h3>
                                            <p>Update your offerings and pricing in real-time.</p>
                                            <a href="Menu.aspx" class="btn">Manage Menu</a>
                                        </div>
                                        <div class="card">
                                            <h3>Order Fulfilment</h3>
                                            <p>Process incoming orders for your region.</p>
                                            <a href="Orders.aspx" class="btn">Process Orders</a>
                                        </div>
                                    </div>
                                    <% ElseIf Session("Role")="Rider" Then %>
                                        <div class="card-grid">
                                            <div class="card">
                                                <h3>Rider Dashboard</h3>
                                                <p>Manage your availability and delivery queue.</p>
                                                <a href="RiderDashboard.aspx" class="btn">Open Dashboard</a>
                                            </div>
                                            <div class="card">
                                                <h3>Earnings</h3>
                                                <p>Track your daily deliveries and revenue.</p>
                                                <a href="RiderDashboard.aspx" class="btn">View Earnings</a>
                                            </div>
                                        </div>
                                        <% ElseIf Session("Role")="Admin" Or Session("Role")="PlatformManager" Then %>
                                            <div class="card-grid">
                                                <div class="card">
                                                    <h3>Segmentation</h3>
                                                    <p>Analyze regional stakeholder performance.</p>
                                                    <a href=" AdminDashboard.aspx" class="btn">Admin Console</a>
                                                </div>
                                                <div class="card">
                                                    <h3>Logistics</h3>
                                                    <p>Oversee network-wide delivery operations.</p>
                                                    <a href="Orders.aspx" class="btn">All Orders</a>
                                                </div>
                                            </div>
                                            <% End If %>
                                                <% End If %>
                </section>
            </div>

            <footer>
                <p>&copy; 2026 QUICK byte - Taste the speed</p>
                <p>Internet application development</p>
                <p>Mansoob-e-Zahra</p>
            </footer>
        </form>
    </body>

    </html>