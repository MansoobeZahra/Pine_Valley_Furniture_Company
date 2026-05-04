Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class Surveyor_Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("RoleName") Is Nothing OrElse Session("RoleName").ToString() <> "Surveyor" Then
            Response.Redirect("/FEEDBACK/Login.aspx")
        End If
        If Not IsPostBack Then
            If Request.QueryString("done") = "1" Then
                pnlMsg.Visible = True
                litMsg.Text = "Survey submitted successfully! Thank you for your feedback."
            End If
            LoadSurveys()
        End If
    End Sub

    Private Sub LoadSurveys()
        Dim uid As Integer = CInt(Session("UserID"))
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("sp_GetActiveSurveys", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@SurveyorID", uid)
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            conn.Open()
            da.Fill(dt)
            If dt.Rows.Count = 0 Then
                pnlEmpty.Visible = True
            Else
                rptSurveys.DataSource = dt
                rptSurveys.DataBind()
            End If
        End Using
    End Sub
End Class

