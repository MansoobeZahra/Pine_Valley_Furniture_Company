Imports System.Data
Imports System.Web.UI.WebControls

Partial Class Admin_ManageUsers
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        AuthHelper.RequireRole(Me, "Admin")
        If Not IsPostBack Then LoadUsers()
    End Sub

    Private Sub LoadUsers()
        Dim sql = "SELECT UserID, FullName, Username, Role, IsActive FROM Users2"
        If ddlFilter.SelectedValue <> "" Then sql &= " WHERE Role = @r"
        gvUsers.DataSource = DBHelper.GetDataTable(sql, DBHelper.Param("@r", ddlFilter.SelectedValue))
        gvUsers.DataBind()
    End Sub

    Protected Sub btnShowAdd_Click(sender As Object, e As EventArgs)
        hfEditID.Value = "0"
        txtFullName.Text = "" : txtUsername.Text = "" : txtPassword.Text = ""
        pnlForm.Visible = True
    End Sub

    Protected Sub btnCancelForm_Click(sender As Object, e As EventArgs)
        pnlForm.Visible = False
    End Sub

    Protected Sub ddlFilter_Changed(sender As Object, e As EventArgs)
        LoadUsers()
    End Sub

    Protected Sub gvUsers_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim uid = CInt(e.CommandArgument)
        If e.CommandName = "ToggleActive" Then
            DBHelper.ExecuteNonQuery("UPDATE Users2 SET IsActive = 1 - IsActive WHERE UserID=@id", DBHelper.Param("@id", uid))
            LoadUsers()
        ElseIf e.CommandName = "EditUser" Then
            Dim dt = DBHelper.GetDataTable("SELECT * FROM Users2 WHERE UserID=@id", DBHelper.Param("@id", uid))
            Dim row = dt.Rows(0)
            hfEditID.Value = uid.ToString()
            txtFullName.Text = row("FullName").ToString()
            txtUsername.Text = row("Username").ToString()
            ddlRole.SelectedValue = row("Role").ToString()
            pnlForm.Visible = True
        End If
    End Sub

    Protected Sub btnSaveUser_Click(sender As Object, e As EventArgs)
        Dim editID = CInt(hfEditID.Value)
        If editID = 0 Then
            DBHelper.ExecuteNonQuery("INSERT INTO Users2 (FullName,Username,Password,Role,IsActive) VALUES (@n,@u,@p,@r,1)", _
                DBHelper.Param("@n", txtFullName.Text), DBHelper.Param("@u", txtUsername.Text), DBHelper.Param("@p", txtPassword.Text), DBHelper.Param("@r", ddlRole.SelectedValue))
        Else
            DBHelper.ExecuteNonQuery("UPDATE Users2 SET FullName=@n,Username=@u,Role=@r WHERE UserID=@id", _
                DBHelper.Param("@n", txtFullName.Text), DBHelper.Param("@u", txtUsername.Text), DBHelper.Param("@r", ddlRole.SelectedValue), DBHelper.Param("@id", editID))
        End If
        pnlForm.Visible = False
        LoadUsers()
    End Sub
End Class
