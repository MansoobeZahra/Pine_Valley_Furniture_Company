<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Help.aspx.vb" Inherits="HelpPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Help - Pine Valley Furniture</title>
    </head>

    <body style="font-family: Arial, sans-serif;">
        <div style="background-color: #583937; color: white; padding: 20px; text-align: center;">
            <h1><img src="logo.png" alt="logo_PVFC" height="50" style="margin-left: 0px; vertical-align: middle;" />
                Pine Valley Furniture Company</h1>
            <p>Mansoob-e-Zahra | Lab 07</p>
        </div>
        <div style="background-color: #f4f4f4; padding: 10px; border-bottom: 1px solid #ccc; text-align: center;">
            <asp:HyperLink ID="lnkRegistration" runat="server" NavigateUrl="Registration.aspx">Registration | </asp:HyperLink><a href="Update.aspx">Update Info</a> |
            <a href="Search.aspx">Search</a> |
            <a href="Order.aspx">Order</a>
            <asp:HyperLink ID="lnkCatalog" runat="server" NavigateUrl="Catalog.aspx"> | Catalog</asp:HyperLink>
            <asp:HyperLink ID="lnkSegmentation" runat="server" NavigateUrl="CustomerSegmentation.aspx"> | Segmentation</asp:HyperLink>
            <asp:HyperLink ID="lnkForecasting" runat="server" NavigateUrl="ManagerDashboard.aspx"> | Forecasting</asp:HyperLink> |
            <a href="Help.aspx">Help</a> |
            <a href="Logout.aspx" style="color:#583937;font-weight:bold;">Logout</a>
        </div>

        <div style="background:#fffbe6;text-align:center;padding:3px;font-size:13px;border-bottom:1px solid #ddd;"><asp:Label ID="lblWelcome" runat="server" /></div>

        <form id="form1" runat="server">
            <a href="../index.html">Back to All Labs</a>
            <br /><br />
            <b>Help &amp; User Guide</b>
            <br /><br />
            <p><b>Registration:</b> Fill in the details (Name, Address, etc.) and click Register. The system handles ID
                generation automatically.</p>
            <p><b>Search:</b> Enter a description or select a product line to filter the inventory.</p>
            <p><b>Orders:</b> Provide your Customer ID and the Product IDs/Quantities you want to order.</p>
            <p><b>Catalog:</b> Manage the product list by adding new items. The Product ID is assigned automatically.
            </p>
            <hr />
            <p>&copy; 2026 Pine Valley Furniture Company</p>
        </form>
    </body>

    </html>