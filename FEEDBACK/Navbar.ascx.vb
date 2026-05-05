Public Class Navbar
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("UserID") IsNot Nothing Then
            userBadge.Visible = True
            btnLogout.Visible = True
            Dim fullName As String = Session("FullName").ToString()
            Dim roleName As String = Session("RoleName").ToString()
            userNameSpan.InnerText = fullName
            roleSpan.InnerText = roleName
            avatarDiv.InnerText = fullName.Substring(0, 1).ToUpper()

            navMenu.InnerHtml = BuildNav(roleName)
        Else
            userBadge.Visible = False
            btnLogout.Visible = False
        End If
    End Sub

    Private Function BuildNav(role As String) As String
        Dim sb As New System.Text.StringBuilder()
        Select Case role
            Case "Survey Administrator"
                sb.Append("<a href='" & ResolveUrl("~/AdminDashboard.aspx") & "'><span></span><span>Dashboard</span></a>")
                sb.Append("<a href='" & ResolveUrl("~/ManageUsers.aspx") & "'><span></span><span>Users</span></a>")
                sb.Append("<a href='" & ResolveUrl("~/ManageSurveys.aspx") & "'><span></span><span>Surveys</span></a>")
                sb.Append("<a href='" & ResolveUrl("~/SurveyResults.aspx") & "'><span></span><span>Results</span></a>")
            Case "Survey Builder"
                sb.Append("<a href='" & ResolveUrl("~/BuilderDashboard.aspx") & "'><span></span><span>Dashboard</span></a>")
                sb.Append("<a href='" & ResolveUrl("~/CreateSurvey.aspx") & "'><span>+</span><span>New Survey</span></a>")
                sb.Append("<a href='" & ResolveUrl("~/SurveyResults.aspx") & "'><span></span><span>Results</span></a>")
            Case "Surveyor"
                sb.Append("<a href='" & ResolveUrl("~/SurveyorDashboard.aspx") & "'><span></span><span>Dashboard</span></a>")
        End Select
        Return sb.ToString()
    End Function

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("~/Login.aspx")
    End Sub
End Class


