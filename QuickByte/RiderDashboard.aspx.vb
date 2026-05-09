Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class RiderDashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not User.Identity.IsAuthenticated OrElse Session("Role") <> "Rider" Then
            Response.Redirect("Default.aspx")
        End If

        If Not IsPostBack Then
            LoadRiderInfo()
            RefreshGrids()
        End If
    End Sub

    Private Sub RefreshGrids()
        LoadAvailableOrders()
        LoadAssignedOrders()
        LoadDeliveryHistory()
    End Sub

    Private Sub LoadRiderInfo()
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT RiderID, Name, Region, Availability, IsActive FROM Rider_QB WHERE RiderID = @RefID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RefID", refId)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        If Not Convert.ToBoolean(reader("IsActive")) Then
                            FormsAuthentication.SignOut()
                            Response.Redirect("Login.aspx?msg=AccountDisabled")
                        End If
                        lblRegion.Text = reader("Region").ToString()
                        lblRegionTitle.Text = reader("Region").ToString()
                        Session("RiderRegion") = reader("Region").ToString()
                        chkAvailability.Checked = Convert.ToBoolean(reader("Availability"))
                        UpdateStatusText()
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub UpdateStatusText()
        If chkAvailability.Checked Then
            lblStatusText.Text = "Status: Available"
            lblStatusText.ForeColor = System.Drawing.Color.Green
        Else
            lblStatusText.Text = "Status: Offline"
            lblStatusText.ForeColor = System.Drawing.Color.Red
        End If
    End Sub

    Protected Sub chkAvailability_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        ExecuteNonQuery("UPDATE Rider_QB SET Availability = " & If(chkAvailability.Checked, "1", "0") & " WHERE RiderID = " & refId)
        UpdateStatusText()
        LoadAvailableOrders()
    End Sub

    Private Sub LoadAvailableOrders()
        If Not chkAvailability.Checked Then
            gvAvailableOrders.DataSource = Nothing
            gvAvailableOrders.DataBind()
            Return
        End If

        Dim region As String = Session("RiderRegion")
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT o.OrderID, r.Name AS RestaurantName, " &
                                 "(SELECT STUFF((SELECT ', ' + mi.Name FROM OrderItem_QB oi JOIN MenuItem_QB mi ON oi.ItemID = mi.ItemID WHERE oi.OrderID = o.OrderID FOR XML PATH('')), 1, 2, '')) AS Items " &
                                 "FROM Order_QB o JOIN Restaurant_QB r ON o.RestaurantID = r.RestaurantID " &
                                 "WHERE o.Status = 'Pending' AND o.Region = @Region"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Region", region)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvAvailableOrders.DataSource = dt
                gvAvailableOrders.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub gvAvailableOrders_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "PickOrder" Then
            Dim orderId As Integer = Convert.ToInt32(e.CommandArgument)
            Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
            
            ' Assign order to rider and update status
            ExecuteNonQuery("UPDATE Order_QB SET RiderID = " & refId & ", Status = 'Assigned' WHERE OrderID = " & orderId)
            ' Make rider unavailable once they pick an order
            ExecuteNonQuery("UPDATE Rider_QB SET Availability = 0 WHERE RiderID = " & refId)
            chkAvailability.Checked = False
            UpdateStatusText()
            
            RefreshGrids()
        End If
    End Sub

    Private Sub LoadAssignedOrders()
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT o.OrderID, c.FirstName + ' ' + c.LastName + '<br/><small>' + c.PhoneNumber + '</small>' AS CustomerInfo, " &
                                 "r.Name + '<br/><small>' + r.Street + '</small>' AS RestaurantInfo, o.Status " &
                                 "FROM Order_QB o INNER JOIN Customer_QB c ON o.CustomerID = c.CustomerID INNER JOIN Restaurant_QB r ON o.RestaurantID = r.RestaurantID " &
                                 "WHERE o.RiderID = @RefID AND o.Status IN ('Assigned', 'Picked Up', 'Delivered')"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RefID", refId)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvAssignedOrders.DataSource = dt
                gvAssignedOrders.DataBind()

                For Each row As GridViewRow In gvAssignedOrders.Rows
                    Dim status As String = dt.Rows(row.RowIndex)("Status").ToString()
                    Dim ddl As DropDownList = CType(row.FindControl("ddlStatus"), DropDownList)
                    If ddl IsNot Nothing Then ddl.SelectedValue = status
                Next
            End Using
        End Using
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim row As GridViewRow = CType(btn.NamingContainer, GridViewRow)
        Dim orderId As Integer = Convert.ToInt32(gvAssignedOrders.DataKeys(row.RowIndex).Value)
        Dim ddl As DropDownList = CType(row.FindControl("ddlStatus"), DropDownList)
        
        ExecuteNonQuery("UPDATE Order_QB SET Status = '" & ddl.SelectedValue & "' WHERE OrderID = " & orderId)
        RefreshGrids()
    End Sub

    Private Sub LoadDeliveryHistory()
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT o.OrderID, o.OrderDate, c.FirstName + ' ' + c.LastName AS CustomerName, o.Status " &
                                 "FROM Order_QB o INNER JOIN Customer_QB c ON o.CustomerID = c.CustomerID " &
                                 "WHERE o.RiderID = @RefID AND o.Status = 'Confirmed' ORDER BY o.OrderDate DESC"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RefID", refId)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvDeliveryHistory.DataSource = dt
                gvDeliveryHistory.DataBind()
            End Using
        End Using
    End Sub

    Private Sub ExecuteNonQuery(ByVal query As String)
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        FormsAuthentication.SignOut()
        Session.Clear()
        Response.Redirect("Default.aspx")
    End Sub
End Class
