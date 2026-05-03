Partial Class Login
    Inherits System.Web.UI.Page

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        Dim username = txtUsername.Text.Trim()
        Dim password = txtPassword.Text.Trim()

        If username = "" Or password = "" Then
            pnlError.Visible = True
            litError.Text = "Enter both fields."
            Return
        End If

        Try
            Dim dt = DBHelper.GetDataTable("SELECT UserID, FullName, Role, IsActive FROM Users2 WHERE Username=@u AND Password=@p",
                DBHelper.Param("@u", username), DBHelper.Param("@p", password))

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
