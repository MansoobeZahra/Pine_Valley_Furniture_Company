Partial Class Sidebar
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim role = If(Session("Role") IsNot Nothing, Session("Role").ToString(), "")
        pnlAdminNav.Visible = (role = "Admin")
        pnlTeacherNav.Visible = (role = "Teacher")
        pnlStudentNav.Visible = (role = "Student")
    End Sub
End Class
