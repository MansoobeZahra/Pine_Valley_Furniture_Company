Imports System
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class UpdatePage
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Session("Username") Is Nothing Then Response.Redirect("Login.aspx?reason=timeout")
        Dim isAdmin As Boolean = (Session("UserRole").ToString() = "admin")
        lnkRegistration.Visible = isAdmin
        lnkCatalog.Visible = True
        lnkSegmentation.Visible = isAdmin
        If Not IsPostBack Then
            lblWelcome.Text = "Welcome, " & Session("Username") & " (" & Session("UserRole") & ")"
            If Session("CustomerID") IsNot Nothing Then txtCustomerID.Text = Session("CustomerID").ToString()
        End If
    End Sub

    Protected Sub Logout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then Return

        Dim custId As Integer
        If Not Integer.TryParse(txtCustomerID.Text.Trim(), custId) Then
            lblMessage.Text = "Error: Customer ID must be a number."
            lblMessage.ForeColor = System.Drawing.Color.Red
            lblMessage.Visible = True
            Return
        End If

        Using conn As New SqlConnection(ConnStr)
            Dim sql As String = "UPDATE CUSTOMER_t SET " & _
                               "Customer_Name = @name, " & _
                               "Customer_Address = @addr, " & _
                               "Customer_City = @city, " & _
                               "Customer_State = @state, " & _
                               "Postal_Code = @zip " & _
                               "WHERE Customer_Id = @id"

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@name", (txtFirstName.Text.Trim() & " " & txtLastName.Text.Trim()).Trim())
                cmd.Parameters.AddWithValue("@addr", txtAddress.Text.Trim())
                cmd.Parameters.AddWithValue("@city", txtCity.Text.Trim())
                cmd.Parameters.AddWithValue("@state", txtState.Text.Trim())
                cmd.Parameters.AddWithValue("@zip", txtPostalCode.Text.Trim())
                cmd.Parameters.AddWithValue("@id", custId)

                Try
                    conn.Open()
                    Dim rows As Integer = cmd.ExecuteNonQuery()
                    If rows > 0 Then
                        lblMessage.Text = "Customer #" & custId & " updated successfully!"
                        lblMessage.ForeColor = System.Drawing.Color.Green
                    Else
                        lblMessage.Text = "No customer found with ID: " & custId & ". Check your Customer ID."
                        lblMessage.ForeColor = System.Drawing.Color.Red
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
        txtCustomerID.Text = ""
        txtFirstName.Text = ""
        txtLastName.Text = ""
        txtAddress.Text = ""
        txtCity.Text = ""
        txtState.Text = ""
        txtPostalCode.Text = ""
        lblMessage.Visible = False
    End Sub

End Class
