Imports System

Partial Class HelpPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Session("Username") Is Nothing Then Response.Redirect("Login.aspx?reason=timeout")
        Dim isAdmin As Boolean = (Session("UserRole").ToString().ToLower() = "admin")
        lnkRegistration.Visible = isAdmin
        lnkCatalog.Visible = True
        lnkSegmentation.Visible = isAdmin
        lnkForecasting.Visible = isAdmin
        If Not IsPostBack Then lblWelcome.Text = "Welcome, " & Session("Username") & " (" & Session("UserRole") & ")"
    End Sub

End Class
