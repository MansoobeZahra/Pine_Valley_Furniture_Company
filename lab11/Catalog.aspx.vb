Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class CatalogPage
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
        lnkCatalog.Visible = True   ' Catalog visible to ALL roles
        lnkSegmentation.Visible = isAdmin
        pnlAdminTools.Visible = isAdmin  ' Add/Update only for admin
        If Not IsPostBack Then
            lblWelcome.Text = "Welcome, " & Session("Username") & " (" & Session("UserRole") & ")"
            LoadCatalog()
        End If
    End Sub

    Protected Sub Logout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    Private Sub LoadCatalog()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(ConnStr)
            Dim sql As String = "SELECT Product_Id, Product_Description, Product_Line_Id, Product_Finish, Standard_Price " &
                               "FROM PRODUCT_t ORDER BY Product_Id"
            Using cmd As New SqlCommand(sql, conn)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        gvCatalog.DataSource = dt
        gvCatalog.DataBind()
    End Sub

    Protected Sub btnAddProduct_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then Return

        Dim conn As New SqlConnection(ConnStr)
        Dim cmd As New SqlCommand
        cmd.Connection = conn

        Try
            conn.Open()
            ' Get next Product_Id (non-IDENTITY schema)
            Dim newId As Integer
            Using cmdMax As New SqlCommand("SELECT ISNULL(MAX(Product_Id), 0) + 1 FROM PRODUCT_t", conn)
                newId = Convert.ToInt32(cmdMax.ExecuteScalar())
            End Using

            cmd.CommandText = "INSERT INTO PRODUCT_t ([Product_Id], [Product_Line_Id], [Product_Description], [Product_Finish], [Standard_Price])"
            cmd.CommandText &= " VALUES (" & newId & "," & ddlProductLine.SelectedValue & ","
            cmd.CommandText &= "'" & txtProductName.Text.Trim() & "',"
            cmd.CommandText &= "'" & txtFinish.Text.Trim() & "',"
            cmd.CommandText &= "'" & txtUnitPrice.Text.Trim() & "')"

            cmd.ExecuteNonQuery()
            lblMessage.Text = "Product #" & newId & " added successfully."
            lblMessage.ForeColor = System.Drawing.Color.Green
            lblMessage.Visible = True
            txtProductName.Text = ""
            txtFinish.Text = ""
            txtUnitPrice.Text = ""
            LoadCatalog()
        Catch ex As Exception
            lblMessage.Text = "Error: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
            lblMessage.Visible = True
        Finally
            cmd.Dispose()
            conn.Close()
        End Try
    End Sub

    Protected Sub btnUpdateProduct_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then Return

        Using conn As New SqlConnection(ConnStr)
            Dim sql As String = "UPDATE PRODUCT_t SET " & _
                               "Product_Description = @desc, " & _
                               "Product_Finish = @finish, " & _
                               "Product_Line_Id = @lineId, " & _
                               "Standard_Price = @price " & _
                               "WHERE Product_Id = @id"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@desc", txtUpdateDesc.Text.Trim())
                cmd.Parameters.AddWithValue("@finish", txtUpdateFinish.Text.Trim())
                cmd.Parameters.AddWithValue("@lineId", Integer.Parse(ddlUpdateLine.SelectedValue))
                cmd.Parameters.AddWithValue("@price", Decimal.Parse(txtUpdatePrice.Text.Trim()))
                cmd.Parameters.AddWithValue("@id", Integer.Parse(txtUpdateID.Text.Trim()))

                Try
                    conn.Open()
                    Dim rows As Integer = cmd.ExecuteNonQuery()
                    If rows > 0 Then
                        lblUpdateMessage.Text = "Product #" & txtUpdateID.Text & " updated successfully."
                        lblUpdateMessage.ForeColor = System.Drawing.Color.Green
                    Else
                        lblUpdateMessage.Text = "No product found with ID: " & txtUpdateID.Text
                        lblUpdateMessage.ForeColor = System.Drawing.Color.Red
                    End If
                Catch ex As Exception
                    lblUpdateMessage.Text = "Update Error: " & ex.Message
                    lblUpdateMessage.ForeColor = System.Drawing.Color.Red
                End Try
            End Using
        End Using
        lblUpdateMessage.Visible = True
        LoadCatalog()
    End Sub

    Protected Sub btnReset_Click(ByVal sender As Object, ByVal e As EventArgs)
        txtProductName.Text = ""
        txtFinish.Text = ""
        txtUnitPrice.Text = ""
        ddlProductLine.SelectedIndex = 0
        lblMessage.Visible = False
    End Sub

    Protected Sub gvCatalog_RowDeleting(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs)
        Try
            Dim productId As Integer = Integer.Parse(gvCatalog.DataKeys(e.RowIndex).Value.ToString())
            Using conn As New SqlConnection(ConnStr)
                Dim sql As String = "DELETE FROM PRODUCT_t WHERE Product_Id = @id"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@id", productId)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            LoadCatalog()
        Catch ex As Exception
            lblMessage.Text = "Delete error: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
            lblMessage.Visible = True
        End Try
    End Sub

    Protected Sub gvCatalog_RowEditing(ByVal sender As Object, ByVal e As GridViewEditEventArgs)
        gvCatalog.EditIndex = e.NewEditIndex
        LoadCatalog()
    End Sub

    Protected Sub gvCatalog_RowCancelingEdit(ByVal sender As Object, ByVal e As GridViewCancelEditEventArgs)
        gvCatalog.EditIndex = -1
        LoadCatalog()
    End Sub

    Protected Sub gvCatalog_RowUpdating(ByVal sender As Object, ByVal e As GridViewUpdateEventArgs)
        Try
            Dim productId As Integer = Integer.Parse(gvCatalog.DataKeys(e.RowIndex).Value.ToString())
            Dim row As GridViewRow = gvCatalog.Rows(e.RowIndex)

            Dim desc As String = DirectCast(row.Cells(1).Controls(0), TextBox).Text.Trim()
            Dim lineId As String = DirectCast(row.Cells(2).Controls(0), TextBox).Text.Trim()
            Dim finish As String = DirectCast(row.Cells(3).Controls(0), TextBox).Text.Trim()
            Dim price As String = DirectCast(row.Cells(4).Controls(0), TextBox).Text.Trim()

            Using conn As New SqlConnection(ConnStr)
                Dim sql As String = "UPDATE PRODUCT_t SET Product_Description = @desc, Product_Line_Id = @lineId, " &
                                   "Product_Finish = @finish, Standard_Price = @price WHERE Product_Id = @id"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@desc", desc)
                    cmd.Parameters.AddWithValue("@lineId", Integer.Parse(lineId))
                    cmd.Parameters.AddWithValue("@finish", finish)
                    cmd.Parameters.AddWithValue("@price", Decimal.Parse(price))
                    cmd.Parameters.AddWithValue("@id", productId)

                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            gvCatalog.EditIndex = -1
            LoadCatalog()
        Catch ex As Exception
            lblMessage.Text = "Update error: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
            lblMessage.Visible = True
        End Try
    End Sub
End Class
