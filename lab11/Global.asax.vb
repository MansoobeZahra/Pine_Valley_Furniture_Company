Imports System
Imports System.Web

Public Class GlobalApplication
    Inherits System.Web.HttpApplication

    ' ---------------------------------------------------------------
    ' APPLICATION START: runs once when app first loads
    ' ---------------------------------------------------------------
    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        Application("AppStartTime") = DateTime.Now
        Application("TotalSessions") = 0
    End Sub

    ' ---------------------------------------------------------------
    ' SESSION START: runs every time a NEW user visits the site
    ' Initializes all session variables to safe defaults
    ' ---------------------------------------------------------------
    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Track total sessions
        Application.Lock()
        Application("TotalSessions") = CInt(Application("TotalSessions")) + 1
        Application.UnLock()

        ' Initialize session variables with defaults
        Session("Username")     = Nothing
        Session("UserId")       = Nothing
        Session("UserRole")     = Nothing
        Session("CustomerID")   = Nothing
        Session("Cart")         = Nothing
        Session("LoginTime")    = Nothing
    End Sub

    ' ---------------------------------------------------------------
    ' SESSION END: runs when session times out OR Session.Clear() called
    ' Timeout configured in Web.config: 30 minutes
    ' ---------------------------------------------------------------
    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Clean up cart data explicitly on session end
        Session("Cart")       = Nothing
        Session("CustomerID") = Nothing
        Session("Username")   = Nothing
        Session("UserRole")   = Nothing
    End Sub

    ' ---------------------------------------------------------------
    ' APPLICATION END: runs when app shuts down
    ' ---------------------------------------------------------------
    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Cleanup if needed
    End Sub

    ' ---------------------------------------------------------------
    ' APPLICATION ERROR: global unhandled error handler
    ' ---------------------------------------------------------------
    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        Dim ex As Exception = Server.GetLastError()
        If ex IsNot Nothing Then
            ' Log to Application state for debugging
            Application("LastError") = ex.Message & " at " & DateTime.Now.ToString()
        End If
    End Sub

End Class
