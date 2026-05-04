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

            If dt Is Nothing Then
                litError.Text = "Error: Database result is null."
                pnlError.Visible = True
                Return
            End If

            If dt.Rows.Count = 0 Then
                pnlError.Visible = True
                litError.Text = "Invalid login."
                Return
            End If

            Dim row = dt.Rows(0)
            If row("IsActive") Is DBNull.Value OrElse Not CBool(row("IsActive")) Then
                pnlError.Visible = True
                litError.Text = "Account inactive."
                Return
            End If

            If Session Is Nothing Then
                litError.Text = "Error: Session is not available."
                pnlError.Visible = True
                Return
            End If

            Session("UserID") = row("UserID")
            Session("FullName") = If(row("FullName") Is DBNull.Value, "User", row("FullName").ToString())
            Session("Role") = If(row("Role") Is DBNull.Value, "Student", row("Role").ToString())

            Response.Redirect(Session("Role").ToString() & "_Dashboard.aspx")

        Catch ex As Exception
            pnlError.Visible = True
            litError.Text = "Error: " & ex.Message & " [Trace: " & ex.StackTrace.Substring(0, Math.Min(ex.StackTrace.Length, 100)) & "]"
        End Try
    End Sub
End Class
