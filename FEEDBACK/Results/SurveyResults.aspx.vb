Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI.HtmlControls

Public Class Results_SurveyResults
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing Then Response.Redirect("~/Login.aspx")

        If Not IsPostBack Then
            PopulateSurveyDropdown()

            ' Auto-load if sid param passed
            Dim sid As Integer
            If Integer.TryParse(Request.QueryString("sid"), sid) AndAlso sid > 0 Then
                ' Find and select the item
                Dim item As ListItem = ddlSurvey.Items.FindByValue(sid.ToString())
                If item IsNot Nothing Then
                    ddlSurvey.SelectedValue = sid.ToString()
                    LoadResults(sid)
                End If
            End If
        End If
    End Sub

    Private Sub PopulateSurveyDropdown()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Dim role As String = Session("RoleName").ToString()
        Dim uid  As Integer = CInt(Session("UserID"))

        Using conn As New SqlConnection(connStr)
            Dim sql As String
            If role = "Survey Builder" Then
                sql = "SELECT SurveyID, Title FROM Surveys WHERE CreatedBy=@u ORDER BY CreatedDate DESC"
            Else
                sql = "SELECT SurveyID, Title FROM Surveys ORDER BY CreatedDate DESC"
            End If
            Dim cmd As New SqlCommand(sql, conn)
            If role = "Survey Builder" Then cmd.Parameters.AddWithValue("@u", uid)
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            conn.Open()
            da.Fill(dt)
            ddlSurvey.DataSource     = dt
            ddlSurvey.DataTextField  = "Title"
            ddlSurvey.DataValueField = "SurveyID"
            ddlSurvey.DataBind()
            ddlSurvey.Items.Insert(0, New System.Web.UI.WebControls.ListItem("-- Select a Survey --", "0"))
        End Using
    End Sub

    Protected Sub btnLoad_Click(sender As Object, e As EventArgs)
        Dim sid As Integer
        If Integer.TryParse(ddlSurvey.SelectedValue, sid) AndAlso sid > 0 Then
            LoadResults(sid)
        End If
    End Sub

    Private Sub LoadResults(surveyID As Integer)
        pnlResults.Visible = True
        phResults.Controls.Clear()

        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' Survey meta
            Dim metaCmd As New SqlCommand(
                "SELECT Title, IsAnonymous, " &
                "(SELECT COUNT(*) FROM Responses WHERE SurveyID=@s) AS TotalResp, " &
                "(SELECT COUNT(*) FROM Questions WHERE SurveyID=@s) AS TotalQ " &
                "FROM Surveys WHERE SurveyID=@s", conn)
            metaCmd.Parameters.AddWithValue("@s", surveyID)
            Using dr As SqlDataReader = metaCmd.ExecuteReader()
                If dr.Read() Then
                    litTotalResp.Text = dr("TotalResp").ToString()
                    litTotalQ.Text    = dr("TotalQ").ToString()
                    litAnonMode.Text  = If(CBool(dr("IsAnonymous")), "Anonymous", "Identified")
                    If CInt(dr("TotalResp")) = 0 Then
                        pnlNoData.Visible = True
                        Return
                    End If
                End If
            End Using

            ' Results per question/option
            Dim resCmd As New SqlCommand("sp_GetSurveyResults", conn)
            resCmd.CommandType = CommandType.StoredProcedure
            resCmd.Parameters.AddWithValue("@SurveyID", surveyID)
            Dim da As New SqlDataAdapter(resCmd)
            Dim dt As New DataTable()
            da.Fill(dt)

            If dt.Rows.Count = 0 Then
                pnlNoData.Visible = True
                Return
            End If

            ' Group by question
            Dim questions As New Dictionary(Of Integer, DataRow())
            Dim questionOrder As New List(Of Integer)
            For Each row As DataRow In dt.Rows
                Dim qid As Integer = CInt(row("QuestionID"))
                If Not questions.ContainsKey(qid) Then
                    questions(qid) = Array.Empty(Of DataRow)()
                    questionOrder.Add(qid)
                End If
                Dim arr = questions(qid)
                Array.Resize(arr, arr.Length + 1)
                arr(arr.Length - 1) = row
                questions(qid) = arr
            Next

            Dim qNum As Integer = 0
            For Each qid As Integer In questionOrder
                qNum += 1
                Dim rows() As DataRow = questions(qid)
                Dim firstRow As DataRow = rows(0)

                ' Calculate total answers for this question
                Dim totalAns As Integer = 0
                For Each r As DataRow In rows
                    totalAns += CInt(r("AnswerCount"))
                Next

                ' Build block
                Dim block As New HtmlGenericControl("div")
                block.Attributes("class") = "results-question-block"

                ' Header
                Dim hdr As New HtmlGenericControl("div")
                hdr.Attributes("class") = "results-q-header"
                Dim numEl As New HtmlGenericControl("div")
                numEl.Attributes("class") = "q-num"
                numEl.InnerText = qNum.ToString()
                Dim typeEl As New HtmlGenericControl("span")
                typeEl.Attributes("class") = If(firstRow("QuestionType").ToString() = "MCQ", "badge badge-blue", "badge badge-orange")
                typeEl.InnerText = If(firstRow("QuestionType").ToString() = "MCQ", "MCQ", "True/False")
                Dim textEl As New HtmlGenericControl("span")
                textEl.Attributes("class") = "q-text"
                textEl.InnerText = firstRow("QuestionText").ToString()
                hdr.Controls.Add(numEl)
                hdr.Controls.Add(typeEl)
                hdr.Controls.Add(textEl)
                block.Controls.Add(hdr)

                ' Body
                Dim body As New HtmlGenericControl("div")
                body.Attributes("class") = "results-q-body"

                For Each r As DataRow In rows
                    Dim optText  As String  = r("OptionText").ToString()
                    Dim optCount As Integer = CInt(r("AnswerCount"))
                    Dim pct As Double = If(totalAns > 0, Math.Round(optCount / totalAns * 100, 1), 0)

                    Dim optRow As New HtmlGenericControl("div")
                    optRow.Attributes("class") = "result-option-row"

                    Dim labelDiv As New HtmlGenericControl("div")
                    labelDiv.Attributes("class") = "result-option-label"
                    Dim nameSpan As New HtmlGenericControl("span")
                    nameSpan.Attributes("class") = "opt-name"
                    nameSpan.InnerText = optText
                    Dim countSpan As New HtmlGenericControl("span")
                    countSpan.Attributes("class") = "opt-count"
                    countSpan.InnerText = optCount.ToString() & " votes (" & pct.ToString() & "%)"
                    labelDiv.Controls.Add(nameSpan)
                    labelDiv.Controls.Add(countSpan)

                    Dim barBg As New HtmlGenericControl("div")
                    barBg.Attributes("class") = "result-bar-bg"
                    Dim barFill As New HtmlGenericControl("div")
                    barFill.Attributes("class") = "result-bar-fill"
                    barFill.Attributes("style") = "width:" & pct.ToString() & "%;"
                    barBg.Controls.Add(barFill)

                    optRow.Controls.Add(labelDiv)
                    optRow.Controls.Add(barBg)
                    body.Controls.Add(optRow)
                Next

                block.Controls.Add(body)
                phResults.Controls.Add(block)
            Next
        End Using
    End Sub
End Class

