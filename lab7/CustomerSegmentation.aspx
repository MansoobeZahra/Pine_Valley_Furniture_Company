<%@ Page Language="VB" AutoEventWireup="true" CodeFile="CustomerSegmentation.aspx.vb" Inherits="CustomerSegmentationPage" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Customer Segmentation Dashboard - PVFC Lab 07</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f5f5f5; }
        .header { background-color: #583937; color: white; padding: 20px; text-align: center; }
        .header h1 { margin: 0; font-size: 22px; }
        .header p  { margin: 4px 0 0; font-size: 13px; }
        .nav { background-color: #f4f4f4; padding: 10px; border-bottom: 1px solid #ccc; text-align: center; }
        .nav a { color: #333; text-decoration: none; }
        .nav a:hover { color: #583937; text-decoration: underline; }
        .welcome-bar { background: #fffbe6; text-align: center; padding: 4px;
                       font-size: 13px; border-bottom: 1px solid #ddd; }
        .page-title { text-align: center; padding: 18px 0 6px;
                      font-size: 20px; font-weight: bold; color: #583937; }
        .page-sub   { text-align: center; font-size: 13px; color: #777; margin-bottom: 18px; }

        /* Summary cards */
        .summary-bar { display: flex; justify-content: center; gap: 20px;
                       padding: 0 30px 20px; flex-wrap: wrap; }
        .card { background: white; border-left: 5px solid #583937;
                border-radius: 6px; padding: 14px 22px; min-width: 160px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1); text-align: center; }
        .card .num  { font-size: 32px; font-weight: bold; color: #583937; }
        .card .lbl  { font-size: 12px; color: #666; margin-top: 4px; }
        .card.freq  { border-color: #2196F3; }  .card.freq .num  { color:#2196F3; }
        .card.prem  { border-color: #FF9800; }  .card.prem .num  { color:#FF9800; }
        .card.bulk  { border-color: #4CAF50; }  .card.bulk .num  { color:#4CAF50; }
        .card.total { border-color: #9C27B0; }  .card.total .num { color:#9C27B0; }

        /* 2x2 Grid dashboard */
        .dashboard { display: grid; grid-template-columns: 1fr 1fr;
                     gap: 20px; padding: 0 30px 30px; }
        .segment-box { background: white; border-radius: 8px;
                       box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                       overflow: hidden; }
        .seg-header { padding: 12px 16px; color: white; font-weight: bold;
                      font-size: 15px; display: flex; justify-content: space-between;
                      align-items: center; }
        .seg-header .badge { background: rgba(255,255,255,0.25);
                             border-radius: 12px; padding: 2px 10px; font-size: 12px; }
        .seg-freq { background: #2196F3; }
        .seg-prem { background: #FF9800; }
        .seg-bulk { background: #4CAF50; }
        .seg-over { background: #9C27B0; }
        .seg-body { padding: 12px; }
        .seg-rule { font-size: 11px; color: #888; padding: 6px 16px 0;
                    font-style: italic; border-top: 1px solid #eee; }

        /* GridView styling */
        table.gv { width: 100%; border-collapse: collapse; font-size: 13px; }
        table.gv th { background: #583937; color: white; padding: 7px 10px; text-align: left; }
        table.gv td { padding: 6px 10px; border-bottom: 1px solid #eee; }
        table.gv tr:nth-child(even) td { background: #fafafa; }
        table.gv tr:hover td { background: #fff3e0; }

        .empty-msg { text-align: center; color: #aaa; padding: 20px;
                     font-style: italic; }
        .refresh-btn { background: #583937; color: white; border: none;
                       padding: 8px 22px; border-radius: 4px; cursor: pointer;
                       margin: 0 30px 16px; font-size: 14px; }
        .refresh-btn:hover { background: #7a504e; }
        .filter-bar { padding: 10px 30px; background: white; border-bottom: 1px solid #eee;
                      display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
        .filter-bar label { font-size: 13px; font-weight: bold; }
        .filter-bar input { padding: 4px 8px; border: 1px solid #ccc; border-radius:3px; width:80px; }
        .filter-bar select { padding: 4px 8px; border: 1px solid #ccc; border-radius:3px; }
    </style>
</head>
<body>
    <div class="header">
        <h1><img src="logo.png" alt="PVFC" height="40" style="vertical-align:middle;"/>
            Pine Valley Furniture Company</h1>
        <p>Mansoob-e-Zahra | Lab 07 — Customer Segmentation</p>
    </div>

    <!-- NAV -->
    <div class="nav">
        <asp:HyperLink ID="lnkRegistration" runat="server" NavigateUrl="Registration.aspx">Registration | </asp:HyperLink><a href="Update.aspx">Update Info</a> |
        <a href="Search.aspx">Search</a> |
        <a href="Order.aspx">Order</a><asp:HyperLink ID="lnkCatalog" runat="server" NavigateUrl="Catalog.aspx"> | Catalog</asp:HyperLink> |
        <a href="CustomerSegmentation.aspx"><b>Segmentation</b></a> |
        <a href="Help.aspx">Help</a> |
        <a href="Logout.aspx" style="color:#583937;font-weight:bold;">Logout</a>
    </div>
    <div class="welcome-bar"><asp:Label ID="lblWelcome" runat="server" /></div>

    <form id="form1" runat="server">
        <div class="page-title">Customer Segmentation Dashboard</div>
        <div class="page-sub">Identify Premium, Frequent, and Bulk Buyer customer segments</div>

        <!-- Filters -->
        <div class="filter-bar">
            <label>Premium Threshold ($):</label>
            <asp:TextBox ID="txtPremiumThreshold" runat="server" Text="1000" Width="80px" />
            <label>Frequent (min orders):</label>
            <asp:TextBox ID="txtFreqThreshold" runat="server" Text="5" Width="60px" />
            <label>Bulk (min avg qty/line):</label>
            <asp:TextBox ID="txtBulkThreshold" runat="server" Text="5" Width="60px" />
            <asp:Button ID="btnRefresh" runat="server" Text="Apply &amp; Refresh"
                CssClass="refresh-btn" OnClick="btnRefresh_Click" CausesValidation="false" />
        </div>

        <!-- Summary Cards -->
        <div class="summary-bar">
            <div class="card total">
                <div class="num"><asp:Label ID="lblTotalCustomers" runat="server" Text="0" /></div>
                <div class="lbl">Total Customers</div>
            </div>
            <div class="card freq">
                <div class="num"><asp:Label ID="lblFreqCount" runat="server" Text="0" /></div>
                <div class="lbl">Frequent Customers</div>
            </div>
            <div class="card prem">
                <div class="num"><asp:Label ID="lblPremCount" runat="server" Text="0" /></div>
                <div class="lbl">Premium Customers</div>
            </div>
            <div class="card bulk">
                <div class="num"><asp:Label ID="lblBulkCount" runat="server" Text="0" /></div>
                <div class="lbl">Bulk Buyers</div>
            </div>
            <div class="card" style="border-color:#E91E63;">
                <div class="num" style="color:#E91E63;"><asp:Label ID="lblOverlapCount" runat="server" Text="0" /></div>
                <div class="lbl">Multi-Segment</div>
            </div>
        </div>

        <!-- 2×2 Dashboard -->
        <div class="dashboard">

            <!-- FREQUENT CUSTOMERS (top-left) -->
            <div class="segment-box">
                <div class="seg-header seg-freq">
                    Frequent Customers
                    <span class="badge"><asp:Label ID="lblFreqBadge" runat="server" Text="0" /> customers</span>
                </div>
                <div class="seg-rule">Rule: orders &gt; <asp:Label ID="lblFreqRule" runat="server" Text="5" /> in total</div>
                <div class="seg-body">
                    <asp:GridView ID="gvFrequent" runat="server" CssClass="gv"
                        AutoGenerateColumns="false" EmptyDataText="No frequent customers found.">
                        <Columns>
                            <asp:BoundField DataField="Customer_Id"   HeaderText="ID"       ItemStyle-Width="40px" />
                            <asp:BoundField DataField="Customer_Name" HeaderText="Customer" />
                            <asp:BoundField DataField="OrderCount"    HeaderText="Orders"   ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="TotalSpend"    HeaderText="Spend"    DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- PREMIUM CUSTOMERS (top-right) -->
            <div class="segment-box">
                <div class="seg-header seg-prem">
                    Premium Customers
                    <span class="badge"><asp:Label ID="lblPremBadge" runat="server" Text="0" /> customers</span>
                </div>
                <div class="seg-rule">Rule: total spend &gt; $<asp:Label ID="lblPremRule" runat="server" Text="1000" /></div>
                <div class="seg-body">
                    <asp:GridView ID="gvPremium" runat="server" CssClass="gv"
                        AutoGenerateColumns="false" EmptyDataText="No premium customers found.">
                        <Columns>
                            <asp:BoundField DataField="Customer_Id"   HeaderText="ID"       ItemStyle-Width="40px" />
                            <asp:BoundField DataField="Customer_Name" HeaderText="Customer" />
                            <asp:BoundField DataField="TotalSpend"    HeaderText="Total Spend" DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="OrderCount"    HeaderText="Orders"   ItemStyle-HorizontalAlign="Center" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- OVERLAP / MULTI-SEGMENT (bottom-left) -->
            <div class="segment-box">
                <div class="seg-header seg-over">
                    Multi-Segment Customers
                    <span class="badge"><asp:Label ID="lblOverBadge" runat="server" Text="0" /> customers</span>
                </div>
                <div class="seg-rule">Rule: appears in 2 or more segments (high-value targets)</div>
                <div class="seg-body">
                    <asp:GridView ID="gvOverlap" runat="server" CssClass="gv"
                        AutoGenerateColumns="false" EmptyDataText="No multi-segment customers found.">
                        <Columns>
                            <asp:BoundField DataField="Customer_Id"   HeaderText="ID"       ItemStyle-Width="40px" />
                            <asp:BoundField DataField="Customer_Name" HeaderText="Customer" />
                            <asp:BoundField DataField="Segments"      HeaderText="Segments" />
                            <asp:BoundField DataField="TotalSpend"    HeaderText="Spend"    DataFormatString="{0:C}" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="OrderCount"    HeaderText="Orders"   ItemStyle-HorizontalAlign="Center" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- BULK BUYERS (bottom-right) -->
            <div class="segment-box">
                <div class="seg-header seg-bulk">
                    Bulk Buyers
                    <span class="badge"><asp:Label ID="lblBulkBadge" runat="server" Text="0" /> customers</span>
                </div>
                <div class="seg-rule">Rule: avg qty per order line &gt; <asp:Label ID="lblBulkRule" runat="server" Text="5" /></div>
                <div class="seg-body">
                    <asp:GridView ID="gvBulk" runat="server" CssClass="gv"
                        AutoGenerateColumns="false" EmptyDataText="No bulk buyers found.">
                        <Columns>
                            <asp:BoundField DataField="Customer_Id"   HeaderText="ID"       ItemStyle-Width="40px" />
                            <asp:BoundField DataField="Customer_Name" HeaderText="Customer" />
                            <asp:BoundField DataField="TotalQty"      HeaderText="Total Qty" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="AvgQtyPerLine" HeaderText="Avg Qty"   DataFormatString="{0:F1}" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="OrderCount"    HeaderText="Orders"    ItemStyle-HorizontalAlign="Center" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div style="padding:0 30px 10px; font-size:12px; color:#999;">
            <a href="../index.html">Back to All Labs</a>
        </div>
    </form>
</body>
</html>
