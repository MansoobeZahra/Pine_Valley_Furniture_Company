Imports System.Web.UI
Imports System.Web.UI.HtmlControls

Public Class Header
    Inherits UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("UserID") IsNot Nothing Then
            ' Show user info in navbar
            userBadge.Visible = True
            btnLogout.Visible = True
            Dim fullName As String = Session("FullName").ToString()
            Dim roleName As String = Session("RoleName").ToString()
            userNameSpan.InnerText = fullName
            roleSpan.InnerText = roleName
            avatarDiv.InnerText = fullName.Substring(0, 1).ToUpper()

            ' Build nav links by role
            navMenu.InnerHtml = BuildNav(roleName)
        Else
            userBadge.Visible = False
            btnLogout.Visible = False
        End If
    End Sub

    Private Function BuildNav(role As String) As String
        Dim sb As New System.Text.StringBuilder()
        ' Adjust paths to be absolute from root if necessary, or relative
        Select Case role
            Case "Survey Administrator"
                sb.Append("<a href='/FEEDBACK/Admin/Dashboard.aspx'><span></span><span>Dashboard</span></a>")
                sb.Append("<a href='/FEEDBACK/Admin/ManageUsers.aspx'><span></span><span>Users</span></a>")
                sb.Append("<a href='/FEEDBACK/Admin/ManageSurveys.aspx'><span></span><span>Surveys</span></a>")
                sb.Append("<a href='/FEEDBACK/Results/SurveyResults.aspx'><span></span><span>Results</span></a>")
            Case "Survey Builder"
                sb.Append("<a href='/FEEDBACK/Builder/Dashboard.aspx'><span></span><span>Dashboard</span></a>")
                sb.Append("<a href='/FEEDBACK/Builder/CreateSurvey.aspx'><span>+</span><span>New Survey</span></a>")
                sb.Append("<a href='/FEEDBACK/Results/SurveyResults.aspx'><span></span><span>Results</span></a>")
            Case "Surveyor"
                sb.Append("<a href='/FEEDBACK/Surveyor/Dashboard.aspx'><span></span><span>Dashboard</span></a>")
        End Select
        Return sb.ToString()
    End Function

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("~/FEEDBACK/Login.aspx")
    End Sub
End Class
