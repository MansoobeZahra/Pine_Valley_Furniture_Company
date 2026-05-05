Partial Class Navbar
    Inherits System.Web.UI.UserControl

    Public ReadOnly Property SessionRole As String
        Get
            Return If(Session("Role") IsNot Nothing, Session("Role").ToString(), "")
        End Get
    End Property

    Public ReadOnly Property SessionFullName As String
        Get
            Return If(Session("FullName") IsNot Nothing, Session("FullName").ToString(), "Guest")
        End Get
    End Property

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim role = SessionRole
        pnlAdminNav.Visible = (role = "Admin")
        pnlTeacherNav.Visible = (role = "Teacher")
        pnlStudentNav.Visible = (role = "Student")
    End Sub
End Class
