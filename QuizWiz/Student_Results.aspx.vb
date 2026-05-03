Imports System.Data
Imports System.Web.UI.WebControls

Partial Class Student_MyResults
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.RequireRole(Me, "Student")
        If Not IsPostBack Then
            Dim sid = CInt(Session("UserID"))
            Dim qid = Request.QueryString("quizid")
            pnlJustDone.Visible = (Request.QueryString("done") = "1")
            If qid <> "" Then LoadSingleResult(sid, CInt(qid))
            LoadAllResults(sid)
        End If
    End Sub

    Private Sub LoadSingleResult(sid As Integer, quizID As Integer)
        Dim dt = DBHelper.GetDataTable("SELECT r.ObtainedMarks, r.TotalMarks, r.Percentage, q.QuizTitle FROM Results r JOIN Quiz q ON r.QuizID = q.QuizID WHERE r.StudentID=@s AND r.QuizID=@q", DBHelper.Param("@s", sid), DBHelper.Param("@q", quizID))
        If dt.Rows.Count = 0 Then Return
        Dim row = dt.Rows(0)
        litPct.Text = Convert.ToDouble(row("Percentage")).ToString("0") & "%"
        litObtained.Text = row("ObtainedMarks").ToString()
        litTotal.Text = row("TotalMarks").ToString()
        litQuizName.Text = row("QuizTitle").ToString()
        pnlHero.Visible = True
        gvDetail.DataSource = DBHelper.GetDataTable("SELECT a.QNo, qt.QuestionStatement, a.CorrectAns, a.StudentAns, a.Marks FROM Answers a JOIN QuestionsTable qt ON a.QuestionID = qt.QuestionID WHERE a.StudentID=@s AND a.QuizID=@q ORDER BY a.QNo", DBHelper.Param("@s", sid), DBHelper.Param("@q", quizID))
        gvDetail.DataBind()
    End Sub

    Private Sub LoadAllResults(sid As Integer)
        gvAllResults.DataSource = DBHelper.GetDataTable("SELECT q.QuizTitle, s.SubjectName, r.Percentage, r.AttemptDate FROM Results r JOIN Quiz q ON r.QuizID = q.QuizID JOIN Subjects s ON q.SubjectID = s.SubjectID WHERE r.StudentID=@sid ORDER BY r.AttemptDate DESC", DBHelper.Param("@sid", sid))
        gvAllResults.DataBind()
    End Sub
End Class
