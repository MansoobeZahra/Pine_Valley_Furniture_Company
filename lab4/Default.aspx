<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="DefaultPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Pine Valley Furniture Company</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
    </head>

    <body>
        <div style="background-color: #583937; color: white; padding: 20px; text-align: center;">
            <h1><img src="logo.png" alt="logo_PVFC" height="50" style="margin-left: 0px; vertical-align: middle;" />
                Pine Valley Furniture Company</h1>
            <p>Mansoob-e-Zahra | Lab 04</p>
        </div>
        <div style="background-color: #f4f4f4; padding: 10px; border-bottom: 1px solid #ccc; text-align: center;">
            <a href="Registration.aspx">Registration</a> |
            <a href="Search.aspx">Search</a> |
            <a href="Order.aspx">Order</a> |
            <a href="Catalog.aspx">Catalog</a> |
            <a href="Help.aspx">Help</a>
        </div>
        <form id="form1" runat="server">
            <div class="page-wrapper">
                <div class="back-bar"><a href="../index.html">Back to All Labs</a></div>

                <!-- Hero Section -->
                <div class="hero-section">
                    <img src="logo.png" alt="PVFC Logo" class="hero-logo-img" />
                </div>

                <div class="menu-grid">
                    <a href="Registration.aspx" class="menu-item">
                        <div class="mi-title">New Customer Registration</div>
                    </a>
                    <a href="Search.aspx" class="menu-item">
                        <div class="mi-title">Search Products</div>
                    </a>
                    <a href="Order.aspx" class="menu-item">
                        <div class="mi-title">Product Selection &amp; Order</div>
                    </a>
                    <a href="Catalog.aspx" class="menu-item">
                        <div class="mi-title">Product Catalog Update</div>
                    </a>
                    <a href="Help.aspx" class="menu-item">
                        <div class="mi-title">Help &amp; User Guide</div>
                    </a>
                </div>
                <footer>&copy; 2026 Pine Valley Furniture Company | Mansoob-e-Zahra</footer>
            </div>
        </form>
    </body>

    </html>