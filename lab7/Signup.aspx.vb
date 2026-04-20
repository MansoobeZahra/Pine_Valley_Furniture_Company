Imports System.Data.SqlClient
Imports System.Configuration

Partial Class SignupPage
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString
        End Get
    End Property

    Protected Sub btnSignup_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then Return

        Using conn As New SqlConnection(ConnStr)
            Try
                conn.Open()

                ' ── 1. Check if username already taken ──────────────────────
                Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Users WHERE Username = @u", conn)
                    cmdCheck.Parameters.AddWithValue("@u", txtUsername.Text.Trim())
                    If Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0 Then
                        lblMessage.Text = "Username already exists. Please choose another."
                        lblMessage.ForeColor = System.Drawing.Color.Red
                        lblMessage.Visible = True
                        Return
                    End If
                End Using

                ' ── 2. Get next Customer_Id (non-IDENTITY schema) ───────────
                Dim newCustId As Integer
                Using cmdMaxCust As New SqlCommand("SELECT ISNULL(MAX(Customer_Id), 0) + 1 FROM CUSTOMER_t", conn)
                    newCustId = Convert.ToInt32(cmdMaxCust.ExecuteScalar())
                End Using

                ' ── 3. Insert into CUSTOMER_t ────────────────────────────────
                Dim custName As String = (txtFirstName.Text.Trim() & " " & txtLastName.Text.Trim()).Trim()
                Using cmdCust As New SqlCommand(
                    "INSERT INTO CUSTOMER_t (Customer_Id, Customer_Name, Customer_Address, Customer_City, Customer_State, Postal_Code) " &
                    "VALUES (@id, @name, @addr, @city, @state, @zip)", conn)
                    cmdCust.Parameters.AddWithValue("@id",    newCustId)
                    cmdCust.Parameters.AddWithValue("@name",  custName)
                    cmdCust.Parameters.AddWithValue("@addr",  txtAddress.Text.Trim())
                    cmdCust.Parameters.AddWithValue("@city",  txtCity.Text.Trim())
                    cmdCust.Parameters.AddWithValue("@state", txtState.Text.Trim())
                    cmdCust.Parameters.AddWithValue("@zip",   txtPostalCode.Text.Trim())
                    cmdCust.ExecuteNonQuery()
                End Using

                ' ── 4. Insert into Users table (role = "user") ──────────────
                Using cmdUser As New SqlCommand(
                    "INSERT INTO Users (Username, User_Password, User_Role) VALUES (@u, @p, 'user')", conn)
                    cmdUser.Parameters.AddWithValue("@u", txtUsername.Text.Trim())
                    cmdUser.Parameters.AddWithValue("@p", txtPassword.Text.Trim())
                    cmdUser.ExecuteNonQuery()
                End Using

                ' ── 5. Success ───────────────────────────────────────────────
                lblMessage.Text = "Account created! Your Customer ID is <b>" & newCustId & "</b>. <a href='Login.aspx'>Click here to login.</a>"
                lblMessage.ForeColor = System.Drawing.Color.Green
                lblMessage.Visible = True

                ' Clear form
                txtUsername.Text = "" : txtPassword.Text = ""
                txtFirstName.Text = "" : txtLastName.Text = ""
                txtAddress.Text = "" : txtCity.Text = ""
                txtState.Text = "" : txtPostalCode.Text = ""

            Catch ex As Exception
                lblMessage.Text = "Error: " & ex.Message
                lblMessage.ForeColor = System.Drawing.Color.Red
                lblMessage.Visible = True
            End Try
        End Using
    End Sub
End Class
