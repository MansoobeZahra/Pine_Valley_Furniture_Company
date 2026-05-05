Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class Register
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Already logged in -> redirect
        If Session("UserID") IsNot Nothing Then
            Response.Redirect("~/Default.aspx")
        End If
    End Sub

    Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then Return

        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Try
            Using conn As New SqlConnection(connStr)
                conn.Open()
                ' Check duplicate username / email
                Dim chkCmd As New SqlCommand(
                    "SELECT COUNT(*) FROM UsersSurvey WHERE Username=@u OR Email=@e", conn)
                chkCmd.Parameters.AddWithValue("@u", txtUsername.Text.Trim())
                chkCmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim())
                Dim dup As Integer = CInt(chkCmd.ExecuteScalar())
                If dup > 0 Then
                    pnlError.Visible = True
                    litError.Text = "Username or email already exists."
                    Return
                End If

                Dim insCmd As New SqlCommand(
                    "INSERT INTO UsersSurvey(Username,PasswordHash,FullName,Email,RoleID) VALUES(@u,@p,@f,@e,@r)", conn)
                insCmd.Parameters.AddWithValue("@u", txtUsername.Text.Trim())
                insCmd.Parameters.AddWithValue("@p", txtPassword.Text.Trim())
                insCmd.Parameters.AddWithValue("@f", txtFullName.Text.Trim())
                insCmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim())
                insCmd.Parameters.AddWithValue("@r", Integer.Parse(ddlRole.SelectedValue))
                insCmd.ExecuteNonQuery()
            End Using
            Response.Redirect("~/Login.aspx?registered=1")
        Catch ex As Exception
            pnlError.Visible = True
            litError.Text = "Error: " & ex.Message
        End Try
    End Sub
End Class

