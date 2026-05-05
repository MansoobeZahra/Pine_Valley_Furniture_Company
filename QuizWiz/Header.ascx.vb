Partial Class Header
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
End Class
