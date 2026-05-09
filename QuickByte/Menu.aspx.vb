Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class MenuPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not User.Identity.IsAuthenticated OrElse Session("Role") <> "RestaurantManager" Then
            Response.Redirect("Default.aspx")
        End If

        If Not IsPostBack Then
            LoadMenu()
        End If
    End Sub

    Private Sub LoadMenu()
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT ItemID, Name, Description, Price, Available FROM MenuItem_QB WHERE RestaurantID = @RefID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RefID", refId)
                Dim dt As New System.Data.DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
                gvMenuItems.DataSource = dt
                gvMenuItems.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim refId As Integer = Convert.ToInt32(Session("ReferenceID"))
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "INSERT INTO MenuItem_QB (RestaurantID, Name, Description, Price, Available) VALUES (@RestaurantID, @Name, @Description, @Price, @Available)"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@RestaurantID", refId)
                cmd.Parameters.AddWithValue("@Name", txtItemName.Text.Trim())
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim())
                cmd.Parameters.AddWithValue("@Price", Convert.ToDecimal(txtPrice.Text))
                cmd.Parameters.AddWithValue("@Available", chkAvailable.Checked)
                
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        lblMessage.Text = "Item added successfully!"
        lblMessage.Visible = True
        
        txtItemName.Text = ""
        txtDescription.Text = ""
        txtPrice.Text = ""
        LoadMenu()
    End Sub

    Protected Sub gvMenuItems_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        If e.CommandName = "ToggleAvailable" Then
            Dim itemId As Integer = Convert.ToInt32(e.CommandArgument)
            Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
            Using conn As New SqlConnection(connString)
                Dim query As String = "UPDATE MenuItem_QB SET Available = CASE WHEN Available = 1 THEN 0 ELSE 1 END WHERE ItemID = @ItemID"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@ItemID", itemId)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            LoadMenu()
        End If
    End Sub

    Protected Sub gvMenuItems_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)
        ' Handled via RowCommand mostly, but keeping this for compatibility if needed
        Dim itemId As Integer = Convert.ToInt32(gvMenuItems.DataKeys(e.RowIndex).Value)
        ExecuteDelete(itemId)
        LoadMenu()
    End Sub

    Private Sub ExecuteDelete(ByVal itemId As Integer)
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "DELETE FROM MenuItem_QB WHERE ItemID = @ItemID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ItemID", itemId)
                conn.Open()
                Try
                    cmd.ExecuteNonQuery()
                    lblMessage.Text = "Item deleted successfully."
                    lblMessage.ForeColor = System.Drawing.Color.Green
                Catch ex As Exception
                    lblMessage.Text = "Cannot delete item. It might be used in existing orders. Try hiding it instead."
                    lblMessage.ForeColor = System.Drawing.Color.Red
                End Try
                lblMessage.Visible = True
            End Using
        End Using
    End Sub

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        FormsAuthentication.SignOut()
        Session.Clear()
        Response.Redirect("Default.aspx")
    End Sub
End Class
