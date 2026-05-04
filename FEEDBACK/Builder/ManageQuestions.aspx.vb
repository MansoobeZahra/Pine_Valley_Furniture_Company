Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class Builder_ManageQuestions
    Inherits System.Web.UI.Page

    Private _surveyID As Integer = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("RoleName") Is Nothing OrElse Session("RoleName").ToString() <> "Survey Builder" Then
            Response.Redirect("/FEEDBACK/Login.aspx")
        End If

        If Not Integer.TryParse(Request.QueryString("sid"), _surveyID) OrElse _surveyID = 0 Then
            Response.Redirect("Dashboard.aspx")
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
                surveyTitleP.InnerText = "Survey: " & title.ToString()
            End If
        End Using
        lnkResults.HRef = "../Results/SurveyResults.aspx?sid=" & _surveyID
    End Sub

    Private Sub LoadQuestions()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("sp_GetSurveyQuestions", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@SurveyID", _surveyID)
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            conn.Open()
            da.Fill(dt)
            litQCount.Text = dt.Rows.Count.ToString()
            rptQuestions.DataSource = dt
            rptQuestions.DataBind()
        End Using
    End Sub

    ' Called from nested repeater in markup
    Public Function GetOptions(questionID As Integer) As DataTable
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("sp_GetQuestionOptions", conn)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@QuestionID", questionID)
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            conn.Open()
            da.Fill(dt)
            Return dt
        End Using
    End Function

    Protected Sub ddlType_Changed(sender As Object, e As EventArgs)
        pnlMCQ.Visible    = (ddlType.SelectedValue = "MCQ")
        pnlTF.Visible     = (ddlType.SelectedValue = "TrueFalse")
        rfvOpt1.Enabled   = (ddlType.SelectedValue = "MCQ")
        rfvOpt2.Enabled   = (ddlType.SelectedValue = "MCQ")
    End Sub

    Protected Sub btnAddQuestion_Click(sender As Object, e As EventArgs)
        If Not Page.IsValid Then Return

        Dim qType As String = ddlType.SelectedValue
        If String.IsNullOrEmpty(qType) Then
            pnlError.Visible = True
            litError.Text = "Please select a question type."
            Return
        End If

        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Try
            Using conn As New SqlConnection(connStr)
                conn.Open()

                ' Get next order number
                Dim orderCmd As New SqlCommand("SELECT ISNULL(MAX(OrderNo),0)+1 FROM Questions WHERE SurveyID=@s", conn)
                orderCmd.Parameters.AddWithValue("@s", _surveyID)
                Dim orderNo As Integer = CInt(orderCmd.ExecuteScalar())

                ' Insert question
                Dim qCmd As New SqlCommand(
                    "INSERT INTO Questions(SurveyID,QuestionText,QuestionType,OrderNo) " &
                    "OUTPUT INSERTED.QuestionID VALUES(@s,@q,@t,@o)", conn)
                qCmd.Parameters.AddWithValue("@s", _surveyID)
                qCmd.Parameters.AddWithValue("@q", txtQuestion.Text.Trim())
                qCmd.Parameters.AddWithValue("@t", qType)
                qCmd.Parameters.AddWithValue("@o", orderNo)
                Dim qID As Integer = CInt(qCmd.ExecuteScalar())

                ' Insert options
                If qType = "TrueFalse" Then
                    InsertOption(conn, qID, "True",  1)
                    InsertOption(conn, qID, "False", 2)
                ElseIf qType = "MCQ" Then
                    Dim dispOrder As Integer = 1
                    Dim opts As String() = {txtOpt1.Text.Trim(), txtOpt2.Text.Trim(),
                                            txtOpt3.Text.Trim(), txtOpt4.Text.Trim()}
                    For Each opt In opts
                        If Not String.IsNullOrEmpty(opt) Then
                            InsertOption(conn, qID, opt, dispOrder)
                            dispOrder += 1
                        End If
                    Next
                End If
            End Using

            ' Reset form
            txtQuestion.Text = ""
            ddlType.SelectedIndex = 0
            pnlMCQ.Visible = False
            pnlTF.Visible  = False
            txtOpt1.Text = "" : txtOpt2.Text = "" : txtOpt3.Text = "" : txtOpt4.Text = ""
            pnlMsg.Visible = True
            litMsg.Text = "Question added successfully!"
            LoadQuestions()
        Catch ex As Exception
            pnlError.Visible = True
            litError.Text = "Error: " & ex.Message
        End Try
    End Sub

    Private Sub InsertOption(conn As SqlConnection, qID As Integer, text As String, order As Integer)
        Dim cmd As New SqlCommand(
            "INSERT INTO Options(QuestionID,OptionText,DisplayOrder) VALUES(@q,@t,@o)", conn)
        cmd.Parameters.AddWithValue("@q", qID)
        cmd.Parameters.AddWithValue("@t", text)
        cmd.Parameters.AddWithValue("@o", order)
        cmd.ExecuteNonQuery()
    End Sub

    Protected Sub rptQuestions_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        If e.CommandName = "Delete" Then
            Dim qID As Integer = CInt(e.CommandArgument)
            Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
            Using conn As New SqlConnection(connStr)
                conn.Open()
                ' Delete answers first
                Dim delA As New SqlCommand("DELETE FROM ResponseAnswers WHERE QuestionID=@q", conn)
                delA.Parameters.AddWithValue("@q", qID)
                delA.ExecuteNonQuery()
                ' Delete options
                Dim delO As New SqlCommand("DELETE FROM Options WHERE QuestionID=@q", conn)
                delO.Parameters.AddWithValue("@q", qID)
                delO.ExecuteNonQuery()
                ' Delete question
                Dim delQ As New SqlCommand("DELETE FROM Questions WHERE QuestionID=@q", conn)
                delQ.Parameters.AddWithValue("@q", qID)
                delQ.ExecuteNonQuery()
            End Using
            pnlMsg.Visible = True
            litMsg.Text = "Question deleted."
            LoadQuestions()
        End If
    End Sub
End Class

