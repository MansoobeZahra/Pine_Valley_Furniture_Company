<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Registration.aspx.vb" Inherits="RegistrationPage" %>
    <!DOCTYPE html>
    <html>

    <head runat="server">
        <title>Customer Registration - Pine Valley Furniture</title>
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
            <b>New Customer Registration</b>
            <br /><br />
            <asp:Label ID="lblMessage" runat="server" Font-Bold="true" ForeColor="Red" />
            <br /><br />
            <table>
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
                            ValidationExpression="^[A-Z]{2}$" ErrorMessage=" (use 2 letters, e.g. NY)" ForeColor="Red"
                            Display="Dynamic" />
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
                        <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click" />
                        <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click"
                            CausesValidation="false" />
                    </td>
                </tr>
            </table>
        </form>
    </body>

    </html>