Public Class DefaultPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If
        Dim role As String = Session("RoleName").ToString()
        Select Case role
            Case "Survey Administrator" : Response.Redirect("~/Admin/Dashboard.aspx")
            Case "Survey Builder"       : Response.Redirect("~/Builder/Dashboard.aspx")
            Case "Surveyor"             : Response.Redirect("~/Surveyor/Dashboard.aspx")
            Case Else                   : Response.Redirect("~/Login.aspx")
        End Select
    End Sub
End Class

