Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI.WebControls

Partial Class Teacher_ViewResults
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim role = If(Session("Role") IsNot Nothing, Session("Role").ToString(), "")
        If role <> "Teacher" And role <> "Admin" Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then LoadQuizList()
    End Sub

    Private Sub LoadQuizList()
        Dim uid = CInt(Session("UserID"))
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim sql = "SELECT QuizID, QuizTitle FROM Quiz WHERE CreatedBy=@id ORDER BY CreatedAt DESC"
            If Session("Role").ToString() = "Admin" Then sql = "SELECT QuizID, QuizTitle FROM Quiz ORDER BY CreatedAt DESC"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@id", uid)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        
        ddlQuiz.DataSource = dt
        ddlQuiz.DataTextField = "QuizTitle"
        ddlQuiz.DataValueField = "QuizID"
        ddlQuiz.DataBind()
        ddlQuiz.Items.Insert(0, New ListItem("-- Select --", ""))
    End Sub

    Protected Sub btnView_Click(sender As Object, e As EventArgs)
        If ddlQuiz.SelectedValue = "" Then Return
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim sql = "SELECT r.ObtainedMarks, r.TotalMarks, r.Percentage, r.AttemptDate, u.FullName AS StudentName " & _
                      "FROM Results r JOIN Users2 u ON r.StudentID = u.UserID WHERE r.QuizID = @q ORDER BY r.Percentage DESC"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@q", ddlQuiz.SelectedValue)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        
        If dt.Rows.Count = 0 Then
            pnlResults.Visible = False
            Return
        End If
        
        pnlResults.Visible = True
        gvResults.DataSource = dt
        gvResults.DataBind()

        Dim sum = 0.0, high = 0.0, low = 100.0
        For Each r As DataRow In dt.Rows
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
