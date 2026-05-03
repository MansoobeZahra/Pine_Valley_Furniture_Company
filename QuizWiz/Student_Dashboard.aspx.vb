Imports System.Data
Imports System.Web.UI.WebControls

Partial Class Student_Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.RequireRole(Me, "Student")
        If Not IsPostBack Then
            LoadStats()
            LoadQuizzes()
            LoadNotifications()
        End If
    End Sub

    Private Sub LoadStats()
        Dim uid = CInt(Session("UserID"))
        litAttempted.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Results WHERE StudentID=@s", DBHelper.Param("@s", uid)).ToString()
        Dim avg = DBHelper.ExecuteScalar("SELECT AVG(Percentage) FROM Results WHERE StudentID=@s", DBHelper.Param("@s", uid))
        litAvgScore.Text = If(avg Is DBNull.Value, "0", Convert.ToDouble(avg).ToString("0")) & "%"
        litNotifs.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Notifications WHERE ToUserID=@u AND IsRead=0", DBHelper.Param("@u", uid)).ToString()
    End Sub

    Private Sub LoadNotifications()
        Dim dt = DBHelper.GetDataTable("SELECT Message FROM Notifications WHERE ToUserID=@u AND IsRead=0", DBHelper.Param("@u", Session("UserID")))
        pnlNotifs.Visible = (dt.Rows.Count > 0)
        rptNotifs.DataSource = dt
        rptNotifs.DataBind()
    End Sub

    Protected Sub btnMarkRead_Click(sender As Object, e As EventArgs)
        DBHelper.ExecuteNonQuery("UPDATE Notifications SET IsRead=1 WHERE ToUserID=@u", DBHelper.Param("@u", Session("UserID")))
        LoadStats()
        LoadNotifications()
    End Sub

    Private Sub LoadQuizzes()
        gvQuizzes.DataSource = DBHelper.GetDataTable( _
            "SELECT q.QuizID, q.QuizTitle, s.SubjectName, CASE WHEN EXISTS(SELECT 1 FROM Results r WHERE r.StudentID=@s AND r.QuizID=q.QuizID) THEN 1 ELSE 0 END AS AlreadyAttempted " & _
            "FROM Quiz q JOIN Subjects s ON q.SubjectID = s.SubjectID WHERE q.IsPublished=1 ORDER BY q.CreatedAt DESC", _
            DBHelper.Param("@s", Session("UserID")))
        gvQuizzes.DataBind()
    End Sub
End Class
