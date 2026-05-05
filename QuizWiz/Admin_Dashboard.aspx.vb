Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class Admin_Dashboard
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim role As String = ""
        If Session("Role") IsNot Nothing Then role = Session("Role").ToString()
        If role <> "Admin" Then Response.Redirect("Login.aspx") : Return
        If Not IsPostBack Then LoadStats()
    End Sub

    Private Sub LoadStats()
        Using conn As New SqlConnection(connStr)
            conn.Open()
            litUsers.Text = New SqlCommand("SELECT COUNT(*) FROM Users2", conn).ExecuteScalar().ToString()
            litTeachers.Text = New SqlCommand("SELECT COUNT(*) FROM Users2 WHERE Role='Teacher'", conn).ExecuteScalar().ToString()
            litStudents.Text = New SqlCommand("SELECT COUNT(*) FROM Users2 WHERE Role='Student'", conn).ExecuteScalar().ToString()
            litQuizzes.Text = New SqlCommand("SELECT COUNT(*) FROM Quiz", conn).ExecuteScalar().ToString()
            litQuestions.Text = New SqlCommand("SELECT COUNT(*) FROM QuestionsTable", conn).ExecuteScalar().ToString()
            litAttempts.Text = New SqlCommand("SELECT COUNT(*) FROM Results", conn).ExecuteScalar().ToString()

            Dim dtQ As New DataTable()
            Dim sqlQ As String = "SELECT TOP 8 q.QuizTitle, u.FullName AS CreatorName, q.IsPublished, " & _
                                "(SELECT COUNT(*) FROM Results r WHERE r.QuizID=q.QuizID) AS Attempts " & _
                                "FROM Quiz q JOIN Users2 u ON q.CreatedBy=u.UserID ORDER BY q.CreatedAt DESC"
            Dim daQ As New SqlDataAdapter(sqlQ, conn)
            daQ.Fill(dtQ)
            gvQuizzes.DataSource = dtQ
            gvQuizzes.DataBind()

            Dim dtR As New DataTable()
            Dim sqlR As String = "SELECT TOP 8 u.FullName AS StudentName, q.QuizTitle, r.Percentage, r.AttemptDate " & _
                                "FROM Results r JOIN Users2 u ON r.StudentID=u.UserID " & _
                                "JOIN Quiz q ON r.QuizID=q.QuizID ORDER BY r.AttemptDate DESC"
            Dim daR As New SqlDataAdapter(sqlR, conn)
            daR.Fill(dtR)
            gvResults.DataSource = dtR
            gvResults.DataBind()
        End Using
    End Sub
End Class
