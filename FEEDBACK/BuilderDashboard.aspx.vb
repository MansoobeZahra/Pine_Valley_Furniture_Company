Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class BuilderDashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("RoleName") Is Nothing OrElse Session("RoleName").ToString() <> "Survey Builder" Then
            Response.Redirect("~/Login.aspx")
        End If
        If Not IsPostBack Then LoadData()
    End Sub

    Private Sub LoadData()
        Dim uid As Integer = CInt(Session("UserID"))
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            conn.Open()

            litMySurveys.Text   = GetScalar(conn, "SELECT COUNT(*) FROM Surveys WHERE CreatedBy=" & uid)
            litMyQuestions.Text = GetScalar(conn, "SELECT COUNT(*) FROM Questions q INNER JOIN Surveys s ON q.SurveyID=s.SurveyID WHERE s.CreatedBy=" & uid)
            litMyResponses.Text = GetScalar(conn, "SELECT COUNT(*) FROM Responses r INNER JOIN Surveys s ON r.SurveyID=s.SurveyID WHERE s.CreatedBy=" & uid)

            Dim cmd As New SqlCommand("sp_GetSurveysByBuilder", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@BuilderID", uid)
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            da.Fill(dt)
            gvSurveys.DataSource = dt
            gvSurveys.DataBind()
        End Using
    End Sub

    Private Function GetScalar(conn As SqlConnection, sql As String) As String
        Return New SqlCommand(sql, conn).ExecuteScalar().ToString()
    End Function
End Class



