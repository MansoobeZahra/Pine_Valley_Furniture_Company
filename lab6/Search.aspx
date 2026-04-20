<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Search.aspx.vb" Inherits="SearchPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Search Products - Pine Valley Furniture</title>
    </head>

    <body style="font-family: Arial, sans-serif;">
        <div style="background-color: #583937; color: white; padding: 20px; text-align: center;">
            <h1><img src="logo.png" alt="logo_PVFC" height="50" style="margin-left: 0px; vertical-align: middle;" />
                Pine Valley Furniture Company</h1>
            <p>Mansoob-e-Zahra | Lab 06</p>
        </div>
        <div style="background-color: #f4f4f4; padding: 10px; border-bottom: 1px solid #ccc; text-align: center;">
            <asp:HyperLink ID="lnkRegistration" runat="server" NavigateUrl="Registration.aspx">Registration | </asp:HyperLink><a href="Update.aspx">Update Info</a> |
            <a href="Search.aspx">Search</a> |
            <a href="Order.aspx">Order</a><asp:HyperLink ID="lnkCatalog" runat="server" NavigateUrl="Catalog.aspx"> | Catalog</asp:HyperLink> |
            <a href="Help.aspx">Help</a> |
            <a href="Logout.aspx" style="color:#583937;font-weight:bold;">Logout</a>
        </div>

        <div style="background:#fffbe6;text-align:center;padding:3px;font-size:13px;border-bottom:1px solid #ddd;"><asp:Label ID="lblWelcome" runat="server" /></div>

        <form id="form1" runat="server">
            <a href="../index.html">Back to All Labs</a>
            <br /><br />
            <b>Search Inventory</b>
            <br /><br />
            <asp:Label ID="lblMessage" runat="server" />
            <br />
            <table>
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
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
                    </td>
                </tr>
            </table>
            <br />
            <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False" OnRowCommand="gvResults_RowCommand"
                DataKeyNames="Product_Id">
                <Columns>
                    <asp:BoundField DataField="Product_Description" HeaderText="Description" />
                    <asp:BoundField DataField="ProductLineName" HeaderText="Category" />
                    <asp:BoundField DataField="Product_Finish" HeaderText="Finish" />
                    <asp:BoundField DataField="Standard_Price" HeaderText="Price" DataFormatString="{0:C}" />
                    <asp:TemplateField HeaderText="Quantity">
                        <ItemTemplate>
                            <asp:TextBox ID="txtQty" runat="server" Text="1" Width="40px" type="number" min="1" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" CommandName="AddToCart"
                                CommandArgument='<%# Container.DataItemIndex %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <div id="cartSummary" runat="server" visible="false"
                style="border: 1px solid #583937; padding: 15px; background-color: #fcfcfc;">
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
        </form>
    </body>

    </html>