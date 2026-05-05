Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI.WebControls

Partial Class Student_Dashboard
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing OrElse Session("Role").ToString() <> "Student" Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then
            LoadStats()
            LoadQuizzes()
            LoadNotifications()
        End If
    End Sub

    Private Sub LoadStats()
        Dim uid = CInt(Session("UserID"))
        Using conn As New SqlConnection(connStr)
            conn.Open()
            Dim cmd1 As New SqlCommand("SELECT COUNT(*) FROM Results WHERE StudentID=@s", conn)
            cmd1.Parameters.AddWithValue("@s", uid)
            litAttempted.Text = cmd1.ExecuteScalar().ToString()

            Dim cmd2 As New SqlCommand("SELECT AVG(Percentage) FROM Results WHERE StudentID=@s", conn)
            cmd2.Parameters.AddWithValue("@s", uid)
            Dim avg = cmd2.ExecuteScalar()
            litAvgScore.Text = If(avg Is DBNull.Value, "0", Convert.ToDouble(avg).ToString("0")) & "%"

            Dim cmd3 As New SqlCommand("SELECT COUNT(*) FROM Notifications WHERE ToUserID=@u AND IsRead=0", conn)
            cmd3.Parameters.AddWithValue("@u", uid)
            litNotifs.Text = cmd3.ExecuteScalar().ToString()
        End Using
    End Sub

    Private Sub LoadNotifications()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT Message FROM Notifications WHERE ToUserID=@u AND IsRead=0", conn)
            cmd.Parameters.AddWithValue("@u", Session("UserID"))
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        pnlNotifs.Visible = (dt.Rows.Count > 0)
        rptNotifs.DataSource = dt
        rptNotifs.DataBind()
    End Sub

    Protected Sub btnMarkRead_Click(sender As Object, e As EventArgs)
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("UPDATE Notifications SET IsRead=1 WHERE ToUserID=@u", conn)
            cmd.Parameters.AddWithValue("@u", Session("UserID"))
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        LoadStats()
        LoadNotifications()
    End Sub

    Private Sub LoadQuizzes()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim sql = "SELECT q.QuizID, q.QuizTitle, s.SubjectName, CASE WHEN EXISTS(SELECT 1 FROM Results r WHERE r.StudentID=@s AND r.QuizID=q.QuizID) THEN 1 ELSE 0 END AS AlreadyAttempted " & _
                      "FROM Quiz q JOIN Subjects s ON q.SubjectID = s.SubjectID WHERE q.IsPublished=1 ORDER BY q.CreatedAt DESC"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@s", Session("UserID"))
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        gvQuizzes.DataSource = dt
        gvQuizzes.DataBind()
    End Sub
End Class
