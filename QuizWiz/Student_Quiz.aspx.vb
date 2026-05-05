Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI.WebControls

Partial Class Student_AttemptQuiz
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing OrElse Session("Role").ToString() <> "Student" Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then
            Dim qid = Request.QueryString("quizid")
            If qid = "" Then Response.Redirect("Student_Dashboard.aspx") : Return
            StartQuiz(CInt(qid))
        End If
    End Sub

    Private Sub StartQuiz(qid As Integer)
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT QuizTitle, AllowedTime, TotalQuestions FROM Quiz WHERE QuizID=@q", conn)
            cmd.Parameters.AddWithValue("@q", qid)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using

        If dt.Rows.Count = 0 Then Response.Redirect("Student_Dashboard.aspx") : Return
        Session("QuizID") = qid
        Session("QuizTitle") = dt.Rows(0)("QuizTitle").ToString()
        Session("TimeLeft") = CInt(dt.Rows(0)("AllowedTime")) * 60
        Session("QIndex") = 0
        
        Dim qDt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim sql = "SELECT TOP " & dt.Rows(0)("TotalQuestions").ToString() & " q.QuestionID, q.QuestionStatement, q.OptionA, q.OptionB, q.OptionC, q.OptionD, q.CorrectOptions, q.QuestionType FROM QuizQuestions qq JOIN QuestionsTable q ON qq.QuestionID = q.QuestionID WHERE qq.QuizID=@q"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@q", qid)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(qDt)
        End Using
        Session("Questions") = qDt
        Session("QTotal") = qDt.Rows.Count
        
        pnlQuiz.Visible = True
        ShowQ()
    End Sub

    Private Sub ShowQ()
        Dim idx = CInt(Session("QIndex"))
        Dim dt = CType(Session("Questions"), DataTable)
        If idx >= dt.Rows.Count Then Finish() : Return

        Dim row = dt.Rows(idx)
        Dim qType = row("QuestionType").ToString()
        litQuizTitle.Text = Session("QuizTitle").ToString()
        litQNum.Text = (idx + 1).ToString()
        litQTotal.Text = Session("QTotal").ToString()
        litQuestion.Text = row("QuestionStatement").ToString()
        hfTimeLeft.Value = Session("TimeLeft").ToString()

        pnlRadio.Visible = (qType = "Radio")
        pnlCheckbox.Visible = (qType = "Checkbox")
        pnlParagraph.Visible = (qType = "Paragraph")

        If qType = "Radio" Then
            rblOptions.Items.Clear()
            If row("OptionA").ToString() <> "" Then rblOptions.Items.Add(New ListItem(row("OptionA").ToString(), "A"))
            If row("OptionB").ToString() <> "" Then rblOptions.Items.Add(New ListItem(row("OptionB").ToString(), "B"))
            If row("OptionC").ToString() <> "" Then rblOptions.Items.Add(New ListItem(row("OptionC").ToString(), "C"))
            If row("OptionD").ToString() <> "" Then rblOptions.Items.Add(New ListItem(row("OptionD").ToString(), "D"))
        ElseIf qType = "Checkbox" Then
            cblOptions.Items.Clear()
            If row("OptionA").ToString() <> "" Then cblOptions.Items.Add(New ListItem(row("OptionA").ToString(), "A"))
            If row("OptionB").ToString() <> "" Then cblOptions.Items.Add(New ListItem(row("OptionB").ToString(), "B"))
            If row("OptionC").ToString() <> "" Then cblOptions.Items.Add(New ListItem(row("OptionC").ToString(), "C"))
            If row("OptionD").ToString() <> "" Then cblOptions.Items.Add(New ListItem(row("OptionD").ToString(), "D"))
        Else
            txtParaAns.Text = ""
        End If
        
        btnNext.Visible = (idx < dt.Rows.Count - 1)
        btnSubmit.Visible = (idx = dt.Rows.Count - 1)
    End Sub

    Protected Sub btnNext_Click(sender As Object, e As EventArgs)
        SaveAns()
        Session("QIndex") = CInt(Session("QIndex")) + 1
        ShowQ()
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        SaveAns()
        Finish()
    End Sub

    Private Sub SaveAns()
        Dim idx = CInt(Session("QIndex"))
        Dim dt = CType(Session("Questions"), DataTable)
        Dim row = dt.Rows(idx)
        Dim qType = row("QuestionType").ToString()
        
        Dim ans = ""
        Dim marks As Decimal = 0
        Dim correct = row("CorrectOptions").ToString()

        If qType = "Radio" Then
            ans = rblOptions.SelectedValue
            If ans = correct Then marks = 1
        ElseIf qType = "Checkbox" Then
            Dim sel As New List(Of String)
            For Each item As ListItem In cblOptions.Items
                If item.Selected Then sel.Add(item.Value)
            Next
            ans = String.Join(",", sel)
            If ans = correct Then marks = 1
        Else
            ans = txtParaAns.Text.Trim()
            If ans.ToLower() = correct.ToLower() Then marks = 1
        End If
        
        Using conn As New SqlConnection(connStr)
            Dim sql = "INSERT INTO Answers (StudentID,QuizID,QuestionID,QNo,CorrectAns,StudentAns,Marks) VALUES (@s,@qz,@qn,@no,@ca,@sa,@m)"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@s", Session("UserID"))
            cmd.Parameters.AddWithValue("@qz", Session("QuizID"))
            cmd.Parameters.AddWithValue("@qn", row("QuestionID"))
            cmd.Parameters.AddWithValue("@no", idx + 1)
            cmd.Parameters.AddWithValue("@ca", correct)
            cmd.Parameters.AddWithValue("@sa", ans)
            cmd.Parameters.AddWithValue("@m", marks)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Private Sub Finish()
        Dim qid = CInt(Session("QuizID"))
        Dim sid = CInt(Session("UserID"))
        Dim total = CInt(Session("QTotal"))
        
        Dim obtained As Integer = 0
        Using conn As New SqlConnection(connStr)
            Dim cmd1 As New SqlCommand("SELECT SUM(Marks) FROM Answers WHERE StudentID=@s AND QuizID=@q", conn)
            cmd1.Parameters.AddWithValue("@s", sid)
            cmd1.Parameters.AddWithValue("@q", qid)
            conn.Open()
            Dim res = cmd1.ExecuteScalar()
            If res IsNot DBNull.Value Then obtained = CInt(res)

            Dim cmd2 As New SqlCommand("INSERT INTO Results (StudentID,QuizID,TotalMarks,ObtainedMarks,Percentage) VALUES (@s,@q,@t,@o,@p)", conn)
            cmd2.Parameters.AddWithValue("@s", sid)
            cmd2.Parameters.AddWithValue("@q", qid)
            cmd2.Parameters.AddWithValue("@t", total)
            cmd2.Parameters.AddWithValue("@o", obtained)
            cmd2.Parameters.AddWithValue("@p", (obtained / total) * 100)
            cmd2.ExecuteNonQuery()
        End Using
        Response.Redirect("Student_Results.aspx?done=1&quizid=" & qid)
    End Sub
End Class
