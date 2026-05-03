Imports System.Data
Imports System.Web.UI.WebControls

Partial Class Teacher_ViewResults
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.RequireRole(Me, "Teacher", "Admin")
        If Not IsPostBack Then LoadQuizList()
    End Sub

    Private Sub LoadQuizList()
        Dim uid = CInt(Session("UserID"))
        Dim sql = "SELECT QuizID, QuizTitle FROM Quiz WHERE CreatedBy=@id ORDER BY CreatedAt DESC"
        If Session("Role").ToString() = "Admin" Then sql = "SELECT QuizID, QuizTitle FROM Quiz ORDER BY CreatedAt DESC"
        
        ddlQuiz.DataSource = DBHelper.GetDataTable(sql, DBHelper.Param("@id", uid))
        ddlQuiz.DataTextField = "QuizTitle"
        ddlQuiz.DataValueField = "QuizID"
        ddlQuiz.DataBind()
        ddlQuiz.Items.Insert(0, New ListItem("-- Select --", ""))
    End Sub

    Protected Sub btnView_Click(sender As Object, e As EventArgs)
        If ddlQuiz.SelectedValue = "" Then Return
        Dim dt = DBHelper.GetDataTable( _
            "SELECT r.ObtainedMarks, r.TotalMarks, r.Percentage, r.AttemptDate, u.FullName AS StudentName " & _
            "FROM Results r JOIN Users2 u ON r.StudentID = u.UserID WHERE r.QuizID = @q ORDER BY r.Percentage DESC", _
            DBHelper.Param("@q", ddlQuiz.SelectedValue))
        
        If dt.Rows.Count = 0 Then
            pnlResults.Visible = False
            Return
        End If
        
        pnlResults.Visible = True
        gvResults.DataSource = dt
        gvResults.DataBind()

        Dim sum = 0.0, high = 0.0, low = 100.0
        For Each r As System.Data.DataRow In dt.Rows
            Dim p = Convert.ToDouble(r("Percentage"))
            sum += p
            If p > high Then high = p
            If p < low Then low = p
        Next
        
        litTotalStudents.Text = dt.Rows.Count.ToString()
        litAvgScore.Text = (sum / dt.Rows.Count).ToString("0") & "%"
        litHighest.Text = high.ToString("0") & "%"
        litLowest.Text = low.ToString("0") & "%"
    End Sub
End Class
