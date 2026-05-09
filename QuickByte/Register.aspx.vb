Imports System.Data.SqlClient

Partial Class Register
    Inherits System.Web.UI.Page

    Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim role As String = ddlUserType.SelectedValue
        If String.IsNullOrEmpty(role) Then
            ShowMessage("Please select a role.")
            Return
        End If

        If txtPassword.Text <> txtConfirmPassword.Text Then
            ShowMessage("Passwords do not match.")
            Return
        End If

        Dim region As String = ddlRegion.SelectedValue
        If String.IsNullOrEmpty(region) Then
            ShowMessage("Please select a region.")
            Return
        End If

        Dim email As String = txtEmail.Text.Trim()
        Dim password As String = txtPassword.Text
        Dim phone As String = txtPhone.Text.Trim()

        Dim connString As String = ConfigurationManager.ConnectionStrings("FoodserviceDB").ConnectionString

        Using conn As New SqlConnection(connString)
            conn.Open()
            
            ' Check if email exists
            Dim checkQuery As String = "SELECT COUNT(*) FROM Users_QB WHERE Email = @Email"
            Using checkCmd As New SqlCommand(checkQuery, conn)
                checkCmd.Parameters.AddWithValue("@Email", email)
                If Convert.ToInt32(checkCmd.ExecuteScalar()) > 0 Then
                    ShowMessage("Email already exists. Please login.")
                    Return
                End If
            End Using

            ' Transaction to ensure both Entity table and Users table are populated
            Dim transaction As SqlTransaction = conn.BeginTransaction()
            Try
                Dim newRefId As Integer = 0

                If role = "Customer" Then
                    Dim insertCust As String = "INSERT INTO Customer_QB (FirstName, LastName, Email, PhoneNumber, Region) OUTPUT INSERTED.CustomerID VALUES (@FirstName, @LastName, @Email, @Phone, @Region)"
                    Using cmd As New SqlCommand(insertCust, conn, transaction)
                        cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim())
                        cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim())
                        cmd.Parameters.AddWithValue("@Email", email)
                        cmd.Parameters.AddWithValue("@Phone", phone)
                        cmd.Parameters.AddWithValue("@Region", region)
                        newRefId = Convert.ToInt32(cmd.ExecuteScalar())
                    End Using

                Else If role = "Rider" Then
                    Dim insertRider As String = "INSERT INTO Rider_QB (Name, ContactNumber, Availability, Region) OUTPUT INSERTED.RiderID VALUES (@Name, @ContactNumber, @Availability, @Region)"
                    Using cmd As New SqlCommand(insertRider, conn, transaction)
                        cmd.Parameters.AddWithValue("@Name", txtFirstName.Text.Trim() & " " & txtLastName.Text.Trim())
                        cmd.Parameters.AddWithValue("@ContactNumber", phone)
                        cmd.Parameters.AddWithValue("@Availability", chkAvailability.Checked)
                        cmd.Parameters.AddWithValue("@Region", region)
                        newRefId = Convert.ToInt32(cmd.ExecuteScalar())
                    End Using
                End If

                ' Now insert into Users
                Dim insertUser As String = "INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID, Region) VALUES (@Email, @Password, @Role, @RefID, @Region)"
                Using cmd As New SqlCommand(insertUser, conn, transaction)
                    cmd.Parameters.AddWithValue("@Email", email)
                    cmd.Parameters.AddWithValue("@Password", password) 
                    cmd.Parameters.AddWithValue("@Role", role)
                    cmd.Parameters.AddWithValue("@RefID", newRefId)
                    cmd.Parameters.AddWithValue("@Region", region)
                    cmd.ExecuteNonQuery()
                End Using

                transaction.Commit()
                lblMessage.ForeColor = System.Drawing.Color.Green
                lblMessage.Text = "Registration successful! You can now <a href='Login.aspx'>Login</a>."
                lblMessage.Visible = True

            Catch ex As Exception
                transaction.Rollback()
                ShowMessage("An error occurred during registration: " & ex.Message)
            End Try
        End Using
    End Sub

    Private Sub ShowMessage(ByVal msg As String)
        lblMessage.ForeColor = System.Drawing.Color.Red
        lblMessage.Text = msg
        lblMessage.Visible = True
    End Sub
End Class
