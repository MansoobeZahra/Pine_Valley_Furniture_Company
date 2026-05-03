Imports System.Data
Imports System.Web.UI.WebControls

Partial Class Teacher_ManageQuestions
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.RequireRole(Me, "Teacher")
        If Not IsPostBack Then
            LoadSubjects()
            LoadQuestions()
        End If
    End Sub

    Private Sub LoadSubjects()
        Dim dt = DBHelper.GetDataTable("SELECT SubjectID, SubjectName FROM Subjects ORDER BY SubjectName")
        ddlFilter.Items.Clear()
        ddlFilter.Items.Add(New ListItem("All Subjects", ""))
        For Each row As System.Data.DataRow In dt.Rows
            ddlFilter.Items.Add(New ListItem(row("SubjectName").ToString(), row("SubjectID").ToString()))
        Next
    End Sub

    Private Sub LoadQuestions()
        Dim sql = "SELECT q.QuestionID, q.QuestionStatement, q.DifficultyLevel, q.CorrectOptions, s.SubjectName FROM QuestionsTable q JOIN Subjects s ON q.SubjectID = s.SubjectID WHERE q.CreatedBy = @t"
        Dim pList As New System.Collections.Generic.List(Of System.Data.SqlClient.SqlParameter)
        pList.Add(DBHelper.Param("@t", CInt(Session("UserID"))))
        If ddlFilter.SelectedValue <> "" Then
            sql &= " AND q.SubjectID = @s"
            pList.Add(DBHelper.Param("@s", ddlFilter.SelectedValue))
        End If
        If ddlDiffFilter.SelectedValue <> "" Then
            sql &= " AND q.DifficultyLevel = @d"
            pList.Add(DBHelper.Param("@d", ddlDiffFilter.SelectedValue))
        End If
        sql &= " ORDER BY q.CreatedAt DESC"
        gvQuestions.DataSource = DBHelper.GetDataTable(sql, pList.ToArray())
        gvQuestions.DataBind()
    End Sub

    Protected Sub ddlFilter_Changed(sender As Object, e As EventArgs)
        LoadQuestions()
    End Sub

    Protected Sub gvQuestions_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "DeleteQ" Then
            DBHelper.ExecuteNonQuery("DELETE FROM QuestionsTable WHERE QuestionID=@q AND CreatedBy=@t", _
                DBHelper.Param("@q", e.CommandArgument), DBHelper.Param("@t", Session("UserID")))
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
        DBHelper.ExecuteNonQuery("UPDATE QuestionsTable SET QuestionStatement=@s, DifficultyLevel=@d WHERE QuestionID=@q", _
            DBHelper.Param("@s", txtStmt.Text), DBHelper.Param("@d", ddlDiff.SelectedValue), DBHelper.Param("@q", qid))
        gvQuestions.EditIndex = -1
        LoadQuestions()
    End Sub
End Class
