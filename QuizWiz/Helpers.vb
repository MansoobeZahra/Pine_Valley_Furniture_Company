Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI

Public Class DBHelper
    Public Shared Function GetConnection() As SqlConnection
        Return New SqlConnection(ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString)
    End Function

    Public Shared Function ExecuteNonQuery(sql As String, ParamArray params As SqlParameter()) As Integer
        Using conn = GetConnection()
            conn.Open()
            Using cmd As New SqlCommand(sql, conn)
                If params IsNot Nothing Then cmd.Parameters.AddRange(params)
                Return cmd.ExecuteNonQuery()
            End Using
        End Using
    End Function

    Public Shared Function ExecuteScalar(sql As String, ParamArray params As SqlParameter()) As Object
        Using conn = GetConnection()
            conn.Open()
            Using cmd As New SqlCommand(sql, conn)
                If params IsNot Nothing Then cmd.Parameters.AddRange(params)
                Return cmd.ExecuteScalar()
            End Using
        End Using
    End Function

    Public Shared Function GetDataTable(sql As String, ParamArray params As SqlParameter()) As DataTable
        Using conn = GetConnection()
            conn.Open()
            Using cmd As New SqlCommand(sql, conn)
                If params IsNot Nothing Then cmd.Parameters.AddRange(params)
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
                Return dt
            End Using
        End Using
    End Function

    Public Shared Function Param(name As String, value As Object) As SqlParameter
        Return New SqlParameter(name, If(value Is Nothing, DBNull.Value, value))
    End Function
End Class

Public Class AuthHelper
    Public Shared Sub RequireRole(page As Page, ParamArray roles As String())
        If page.Session("UserID") Is Nothing Then
            page.Response.Redirect("Login.aspx")
            Return
        End If
        Dim userRole = page.Session("Role").ToString()
        For Each r In roles
            If r = userRole Then Return
        Next
        page.Response.Redirect("Login.aspx")
    End Sub
End Class
