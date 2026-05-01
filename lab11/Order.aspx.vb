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
        If Session("Username") Is Nothing Then Response.Redirect("Login.aspx?reason=timeout")
        Dim isAdmin As Boolean = (Session("UserRole").ToString() = "admin")
        lnkRegistration.Visible = isAdmin
        lnkCatalog.Visible = True
        lnkSegmentation.Visible = isAdmin
        If Not IsPostBack Then
            lblWelcome.Text = "Welcome, " & Session("Username") & " (" & Session("UserRole") & ")"
            If String.IsNullOrEmpty(txtOrderDate.Text) Then
                txtOrderDate.Text = DateTime.Now.ToString("yyyy-MM-dd")
            End If
            If Session("CustomerID") IsNot Nothing Then
                lblCustomerInfo.Text = "Ordering as Customer ID: " & Session("CustomerID").ToString()
            Else
                lblCustomerInfo.Text = "Warning: No Customer ID found. Please Register first."
                lblCustomerInfo.ForeColor = System.Drawing.Color.Red
                btnPlaceOrder.Enabled = False
            End If
            LoadCart()
        End If
    End Sub


    Private Sub LoadCart()
        Dim dtCart As DataTable = DirectCast(Session("Cart"), DataTable)
        If dtCart IsNot Nothing AndAlso dtCart.Rows.Count > 0 Then
            gvCart.DataSource = dtCart
            gvCart.DataBind()

            Dim total As Decimal = 0
            For Each row As DataRow In dtCart.Rows
                total += Convert.ToDecimal(row("Subtotal"))
            Next
            lblGrandTotal.Text = String.Format("{0:C}", total)
        Else
            ' If cart is empty, redirect back to search or show message
            lblMessage.Text = "Your cart is empty. Please add products first."
            lblMessage.ForeColor = System.Drawing.Color.Red
            lblMessage.Visible = True
            btnPlaceOrder.Enabled = False
        End If
    End Sub

    Protected Sub btnPlaceOrder_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Session("CustomerID") Is Nothing Then
            lblMessage.Text = "Error: You must be registered to place an order."
            lblMessage.ForeColor = System.Drawing.Color.Red
            lblMessage.Visible = True
            Return
        End If

        Dim dtCart As DataTable = DirectCast(Session("Cart"), DataTable)
        If dtCart Is Nothing OrElse dtCart.Rows.Count = 0 Then Return

        Using conn As New SqlConnection(ConnStr)
            conn.Open()
            Dim trans As SqlTransaction = conn.BeginTransaction()
            Try
                ' 1. Get next Order_Id
                Dim nextIdCmd As New SqlCommand("SELECT ISNULL(MAX(Order_Id), 1000) + 1 FROM ORDER_t", conn, trans)
                Dim orderId As Integer = Convert.ToInt32(nextIdCmd.ExecuteScalar())

                ' 2. Insert Order Header
                Dim sqlHeader As String = "INSERT INTO ORDER_t (Order_Id, Customer_Id, Order_Date) VALUES (@oid, @cid, @date)"
                Using cmdHeader As New SqlCommand(sqlHeader, conn, trans)
                    cmdHeader.Parameters.AddWithValue("@oid", orderId)
                    cmdHeader.Parameters.AddWithValue("@cid", Integer.Parse(Session("CustomerID").ToString()))
                    cmdHeader.Parameters.AddWithValue("@date", Date.Parse(txtOrderDate.Text.Trim()))
                    cmdHeader.ExecuteNonQuery()
                End Using

                ' 2. Insert Order Lines
                Dim sqlLine As String = "INSERT INTO Order_line_t (Order_Id, Product_Id, Ordered_Quantity) VALUES (@oid, @pid, @qty)"
                For Each row As DataRow In dtCart.Rows
                    Using cmdLine As New SqlCommand(sqlLine, conn, trans)
                        cmdLine.Parameters.AddWithValue("@oid", orderId)
                        cmdLine.Parameters.AddWithValue("@pid", Convert.ToInt32(row("ProductId")))
                        cmdLine.Parameters.AddWithValue("@qty", Convert.ToInt32(row("Quantity")))
                        cmdLine.ExecuteNonQuery()
                    End Using
                Next

                trans.Commit()
                
                ' Clear Cart
                Session("Cart") = Nothing
                lblMessage.Text = "Successfully placed Order #" & orderId & "!"
                lblMessage.ForeColor = System.Drawing.Color.Green
                lblMessage.Visible = True
                
                gvCart.Visible = False
                btnPlaceOrder.Visible = False
                btnClear.Text = "Start New Shopping Session"
                
            Catch ex As Exception
                trans.Rollback()
                lblMessage.Text = "Order Error: " & ex.Message
                lblMessage.ForeColor = System.Drawing.Color.Red
                lblMessage.Visible = True
            End Try
        End Using
    End Sub

    Protected Sub btnClear_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session("Cart") = Nothing
        Response.Redirect("Search.aspx")
    End Sub
End Class
