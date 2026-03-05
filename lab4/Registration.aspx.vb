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
        ' No Page_Load logic needed at this time.
    End Sub

    Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim conn As New SqlConnection(ConnStr)
        Dim cmd As New SqlCommand
        cmd.Connection = conn
        
        cmd.CommandText = "INSERT INTO CUSTOMER_t ([Customer_Name]"
        cmd.CommandText &= ", [Customer_Address]"
        cmd.CommandText &= ", [Customer_City]"
        cmd.CommandText &= ", [Customer_State]"
        cmd.CommandText &= ", [Postal_Code])"
        
        cmd.CommandText &= " VALUES ('" & (txtFirstName.Text.Trim() & " " & txtLastName.Text.Trim()).Trim() & "',"
        cmd.CommandText &= "'" & txtAddress.Text.Trim() & "',"
        cmd.CommandText &= "'" & txtCity.Text.Trim() & "',"
        cmd.CommandText &= "'" & txtState.Text.Trim() & "',"
        cmd.CommandText &= "'" & txtPostalCode.Text.Trim() & "')"

        Dim inserted As Integer = 0
        Try
            conn.Open()
            inserted = cmd.ExecuteNonQuery()
            If inserted = 1 Then
                lblMessage.Text = inserted & " customer record inserted."
                ' Note: To show the ID, we'd need a separate query like in previous steps, 
                ' but I'm following the slide's "inserted & ' customer record inserted'" style.
            Else
                lblMessage.Text = "no record inserted"
            End If
        Catch ex As Exception
            lblMessage.Text = ex.Message
        Finally
            cmd.Dispose()
            conn.Close()
        End Try
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
