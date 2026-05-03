Imports System.Data
Imports System.Web.UI.WebControls

Partial Class Teacher_CreateQuiz
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.RequireRole(Me, "Teacher")
        If Not IsPostBack Then
            LoadSubjects()
            mvWizard.ActiveViewIndex = 0
        End If
    End Sub

    Private Sub LoadSubjects()
        ddlSubject.DataSource = DBHelper.GetDataTable("SELECT SubjectID, SubjectName FROM Subjects ORDER BY SubjectName")
        ddlSubject.DataTextField = "SubjectName"
        ddlSubject.DataValueField = "SubjectID"
        ddlSubject.DataBind()
    End Sub

    Protected Sub btnStep1Next_Click(sender As Object, e As EventArgs)
        Dim quizID = CInt(If(hfQuizID.Value = "", 0, hfQuizID.Value))
        If quizID = 0 Then
            quizID = CInt(DBHelper.ExecuteScalar( _
                "INSERT INTO Quiz (QuizTitle,SubjectID,AllowedTime,TotalQuestions,RandomizeQ,IsPublished,CreatedBy) " & _
                "VALUES (@t,@s,@at,@tq,@rq,0,@by); SELECT SCOPE_IDENTITY();", _
                DBHelper.Param("@t", txtTitle.Text.Trim()), DBHelper.Param("@s", CInt(ddlSubject.SelectedValue)), _
                DBHelper.Param("@at", CInt(txtTime.Text)), DBHelper.Param("@tq", CInt(txtTotalQ.Text)), _
                DBHelper.Param("@rq", chkRandomize.Checked), DBHelper.Param("@by", CInt(Session("UserID")))))
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

        Dim imgPath = ""
        If fuQImage.HasFile Then
            Try
                Dim folder = Server.MapPath("~/Images/Questions/")
                If Not System.IO.Directory.Exists(folder) Then System.IO.Directory.CreateDirectory(folder)
                Dim fName = Guid.NewGuid().ToString() & System.IO.Path.GetExtension(fuQImage.FileName)
                fuQImage.SaveAs(folder & fName)
                imgPath = "Images/Questions/" & fName
            Catch : End Try
        End If

        Dim qid = CInt(DBHelper.ExecuteScalar( _
            "INSERT INTO QuestionsTable (SubjectID,QuestionStatement,OptionA,OptionB,OptionC,OptionD,CorrectOption,DifficultyLevel,CreatedBy,QuestionType,CorrectOptions,ImagePath) " & _
            "VALUES (@sid,@stmt,@a,@b,@c,@d,@co,'Medium',@by,@qt,@cops,@img); SELECT SCOPE_IDENTITY();", _
            DBHelper.Param("@sid", ddlSubject.SelectedValue), DBHelper.Param("@stmt", txtQStmt.Text), _
            DBHelper.Param("@a", txtOptA.Text), DBHelper.Param("@b", txtOptB.Text), _
            DBHelper.Param("@c", txtOptC.Text), DBHelper.Param("@d", txtOptD.Text), _
            DBHelper.Param("@co", If(qType="Radio", cops, "A")), DBHelper.Param("@by", Session("UserID")), _
            DBHelper.Param("@qt", qType), DBHelper.Param("@cops", cops), _
            DBHelper.Param("@img", If(imgPath="", DBNull.Value, imgPath))))
        
        DBHelper.ExecuteNonQuery("INSERT INTO QuizQuestions (QuizID,QuestionID) VALUES (@qz,@q)", DBHelper.Param("@qz", hfQuizID.Value), DBHelper.Param("@q", qid))
        LoadCurrentQuestions()
        txtQStmt.Text = "" : txtOptA.Text = "" : txtOptB.Text = "" : txtOptC.Text = "" : txtOptD.Text = ""
    End Sub

    Protected Sub btnAddSelected_Click(sender As Object, e As EventArgs)
        For Each row As GridViewRow In gvBank.Rows
            If CType(row.FindControl("chkSelect"), CheckBox).Checked Then
                DBHelper.ExecuteNonQuery("INSERT INTO QuizQuestions (QuizID,QuestionID) VALUES (@qz,@q)", _
                    DBHelper.Param("@qz", hfQuizID.Value), DBHelper.Param("@q", gvBank.DataKeys(row.RowIndex).Value))
            End If
        Next
        LoadCurrentQuestions()
    End Sub

    Private Sub LoadBankQuestions()
        gvBank.DataSource = DBHelper.GetDataTable("SELECT QuestionID, QuestionStatement FROM QuestionsTable WHERE SubjectID=@s AND CreatedBy=@by", _
            DBHelper.Param("@s", ddlSubject.SelectedValue), DBHelper.Param("@by", Session("UserID")))
        gvBank.DataBind()
    End Sub

    Private Sub LoadCurrentQuestions()
        Dim dt = DBHelper.GetDataTable("SELECT qq.QuizQuestionID, q.QuestionStatement FROM QuizQuestions qq JOIN QuestionsTable q ON qq.QuestionID = q.QuestionID WHERE qq.QuizID=@qz", _
            DBHelper.Param("@qz", hfQuizID.Value))
        rptCurrentQ.DataSource = dt
        rptCurrentQ.DataBind()
        litCurQCount.Text = dt.Rows.Count.ToString()
    End Sub

    Protected Sub rptCurrentQ_Command(source As Object, e As RepeaterCommandEventArgs)
        If e.CommandName = "Remove" Then
            DBHelper.ExecuteNonQuery("DELETE FROM QuizQuestions WHERE QuizQuestionID=@id", DBHelper.Param("@id", e.CommandArgument))
            LoadCurrentQuestions()
        End If
    End Sub

    Protected Sub btnStep2Next_Click(sender As Object, e As EventArgs)
        litFinalTitle.Text = txtTitle.Text
        mvWizard.ActiveViewIndex = 2
    End Sub

    Protected Sub btnPublish_Click(sender As Object, e As EventArgs)
        DBHelper.ExecuteNonQuery("UPDATE Quiz SET IsPublished=1 WHERE QuizID=@q", DBHelper.Param("@q", hfQuizID.Value))
        Response.Redirect("Teacher_Dashboard.aspx")
    End Sub
End Class
