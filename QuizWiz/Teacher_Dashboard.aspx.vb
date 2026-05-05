Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class Teacher_Dashboard
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing OrElse Session("Role").ToString() <> "Teacher" Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then
            LoadStats()
            LoadQuizzes()
        End If
    End Sub

    Private Sub LoadStats()
        Dim uid = CInt(Session("UserID"))
        Using conn As New SqlConnection(connStr)
            conn.Open()
            Dim cmd1 As New SqlCommand("SELECT COUNT(*) FROM QuestionsTable WHERE CreatedBy=@u", conn)
            cmd1.Parameters.AddWithValue("@u", uid)
            litTotalQ.Text = cmd1.ExecuteScalar().ToString()

            Dim cmd2 As New SqlCommand("SELECT COUNT(*) FROM Quiz WHERE CreatedBy=@u", conn)
            cmd2.Parameters.AddWithValue("@u", uid)
            litTotalQuiz.Text = cmd2.ExecuteScalar().ToString()

            Dim cmd3 As New SqlCommand("SELECT COUNT(*) FROM Quiz WHERE CreatedBy=@u AND IsPublished=1", conn)
            cmd3.Parameters.AddWithValue("@u", uid)
            litPublished.Text = cmd3.ExecuteScalar().ToString()

            Dim cmd4 As New SqlCommand("SELECT COUNT(*) FROM Results r JOIN Quiz q ON r.QuizID = q.QuizID WHERE q.CreatedBy=@u", conn)
            cmd4.Parameters.AddWithValue("@u", uid)
            litAttempts.Text = cmd4.ExecuteScalar().ToString()
        End Using
    End Sub

    Private Sub LoadQuizzes()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim sql = "SELECT q.QuizID, q.QuizTitle, q.AllowedTime, q.TotalQuestions, q.IsPublished, s.SubjectName " & _
                      "FROM Quiz q JOIN Subjects s ON q.SubjectID = s.SubjectID " & _
                      "WHERE q.CreatedBy = @u ORDER BY q.CreatedAt DESC"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@u", CInt(Session("UserID")))
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        gvQuizzes.DataSource = dt
        gvQuizzes.DataBind()
    End Sub

    Protected Sub gvQuizzes_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        If e.CommandName = "PublishToggle" Then
            Dim qid = CInt(e.CommandArgument)
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("UPDATE Quiz SET IsPublished = 1 - IsPublished WHERE QuizID=@q AND CreatedBy=@u", conn)
                cmd.Parameters.AddWithValue("@q", qid)
                cmd.Parameters.AddWithValue("@u", CInt(Session("UserID")))
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
            LoadStats()
            LoadQuizzes()
        End If
    End Sub
End Class
