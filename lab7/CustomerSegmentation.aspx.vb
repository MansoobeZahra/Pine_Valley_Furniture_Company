Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class CustomerSegmentationPage
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString
        End Get
    End Property

    ' ─────────────────────────────────────────────────────────────
    ' PAGE LOAD – RBAC guard + load segments on first visit
    ' ─────────────────────────────────────────────────────────────
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Session("Username") Is Nothing Then Response.Redirect("Login.aspx?reason=timeout")
        If Session("UserRole").ToString() <> "admin" Then
            Response.Write("<script>alert('Access Denied: Segmentation is for Admins only.');</script>")
            Response.Redirect("Update.aspx")
        End If
        Dim isAdmin As Boolean = True
        lnkRegistration.Visible = isAdmin
        lnkCatalog.Visible      = True
        If Not IsPostBack Then
            lblWelcome.Text = "Welcome, " & Session("Username") & " (" & Session("UserRole") & ")"
            LoadAllSegments()
        End If
    End Sub

    ' ─────────────────────────────────────────────────────────────
    ' REFRESH BUTTON
    ' ─────────────────────────────────────────────────────────────
    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As EventArgs)
        LoadAllSegments()
    End Sub

    ' ─────────────────────────────────────────────────────────────
    ' LOAD ALL SEGMENTS
    ' ─────────────────────────────────────────────────────────────
    Private Sub LoadAllSegments()
        Dim premThreshold As Decimal = 1000
        Dim freqThreshold As Integer = 5
        Dim bulkThreshold As Decimal = 5

        If Not Decimal.TryParse(txtPremiumThreshold.Text, premThreshold) Then premThreshold = 1000
        If Not Integer.TryParse(txtFreqThreshold.Text, freqThreshold)   Then freqThreshold = 5
        If Not Decimal.TryParse(txtBulkThreshold.Text, bulkThreshold)   Then bulkThreshold = 5

        ' Update rule labels
        lblPremRule.Text = premThreshold.ToString("N0")
        lblFreqRule.Text = freqThreshold.ToString()
        lblBulkRule.Text = bulkThreshold.ToString("N0")

        Dim dtFreq As DataTable = GetFrequentCustomers(freqThreshold)
        Dim dtPrem As DataTable = GetPremiumCustomers(premThreshold)
        Dim dtBulk As DataTable = GetBulkBuyers(bulkThreshold)
        Dim dtOver As DataTable = GetMultiSegment(premThreshold, freqThreshold, bulkThreshold)

        ' NEW: customers with zero orders (real-time – auto-reflects new registrations)
        Dim dtNew As DataTable = GetNewCustomers()

        ' Bind grids
        gvFrequent.DataSource    = dtFreq : gvFrequent.DataBind()
        gvPremium.DataSource     = dtPrem : gvPremium.DataBind()
        gvBulk.DataSource        = dtBulk : gvBulk.DataBind()
        gvOverlap.DataSource     = dtOver : gvOverlap.DataBind()
        gvNewCustomers.DataSource = dtNew : gvNewCustomers.DataBind()

        ' Update summary card counts
        Dim totalCust As Integer = GetTotalCustomers()
        lblTotalCustomers.Text = totalCust.ToString()
        lblFreqCount.Text      = dtFreq.Rows.Count.ToString()
        lblPremCount.Text      = dtPrem.Rows.Count.ToString()
        lblBulkCount.Text      = dtBulk.Rows.Count.ToString()
        lblOverlapCount.Text   = dtOver.Rows.Count.ToString()
        lblNewCount.Text       = dtNew.Rows.Count.ToString()

        ' Update segment-header badges
        lblFreqBadge.Text = dtFreq.Rows.Count.ToString()
        lblPremBadge.Text = dtPrem.Rows.Count.ToString()
        lblBulkBadge.Text = dtBulk.Rows.Count.ToString()
        lblOverBadge.Text = dtOver.Rows.Count.ToString()
        lblNewBadge.Text  = dtNew.Rows.Count.ToString()
    End Sub

    ' ─────────────────────────────────────────────────────────────
    ' QUERY: FREQUENT CUSTOMERS
    ' Rule: Number of distinct orders > freqThreshold
    ' ─────────────────────────────────────────────────────────────
    Private Function GetFrequentCustomers(ByVal minOrders As Integer) As DataTable
        Dim sql As String =
            "SELECT c.Customer_Id, c.Customer_Name, " &
            "       COUNT(DISTINCT o.Order_Id) AS OrderCount, " &
            "       ISNULL(SUM(ol.Ordered_Quantity * p.Standard_Price), 0) AS TotalSpend " &
            "FROM CUSTOMER_t c " &
            "JOIN ORDER_t o ON c.Customer_Id = o.Customer_Id " &
            "JOIN Order_line_t ol ON o.Order_Id = ol.Order_Id " &
            "JOIN PRODUCT_t p ON ol.Product_Id = p.Product_Id " &
            "GROUP BY c.Customer_Id, c.Customer_Name " &
            "HAVING COUNT(DISTINCT o.Order_Id) > @minOrders " &
            "ORDER BY OrderCount DESC"
        Return FillDataTable(sql, New SqlParameter("@minOrders", minOrders))
    End Function

    ' ─────────────────────────────────────────────────────────────
    ' QUERY: PREMIUM CUSTOMERS
    ' Rule: Total spend (qty × price across all orders) > threshold
    ' ─────────────────────────────────────────────────────────────
    Private Function GetPremiumCustomers(ByVal minSpend As Decimal) As DataTable
        Dim sql As String =
            "SELECT c.Customer_Id, c.Customer_Name, " &
            "       ISNULL(SUM(ol.Ordered_Quantity * p.Standard_Price), 0) AS TotalSpend, " &
            "       COUNT(DISTINCT o.Order_Id) AS OrderCount " &
            "FROM CUSTOMER_t c " &
            "JOIN ORDER_t o ON c.Customer_Id = o.Customer_Id " &
            "JOIN Order_line_t ol ON o.Order_Id = ol.Order_Id " &
            "JOIN PRODUCT_t p ON ol.Product_Id = p.Product_Id " &
            "GROUP BY c.Customer_Id, c.Customer_Name " &
            "HAVING SUM(ol.Ordered_Quantity * p.Standard_Price) > @minSpend " &
            "ORDER BY TotalSpend DESC"
        Return FillDataTable(sql, New SqlParameter("@minSpend", minSpend))
    End Function

    ' ─────────────────────────────────────────────────────────────
    ' QUERY: BULK BUYERS
    ' Rule: Average quantity per order line > bulkThreshold
    ' ─────────────────────────────────────────────────────────────
    Private Function GetBulkBuyers(ByVal minAvgQty As Decimal) As DataTable
        Dim sql As String =
            "SELECT c.Customer_Id, c.Customer_Name, " &
            "       COUNT(DISTINCT o.Order_Id)              AS OrderCount, " &
            "       SUM(ol.Ordered_Quantity)                AS TotalQty, " &
            "       AVG(CAST(ol.Ordered_Quantity AS DECIMAL(10,2))) AS AvgQtyPerLine " &
            "FROM CUSTOMER_t c " &
            "JOIN ORDER_t o ON c.Customer_Id = o.Customer_Id " &
            "JOIN Order_line_t ol ON o.Order_Id = ol.Order_Id " &
            "JOIN PRODUCT_t p ON ol.Product_Id = p.Product_Id " &
            "GROUP BY c.Customer_Id, c.Customer_Name " &
            "HAVING AVG(CAST(ol.Ordered_Quantity AS DECIMAL(10,2))) > @minAvgQty " &
            "ORDER BY AvgQtyPerLine DESC"
        Return FillDataTable(sql, New SqlParameter("@minAvgQty", minAvgQty))
    End Function

    ' ─────────────────────────────────────────────────────────────
    ' QUERY: MULTI-SEGMENT CUSTOMERS (overlapping segments)
    ' Customers appearing in 2+ segments – highest priority targets
    ' ─────────────────────────────────────────────────────────────
    Private Function GetMultiSegment(ByVal minSpend As Decimal, ByVal minOrders As Integer, ByVal minAvgQty As Decimal) As DataTable
        Dim sql As String =
            "WITH Stats AS ( " &
            "    SELECT c.Customer_Id, c.Customer_Name, " &
            "           COUNT(DISTINCT o.Order_Id) AS OrderCount, " &
            "           SUM(ol.Ordered_Quantity * p.Standard_Price) AS TotalSpend, " &
            "           AVG(CAST(ol.Ordered_Quantity AS DECIMAL(10,2))) AS AvgQtyPerLine " &
            "    FROM CUSTOMER_t c " &
            "    JOIN ORDER_t o  ON c.Customer_Id = o.Customer_Id " &
            "    JOIN Order_line_t ol ON o.Order_Id = ol.Order_Id " &
            "    JOIN PRODUCT_t p ON ol.Product_Id = p.Product_Id " &
            "    GROUP BY c.Customer_Id, c.Customer_Name " &
            ") " &
            "SELECT Customer_Id, Customer_Name, TotalSpend, OrderCount, AvgQtyPerLine, " &
            "   CASE " &
            "       WHEN OrderCount > @minOrders AND TotalSpend > @minSpend AND AvgQtyPerLine > @minAvg " &
            "           THEN 'Frequent + Premium + Bulk' " &
            "       WHEN OrderCount > @minOrders AND TotalSpend > @minSpend " &
            "           THEN 'Frequent + Premium' " &
            "       WHEN OrderCount > @minOrders AND AvgQtyPerLine > @minAvg " &
            "           THEN 'Frequent + Bulk' " &
            "       WHEN TotalSpend > @minSpend AND AvgQtyPerLine > @minAvg " &
            "           THEN 'Premium + Bulk' " &
            "   END AS Segments " &
            "FROM Stats " &
            "WHERE " &
            "   (CASE WHEN OrderCount > @minOrders THEN 1 ELSE 0 END + " &
            "    CASE WHEN TotalSpend > @minSpend  THEN 1 ELSE 0 END + " &
            "    CASE WHEN AvgQtyPerLine > @minAvg THEN 1 ELSE 0 END) >= 2 " &
            "ORDER BY TotalSpend DESC"

        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@minOrders", minOrders)
                cmd.Parameters.AddWithValue("@minSpend",  minSpend)
                cmd.Parameters.AddWithValue("@minAvg",    minAvgQty)
                Dim da As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            End Using
        End Using
    End Function

    ' ─────────────────────────────────────────────────────────────
    ' QUERY: NEW CUSTOMERS (zero orders – real-time)
    ' Any customer registered via Registration.aspx with no orders
    ' will appear here IMMEDIATELY without any manual step.
    ' ─────────────────────────────────────────────────────────────
    Private Function GetNewCustomers() As DataTable
        Dim sql As String =
            "SELECT c.Customer_Id, c.Customer_Name, " &
            "       c.Customer_Address, c.Customer_City, " &
            "       c.Customer_State,  c.Postal_Code, " &
            "       'New - No Orders Yet' AS Status " &
            "FROM CUSTOMER_t c " &
            "WHERE NOT EXISTS ( " &
            "    SELECT 1 FROM ORDER_t o WHERE o.Customer_Id = c.Customer_Id " &
            ") " &
            "ORDER BY c.Customer_Id DESC"

        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(sql, conn)
                Dim da As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            End Using
        End Using
    End Function

    ' ─────────────────────────────────────────────────────────────
    ' HELPER – fill DataTable with single-param query
    ' ─────────────────────────────────────────────────────────────
    Private Function FillDataTable(ByVal sql As String, ByVal param As SqlParameter) As DataTable
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.Add(param)
                Dim da As New SqlDataAdapter(cmd)
                Dim dt As New DataTable()
                da.Fill(dt)
                Return dt
            End Using
        End Using
    End Function

    ' ─────────────────────────────────────────────────────────────
    ' HELPER – total customer count
    ' ─────────────────────────────────────────────────────────────
    Private Function GetTotalCustomers() As Integer
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("SELECT COUNT(*) FROM CUSTOMER_t", conn)
                conn.Open()
                Return Convert.ToInt32(cmd.ExecuteScalar())
            End Using
        End Using
    End Function

End Class
