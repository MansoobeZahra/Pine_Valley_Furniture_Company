Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class AdminDashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("RoleName") Is Nothing OrElse Session("RoleName").ToString() <> "Survey Administrator" Then
            Response.Redirect("~/Login.aspx")
        End If
        If Not IsPostBack Then LoadStats()
    End Sub

    Private Sub LoadStats()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            conn.Open()
            litTotalUsers.Text     = GetScalar(conn, "SELECT COUNT(*) FROM UsersSurvey")
            litTotalSurveys.Text   = GetScalar(conn, "SELECT COUNT(*) FROM Surveys")
            litTotalResponses.Text = GetScalar(conn, "SELECT COUNT(*) FROM Responses")
            litActiveSurveys.Text  = GetScalar(conn, "SELECT COUNT(*) FROM Surveys WHERE IsActive=1")

            Dim cmd As New SqlCommand("sp_GetAllSurveys", conn)
            cmd.CommandType = CommandType.StoredProcedure
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            da.Fill(dt)
            If dt.Rows.Count > 0 Then
                gvSurveys.DataSource = dt.AsEnumerable().Take(10).CopyToDataTable()
                gvSurveys.DataBind()
            End If
        End Using
    End Sub

    Private Function GetScalar(conn As SqlConnection, sql As String) As String
        Dim cmd As New SqlCommand(sql, conn)
        Return cmd.ExecuteScalar().ToString()
    End Function
End Class



