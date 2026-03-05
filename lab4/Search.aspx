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
            <asp:GridView ID="gvResults" runat="server"></asp:GridView>
        </form>
    </body>

    </html>