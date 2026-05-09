<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Register.aspx.vb" Inherits="Register" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration - QUICK byte</title>
    <link rel="stylesheet" href="registration.css">
    <script type="text/javascript">
        function toggleFields() {
            var userType = document.getElementById('<%= ddlUserType.ClientID %>').value;
            var restaurantFields = document.getElementById('restaurantFields');
            var riderFields = document.getElementById('riderFields');
            var nameFields = document.getElementById('nameFields');

            // Hide all first
            restaurantFields.style.display = 'none';
            riderFields.style.display = 'none';

            if (userType === 'Customer' || userType === 'Rider') {
                nameFields.style.display = 'block';
            } else if (userType === 'RestaurantManager') {
                nameFields.style.display = 'none';
            }

            if (userType === 'RestaurantManager') {
                restaurantFields.style.display = 'block';
            } else if (userType === 'Rider') {
                riderFields.style.display = 'block';
            }
        }
        
        window.onload = function() {
            toggleFields();
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="form-wrapper">
                <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                <h1>QuickByte</h1>
                <p class="subtitle">Taste the speed</p>

                <asp:Label ID="lblMessage" runat="server" ForeColor="Red" Visible="false" Font-Bold="true"></asp:Label>

                <div class="form-group">
                    <label for="ddlUserType">Register As:</label>
                    <asp:DropDownList ID="ddlUserType" runat="server" onchange="toggleFields()" required="required">
                        <asp:ListItem Value="" Text="Select Role"></asp:ListItem>
                        <asp:ListItem Value="Customer" Text="Customer"></asp:ListItem>
                        <asp:ListItem Value="Rider" Text="Delivery Rider"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label for="ddlRegion">Select Region/City:</label>
                    <asp:DropDownList ID="ddlRegion" runat="server" required="required">
                        <asp:ListItem Value="" Text="Select Region"></asp:ListItem>
                        <asp:ListItem Value="Karachi" Text="Karachi"></asp:ListItem>
                        <asp:ListItem Value="Lahore" Text="Lahore"></asp:ListItem>
                        <asp:ListItem Value="Islamabad" Text="Islamabad"></asp:ListItem>
                        <asp:ListItem Value="Rawalpindi" Text="Rawalpindi"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div id="nameFields">
                    <div class="form-group">
                        <label for="txtFirstName">First Name:</label>
                        <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtLastName">Last Name:</label>
                        <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtEmail">Email:</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" required="required"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtPhone">Phone Number:</label>
                    <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone" placeholder="03001234567" required="required"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password:</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" required="required"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtConfirmPassword">Confirm Password:</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" required="required"></asp:TextBox>
                </div>

                <!-- Rider-specific Fields -->
                <div id="riderFields" style="display:none;">
                    <div class="form-group">
                        <label class="checkbox-label">
                            <asp:CheckBox ID="chkAvailability" runat="server" Checked="true" />
                            Available for Delivery
                        </label>
                    </div>
                </div>

                <div class="btn-container">
                    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn-submit" OnClick="btnRegister_Click" />
                    <button type="reset" class="btn-reset">Clear Form</button>
                </div>

                <div class="links">
                    <a href="Login.aspx">Already have an account? Login here</a> |
                    <a href="Default.aspx">Back to Home</a>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
