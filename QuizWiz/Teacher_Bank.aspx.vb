Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI.WebControls

Partial Class Teacher_ManageQuestions
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing OrElse Session("Role").ToString() <> "Teacher" Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then
            LoadSubjects()
            LoadQuestions()
        End If
    End Sub

    Private Sub LoadSubjects()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT SubjectID, SubjectName FROM Subjects ORDER BY SubjectName", conn)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        ddlFilter.Items.Clear()
        ddlFilter.Items.Add(New ListItem("All Subjects", ""))
        For Each row As DataRow In dt.Rows
            ddlFilter.Items.Add(New ListItem(row("SubjectName").ToString(), row("SubjectID").ToString()))
        Next
    End Sub

    Private Sub LoadQuestions()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim sql = "SELECT q.QuestionID, q.QuestionStatement, q.DifficultyLevel, q.CorrectOptions, s.SubjectName FROM QuestionsTable q JOIN Subjects s ON q.SubjectID = s.SubjectID WHERE q.CreatedBy = @t"
            If ddlFilter.SelectedValue <> "" Then sql &= " AND q.SubjectID = @s"
            If ddlDiffFilter.SelectedValue <> "" Then sql &= " AND q.DifficultyLevel = @d"
            sql &= " ORDER BY q.CreatedAt DESC"

            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@t", CInt(Session("UserID")))
            If ddlFilter.SelectedValue <> "" Then cmd.Parameters.AddWithValue("@s", ddlFilter.SelectedValue)
            If ddlDiffFilter.SelectedValue <> "" Then cmd.Parameters.AddWithValue("@d", ddlDiffFilter.SelectedValue)
            
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        gvQuestions.DataSource = dt
        gvQuestions.DataBind()
    End Sub

    Protected Sub ddlFilter_Changed(sender As Object, e As EventArgs)
        LoadQuestions()
    End Sub

    Protected Sub gvQuestions_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "DeleteQ" Then
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("DELETE FROM QuestionsTable WHERE QuestionID=@q AND CreatedBy=@t", conn)
                cmd.Parameters.AddWithValue("@q", e.CommandArgument)
                cmd.Parameters.AddWithValue("@t", Session("UserID"))
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
            LoadQuestions()
        End If
    End Sub

    Protected Sub gvQuestions_RowEditing(sender As Object, e As GridViewEditEventArgs)
        gvQuestions.EditIndex = e.NewEditIndex
        LoadQuestions()
    End Sub

    Protected Sub gvQuestions_CancelEdit(sender As Object, e As GridViewCancelEditEventArgs)
        gvQuestions.EditIndex = -1
        LoadQuestions()
    End Sub

    Protected Sub gvQuestions_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        Dim qid = gvQuestions.DataKeys(e.RowIndex).Value
        Dim txtStmt = CType(gvQuestions.Rows(e.RowIndex).FindControl("txtEditStmt"), TextBox)
        Dim ddlDiff = CType(gvQuestions.Rows(e.RowIndex).FindControl("ddlEditDiff"), DropDownList)
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("UPDATE QuestionsTable SET QuestionStatement=@s, DifficultyLevel=@d WHERE QuestionID=@q", conn)
            cmd.Parameters.AddWithValue("@s", txtStmt.Text)
            cmd.Parameters.AddWithValue("@d", ddlDiff.SelectedValue)
            cmd.Parameters.AddWithValue("@q", qid)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        gvQuestions.EditIndex = -1
        LoadQuestions()
    End Sub
End Class
