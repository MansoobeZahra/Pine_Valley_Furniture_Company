Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls

Public Class Surveyor_TakeSurvey
    Inherits System.Web.UI.Page

    Private _surveyID As Integer = 0
    Private _questions As DataTable = Nothing

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("RoleName") Is Nothing OrElse Session("RoleName").ToString() <> "Surveyor" Then
            Response.Redirect("/FEEDBACK/Login.aspx")
        End If

        If Not Integer.TryParse(Request.QueryString("sid"), _surveyID) OrElse _surveyID = 0 Then
            Response.Redirect("Dashboard.aspx")
        End If

        If Not IsPostBack Then
            LoadSurvey()
        End If
    End Sub

    Private Sub LoadSurvey()
        Dim uid As Integer = CInt(Session("UserID"))
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' Check survey exists and is active
            Dim infoCmd As New SqlCommand(
                "SELECT Title, Description, IsAnonymous FROM Surveys WHERE SurveyID=@s AND IsActive=1", conn)
            infoCmd.Parameters.AddWithValue("@s", _surveyID)
            Using dr As SqlDataReader = infoCmd.ExecuteReader()
                If Not dr.Read() Then
                    pnlError.Visible = True
                    litError.Text = "Survey not found or is no longer active."
                    pnlSurvey.Visible = False
                    Return
                End If
                surveyTitle.InnerText = dr("Title").ToString()
                surveyDesc.InnerText  = If(IsDBNull(dr("Description")), "", dr("Description").ToString())
                anonBadge.InnerText   = If(CBool(dr("IsAnonymous")), " Anonymous Survey", " Identified Survey")
                lnkResults2.HRef = "../Results/SurveyResults.aspx?sid=" & _surveyID
            End Using

            ' Check already taken
            Dim takenCmd As New SqlCommand(
                "SELECT COUNT(*) FROM Responses WHERE SurveyID=@s AND UserID=@u", conn)
            takenCmd.Parameters.AddWithValue("@s", _surveyID)
            takenCmd.Parameters.AddWithValue("@u", uid)
            If CInt(takenCmd.ExecuteScalar()) > 0 Then
                pnlSurvey.Visible     = False
                pnlAlreadyDone.Visible = True
                Return
            End If

            ' Load questions
            Dim qCmd As New SqlCommand("sp_GetSurveyQuestions", conn)
            qCmd.CommandType = CommandType.StoredProcedure
            qCmd.Parameters.AddWithValue("@SurveyID", _surveyID)
            Dim da As New SqlDataAdapter(qCmd)
            _questions = New DataTable()
            da.Fill(_questions)
        End Using

        RenderQuestions()
    End Sub

    Private Sub RenderQuestions()
        If _questions Is Nothing OrElse _questions.Rows.Count = 0 Then
            pnlError.Visible = True
            litError.Text = "This survey has no questions yet."
            pnlSurvey.Visible = False
            Return
        End If

        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Dim qNum As Integer = 0

        For Each row As DataRow In _questions.Rows
            qNum += 1
            Dim qID   As Integer = CInt(row("QuestionID"))
            Dim qText As String  = row("QuestionText").ToString()
            Dim qType As String  = row("QuestionType").ToString()

            ' Outer block
            Dim block As New HtmlGenericControl("div")
            block.Attributes("class") = "question-block"
            block.Attributes("data-qid") = qID.ToString()

            ' Header
            Dim header As New HtmlGenericControl("div")
            header.Attributes("class") = "question-block-header"
            Dim numBadge As New HtmlGenericControl("div")
            numBadge.Attributes("class") = "results-q-header q-num"
            numBadge.InnerText = qNum.ToString()
            Dim typeBadge As New HtmlGenericControl("span")
            typeBadge.Attributes("class") = If(qType = "MCQ", "badge badge-blue", "badge badge-orange")
            typeBadge.InnerText = If(qType = "MCQ", "Multiple Choice", "True / False")
            Dim qTextEl As New HtmlGenericControl("span")
            qTextEl.Attributes("style") = "font-weight:600;font-size:.95rem;"
            qTextEl.InnerText = qText
            header.Controls.Add(numBadge)
            header.Controls.Add(typeBadge)
            header.Controls.Add(qTextEl)
            block.Controls.Add(header)

            ' Body with radio options
            Dim body As New HtmlGenericControl("div")
            body.Attributes("class") = "question-block-body"

            ' Get options
            Using conn As New SqlConnection(connStr)
                Dim optCmd As New SqlCommand("sp_GetQuestionOptions", conn)
                optCmd.CommandType = CommandType.StoredProcedure
                optCmd.Parameters.AddWithValue("@QuestionID", qID)
                Dim optDA As New SqlDataAdapter(optCmd)
                Dim optDT As New DataTable()
                conn.Open()
                optDA.Fill(optDT)

                For Each optRow As DataRow In optDT.Rows
                    Dim optID   As Integer = CInt(optRow("OptionID"))
                    Dim optText As String  = optRow("OptionText").ToString()

                    Dim label As New HtmlGenericControl("label")
                    label.Attributes("class") = "answer-option"

                    Dim radio As New HtmlInputRadioButton()
                    radio.Name  = "q_" & qID.ToString()
                    radio.Value = optID.ToString()
                    radio.Attributes("style") = "margin:0;"

                    Dim span As New HtmlGenericControl("span")
                    span.InnerText = optText

                    label.Controls.Add(radio)
                    label.Controls.Add(span)
                    body.Controls.Add(label)
                Next
            End Using

            block.Controls.Add(body)
            phQuestions.Controls.Add(block)
        Next
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        Dim uid As Integer = CInt(Session("UserID"))
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString

        Try
            Using conn As New SqlConnection(connStr)
                conn.Open()

                ' Get survey anonymity setting
                Dim anonCmd As New SqlCommand("SELECT IsAnonymous FROM Surveys WHERE SurveyID=@s", conn)
                anonCmd.Parameters.AddWithValue("@s", _surveyID)
                Dim isAnon As Boolean = CBool(anonCmd.ExecuteScalar())

                ' Create response record
                Dim respCmd As New SqlCommand(
                    "INSERT INTO Responses(SurveyID, UserID) OUTPUT INSERTED.ResponseID VALUES(@s,@u)", conn)
                respCmd.Parameters.AddWithValue("@s", _surveyID)
                respCmd.Parameters.AddWithValue("@u", If(isAnon, CObj(DBNull.Value), CObj(uid)))
                Dim responseID As Integer = CInt(respCmd.ExecuteScalar())

                ' Load questions to iterate
                Dim qCmd As New SqlCommand("sp_GetSurveyQuestions", conn)
                qCmd.CommandType = CommandType.StoredProcedure
                qCmd.Parameters.AddWithValue("@SurveyID", _surveyID)
                Dim da As New SqlDataAdapter(qCmd)
                Dim dt As New DataTable()
                da.Fill(dt)

                ' Save each answer
                For Each row As DataRow In dt.Rows
                    Dim qID    As Integer = CInt(row("QuestionID"))
                    Dim answer As String  = Request.Form("q_" & qID.ToString())
                    If Not String.IsNullOrEmpty(answer) Then
                        Dim ansCmd As New SqlCommand(
                            "INSERT INTO ResponseAnswers(ResponseID,QuestionID,OptionID) VALUES(@r,@q,@o)", conn)
                        ansCmd.Parameters.AddWithValue("@r", responseID)
                        ansCmd.Parameters.AddWithValue("@q", qID)
                        ansCmd.Parameters.AddWithValue("@o", Integer.Parse(answer))
                        ansCmd.ExecuteNonQuery()
                    End If
                Next
            End Using

            Response.Redirect("Dashboard.aspx?done=1")
        Catch ex As Exception
            pnlError.Visible = True
            litError.Text = "Error submitting survey: " & ex.Message
        End Try
    End Sub
End Class

