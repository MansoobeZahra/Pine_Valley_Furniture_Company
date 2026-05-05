Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.UI.WebControls

Partial Class Teacher_CreateQuiz
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing OrElse Session("Role").ToString() <> "Teacher" Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then
            LoadSubjects()
            mvWizard.ActiveViewIndex = 0
        End If
    End Sub

    Private Sub LoadSubjects()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT SubjectID, SubjectName FROM Subjects ORDER BY SubjectName", conn)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        ddlSubject.DataSource = dt
        ddlSubject.DataTextField = "SubjectName"
        ddlSubject.DataValueField = "SubjectID"
        ddlSubject.DataBind()
    End Sub

    Protected Sub btnStep1Next_Click(sender As Object, e As EventArgs)
        Dim quizID = CInt(If(hfQuizID.Value = "", 0, hfQuizID.Value))
        If quizID = 0 Then
            Using conn As New SqlConnection(connStr)
                Dim sql = "INSERT INTO Quiz (QuizTitle,SubjectID,AllowedTime,TotalQuestions,RandomizeQ,IsPublished,CreatedBy) " & _
                          "VALUES (@t,@s,@at,@tq,@rq,0,@by); SELECT SCOPE_IDENTITY();"
                Dim cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@t", txtTitle.Text.Trim())
                cmd.Parameters.AddWithValue("@s", CInt(ddlSubject.SelectedValue))
                cmd.Parameters.AddWithValue("@at", CInt(txtTime.Text))
                cmd.Parameters.AddWithValue("@tq", CInt(txtTotalQ.Text))
                cmd.Parameters.AddWithValue("@rq", chkRandomize.Checked)
                cmd.Parameters.AddWithValue("@by", CInt(Session("UserID")))
                conn.Open()
                quizID = CInt(cmd.ExecuteScalar())
            End Using
            hfQuizID.Value = quizID.ToString()
        End If
        LoadCurrentQuestions()
        LoadBankQuestions()
        mvWizard.ActiveViewIndex = 1
    End Sub

    Protected Sub btnTabNew_Click(sender As Object, e As EventArgs)
        pnlWriteNew.Visible = True
        pnlSelectBank.Visible = False
    End Sub

    Protected Sub btnTabBank_Click(sender As Object, e As EventArgs)
        pnlWriteNew.Visible = False
        pnlSelectBank.Visible = True
    End Sub

    Protected Sub ddlQType_Changed(sender As Object, e As EventArgs)
        Dim isCB = (ddlQType.SelectedValue = "Checkbox")
        rbAnsA.Visible = Not isCB : rbAnsB.Visible = Not isCB : rbAnsC.Visible = Not isCB : rbAnsD.Visible = Not isCB
        cbAnsA.Visible = isCB : cbAnsB.Visible = isCB : cbAnsC.Visible = isCB : cbAnsD.Visible = isCB
    End Sub

    Protected Sub btnSaveQ_Click(sender As Object, e As EventArgs)
        Dim qType = ddlQType.SelectedValue
        Dim cops = ""
        If qType = "Radio" Then
            If rbAnsA.Checked Then cops = "A" Else If rbAnsB.Checked Then cops = "B" Else If rbAnsC.Checked Then cops = "C" Else If rbAnsD.Checked Then cops = "D"
        Else
            Dim sel As New List(Of String)
            If cbAnsA.Checked Then sel.Add("A")
            If cbAnsB.Checked Then sel.Add("B")
            If cbAnsC.Checked Then sel.Add("C")
            If cbAnsD.Checked Then sel.Add("D")
            cops = String.Join(",", sel)
        End If

        Using conn As New SqlConnection(connStr)
            conn.Open()
            Dim sqlQ = "INSERT INTO QuestionsTable (SubjectID,QuestionStatement,OptionA,OptionB,OptionC,OptionD,CorrectOption,DifficultyLevel,CreatedBy,QuestionType,CorrectOptions) " & _
                       "VALUES (@sid,@stmt,@a,@b,@c,@d,@co,'Medium',@by,@qt,@cops); SELECT SCOPE_IDENTITY();"
            Dim cmdQ As New SqlCommand(sqlQ, conn)
            cmdQ.Parameters.AddWithValue("@sid", ddlSubject.SelectedValue)
            cmdQ.Parameters.AddWithValue("@stmt", txtQStmt.Text)
            cmdQ.Parameters.AddWithValue("@a", txtOptA.Text)
            cmdQ.Parameters.AddWithValue("@b", txtOptB.Text)
            cmdQ.Parameters.AddWithValue("@c", txtOptC.Text)
            cmdQ.Parameters.AddWithValue("@d", txtOptD.Text)
            cmdQ.Parameters.AddWithValue("@co", If(qType = "Radio", cops, "A"))
            cmdQ.Parameters.AddWithValue("@by", Session("UserID"))
            cmdQ.Parameters.AddWithValue("@qt", qType)
            cmdQ.Parameters.AddWithValue("@cops", cops)
            Dim qid = CInt(cmdQ.ExecuteScalar())

            Dim cmdL As New SqlCommand("INSERT INTO QuizQuestions (QuizID,QuestionID) VALUES (@qz,@q)", conn)
            cmdL.Parameters.AddWithValue("@qz", hfQuizID.Value)
            cmdL.Parameters.AddWithValue("@q", qid)
            cmdL.ExecuteNonQuery()
        End Using
        
        LoadCurrentQuestions()
        txtQStmt.Text = "" : txtOptA.Text = "" : txtOptB.Text = "" : txtOptC.Text = "" : txtOptD.Text = ""
    End Sub

    Protected Sub btnAddSelected_Click(sender As Object, e As EventArgs)
        Using conn As New SqlConnection(connStr)
            conn.Open()
            For Each row As GridViewRow In gvBank.Rows
                If CType(row.FindControl("chkSelect"), CheckBox).Checked Then
                    Dim cmd As New SqlCommand("INSERT INTO QuizQuestions (QuizID,QuestionID) VALUES (@qz,@q)", conn)
                    cmd.Parameters.AddWithValue("@qz", hfQuizID.Value)
                    cmd.Parameters.AddWithValue("@q", gvBank.DataKeys(row.RowIndex).Value)
                    cmd.ExecuteNonQuery()
                End If
            Next
        End Using
        LoadCurrentQuestions()
    End Sub

    Private Sub LoadBankQuestions()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT QuestionID, QuestionStatement FROM QuestionsTable WHERE SubjectID=@s AND CreatedBy=@by", conn)
            cmd.Parameters.AddWithValue("@s", ddlSubject.SelectedValue)
            cmd.Parameters.AddWithValue("@by", Session("UserID"))
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        gvBank.DataSource = dt
        gvBank.DataBind()
    End Sub

    Private Sub LoadCurrentQuestions()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT qq.QuizQuestionID, q.QuestionStatement FROM QuizQuestions qq JOIN QuestionsTable q ON qq.QuestionID = q.QuestionID WHERE qq.QuizID=@qz", conn)
            cmd.Parameters.AddWithValue("@qz", hfQuizID.Value)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
        rptCurrentQ.DataSource = dt
        rptCurrentQ.DataBind()
        litCurQCount.Text = dt.Rows.Count.ToString()
    End Sub

    Protected Sub rptCurrentQ_Command(source As Object, e As RepeaterCommandEventArgs)
        If e.CommandName = "Remove" Then
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("DELETE FROM QuizQuestions WHERE QuizQuestionID=@id", conn)
                cmd.Parameters.AddWithValue("@id", e.CommandArgument)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
            LoadCurrentQuestions()
        End If
    End Sub

    Protected Sub btnStep2Next_Click(sender As Object, e As EventArgs)
        litFinalTitle.Text = txtTitle.Text
        mvWizard.ActiveViewIndex = 2
    End Sub

    Protected Sub btnPublish_Click(sender As Object, e As EventArgs)
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("UPDATE Quiz SET IsPublished=1 WHERE QuizID=@q", conn)
            cmd.Parameters.AddWithValue("@q", hfQuizID.Value)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
        Response.Redirect("Teacher_Dashboard.aspx")
    End Sub
End Class
