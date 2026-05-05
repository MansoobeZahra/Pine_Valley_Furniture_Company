Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class Login
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        Dim username = txtUsername.Text.Trim()
        Dim password = txtPassword.Text.Trim()

        If username = "" Or password = "" Then
            pnlError.Visible = True
            litError.Text = "Enter both fields."
            Return
        End If

        Try
            Dim dt As New DataTable()
            Using conn As New SqlConnection(connStr)
                Dim sql As String = "SELECT UserID, FullName, Role, IsActive FROM Users2 WHERE Username=@u AND Password=@p"
                Dim cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@u", username)
                cmd.Parameters.AddWithValue("@p", password)
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
            End Using

            If dt.Rows.Count = 0 Then
                pnlError.Visible = True
                litError.Text = "Invalid login."
                Return
            End If

            Dim row = dt.Rows(0)
            If Not CBool(row("IsActive")) Then
                pnlError.Visible = True
                litError.Text = "Account inactive."
                Return
            End If

            Session("UserID") = row("UserID")
            Session("FullName") = row("FullName").ToString()
            Session("Role") = row("Role").ToString()

            Select Case Session("Role").ToString()
                Case "Admin"   : Response.Redirect("Admin_Dashboard.aspx")
                Case "Teacher" : Response.Redirect("Teacher_Dashboard.aspx")
                Case "Student" : Response.Redirect("Student_Dashboard.aspx")
            End Select

        Catch ex As Exception
            pnlError.Visible = True
            litError.Text = "Error: " & ex.Message
        End Try
    End Sub
End Class
