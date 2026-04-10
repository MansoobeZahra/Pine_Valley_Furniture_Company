<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Update.aspx.vb" Inherits="UpdatePage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Update Customer Info - Pine Valley Furniture</title>
    </head>

    <body style="font-family: Arial, sans-serif;">
        <div style="background-color: #583937; color: white; padding: 20px; text-align: center;">
            <h1><img src="logo.png" alt="logo_PVFC" height="50" style="margin-left: 0px; vertical-align: middle;" />
                Pine Valley Furniture Company</h1>
            <p>Mansoob-e-Zahra | Lab 06</p>
        </div>
                        <div style="background-color: #f4f4f4; padding: 10px; border-bottom: 1px solid #ccc; text-align: center;">
            <a href="Registration.aspx">Registration</a> |
            <a href="Update.aspx">Update Info</a> |
            <a href="Search.aspx">Search</a> |
            <a href="Order.aspx">Order</a><asp:HyperLink ID="lnkCatalog" runat="server" NavigateUrl="Catalog.aspx"> | Catalog</asp:HyperLink> |
            <a href="Help.aspx">Help</a> |
            <a href="Logout.aspx" style="color:#583937;font-weight:bold;"> Logout</a>
        </div>

        <div style="background:#fffbe6;text-align:center;padding:3px;font-size:13px;border-bottom:1px solid #ddd;"><asp:Label ID="lblWelcome" runat="server" /></div>

        <form id="form1" runat="server">
            <a href="../index.html">Back to All Labs</a>
            <br /><br />
            <b>Update Customer Information</b>
            <br /><br />
            <asp:Label ID="lblMessage" runat="server" Font-Bold="true" Visible="false" />
            <br />
            <table>
                <tr>
                    <td>Customer ID:</td>
                    <td>
                        <asp:TextBox ID="txtCustomerID" runat="server" Width="80px" />
                        <asp:RequiredFieldValidator ID="rfvID" runat="server" ControlToValidate="txtCustomerID"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" />
                        <small style="color: gray;"> (enter the ID from your registration)</small>
                    </td>
                </tr>
                <tr>
                    <td>First Name:</td>
                    <td>
                        <asp:TextBox ID="txtFirstName" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvFN" runat="server" ControlToValidate="txtFirstName"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>Last Name:</td>
                    <td>
                        <asp:TextBox ID="txtLastName" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvLN" runat="server" ControlToValidate="txtLastName"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>Address:</td>
                    <td>
                        <asp:TextBox ID="txtAddress" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvAddr" runat="server" ControlToValidate="txtAddress"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>City:</td>
                    <td>
                        <asp:TextBox ID="txtCity" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>State:</td>
                    <td>
                        <asp:TextBox ID="txtState" runat="server" MaxLength="2" Width="30px" />
                        <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="txtState"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revState" runat="server" ControlToValidate="txtState"
                            ValidationExpression="^[A-Z]{2}$" ErrorMessage=" (2 capital letters, e.g. NY)"
                            ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td>Postal Code:</td>
                    <td>
                        <asp:TextBox ID="txtPostalCode" runat="server" Width="100px" />
                        <asp:RequiredFieldValidator ID="rfvPC" runat="server" ControlToValidate="txtPostalCode"
                            ErrorMessage="*" ForeColor="Red" Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <br />
                        <asp:Button ID="btnUpdate" runat="server" Text="Update Information" OnClick="btnUpdate_Click" />
                        <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click"
                            CausesValidation="false" />
                    </td>
                </tr>
            </table>
        </form>
    </body>

    </html>