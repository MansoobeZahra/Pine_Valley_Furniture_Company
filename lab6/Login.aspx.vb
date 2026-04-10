Imports System.Data.SqlClient
Imports System.Configuration

Partial Class LoginPage
    Inherits System.Web.UI.Page

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim connString As String = ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString

        Try
            Dim conn As New SqlConnection(connString)
            conn.Open()

            Dim cmd As New SqlCommand
            cmd.Connection = conn
            cmd.CommandText = "SELECT * "
            cmd.CommandText &= "FROM Users "
            cmd.CommandText &= "WHERE Username = '" & txtUser.Text & "' AND User_Password = '" & txtPass.Text & "'"

            Dim reader As SqlDataReader = cmd.ExecuteReader()

            If reader.Read() Then
                Session("UserId")   = reader("UserId").ToString()
                Session("Username") = txtUser.Text
                Session("User_Password") = txtPass.Text
                Session("UserRole") = reader("User_Role").ToString()
                reader.Close()
                conn.Close()
                Response.Redirect("Registration.aspx")
            Else
                reader.Close()
                conn.Close()
                Response.Write("<script>alert('Invalid Credentials');</script>")
            End If

        Catch ex As Exception
            Response.Write("<script>alert('Error: " & ex.Message.Replace("'", "") & "');</script>")
        End Try
    End Sub
End Class
