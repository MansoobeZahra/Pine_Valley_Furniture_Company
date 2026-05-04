Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class Admin_ManageSurveys
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("RoleName") Is Nothing OrElse Session("RoleName").ToString() <> "Survey Administrator" Then
            Response.Redirect("/FEEDBACK/Login.aspx")
        End If
        If Not IsPostBack Then LoadSurveys()
    End Sub

    Private Sub LoadSurveys()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("sp_GetAllSurveys", conn)
            cmd.CommandType = CommandType.StoredProcedure
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            conn.Open()
            da.Fill(dt)
            gvSurveys.DataSource = dt
            gvSurveys.DataBind()
        End Using
    End Sub

    Protected Sub gvSurveys_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim parts = e.CommandArgument.ToString().Split("|")
        Dim sid   As Integer = Integer.Parse(parts(0))
        Dim cur   As Boolean = Boolean.Parse(parts(1))
        Dim newVal As Integer = If(cur, 0, 1)

        Dim col As String = If(e.CommandName = "ToggleAnon", "IsAnonymous", "IsActive")

        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("UPDATE Surveys SET " & col & "=@v WHERE SurveyID=@s", conn)
            cmd.Parameters.AddWithValue("@v", newVal)
            cmd.Parameters.AddWithValue("@s", sid)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using

        pnlMsg.Visible = True
        litMsg.Text = If(e.CommandName = "ToggleAnon",
                         "Survey anonymity setting updated.",
                         "Survey active status updated.")
        LoadSurveys()
    End Sub
End Class

