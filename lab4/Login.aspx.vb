Imports System.Data.SqlClient
Imports System.Configuration

Partial Class LoginPage
    Inherits System.Web.UI.Page

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString
        Dim conn As New SqlConnection(connStr)
        
        ' Teacher Style: String concatenation for SQL
        Dim sql As String = "SELECT * FROM USERS_t WHERE Username = '" & txtUsername.Text & "' AND Password = '" & txtPassword.Text & "'"
        Dim cmd As New SqlCommand(sql, conn)
        
        Try
            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            
            If reader.HasRows Then
                Session("User") = txtUsername.Text
                Response.Redirect("Default.aspx")
            Else
                lblMessage.Text = "Invalid username or password."
                lblMessage.Visible = True
            End If
            
            reader.Close()
        Catch ex As Exception
            lblMessage.Text = "Error: " & ex.Message
            lblMessage.Visible = True
        Finally
            conn.Close()
        End Try
    End Sub
End Class
