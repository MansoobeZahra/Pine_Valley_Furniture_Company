Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class RegistrationPage
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Session("Username") Is Nothing Then Response.Redirect("Login.aspx?reason=timeout")
        Dim isAdmin As Boolean = (Session("UserRole").ToString().ToLower() = "admin")
        ' Registration page is admin-only
        If Not isAdmin Then Response.Redirect("Update.aspx")
        lnkRegistration.Visible = True
        lnkCatalog.Visible = True
        lnkSegmentation.Visible = True
        lnkForecasting.Visible = True
        If Not IsPostBack Then lblWelcome.Text = "Welcome, " & Session("Username") & " (" & Session("UserRole") & ")"
    End Sub

    Protected Sub Logout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then Return

        Using conn As New SqlConnection(ConnStr)
            Try
                conn.Open()
                ' Get next Customer_Id (non-IDENTITY schema)
                Dim newId As Integer
                Using cmdMax As New SqlCommand("SELECT ISNULL(MAX(Customer_Id), 0) + 1 FROM CUSTOMER_t", conn)
                    newId = Convert.ToInt32(cmdMax.ExecuteScalar())
                End Using

                Dim sql As String = "INSERT INTO CUSTOMER_t (Customer_Id, Customer_Name, Customer_Address, Customer_City, Customer_State, Postal_Code) VALUES (@id, @name, @addr, @city, @state, @zip)"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@id", newId)
                    cmd.Parameters.AddWithValue("@name", (txtFirstName.Text.Trim() & " " & txtLastName.Text.Trim()).Trim())
                    cmd.Parameters.AddWithValue("@addr", txtAddress.Text.Trim())
                    cmd.Parameters.AddWithValue("@city", txtCity.Text.Trim())
                    cmd.Parameters.AddWithValue("@state", txtState.Text.Trim())
                    cmd.Parameters.AddWithValue("@zip", txtPostalCode.Text.Trim())
                    cmd.ExecuteNonQuery()
                End Using

                lblMessage.Text = "Registration Successful! Customer ID: " & newId
                lblMessage.ForeColor = System.Drawing.Color.Green
            Catch ex As Exception
                lblMessage.Text = "Database Error: " & ex.Message
                lblMessage.ForeColor = System.Drawing.Color.Red
            End Try
        End Using
        lblMessage.Visible = True
    End Sub


    Protected Sub btnClear_Click(ByVal sender As Object, ByVal e As EventArgs)
        txtFirstName.Text = ""
        txtLastName.Text = ""
        txtAddress.Text = ""
        txtCity.Text = ""
        txtState.Text = ""
        txtPostalCode.Text = ""
        lblMessage.Visible = False
    End Sub
End Class
