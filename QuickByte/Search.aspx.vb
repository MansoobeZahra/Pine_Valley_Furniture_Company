Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class Search
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadUserRegion()
            LoadAllItems()
        End If
    End Sub

    Private Sub LoadUserRegion()
        If Not IsPostBack Then
            If User.Identity.IsAuthenticated Then
                Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
                Using conn As New SqlConnection(connString)
                    Dim query As String = "SELECT Region FROM Users_QB WHERE Email = @Email"
                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@Email", User.Identity.Name)
                        conn.Open()
                        Dim reg As Object = cmd.ExecuteScalar()
                        If reg IsNot Nothing Then
                            Session("UserRegion") = reg.ToString()
                            ddlRegion.SelectedValue = reg.ToString()
                        End If
                    End Using
                End Using
            Else
                ddlRegion.SelectedValue = "Islamabad"
                Session("UserRegion") = "Islamabad"
            End If
        End If
    End Sub

    Protected Sub ddlRegion_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Session("UserRegion") = ddlRegion.SelectedValue
        LoadAllItems()
    End Sub

    Private Sub LoadAllItems()
        Dim region As String = ddlRegion.SelectedValue
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT m.ItemID, r.RestaurantID, m.Name AS ItemName, r.Name AS RestaurantName, m.Price, m.Description, " &
                                 "ISNULL((SELECT AVG(CAST(Rating AS DECIMAL(3,2))) FROM Feedback_QB WHERE TargetID = r.RestaurantID AND TargetType = 'Restaurant'), 0) AS AvgRating " &
                                 "FROM MenuItem_QB m INNER JOIN Restaurant_QB r ON m.RestaurantID = r.RestaurantID " &
                                 "WHERE m.Available = 1 AND r.Region = @Region AND r.IsActive = 1"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Region", region)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvResults.DataSource = dt
                gvResults.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim searchStr As String = txtSearch.Text.Trim()
        Dim region As String = ddlRegion.SelectedValue
        
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT m.ItemID, r.RestaurantID, m.Name AS ItemName, r.Name AS RestaurantName, m.Price, m.Description, " &
                                 "ISNULL((SELECT AVG(CAST(Rating AS DECIMAL(3,2))) FROM Feedback_QB WHERE TargetID = r.RestaurantID AND TargetType = 'Restaurant'), 0) AS AvgRating " &
                                 "FROM MenuItem_QB m INNER JOIN Restaurant_QB r ON m.RestaurantID = r.RestaurantID " &
                                 "WHERE m.Available = 1 AND r.Region = @Region AND r.IsActive = 1 AND (m.Name LIKE @Search OR r.Name LIKE @Search)"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Region", region)
                cmd.Parameters.AddWithValue("@Search", "%" & searchStr & "%")
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvResults.DataSource = dt
                gvResults.DataBind()
                
                If dt.Rows.Count = 0 Then
                    lblMessage.Text = "No items found in your region."
                    lblMessage.ForeColor = System.Drawing.Color.Red
                    lblMessage.Visible = True
                Else
                    lblMessage.Visible = False
                End If
            End Using
        End Using
    End Sub

    Protected Sub gvResults_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "Order" Then
            If Not User.Identity.IsAuthenticated Then
                Response.Redirect("Login.aspx")
                Return
            End If

            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim itemId As Integer = Convert.ToInt32(gvResults.DataKeys(index).Values("ItemID"))
            Dim restId As Integer = Convert.ToInt32(gvResults.DataKeys(index).Values("RestaurantID"))
            Dim custId As Integer = Convert.ToInt32(Session("ReferenceID"))
            Dim region As String = Session("UserRegion")

            Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
            Using conn As New SqlConnection(connString)
                conn.Open()
                Dim trans As SqlTransaction = conn.BeginTransaction()
                Try
                    ' 1. Create Order
                    Dim qOrder As String = "INSERT INTO Order_QB (CustomerID, RestaurantID, Status, Region) OUTPUT INSERTED.OrderID VALUES (@CustID, @RestID, 'Pending', @Region)"
                    Dim orderId As Integer
                    Using cmd As New SqlCommand(qOrder, conn, trans)
                        cmd.Parameters.AddWithValue("@CustID", custId)
                        cmd.Parameters.AddWithValue("@RestID", restId)
                        cmd.Parameters.AddWithValue("@Region", region)
                        orderId = cmd.ExecuteScalar()
                    End Using

                    ' 2. Add Order Item
                    Dim qItem As String = "INSERT INTO OrderItem_QB (OrderID, ItemID, Quantity) VALUES (@OrderID, @ItemID, 1)"
                    Using cmd As New SqlCommand(qItem, conn, trans)
                        cmd.Parameters.AddWithValue("@OrderID", orderId)
                        cmd.Parameters.AddWithValue("@ItemID", itemId)
                        cmd.ExecuteNonQuery()
                    End Using

                    trans.Commit()
                    lblMessage.Text = "Order placed successfully! Check 'My Orders' for status."
                    lblMessage.ForeColor = System.Drawing.Color.Green
                    lblMessage.Visible = True
                Catch ex As Exception
                    trans.Rollback()
                    lblMessage.Text = "Error placing order: " & ex.Message
                    lblMessage.ForeColor = System.Drawing.Color.Red
                    lblMessage.Visible = True
                End Try
            End Using
        End If
    End Sub

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        FormsAuthentication.SignOut()
        Session.Clear()
        Response.Redirect("Default.aspx")
    End Sub
End Class
