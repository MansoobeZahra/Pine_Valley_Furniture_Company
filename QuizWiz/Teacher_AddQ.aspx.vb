Partial Class Teacher_AddQuestion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.RequireRole(Me, "Teacher")
        If Not IsPostBack Then LoadSubjects()
    End Sub

    Private Sub LoadSubjects()
        ddlSubject.DataSource = DBHelper.GetDataTable("SELECT SubjectID, SubjectName FROM Subjects ORDER BY SubjectName")
        ddlSubject.DataTextField = "SubjectName"
        ddlSubject.DataValueField = "SubjectID"
        ddlSubject.DataBind()
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        Dim qType = hfQType.Value
        If qType = "" Then qType = "Radio"
        
        Dim correctOptions = ""
        If qType = "Radio" Then
            If rbA.Checked Then
                correctOptions = "A"
            ElseIf rbB.Checked Then
                correctOptions = "B"
            ElseIf rbC.Checked Then
                correctOptions = "C"
            ElseIf rbD.Checked Then
                correctOptions = "D"
            End If
        ElseIf qType = "Checkbox" Then
            Dim sel As New List(Of String)
            If cbCA.Checked Then sel.Add("A")
            If cbCB.Checked Then sel.Add("B")
            If cbCC.Checked Then sel.Add("C")
            If cbCD.Checked Then sel.Add("D")
            correctOptions = String.Join(",", sel)
        Else
            correctOptions = txtModelAnswer.Text.Trim()
        End If

        Dim imgPath = ""
        If fuImage.HasFile Then
            Try
                Dim folder = Server.MapPath("~/Images/Questions/")
                If Not System.IO.Directory.Exists(folder) Then System.IO.Directory.CreateDirectory(folder)
                Dim ext = System.IO.Path.GetExtension(fuImage.FileName).ToLower()
                Dim fName = Guid.NewGuid().ToString() & ext
                fuImage.SaveAs(folder & fName)
                imgPath = "Images/Questions/" & fName
            Catch ex As Exception
                litError.Text = "Image upload failed: " & ex.Message : pnlError.Visible = True : Return
            End Try
        End If

        DBHelper.ExecuteNonQuery( _
            "INSERT INTO QuestionsTable (SubjectID,QuestionStatement,OptionA,OptionB,OptionC,OptionD,CorrectOption,DifficultyLevel,CreatedBy,QuestionType,CorrectOptions,ImagePath) " & _
            "VALUES (@sid,@stmt,@a,@b,@c,@d,@co,@diff,@by,@qt,@cops,@img)", _
            DBHelper.Param("@sid", CInt(ddlSubject.SelectedValue)), _
            DBHelper.Param("@stmt", txtStatement.Text.Trim()), _
            DBHelper.Param("@a", txtA.Text.Trim()), _
            DBHelper.Param("@b", txtB.Text.Trim()), _
            DBHelper.Param("@c", txtC.Text.Trim()), _
            DBHelper.Param("@d", txtD.Text.Trim()), _
            DBHelper.Param("@co", If(qType="Radio", correctOptions, "A")), _
            DBHelper.Param("@diff", ddlDifficulty.SelectedValue), _
            DBHelper.Param("@by", CInt(Session("UserID"))), _
            DBHelper.Param("@qt", qType), _
            DBHelper.Param("@cops", correctOptions), _
            DBHelper.Param("@img", If(imgPath="", DBNull.Value, imgPath)))

        pnlSuccess.Visible = True
        txtStatement.Text = "" : txtA.Text = "" : txtB.Text = "" : txtC.Text = "" : txtD.Text = ""
    End Sub
End Class
