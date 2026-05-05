Imports System.Web.Security

Public Class Global_asax
    Inherits System.Web.HttpApplication

    Sub Application_Start(sender As Object, e As EventArgs)
        ' Application start event
    End Sub

    Sub Application_End(sender As Object, e As EventArgs)
        ' Application end event
    End Sub

    Sub Application_Error(sender As Object, e As EventArgs)
        ' Global error handler
        Dim ex As Exception = Server.GetLastError()
        ' Log or redirect to error page
    End Sub

    Sub Session_Start(sender As Object, e As EventArgs)
        ' Session start event
    End Sub

    Sub Session_End(sender As Object, e As EventArgs)
        ' Session end event
    End Sub

End Class

