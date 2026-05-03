Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI

' Helper classes moved here to remove App_Code folder
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

Partial Class MasterPage
    Inherits System.Web.UI.MasterPage

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
        If Session("UserID") Is Nothing AndAlso Not Request.Url.AbsolutePath.EndsWith("Login.aspx") Then
            Response.Redirect("Login.aspx")
            Return
        End If
        Dim role = SessionRole
        pnlAdminNav.Visible = (role = "Admin")
        pnlTeacherNav.Visible = (role = "Teacher")
        pnlStudentNav.Visible = (role = "Student")
    End Sub
End Class
