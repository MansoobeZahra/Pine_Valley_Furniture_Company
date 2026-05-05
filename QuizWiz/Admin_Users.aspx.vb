Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI.WebControls

Partial Class Admin_ManageUsers
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing OrElse Session("Role").ToString() <> "Admin" Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then LoadUsers()
    End Sub

    Private Sub LoadUsers()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim sql = "SELECT UserID, FullName, Username, Role, IsActive FROM Users2"
            If ddlFilter.SelectedValue <> "" Then sql &= " WHERE Role = @r"
            Dim cmd As New SqlCommand(sql, conn)
            If ddlFilter.SelectedValue <> "" Then cmd.Parameters.AddWithValue("@r", ddlFilter.SelectedValue)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        gvUsers.DataSource = dt
        gvUsers.DataBind()
    End Sub

    Protected Sub btnShowAdd_Click(sender As Object, e As EventArgs)
        hfEditID.Value = "0"
        txtFullName.Text = "" : txtUsername.Text = "" : txtPassword.Text = ""
        pnlForm.Visible = True
    End Sub

    Protected Sub btnCancelForm_Click(sender As Object, e As EventArgs)
        pnlForm.Visible = False
    End Sub

    Protected Sub ddlFilter_Changed(sender As Object, e As EventArgs)
        LoadUsers()
    End Sub

    Protected Sub gvUsers_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim uid = CInt(e.CommandArgument)
        If e.CommandName = "ToggleActive" Then
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("UPDATE Users2 SET IsActive = 1 - IsActive WHERE UserID=@id", conn)
                cmd.Parameters.AddWithValue("@id", uid)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
            LoadUsers()
        ElseIf e.CommandName = "EditUser" Then
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("SELECT * FROM Users2 WHERE UserID=@id", conn)
                cmd.Parameters.AddWithValue("@id", uid)
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
            End Using
            If dt.Rows.Count > 0 Then
                Dim row = dt.Rows(0)
                hfEditID.Value = uid.ToString()
                txtFullName.Text = row("FullName").ToString()
                txtUsername.Text = row("Username").ToString()
                ddlRole.SelectedValue = row("Role").ToString()
                pnlForm.Visible = True
            End If
        End If
    End Sub

    Protected Sub btnSaveUser_Click(sender As Object, e As EventArgs)
        Dim editID = CInt(hfEditID.Value)
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand()
            cmd.Connection = conn
            If editID = 0 Then
                cmd.CommandText = "INSERT INTO Users2 (FullName,Username,Password,Role,IsActive) VALUES (@n,@u,@p,@r,1)"
                cmd.Parameters.AddWithValue("@p", txtPassword.Text)
            Else
                cmd.CommandText = "UPDATE Users2 SET FullName=@n,Username=@u,Role=@r WHERE UserID=@id"
                cmd.Parameters.AddWithValue("@id", editID)
            End If
            cmd.Parameters.AddWithValue("@n", txtFullName.Text)
            cmd.Parameters.AddWithValue("@u", txtUsername.Text)
            cmd.Parameters.AddWithValue("@r", ddlRole.SelectedValue)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        pnlForm.Visible = False
        LoadUsers()
    End Sub
End Class
