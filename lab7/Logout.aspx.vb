Partial Class LogoutPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub
End Class
