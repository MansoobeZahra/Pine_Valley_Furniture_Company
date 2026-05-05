Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class Teacher_AddQuestion
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("QuizWizDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("UserID") Is Nothing OrElse Session("Role").ToString() <> "Teacher" Then
            Response.Redirect("Login.aspx")
            Return
        End If
        If Not IsPostBack Then LoadSubjects()
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

        Using conn As New SqlConnection(connStr)
            Dim sql = "INSERT INTO QuestionsTable (SubjectID,QuestionStatement,OptionA,OptionB,OptionC,OptionD,CorrectOption,DifficultyLevel,CreatedBy,QuestionType,CorrectOptions) " & _
                      "VALUES (@sid,@stmt,@a,@b,@c,@d,@co,@diff,@by,@qt,@cops)"
            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@sid", CInt(ddlSubject.SelectedValue))
            cmd.Parameters.AddWithValue("@stmt", txtStatement.Text.Trim())
            cmd.Parameters.AddWithValue("@a", txtA.Text.Trim())
            cmd.Parameters.AddWithValue("@b", txtB.Text.Trim())
            cmd.Parameters.AddWithValue("@c", txtC.Text.Trim())
            cmd.Parameters.AddWithValue("@d", txtD.Text.Trim())
            cmd.Parameters.AddWithValue("@co", If(qType = "Radio", correctOptions, "A"))
            cmd.Parameters.AddWithValue("@diff", ddlDifficulty.SelectedValue)
            cmd.Parameters.AddWithValue("@by", CInt(Session("UserID")))
            cmd.Parameters.AddWithValue("@qt", qType)
            cmd.Parameters.AddWithValue("@cops", correctOptions)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using

        pnlSuccess.Visible = True
        txtStatement.Text = "" : txtA.Text = "" : txtB.Text = "" : txtC.Text = "" : txtD.Text = ""
    End Sub
End Class
