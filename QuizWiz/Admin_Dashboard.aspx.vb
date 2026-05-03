Imports System.Data

Partial Class Admin_Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim role As String = ""
        If Session("Role") IsNot Nothing Then role = Session("Role").ToString()
        If role <> "Admin" Then Response.Redirect("Login.aspx") : Return
        If Not IsPostBack Then LoadStats()
    End Sub

    Private Sub LoadStats()
        litUsers.Text     = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users2").ToString()
        litTeachers.Text  = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users2 WHERE Role='Teacher'").ToString()
        litStudents.Text  = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users2 WHERE Role='Student'").ToString()
        litQuizzes.Text   = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Quiz").ToString()
        litQuestions.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM QuestionsTable").ToString()
        litAttempts.Text  = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Results").ToString()

        gvQuizzes.DataSource = DBHelper.GetDataTable( _
            "SELECT TOP 8 q.QuizTitle, u.FullName AS CreatorName, q.IsPublished, " & _
            "       (SELECT COUNT(*) FROM Results r WHERE r.QuizID=q.QuizID) AS Attempts " & _
            "FROM Quiz q JOIN Users2 u ON q.CreatedBy=u.UserID " & _
            "ORDER BY q.CreatedAt DESC")
        gvQuizzes.DataBind()

        gvResults.DataSource = DBHelper.GetDataTable( _
            "SELECT TOP 8 u.FullName AS StudentName, q.QuizTitle, r.Percentage, r.AttemptDate " & _
            "FROM Results r " & _
            "JOIN Users2 u ON r.StudentID=u.UserID " & _
            "JOIN Quiz q  ON r.QuizID=q.QuizID " & _
            "ORDER BY r.AttemptDate DESC")
        gvResults.DataBind()
    End Sub
End Class
