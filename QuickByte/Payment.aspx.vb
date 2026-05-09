Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class Payment
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not User.Identity.IsAuthenticated Then
            Response.Redirect("Login.aspx")
        End If

        If Not IsPostBack Then
            Dim orderId As String = Request.QueryString("OrderID")
            If Not String.IsNullOrEmpty(orderId) Then
                LoadOrderDetails(orderId)
            Else
                paymentFormSection.Visible = False
                litOrderSummary.Text = "<p>No order selected for payment. Please go to <a href='Orders.aspx'>Orders</a>.</p>"
            End If
            LoadPaymentHistory()
        End If
    End Sub

    Private Sub LoadOrderDetails(ByVal orderId As String)
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName, r.Name AS RestaurantName, o.Status, " &
                                 "(SELECT SUM(mi.Price * oi.Quantity) FROM OrderItem_QB oi JOIN MenuItem_QB mi ON oi.ItemID = mi.ItemID WHERE oi.OrderID = o.OrderID) AS TotalAmount " &
                                 "FROM Order_QB o INNER JOIN Customer_QB c ON o.CustomerID = c.CustomerID INNER JOIN Restaurant_QB r ON o.RestaurantID = r.RestaurantID " &
                                 "WHERE o.OrderID = @OrderID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@OrderID", orderId)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        Dim amount As Decimal = If(reader("TotalAmount") Is DBNull.Value, 0, Convert.ToDecimal(reader("TotalAmount")))
                        txtAmount.Text = amount.ToString("F2")
                        
                        litOrderSummary.Text = String.Format(
                            "<div class='info-row'><span class='label'>Order ID:</span><span class='value'>{0}</span></div>" &
                            "<div class='info-row'><span class='label'>Customer Name:</span><span class='value'>{1}</span></div>" &
                            "<div class='info-row'><span class='label'>Restaurant:</span><span class='value'>{2}</span></div>" &
                            "<div class='info-row'><span class='label'>Total Amount:</span><span class='value amount'>Rs. {3}</span></div>" &
                            "<div class='info-row'><span class='label'>Order Status:</span><span class='value'>{4}</span></div>",
                            reader("OrderID"), reader("CustomerName"), reader("RestaurantName"), amount.ToString("N2"), reader("Status"))
                    Else
                        paymentFormSection.Visible = False
                        litOrderSummary.Text = "<p>Order not found.</p>"
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadPaymentHistory()
        Dim role As String = If(Session("Role") IsNot Nothing, Session("Role").ToString(), "")
        Dim refId As Integer = If(Session("ReferenceID") IsNot Nothing, Convert.ToInt32(Session("ReferenceID")), 0)
        
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT p.PaymentID, p.OrderID, p.Method, p.Amount, p.PaymentDate, p.Status FROM Payment_QB p "
            
            If role = "Customer" Then
                query &= "INNER JOIN Order_QB o ON p.OrderID = o.OrderID WHERE o.CustomerID = @RefID"
            End If
            
            query &= " ORDER BY p.PaymentDate DESC"

            Using cmd As New SqlCommand(query, conn)
                If role = "Customer" Then
                    cmd.Parameters.AddWithValue("@RefID", refId)
                End If
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvPaymentHistory.DataSource = dt
                gvPaymentHistory.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub btnPay_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim orderId As String = Request.QueryString("OrderID")
        Dim method As String = ddlPaymentMethod.SelectedValue
        Dim amount As Decimal = Convert.ToDecimal(txtAmount.Text)

        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim transaction As SqlTransaction = conn.BeginTransaction()
            Try
                ' 1. Insert Payment record
                Dim insertPayment As String = "INSERT INTO Payment_QB (OrderID, Method, Amount, Status) VALUES (@OrderID, @Method, @Amount, 'Paid')"
                Using cmd As New SqlCommand(insertPayment, conn, transaction)
                    cmd.Parameters.AddWithValue("@OrderID", orderId)
                    cmd.Parameters.AddWithValue("@Method", method)
                    cmd.Parameters.AddWithValue("@Amount", amount)
                    cmd.ExecuteNonQuery()
                End Using

                ' 2. Update Order Status
                Dim updateOrder As String = "UPDATE Order_QB SET Status = 'Preparing' WHERE OrderID = @OrderID AND Status = 'Pending'"
                Using cmd As New SqlCommand(updateOrder, conn, transaction)
                    cmd.Parameters.AddWithValue("@OrderID", orderId)
                    cmd.ExecuteNonQuery()
                End Using

                transaction.Commit()
                Response.Redirect("Orders.aspx")
            Catch ex As Exception
                transaction.Rollback()
                lblError.Text = "Payment failed: " & ex.Message
                lblError.Visible = True
            End Try
        End Using
    End Sub

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        FormsAuthentication.SignOut()
        Session.Clear()
        Response.Redirect("Default.aspx")
    End Sub
End Class
