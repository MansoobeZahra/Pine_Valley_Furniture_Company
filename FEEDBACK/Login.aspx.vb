Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Already logged in -> redirect
        If Session("UserID") IsNot Nothing Then
            RedirectByRole(Session("RoleName").ToString())
        End If

        If Not IsPostBack Then
            If Request.QueryString("registered") = "1" Then
                pnlSuccess.Visible = True
                litSuccess.Text = "Registration successful! Please sign in."
            End If
        End If
    End Sub

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then Return

        Dim connStr As String = ConfigurationManager.ConnectionStrings("SurveyDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("sp_ValidateUser", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim())
                cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim())
                conn.Open()
                Using dr As SqlDataReader = cmd.ExecuteReader()
                    If dr.Read() Then
                        Session("UserID")   = dr("UserID")
                        Session("Username") = dr("Username")
                        Session("FullName") = dr("FullName")
                        Session("Email")    = dr("Email")
                        Session("RoleID")   = dr("RoleID")
                        Session("RoleName") = dr("RoleName")
                        RedirectByRole(dr("RoleName").ToString())
                    Else
                        pnlError.Visible = True
                        litError.Text = "Invalid username or password. Please try again."
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub RedirectByRole(role As String)
        Select Case role
            Case "Survey Administrator"
                Response.Redirect("/FEEDBACK/Admin/Dashboard.aspx")
            Case "Survey Builder"
                Response.Redirect("/FEEDBACK/Builder/Dashboard.aspx")
            Case "Surveyor"
                Response.Redirect("/FEEDBACK/Surveyor/Dashboard.aspx")
            Case Else
                Response.Redirect("/FEEDBACK/Login.aspx")
        End Select
    End Sub
End Class

