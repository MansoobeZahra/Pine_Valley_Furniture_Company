<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Search.aspx.vb" Inherits="SearchPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Search - Pine Valley Furniture</title>
        <style>
            body {
                font-family: Arial, sans-serif;
            }

            .section-box {
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 16px 20px;
                margin: 0 0 24px;
                background: #fff;
            }

            .section-title {
                font-size: 15px;
                font-weight: bold;
                color: #583937;
                margin-bottom: 10px;
            }

            .search-table td {
                padding: 4px 8px;
                vertical-align: middle;
            }

            .gv-orders th {
                background: #583937;
                color: white;
                padding: 7px 10px;
                text-align: left;
            }

            .gv-orders td {
                padding: 6px 10px;
                border-bottom: 1px solid #eee;
            }

            .gv-orders tr:nth-child(even) td {
                background: #fafafa;
            }

            .gv-orders tr:hover td {
                background: #fff3e0;
            }

            .grand-total {
                font-weight: bold;
                color: #583937;
                font-size: 14px;
                margin-top: 8px;
                text-align: right;
            }

            .order-summary {
                background: #fff8e1;
                border-left: 4px solid #583937;
                padding: 8px 14px;
                margin-top: 10px;
                font-size: 13px;
            }

            select {
                padding: 4px 8px;
                border: 1px solid #ccc;
                border-radius: 3px;
                min-width: 220px;
            }

            input[type=text] {
                padding: 4px 8px;
                border: 1px solid #ccc;
                border-radius: 3px;
            }
        </style>
    </head>

    <body style="font-family: Arial, sans-serif;">
        <div style="background-color: #583937; color: white; padding: 20px; text-align: center;">
            <h1><img src="logo.png" alt="logo_PVFC" height="50" style="margin-left: 0px; vertical-align: middle;" />
                Pine Valley Furniture Company</h1>
            <p>Mansoob-e-Zahra | Lab 06</p>
        </div>
        <div style="background-color: #f4f4f4; padding: 10px; border-bottom: 1px solid #ccc; text-align: center;">
            <asp:HyperLink ID="lnkRegistration" runat="server" NavigateUrl="Registration.aspx">Registration |
            </asp:HyperLink><a href="Update.aspx">Update Info</a> |
            <a href="Search.aspx">Search</a> |
            <a href="Order.aspx">Order</a>
            <asp:HyperLink ID="lnkCatalog" runat="server" NavigateUrl="Catalog.aspx"> | Catalog</asp:HyperLink> |
            <a href="Help.aspx">Help</a> |
            <a href="Logout.aspx" style="color:#583937;font-weight:bold;">Logout</a>
        </div>

        <div style="background:#fffbe6;text-align:center;padding:3px;font-size:13px;border-bottom:1px solid #ddd;">
            <asp:Label ID="lblWelcome" runat="server" />
        </div>

        <form id="form1" runat="server">
            <div style="padding: 16px 20px;">
                <a href="../index.html">Back to All Labs</a>
                <br /><br />

                <!-- ─── PRODUCT SEARCH ─────────────────────────────────── -->
                <div class="section-box">
                    <div class="section-title"> Search Products / Inventory</div>
                    <asp:Label ID="lblMessage" runat="server" Visible="false" />
                    <table class="search-table">
                        <tr>
                            <td>Description:</td>
                            <td>
                                <asp:TextBox ID="txtProductDesc" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>Product Line:</td>
                            <td>
                                <asp:DropDownList ID="ddlProductLine" runat="server">
                                    <asp:ListItem Text="-- Any --" Value="" />
                                    <asp:ListItem Text="Living Room" Value="1" />
                                    <asp:ListItem Text="Dining Room" Value="2" />
                                    <asp:ListItem Text="Bedroom" Value="3" />
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Button ID="btnSearch" runat="server" Text="Search Products"
                                    OnClick="btnSearch_Click" />
                            </td>
                        </tr>
                    </table>
                    <br />
                    <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False"
                        OnRowCommand="gvResults_RowCommand" DataKeyNames="Product_Id">
                        <Columns>
                            <asp:BoundField DataField="Product_Description" HeaderText="Description" />
                            <asp:BoundField DataField="ProductLineName" HeaderText="Category" />
                            <asp:BoundField DataField="Product_Finish" HeaderText="Finish" />
                            <asp:BoundField DataField="Standard_Price" HeaderText="Price" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Quantity">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtQty" runat="server" Text="1" Width="40px" type="number"
                                        min="1" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart"
                                        CommandName="AddToCart" CommandArgument='<%# Container.DataItemIndex %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- ─── CART SUMMARY ──────────────────────────────────── -->
                <div id="cartSummary" runat="server" visible="false"
                    style="border: 1px solid #583937; padding: 15px; background-color: #fcfcfc; margin-bottom: 24px;">
                    <h3>Your Cart Summary</h3>
                    <asp:GridView ID="gvCart" runat="server" AutoGenerateColumns="False" Width="100%">
                        <Columns>
                            <asp:BoundField DataField="Description" HeaderText="Item" />
                            <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                            <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C}" />
                        </Columns>
                    </asp:GridView>
                    <div style="text-align: right; margin-top: 10px;">
                        <b>Grand Total:
                            <asp:Label ID="lblTotal" runat="server" Text="$0.00" />
                        </b>
                        <br /><br />
                        <asp:Button ID="btnGoToOrder" runat="server" Text="Proceed to Place Order"
                            OnClick="btnGoToOrder_Click" />
                    </div>
                </div>

                <!-- ─── CUSTOMER ORDER LOOKUP ─────────────────────────── -->
                <div class="section-box">
                    <div class="section-title">Customer Order Lookup</div>
                    <p style="font-size:12px;color:#888;margin:0 0 10px;">
                        Search by customer name or order ID to view all order details.
                    </p>
                    <asp:Label ID="lblCustomerSearchMsg" runat="server" Visible="false" /><br />
                    <table class="search-table">
                        <tr>
                            <td>Customer Name:</td>
                            <td>
                                <asp:DropDownList ID="ddlCustomer" runat="server">
                                </asp:DropDownList>
                                <span style="font-size:11px;color:#999;margin-left:6px;">(shows name → searches by
                                    ID)</span>
                            </td>
                        </tr>
                        <tr>
                            <td><span style="font-size:12px;color:#888;">OR Order ID:</span></td>
                            <td>
                                <asp:TextBox ID="txtOrderId" runat="server" Width="100px" placeholder="e.g. 1001" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-top:8px;">
                                <asp:Button ID="btnCustomerSearch" runat="server" Text="Find Orders"
                                    OnClick="btnCustomerSearch_Click" CausesValidation="false" />
                                &nbsp;
                                <asp:Button ID="btnClearOrderSearch" runat="server" Text="Clear"
                                    OnClick="btnClearOrderSearch_Click" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>

                    <asp:Panel ID="pnlOrderResults" runat="server" Visible="false">
                        <br />
                        <div class="order-summary">
                            <asp:Label ID="lblOrderSummary" runat="server" />
                        </div>
                        <br />
                        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="gv-orders"
                            Width="100%">
                            <Columns>
                                <asp:BoundField DataField="Customer_Id" HeaderText="Cust. ID" ItemStyle-Width="60px" />
                                <asp:BoundField DataField="Customer_Name" HeaderText="Customer Name" />
                                <asp:BoundField DataField="Order_Id" HeaderText="Order ID" ItemStyle-Width="70px" />
                                <asp:BoundField DataField="Order_Date" HeaderText="Order Date"
                                    DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:BoundField DataField="Product_Description" HeaderText="Product" />
                                <asp:BoundField DataField="Ordered_Quantity" HeaderText="Qty"
                                    ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="Unit_Price" HeaderText="Unit Price" DataFormatString="{0:C}"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="Line_Total" HeaderText="Line Total" DataFormatString="{0:C}"
                                    ItemStyle-HorizontalAlign="Right" />
                            </Columns>
                        </asp:GridView>
                        <div class="grand-total">
                            Grand Total:
                            <asp:Label ID="lblOrderGrandTotal" runat="server" />
                        </div>
                    </asp:Panel>
                </div>

            </div>
        </form>
    </body>

    </html>