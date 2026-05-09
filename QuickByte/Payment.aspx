<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Payment.aspx.vb" Inherits="Payment" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - QUICK byte</title>
    <link rel="stylesheet" href="payment.css">
    <link rel="stylesheet" href="index.css">
    <script>
        function togglePaymentFields() {
            const method = document.getElementById('<%= ddlPaymentMethod.ClientID %>').value;
            const cardFields = document.getElementById('cardFields');
            const walletFields = document.getElementById('walletFields');

            cardFields.style.display = 'none';
            walletFields.style.display = 'none';

            if (method === 'credit' || method === 'debit') {
                cardFields.style.display = 'block';
            } else if (method === 'easypaisa' || method === 'jazzcash') {
                walletFields.style.display = 'block';
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <div class="nav-container">
                <a href="Default.aspx" class="nav-logo">
                    <img src="assets/logo.png" alt="QuickByte Logo" style="height:40px;" />
                    QuickByte
                </a>
                <ul class="nav-menu">
                    <li><a href="Default.aspx">Home</a></li>
                    <% If User.Identity.IsAuthenticated Then %>
                        <% If Session("Role") = "Customer" Then %>
                            <li><a href="Search.aspx">Search</a></li>
                            <li><a href="Orders.aspx">My Orders</a></li>
                        <% ElseIf Session("Role") = "RestaurantManager" Then %>
                            <li><a href="Menu.aspx">Manage Menu</a></li>
                            <li><a href="Orders.aspx">Orders</a></li>
                        <% ElseIf Session("Role") = "Rider" Then %>
                            <li><a href="RiderDashboard.aspx">Dashboard</a></li>
                        <% ElseIf Session("Role") = "Admin" Or Session("Role") = "PlatformManager" Then %>
                            <li><a href="Orders.aspx">All Orders</a></li>
                            <li><a href="AdminDashboard.aspx">Segmentation Dashboard</a></li>
                        <% End If %>
                        <li><asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click">Logout</asp:LinkButton></li>
                        <li class="user-welcome"><b><%= Session("Role") %>: <%= User.Identity.Name %></b></li>
                    <% Else %>
                        <li><a href="Register.aspx">Register</a></li>
                        <li><a href="Login.aspx">Login</a></li>
                        <li><a href="Search.aspx">Search</a></li>
                    <% End If %>
                </ul>
            </div>
        </nav>
        <div class="container">
            <div class="payment-wrapper">
                <img src="assets/logo.png" alt="QuickByte Logo" class="brand-logo" />
                <h1>QuickByte Payment</h1>
                <p class="subtitle">Complete your transaction</p>

                <div class="payment-info">
                    <h2>Order Summary</h2>
                    <asp:Literal ID="litOrderSummary" runat="server"></asp:Literal>
                </div>

                <div id="paymentFormSection" runat="server">
                    <h2>Payment Information</h2>
                    <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="false"></asp:Label>

                    <div class="form-group">
                        <label for="ddlPaymentMethod">Payment Method:</label>
                        <asp:DropDownList ID="ddlPaymentMethod" runat="server" onchange="togglePaymentFields()" required="required">
                            <asp:ListItem Value="" Text="Select Payment Method"></asp:ListItem>
                            <asp:ListItem Value="cash" Text="Cash on Delivery"></asp:ListItem>
                            <asp:ListItem Value="credit" Text="Credit Card"></asp:ListItem>
                            <asp:ListItem Value="debit" Text="Debit Card"></asp:ListItem>
                            <asp:ListItem Value="easypaisa" Text="Easypaisa"></asp:ListItem>
                            <asp:ListItem Value="jazzcash" Text="JazzCash"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div id="cardFields" style="display:none;">
                        <div class="form-group">
                            <label for="txtCardNumber">Card Number:</label>
                            <asp:TextBox ID="txtCardNumber" runat="server" placeholder="1234 5678 9012 3456" MaxLength="19"></asp:TextBox>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="txtExpiryDate">Expiry Date:</label>
                                <asp:TextBox ID="txtExpiryDate" runat="server" placeholder="MM/YY" MaxLength="5"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txtCVV">CVV:</label>
                                <asp:TextBox ID="txtCVV" runat="server" placeholder="123" MaxLength="3"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div id="walletFields" style="display:none;">
                        <div class="form-group">
                            <label for="txtWalletNumber">Mobile Number:</label>
                            <asp:TextBox ID="txtWalletNumber" runat="server" placeholder="03001234567"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="txtAmount">Amount:</label>
                        <asp:TextBox ID="txtAmount" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnPay" runat="server" Text="Process Payment" CssClass="btn-pay" OnClick="btnPay_Click" />
                </div>

                <div class="payment-history">
                    <h2>Your Recent Payments</h2>
                    <asp:GridView ID="gvPaymentHistory" runat="server" AutoGenerateColumns="False" CssClass="history-table" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="PaymentID" HeaderText="Payment ID" />
                            <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                            <asp:BoundField DataField="Method" HeaderText="Method" />
                            <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="PaymentDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
        <footer>
            <p>&copy; 2026 QUICK byte - Taste the speed</p>
        </footer>
    </form>
</body>
</html>
