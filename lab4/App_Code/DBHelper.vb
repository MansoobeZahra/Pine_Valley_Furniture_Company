Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient

Public NotInheritable Class DBHelper
    Private Shared ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString
        End Get
    End Property

    ' ---------------------------------------------------------------
    ' ExecuteQuery – returns a DataTable from a SELECT statement
    ' ---------------------------------------------------------------
    Public Shared Function ExecuteQuery(sql As String, Optional parms As SqlParameter() = Nothing) As DataTable
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(sql, conn)
                If parms IsNot Nothing Then
                    cmd.Parameters.AddRange(parms)
                End If

                conn.Open()
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
                Return dt
            End Using
        End Using
    End Function

    ' ---------------------------------------------------------------
    ' ExecuteNonQuery – for INSERT / UPDATE / DELETE
    ' ---------------------------------------------------------------
    Public Shared Function ExecuteNonQuery(sql As String, Optional parms As SqlParameter() = Nothing) As Integer
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(sql, conn)
                If parms IsNot Nothing Then
                    cmd.Parameters.AddRange(parms)
                End If

                conn.Open()
                Return cmd.ExecuteNonQuery()
            End Using
        End Using
    End Function

    ' ---------------------------------------------------------------
    ' ExecuteScalar – returns a single value, e.g. for COUNT/SUM
    ' ---------------------------------------------------------------
    Public Shared Function ExecuteScalar(sql As String, Optional parms As SqlParameter() = Nothing) As Object
        Using conn As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand(sql, conn)
                If parms IsNot Nothing Then
                    cmd.Parameters.AddRange(parms)
                End If

                conn.Open()
                Return cmd.ExecuteScalar()
            End Using
        End Using
    End Function
End Class
