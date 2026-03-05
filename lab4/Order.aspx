<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Order.aspx.vb" Inherits="OrderPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Order Placement - Pine Valley Furniture</title>
    </head>

    <body style="font-family: Arial, sans-serif;">
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
            <a href="../index.html">Back to All Labs</a>
            <br /><br />
            <b>Order Placement</b>
            <br /><br />
            <asp:Label ID="lblMessage" runat="server" />
            <br /><br />
            <table>
                <tr>
                    <td>Customer ID:</td>
                    <td>
                        <asp:TextBox ID="txtCustomerID" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>Order Date:</td>
                    <td>
                        <asp:TextBox ID="txtOrderDate" runat="server" placeholder="YYYY-MM-DD" />
                    </td>
                </tr>
            </table>
            <br />
            <b>Order Items</b>
            <table border="1">
                <tr>
                    <th>Product ID</th>
                    <th>Quantity</th>
                </tr>
                <tr>
                    <td>
                        <asp:TextBox ID="txtProdID1" runat="server" />
                    </td>
                    <td>
                        <asp:TextBox ID="txtQty1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:TextBox ID="txtProdID2" runat="server" />
                    </td>
                    <td>
                        <asp:TextBox ID="txtQty2" runat="server" />
                    </td>
                </tr>
            </table>
            <br />
            <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" OnClick="btnPlaceOrder_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CausesValidation="false" />

            <hr />
            <b>Order Lookup</b>
            <br />
            Customer ID:
            <asp:TextBox ID="txtLookupCustID" runat="server" Width="80px" />
            Product ID:
            <asp:TextBox ID="txtLookupProdID" runat="server" Width="80px" />
            <asp:Button ID="btnLookup" runat="server" Text="Lookup" OnClick="btnLookup_Click"
                CausesValidation="false" />
            <br /><br />
            <asp:GridView ID="gvLookupResults" runat="server"></asp:GridView>
        </form>
    </body>

    </html>