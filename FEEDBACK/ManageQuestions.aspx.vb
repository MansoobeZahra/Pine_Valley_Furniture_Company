Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class ManageQuestions
    Inherits System.Web.UI.Page

    Private _surveyID As Integer = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("RoleName") Is Nothing OrElse Session("RoleName").ToString() <> "Survey Builder" Then
            Response.Redirect("~/Login.aspx")
        End If

        If Not Integer.TryParse(Request.QueryString("sid"), _surveyID) OrElse _surveyID = 0 Then
            Response.Redirect("BuilderDashboard.aspx")
        End If

        If Not IsPostBack Then
            LoadSurveyInfo()
            LoadQuestions()

            If Request.QueryString("new") = "1" Then
                pnlMsg.Visible = True
                litMsg.Text = "Survey created! Now add your questions below."
            End If
        End If
    End Sub

    Private Sub LoadSurveyInfo()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT Title FROM Surveys WHERE SurveyID=@s", conn)
            cmd.Parameters.AddWithValue("@s", _surveyID)
            conn.Open()
            Dim title As Object = cmd.ExecuteScalar()
            If title IsNot Nothing Then
                litSurveyTitle.Text = title.ToString()
            End If
        End Using
    End Sub

    Private Sub LoadQuestions()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT * FROM Questions WHERE SurveyID=@s ORDER BY OrderNo", conn)
            cmd.Parameters.AddWithValue("@s", _surveyID)
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            conn.Open()
            da.Fill(dt)
            
            rptQuestions.DataSource = dt
            rptQuestions.DataBind()
            pnlNoQs.Visible = (dt.Rows.Count = 0)
        End Using
    End Sub

    Protected Sub ddlQType_SelectedIndexChanged(sender As Object, e As EventArgs)
        pnlOptions.Visible = (ddlQType.SelectedValue = "Choice")
    End Sub

    Protected Sub btnAddQ_Click(sender As Object, e As EventArgs)
        If Not Page.IsValid Then Return

        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            conn.Open()
            Dim trans As SqlTransaction = conn.BeginTransaction()
            Try
                ' Get next order number
                Dim orderCmd As New SqlCommand("SELECT ISNULL(MAX(OrderNo),0)+1 FROM Questions WHERE SurveyID=@s", conn, trans)
                orderCmd.Parameters.AddWithValue("@s", _surveyID)
                Dim orderNo As Integer = CInt(orderCmd.ExecuteScalar())

                ' Insert question
                Dim qCmd As New SqlCommand(
                    "INSERT INTO Questions(SurveyID, QuestionText, QuestionType, OrderNo) " &
                    "OUTPUT INSERTED.QuestionID VALUES(@s, @q, @t, @o)", conn, trans)
                qCmd.Parameters.AddWithValue("@s", _surveyID)
                qCmd.Parameters.AddWithValue("@q", txtQText.Text.Trim())
                qCmd.Parameters.AddWithValue("@t", ddlQType.SelectedValue)
                qCmd.Parameters.AddWithValue("@o", orderNo)
                Dim questionID As Integer = CInt(qCmd.ExecuteScalar())

                ' Insert options if Choice
                If ddlQType.SelectedValue = "Choice" AndAlso Not String.IsNullOrEmpty(txtOptions.Text) Then
                    Dim lines As String() = txtOptions.Text.Split(New String() {Environment.NewLine, "\n"}, StringSplitOptions.RemoveEmptyEntries)
                    For i As Integer = 0 To lines.Length - 1
                        Dim optCmd As New SqlCommand("INSERT INTO Options(QuestionID, OptionText, DisplayOrder) VALUES(@q, @t, @o)", conn, trans)
                        optCmd.Parameters.AddWithValue("@q", questionID)
                        optCmd.Parameters.AddWithValue("@t", lines(i).Trim())
                        optCmd.Parameters.AddWithValue("@o", i + 1)
                        optCmd.ExecuteNonQuery()
                    Next
                End If

                trans.Commit()
                
                txtQText.Text = ""
                txtOptions.Text = ""
                ddlQType.SelectedIndex = 0
                pnlOptions.Visible = False
                pnlMsg.Visible = True
                litMsg.Text = "Question added successfully!"
                LoadQuestions()
            Catch ex As Exception
                trans.Rollback()
                ' Handle error if needed (e.g. show in pnlMsg with red style)
                pnlMsg.Visible = True
                litMsg.Text = "Error: " & ex.Message
            End Try
        End Using
    End Sub

    Protected Sub rptQuestions_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        If e.CommandName = "DeleteQ" Then
            Dim qID As Integer = CInt(e.CommandArgument)
            Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
            Using conn As New SqlConnection(connStr)
                conn.Open()
                ' Options are deleted via cascade or manually
                Dim delO As New SqlCommand("DELETE FROM Options WHERE QuestionID=@q", conn)
                delO.Parameters.AddWithValue("@q", qID)
                delO.ExecuteNonQuery()

                Dim delQ As New SqlCommand("DELETE FROM Questions WHERE QuestionID=@q", conn)
                delQ.Parameters.AddWithValue("@q", qID)
                delQ.ExecuteNonQuery()
            End Using
            pnlMsg.Visible = True
            litMsg.Text = "Question removed."
            LoadQuestions()
        End If
    End Sub
End Class
