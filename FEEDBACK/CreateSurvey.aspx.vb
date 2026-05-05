Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class CreateSurvey
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("RoleName") Is Nothing OrElse Session("RoleName").ToString() <> "Survey Builder" Then
            Response.Redirect("~/Login.aspx")
        End If
    End Sub

    Protected Sub btnCreate_Click(sender As Object, e As EventArgs)
        If Not Page.IsValid Then Return

        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Try
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand(
                    "INSERT INTO Surveys(Title,Description,CreatedBy,IsActive) " &
                    "OUTPUT INSERTED.SurveyID " &
                    "VALUES(@t,@d,@c,@a)", conn)
                cmd.Parameters.AddWithValue("@t", txtTitle.Text.Trim())
                cmd.Parameters.AddWithValue("@d", If(String.IsNullOrEmpty(txtDescription.Text.Trim()), DBNull.Value, CObj(txtDescription.Text.Trim())))
                cmd.Parameters.AddWithValue("@c", CInt(Session("UserID")))
                cmd.Parameters.AddWithValue("@a", If(chkActive.Checked, 1, 0))
                conn.Open()
                Dim newID As Integer = CInt(cmd.ExecuteScalar())
                Response.Redirect("ManageQuestions.aspx?sid=" & newID & "&new=1")
            End Using
        Catch ex As Exception
            pnlError.Visible = True
            litError.Text = "Error creating survey: " & ex.Message
        End Try
    End Sub
End Class



