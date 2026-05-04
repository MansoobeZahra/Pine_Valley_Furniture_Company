Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class Admin_ManageUsers
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("RoleName") Is Nothing OrElse Session("RoleName").ToString() <> "Survey Administrator" Then
            Response.Redirect("/FEEDBACK/Login.aspx")
        End If
        If Not IsPostBack Then LoadUsers("")
    End Sub

    Private Sub LoadUsers(filter As String)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT u.UserID, u.Username, u.FullName, u.Email, u.IsActive, u.CreatedDate, r.RoleName " &
                                "FROM UsersSurvey u INNER JOIN Roles r ON u.RoleID=r.RoleID "
            If Not String.IsNullOrEmpty(filter) Then
                sql &= "WHERE u.FullName LIKE @f OR u.Username LIKE @f "
            End If
            sql &= "ORDER BY u.CreatedDate DESC"
            Dim cmd As New SqlCommand(sql, conn)
            If Not String.IsNullOrEmpty(filter) Then
                cmd.Parameters.AddWithValue("@f", "%" & filter & "%")
            End If
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            conn.Open()
            da.Fill(dt)
            gvUsers.DataSource = dt
            gvUsers.DataBind()
        End Using
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        LoadUsers(txtSearch.Text.Trim())
    End Sub

    Protected Sub gvUsers_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "ToggleStatus" Then
            Dim parts = e.CommandArgument.ToString().Split("|")
            Dim uid       As Integer = Integer.Parse(parts(0))
            Dim curStatus As Boolean = Boolean.Parse(parts(1))
            Dim newStatus As Integer = If(curStatus, 0, 1)

            Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("UPDATE UsersSurvey SET IsActive=@s WHERE UserID=@u", conn)
                cmd.Parameters.AddWithValue("@s", newStatus)
                cmd.Parameters.AddWithValue("@u", uid)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using

            pnlMsg.Visible = True
            litMsg.Text = "User status updated successfully."
            LoadUsers("")
        End If
    End Sub
End Class

