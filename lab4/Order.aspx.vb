Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class OrderPage
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        ' Set today's date if empty
        ' Set today's date if empty
        If Not IsPostBack AndAlso String.IsNullOrEmpty(txtOrderDate.Text) Then
            txtOrderDate.Text = DateTime.Now.ToString("yyyy-MM-dd")
        End If

        ' Admin Only check for lookup functionality
        Dim isAdmin As Boolean = False
        If Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToLower() = "admin" Then
            isAdmin = True
        End If
        pnlLookup.Visible = isAdmin
    End Sub

    ' ---------------------------------------------------------------
    ' PLACE ORDER button:
    '   1. INSERT into ORDER_t (header)
    '   2. INSERT into Order_line_t for each non-empty product row
    ' ---------------------------------------------------------------
    Protected Sub btnPlaceOrder_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim conn As New SqlConnection(ConnStr)
        Dim cmd As New SqlCommand
        cmd.Connection = conn

        Try
            conn.Open()
            ' Header
            cmd.CommandText = "INSERT INTO ORDER_t ([Customer_Id], [Order_Date]) VALUES ("
            cmd.CommandText &= "'" & txtCustomerID.Text.Trim() & "',"
            cmd.CommandText &= "'" & txtOrderDate.Text.Trim() & "'); SELECT SCOPE_IDENTITY();"
            
            Dim orderId As Integer = Convert.ToInt32(cmd.ExecuteScalar())

            ' Lines (Skipping complex loop for direct style)
            If Not String.IsNullOrWhiteSpace(txtProdID1.Text) Then
                cmd.CommandText = "INSERT INTO Order_line_t ([Order_Id], [Product_Id], [Ordered_Quantity]) VALUES ("
                cmd.CommandText &= orderId & "," & txtProdID1.Text.Trim() & "," & txtQty1.Text.Trim() & ")"
                cmd.ExecuteNonQuery()
            End If

            If Not String.IsNullOrWhiteSpace(txtProdID2.Text) Then
                cmd.CommandText = "INSERT INTO Order_line_t ([Order_Id], [Product_Id], [Ordered_Quantity]) VALUES ("
                cmd.CommandText &= orderId & "," & txtProdID2.Text.Trim() & "," & txtQty2.Text.Trim() & ")"
                cmd.ExecuteNonQuery()
            End If

            lblMessage.Text = "Order record inserted."
            lblMessage.Visible = True
        Catch ex As Exception
            lblMessage.Text = ex.Message
            lblMessage.Visible = True
        Finally
            cmd.Dispose()
            conn.Close()
        End Try
    End Sub

    ' Inserts one Order_line_t row; returns 1 if successful, 0 if skipped
    Private Function InsertLine(ByRef conn As SqlConnection, ByVal orderId As Integer, ByVal productIdText As String, ByVal qtyText As String) As Integer
        If String.IsNullOrWhiteSpace(productIdText) OrElse String.IsNullOrWhiteSpace(qtyText) Then Return 0

        Try
            Dim sql As String = "INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (@oid, @pid, @qty)"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@oid", orderId)
                cmd.Parameters.AddWithValue("@pid", Integer.Parse(productIdText.Trim()))
                cmd.Parameters.AddWithValue("@qty", Integer.Parse(qtyText.Trim()))
                cmd.ExecuteNonQuery()
            End Using
            Return 1
        Catch ex As Exception
            Return 0
        End Try
    End Function

    ' ---------------------------------------------------------------
    ' LOOKUP button:
    '   Finds orders matching Customer ID and Product ID
    ' ---------------------------------------------------------------
    Protected Sub btnLookup_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim custIdText As String = txtLookupCustID.Text.Trim()
            Dim prodIdText As String = txtLookupProdID.Text.Trim()

            If String.IsNullOrEmpty(custIdText) OrElse String.IsNullOrEmpty(prodIdText) Then
                lblMessage.Text = "Please enter both Customer ID and Product ID to lookup."
                lblMessage.ForeColor = System.Drawing.Color.Red
                lblMessage.Visible = True
                Return
            End If

            Dim sql As String = "SELECT o.Order_Id, o.Order_Date FROM ORDER_t o " & _
                               "JOIN Order_line_t ol ON o.Order_Id = ol.Order_Id " & _
                               "WHERE o.Customer_Id = @cid AND ol.Product_Id = @pid"
            
            Dim dt As New DataTable()
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@cid", Integer.Parse(custIdText))
                    cmd.Parameters.AddWithValue("@pid", Integer.Parse(prodIdText))
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using

            gvLookupResults.DataSource = dt
            gvLookupResults.DataBind()
            gvLookupResults.Visible = True
            lblMessage.Visible = False
        Catch ex As Exception
            lblMessage.Text = "Lookup error: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
            lblMessage.Visible = True
        End Try
    End Sub

    ' ---------------------------------------------------------------
    ' CLEAR button
    ' ---------------------------------------------------------------
    Protected Sub btnClear_Click(ByVal sender As Object, ByVal e As EventArgs)
        txtCustomerID.Text = ""
        txtOrderDate.Text = DateTime.Now.ToString("yyyy-MM-dd")
        txtProdID1.Text = "" : txtQty1.Text = ""
        txtProdID2.Text = "" : txtQty2.Text = ""
        txtLookupCustID.Text = ""
        txtLookupProdID.Text = ""
        gvLookupResults.Visible = False
        lblMessage.Visible = False
    End Sub
End Class
