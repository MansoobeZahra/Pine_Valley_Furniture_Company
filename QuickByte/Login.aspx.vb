Imports System.Data.SqlClient
Imports System.Web.Security

Partial Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If User.Identity.IsAuthenticated Then
                Response.Redirect("Default.aspx")
            End If
        End If
    End Sub

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim email As String = txtEmail.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()
        
        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString
        
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT UserID, Role, ReferenceID FROM Users_QB WHERE Email = @Email AND PasswordHash = @Password"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@Password", password)
                
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        Dim role As String = reader("Role").ToString()
                        Dim refId As Object = reader("ReferenceID")
                        
                        ' Create auth ticket with role
                        Dim ticket As New FormsAuthenticationTicket(1, email, DateTime.Now, DateTime.Now.AddMinutes(60), chkRememberMe.Checked, role)
                        Dim encryptedTicket As String = FormsAuthentication.Encrypt(ticket)
                        Dim cookie As New HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)
                        Response.Cookies.Add(cookie)
                        
                        Session("Role") = role
                        If Not IsDBNull(refId) Then
                            Session("ReferenceID") = Convert.ToInt32(refId)
                        End If
                        
                        ' Redirect based on role
                        Select Case role
                            Case "Customer"
                                Response.Redirect("Default.aspx")
                            Case "RestaurantManager"
                                Response.Redirect("Menu.aspx")
                            Case "Rider"
                                Response.Redirect("RiderDashboard.aspx")
                            Case "Admin", "PlatformManager"
                                Response.Redirect("AdminDashboard.aspx")
                            Case Else
                                Response.Redirect("Default.aspx")
                        End Select
                    Else
                        lblError.Text = "Invalid email or password."
                        lblError.Visible = True
                    End If
                End Using
            End Using
        End Using
    End Sub
End Class
