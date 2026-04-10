<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Catalog.aspx.vb" Inherits="CatalogPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Product Catalog Update - Pine Valley Furniture</title>
    </head>

    <body style="font-family: Arial, sans-serif;">
        <div style="background-color: #583937; color: white; padding: 20px; text-align: center;">
            <h1><img src="logo.png" alt="logo_PVFC" height="50" style="margin-left: 0px; vertical-align: middle;" />
                Pine Valley Furniture Company</h1>
            <p>Mansoob-e-Zahra | Lab 05</p>
        </div>
        <div style="background-color: #f4f4f4; padding: 10px; border-bottom: 1px solid #ccc; text-align: center;">
            <a href="Registration.aspx">Registration</a> |
            <a href="Update.aspx">Update Info</a> |
            <a href="Search.aspx">Search</a> |
            <a href="Order.aspx">Order</a> |
            <a href="Catalog.aspx">Catalog</a> |
            <a href="Help.aspx">Help</a>
        </div>

        <form id="form1" runat="server">
            <a href="../index.html">Back to All Labs</a>
            <br /><br />
            <b>Add New Product</b>
            <br /><br />
            <asp:Label ID="lblMessage" runat="server" />
            <br />
            <table>
                <tr>
                    <td>Description:</td>
                    <td>
                        <asp:TextBox ID="txtProductName" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvDesc" runat="server" ControlToValidate="txtProductName"
                            ErrorMessage="*" ForeColor="Red" />
                    </td>
                </tr>
                <tr>
                    <td>Finish:</td>
                    <td>
                        <asp:TextBox ID="txtFinish" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>Product Line:</td>
                    <td>
                        <asp:DropDownList ID="ddlProductLine" runat="server">
                            <asp:ListItem Text="Living Room" Value="1" />
                            <asp:ListItem Text="Dining Room" Value="2" />
                            <asp:ListItem Text="Bedroom" Value="3" />
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>Price:</td>
                    <td>
                        <asp:TextBox ID="txtUnitPrice" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtUnitPrice"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" />
                        <asp:CompareValidator ID="cvPrice" runat="server" ControlToValidate="txtUnitPrice"
                            Operator="DataTypeCheck" Type="Currency" ErrorMessage=" (use numbers, e.g. 150.00)"
                            ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="btnAdd" runat="server" Text="Add Product" OnClick="btnAddProduct_Click" />
                    </td>
                </tr>
            </table>

            <hr />
            <b>Update Existing Product</b>
            <br /><br />
            <asp:Label ID="lblUpdateMessage" runat="server" Font-Bold="true" Visible="false" />
            <br />
            <table>
                <tr>
                    <td>Product ID to Update:</td>
                    <td>
                        <asp:TextBox ID="txtUpdateID" runat="server" Width="60px" />
                        <asp:RequiredFieldValidator ID="rfvUpdateID" runat="server" ControlToValidate="txtUpdateID"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" ValidationGroup="updateGroup" />
                        <asp:CompareValidator ID="cvUpdateID" runat="server" ControlToValidate="txtUpdateID"
                            Operator="DataTypeCheck" Type="Integer" ErrorMessage=" (must be a number)" ForeColor="Red"
                            Display="Dynamic" ValidationGroup="updateGroup" />
                    </td>
                </tr>
                <tr>
                    <td>New Description:</td>
                    <td>
                        <asp:TextBox ID="txtUpdateDesc" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvUpdateDesc" runat="server" ControlToValidate="txtUpdateDesc"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" ValidationGroup="updateGroup" />
                    </td>
                </tr>
                <tr>
                    <td>New Finish:</td>
                    <td>
                        <asp:TextBox ID="txtUpdateFinish" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>New Product Line:</td>
                    <td>
                        <asp:DropDownList ID="ddlUpdateLine" runat="server">
                            <asp:ListItem Text="Living Room" Value="1" />
                            <asp:ListItem Text="Dining Room" Value="2" />
                            <asp:ListItem Text="Bedroom" Value="3" />
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>New Price:</td>
                    <td>
                        <asp:TextBox ID="txtUpdatePrice" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvUpdatePrice" runat="server"
                            ControlToValidate="txtUpdatePrice" ErrorMessage="*" ForeColor="Red" Display="Dynamic"
                            ValidationGroup="updateGroup" />
                        <asp:CompareValidator ID="cvUpdatePrice" runat="server" ControlToValidate="txtUpdatePrice"
                            Operator="DataTypeCheck" Type="Currency" ErrorMessage=" (numbers only)" ForeColor="Red"
                            Display="Dynamic" ValidationGroup="updateGroup" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="btnUpdateProduct" runat="server" Text="Update Product"
                            OnClick="btnUpdateProduct_Click" ValidationGroup="updateGroup" />
                    </td>
                </tr>
            </table>

            <hr />
            <b>Current Catalog</b>
            <asp:GridView ID="gvCatalog" runat="server"></asp:GridView>
        </form>
    </body>

    </html>