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
    End Sub

    Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then Return

        Using conn As New SqlConnection(ConnStr)
            Dim sql As String = "INSERT INTO CUSTOMER_t (Customer_Name, Customer_Address, Customer_City, Customer_State, Postal_Code) " & _
                               "VALUES (@name, @addr, @city, @state, @zip); SELECT SCOPE_IDENTITY();"
            
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@name", (txtFirstName.Text.Trim() & " " & txtLastName.Text.Trim()).Trim())
                cmd.Parameters.AddWithValue("@addr", txtAddress.Text.Trim())
                cmd.Parameters.AddWithValue("@city", txtCity.Text.Trim())
                cmd.Parameters.AddWithValue("@state", txtState.Text.Trim())
                cmd.Parameters.AddWithValue("@zip", txtPostalCode.Text.Trim())

                Try
                    conn.Open()
                    Dim newId As Object = cmd.ExecuteScalar()
                    If newId IsNot Nothing Then
                        Session("CustomerID") = newId.ToString()
                        lblMessage.Text = "Registration Successful! Customer ID: " & Session("CustomerID")
                        lblMessage.ForeColor = System.Drawing.Color.Green
                    End If
                Catch ex As Exception
                    lblMessage.Text = "Database Error: " & ex.Message
                    lblMessage.ForeColor = System.Drawing.Color.Red
                End Try
            End Using
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
