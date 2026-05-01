Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class SearchPage
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString
        End Get
    End Property

    Private Shared ReadOnly LineNames As New Dictionary(Of Integer, String) From {
        {1, "Living Room"},
        {2, "Dining Room"},
        {3, "Bedroom"},
        {4, "Office"}
    }

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Session("Username") Is Nothing Then Response.Redirect("Login.aspx?reason=timeout")
        Dim isAdmin As Boolean = (Session("UserRole").ToString() = "admin")
        lnkRegistration.Visible = isAdmin
        lnkCatalog.Visible = True
        lnkSegmentation.Visible = isAdmin
        pnlOrderLookup.Visible = isAdmin
        If Not IsPostBack Then
            lblWelcome.Text = "Welcome, " & Session("Username") & " (" & Session("UserRole") & ")"
            If Session("Cart") Is Nothing Then
                Dim dtCart As New DataTable()
                dtCart.Columns.Add("ProductId", GetType(Integer))
                dtCart.Columns.Add("Description", GetType(String))
                dtCart.Columns.Add("Quantity", GetType(Integer))
                dtCart.Columns.Add("Price", GetType(Decimal))
                dtCart.Columns.Add("Subtotal", GetType(Decimal))
                Session("Cart") = dtCart
            End If
            UpdateCartDisplay()
            LoadCustomerDropdown()
        End If
    End Sub

    ' ─────────────────────────────────────────────
    ' Populate customer dropdown (name shown, ID as value)
    ' ─────────────────────────────────────────────
    Private Sub LoadCustomerDropdown()
        ddlCustomer.Items.Clear()
        ddlCustomer.Items.Add(New ListItem("-- Select Customer --", ""))
        Using conn As New SqlConnection(ConnStr)
            Dim sql As String = "SELECT Customer_Id, Customer_Name FROM CUSTOMER_t ORDER BY Customer_Name"
            Using cmd As New SqlCommand(sql, conn)
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    For Each row As DataRow In dt.Rows
                        ddlCustomer.Items.Add(New ListItem(
                            row("Customer_Name").ToString(),
                            row("Customer_Id").ToString()))
                    Next
                End Using
            End Using
        End Using
    End Sub

    Protected Sub Logout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    Protected Sub gvResults_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "AddToCart" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvResults.Rows(index)
            Dim productId As Integer = Convert.ToInt32(gvResults.DataKeys(index).Value)
            Dim desc As String = row.Cells(0).Text
            Dim price As Decimal = Decimal.Parse(row.Cells(3).Text, System.Globalization.NumberStyles.Currency)
            Dim txtQty As TextBox = DirectCast(row.FindControl("txtQty"), TextBox)
            Dim qty As Integer = 1
            Integer.TryParse(txtQty.Text, qty)

            Dim dtCart As DataTable = DirectCast(Session("Cart"), DataTable)
            Dim existingRow As DataRow() = dtCart.Select("ProductId = " & productId)
            If existingRow.Length > 0 Then
                existingRow(0)("Quantity") = Convert.ToInt32(existingRow(0)("Quantity")) + qty
                existingRow(0)("Subtotal") = Convert.ToDecimal(existingRow(0)("Quantity")) * price
            Else
                Dim newRow As DataRow = dtCart.NewRow()
                newRow("ProductId") = productId
                newRow("Description") = desc
                newRow("Quantity") = qty
                newRow("Price") = price
                newRow("Subtotal") = qty * price
                dtCart.Rows.Add(newRow)
            End If

            Session("Cart") = dtCart
            UpdateCartDisplay()
        End If
    End Sub

    Private Sub UpdateCartDisplay()
        Dim dtCart As DataTable = DirectCast(Session("Cart"), DataTable)
        If dtCart IsNot Nothing AndAlso dtCart.Rows.Count > 0 Then
            gvCart.DataSource = dtCart
            gvCart.DataBind()
            cartSummary.Visible = True

            Dim total As Decimal = 0
            For Each row As DataRow In dtCart.Rows
                total += Convert.ToDecimal(row("Subtotal"))
            Next
            lblTotal.Text = String.Format("{0:C}", total)
        Else
            cartSummary.Visible = False
        End If
    End Sub

    Protected Sub btnGoToOrder_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("Order.aspx")
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim sql As String = "SELECT Product_Id, Product_Description, Product_Line_Id, Product_Finish, Standard_Price " & _
                               "FROM PRODUCT_t WHERE 1 = 1"

            Dim parms As New List(Of SqlParameter)()

            If Not String.IsNullOrWhiteSpace(txtProductDesc.Text) Then
                sql &= " AND Product_Description LIKE @desc"
                parms.Add(New SqlParameter("@desc", "%" & txtProductDesc.Text.Trim() & "%"))
            End If

            If Not String.IsNullOrWhiteSpace(ddlProductLine.SelectedValue) Then
                sql &= " AND Product_Line_Id = @lineId"
                parms.Add(New SqlParameter("@lineId", Integer.Parse(ddlProductLine.SelectedValue)))
            End If

            sql &= " ORDER BY Product_Id"

            Dim dt As New DataTable()
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddRange(parms.ToArray())
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using

            dt.Columns.Add("ProductLineName", GetType(String))
            For Each row As DataRow In dt.Rows
                Dim id As Integer = Convert.ToInt32(row("Product_Line_Id"))
                row("ProductLineName") = If(LineNames.ContainsKey(id), LineNames(id), id.ToString())
            Next

            gvResults.DataSource = dt
            gvResults.DataBind()
            gvResults.Visible = True
            lblMessage.Visible = False
        Catch ex As Exception
            lblMessage.Text = "Error: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
            lblMessage.Visible = True
        End Try
    End Sub

    Protected Sub btnClear_Click(ByVal sender As Object, ByVal e As EventArgs)
        txtProductDesc.Text = ""
        ddlProductLine.SelectedIndex = 0
        gvResults.Visible = False
        lblMessage.Visible = False
    End Sub

    ' ──────────────────────────────────────────────────────────────
    ' CUSTOMER ORDER LOOKUP
    ' Frontend: dropdown shows names; backend queries by Customer_Id
    ' ──────────────────────────────────────────────────────────────
    Protected Sub btnCustomerSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim custId As String = ddlCustomer.SelectedValue
        Dim orderIdText As String = txtOrderId.Text.Trim()

        ' Validation
        If String.IsNullOrEmpty(custId) AndAlso String.IsNullOrEmpty(orderIdText) Then
            ShowOrderMsg("Please select a customer from the dropdown OR enter an Order ID.", System.Drawing.Color.OrangeRed)
            pnlOrderResults.Visible = False
            Return
        End If

        Try
            Dim sql As String =
                "SELECT c.Customer_Id, c.Customer_Name, " &
                "       c.Customer_City, c.Customer_State, " &
                "       o.Order_Id, o.Order_Date, " &
                "       p.Product_Description, ol.Ordered_Quantity, " &
                "       p.Standard_Price AS Unit_Price, " &
                "       (ol.Ordered_Quantity * p.Standard_Price) AS Line_Total " &
                "FROM CUSTOMER_t c " &
                "JOIN ORDER_t o        ON c.Customer_Id = o.Customer_Id " &
                "JOIN Order_line_t ol  ON o.Order_Id    = ol.Order_Id " &
                "JOIN PRODUCT_t p      ON ol.Product_Id = p.Product_Id " &
                "WHERE 1 = 1"

            Dim parms As New List(Of SqlParameter)()

            ' Filter by Customer_Id (from dropdown – frontend shows name, backend uses ID)
            If Not String.IsNullOrEmpty(custId) Then
                sql &= " AND c.Customer_Id = @custId"
                parms.Add(New SqlParameter("@custId", Integer.Parse(custId)))
            End If

            ' Filter by Order_Id if supplied
            If Not String.IsNullOrEmpty(orderIdText) Then
                Dim oid As Integer
                If Integer.TryParse(orderIdText, oid) Then
                    sql &= " AND o.Order_Id = @orderId"
                    parms.Add(New SqlParameter("@orderId", oid))
                Else
                    ShowOrderMsg("Order ID must be a number.", System.Drawing.Color.OrangeRed)
                    Return
                End If
            End If

            sql &= " ORDER BY o.Order_Id, p.Product_Id"

            Dim dt As New DataTable()
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddRange(parms.ToArray())
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using

            If dt.Rows.Count = 0 Then
                ShowOrderMsg("No orders found for the selected criteria.", System.Drawing.Color.DarkOrange)
                pnlOrderResults.Visible = False
                Return
            End If

            ' Bind results
            lblCustomerSearchMsg.Visible = False
            gvOrders.DataSource = dt
            gvOrders.DataBind()

            ' Grand total + summary
            Dim grandTotal As Decimal = 0
            Dim distinctOrders As New System.Collections.Generic.HashSet(Of Integer)()
            For Each row As DataRow In dt.Rows
                grandTotal += Convert.ToDecimal(row("Line_Total"))
                distinctOrders.Add(Convert.ToInt32(row("Order_Id")))
            Next
            lblOrderGrandTotal.Text = String.Format("{0:C}", grandTotal)

            Dim custName As String = dt.Rows(0)("Customer_Name").ToString()
            Dim custIdVal As String = dt.Rows(0)("Customer_Id").ToString()
            lblOrderSummary.Text = "Customer: <b>" & custName & "</b> (ID: " & custIdVal & ") - " & _
                distinctOrders.Count.ToString() & " order(s) found | " & dt.Rows.Count.ToString() & " line item(s)"

            pnlOrderResults.Visible = True

        Catch ex As Exception
            ShowOrderMsg("Error: " & ex.Message, System.Drawing.Color.Red)
        End Try
    End Sub

    Protected Sub btnClearOrderSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        ddlCustomer.SelectedIndex = 0
        txtOrderId.Text = ""
        pnlOrderResults.Visible = False
        lblCustomerSearchMsg.Visible = False
    End Sub

    Private Sub ShowOrderMsg(ByVal msg As String, ByVal color As System.Drawing.Color)
        lblCustomerSearchMsg.Text = msg
        lblCustomerSearchMsg.ForeColor = color
        lblCustomerSearchMsg.Visible = True
    End Sub

End Class
