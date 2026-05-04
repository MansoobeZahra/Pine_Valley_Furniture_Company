<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Order.aspx.vb" Inherits="OrderPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Order Placement - Pine Valley Furniture</title>
        <style>
            .rec-box { background: #f1f8e9; border: 1px solid #8bc34a; padding: 15px; border-radius: 5px; margin-top: 20px; }
            .rec-title { font-weight: bold; color: #33691e; }
            .rec-item { display: inline-block; background: white; padding: 4px 10px; margin: 5px; border-radius: 15px; border: 1px solid #c5e1a5; font-size: 12px; }
        </style>
        <script>
            function loadOrderSuggestions() {
                // Fetch reorder suggestions for current customer from Blazor API
                const custId = '<%= Session("CustomerID") %>';
                if (custId) {
                    fetch('http://localhost:5170/api/recommendation/reorder?customerId=' + custId)
                        .then(r => r.json())
                        .then(data => {
                            const div = document.getElementById('reorderList');
                            if (data.length > 0) {
                                div.innerHTML = data.map(i => `<span class="rec-item">${i.name}</span>`).join('');
                                document.getElementById('reorderPanel').style.display = 'block';
                            }
                        });
                }
            }

            window.onload = loadOrderSuggestions;
        </script>
    </head>

    <body style="font-family: Arial, sans-serif;">
        <div style="background-color: #583937; color: white; padding: 20px; text-align: center;">
            <h1><img src="logo.png" alt="logo_PVFC" height="50" style="margin-left: 0px; vertical-align: middle;" />
                Pine Valley Furniture Company</h1>
            <p>Mansoob-e-Zahra | Lab 11</p>
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

        <div style="background:#fffbe6;text-align:center;padding:3px;font-size:13px;border-bottom:1px solid #ddd;">
            <asp:Label ID="lblWelcome" runat="server" />
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
                    <td colspan="2">
                        <asp:Label ID="lblCustomerInfo" runat="server" Font-Bold="true" ForeColor="#583937" />
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
            <br />
            <b>Current Cart Items</b>
            <asp:GridView ID="gvCart" runat="server" AutoGenerateColumns="False" Width="100%" GridLines="None"
                CellPadding="5">
                <HeaderStyle BackColor="#583937" ForeColor="White" />
                <Columns>
                    <asp:BoundField DataField="Description" HeaderText="Item" />
                    <asp:BoundField DataField="Quantity" HeaderText="Qty" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}"
                        ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}"
                        ItemStyle-HorizontalAlign="Right" />
                </Columns>
            </asp:GridView>
            <div style="text-align: right; margin-top: 10px; border-top: 2px solid #583937; padding-top: 5px;">
                <b>Total Amount:
                    <asp:Label ID="lblGrandTotal" runat="server" Text="$0.00" />
                </b>
            </div>
            <br />
            <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" OnClick="btnPlaceOrder_Click"
                style="background-color: #583937; color: white; padding: 10px 20px; border: none; cursor: pointer;" />
            <asp:Button ID="btnClear" runat="server" Text="Clear Cart" OnClick="btnClear_Click" CausesValidation="false"
                style="margin-left: 10px; padding: 10px; border: 1px solid #ccc; background: none; cursor: pointer;" />

            <!-- Reordering Suggestions -->
            <div id="reorderPanel" class="rec-box" style="display:none;">
                <div class="rec-title">Frequently Reordered by You:</div>
                <div id="reorderList"></div>
            </div>

            <!-- Management Link (for Lab 11 demo) -->
            <div style="margin-top: 40px; border-top: 1px dashed #ccc; padding-top: 10px;">
                <a href="ManagerDashboard.aspx" style="color: #666; font-size: 12px;">Manager: View Forecasting Dashboard</a>
            </div>
        </form>
    </body>

    </html>