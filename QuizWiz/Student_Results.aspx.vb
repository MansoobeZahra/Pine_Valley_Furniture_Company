Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI.WebControls

Partial Class Student_MyResults
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing OrElse Session("Role").ToString() <> "Student" Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then
            Dim sid = CInt(Session("UserID"))
            Dim qid = Request.QueryString("quizid")
            pnlJustDone.Visible = (Request.QueryString("done") = "1")
            If qid <> "" Then LoadSingleResult(sid, CInt(qid))
            LoadAllResults(sid)
        End If
    End Sub

    Private Sub LoadSingleResult(sid As Integer, quizID As Integer)
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT r.ObtainedMarks, r.TotalMarks, r.Percentage, q.QuizTitle FROM Results r JOIN Quiz q ON r.QuizID = q.QuizID WHERE r.StudentID=@s AND r.QuizID=@q", conn)
            cmd.Parameters.AddWithValue("@s", sid)
            cmd.Parameters.AddWithValue("@q", quizID)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using

        If dt.Rows.Count = 0 Then Return
        Dim row = dt.Rows(0)
        litPct.Text = Convert.ToDouble(row("Percentage")).ToString("0") & "%"
        litObtained.Text = row("ObtainedMarks").ToString()
        litTotal.Text = row("TotalMarks").ToString()
        litQuizName.Text = row("QuizTitle").ToString()
        pnlHero.Visible = True

        Dim dtDetail As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT a.QNo, qt.QuestionStatement, a.CorrectAns, a.StudentAns, a.Marks FROM Answers a JOIN QuestionsTable qt ON a.QuestionID = qt.QuestionID WHERE a.StudentID=@s AND a.QuizID=@q ORDER BY a.QNo", conn)
            cmd.Parameters.AddWithValue("@s", sid)
            cmd.Parameters.AddWithValue("@q", quizID)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dtDetail)
        End Using
        gvDetail.DataSource = dtDetail
        gvDetail.DataBind()
    End Sub

    Private Sub LoadAllResults(sid As Integer)
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim sql = "SELECT q.QuizTitle, s.SubjectName, r.Percentage, r.AttemptDate FROM Results r JOIN Quiz q ON r.QuizID = q.QuizID JOIN Subjects s ON q.SubjectID = s.SubjectID WHERE r.StudentID=@sid ORDER BY r.AttemptDate DESC"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@sid", sid)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        gvAllResults.DataSource = dt
        gvAllResults.DataBind()
    End Sub
End Class
