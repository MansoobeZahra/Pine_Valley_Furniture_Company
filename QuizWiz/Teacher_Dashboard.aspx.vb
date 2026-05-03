Imports System.Data

Partial Class Teacher_Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.RequireRole(Me, "Teacher")
        If Not IsPostBack Then
            LoadStats()
            LoadQuizzes()
        End If
    End Sub

    Private Sub LoadStats()
        Dim uid = CInt(Session("UserID"))
        litTotalQ.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM QuestionsTable WHERE CreatedBy=@u", DBHelper.Param("@u", uid)).ToString()
        litTotalQuiz.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Quiz WHERE CreatedBy=@u", DBHelper.Param("@u", uid)).ToString()
        litPublished.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Quiz WHERE CreatedBy=@u AND IsPublished=1", DBHelper.Param("@u", uid)).ToString()
        litAttempts.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Results r JOIN Quiz q ON r.QuizID = q.QuizID WHERE q.CreatedBy=@u", DBHelper.Param("@u", uid)).ToString()
    End Sub

    Private Sub LoadQuizzes()
        gvQuizzes.DataSource = DBHelper.GetDataTable( _
            "SELECT q.QuizID, q.QuizTitle, q.AllowedTime, q.TotalQuestions, q.IsPublished, s.SubjectName " & _
            "FROM Quiz q JOIN Subjects s ON q.SubjectID = s.SubjectID " & _
            "WHERE q.CreatedBy = @u ORDER BY q.CreatedAt DESC", _
            DBHelper.Param("@u", CInt(Session("UserID"))))
        gvQuizzes.DataBind()
    End Sub

    Protected Sub gvQuizzes_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        If e.CommandName = "PublishToggle" Then
            Dim qid = CInt(e.CommandArgument)
            DBHelper.ExecuteNonQuery("UPDATE Quiz SET IsPublished = 1 - IsPublished WHERE QuizID=@q AND CreatedBy=@u", _
                DBHelper.Param("@q", qid), DBHelper.Param("@u", CInt(Session("UserID"))))
            LoadStats()
            LoadQuizzes()
        End If
    End Sub
End Class
