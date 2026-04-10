Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class SearchPage
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("PineValleyDB").ConnectionString
        End Get
    End Property

    Private Shared ReadOnly LineNames As New Dictionary(Of Integer, String) From {
        {1, "Living Room"},
        {2, "Dining Room"},
        {3, "Bedroom"},
        {4, "Office"}
    }

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Session("Username") Is Nothing Then Response.Redirect("Login.aspx")
        lnkCatalog.Visible = (Session("UserRole").ToString() = "admin")
        If Not IsPostBack Then
            lblWelcome.Text = "Welcome, " & Session("Username") & " (" & Session("UserRole") & ")"
            If Session("Cart") Is Nothing Then
                Dim dtCart As New DataTable()
                dtCart.Columns.Add("ProductId", GetType(Integer))
                dtCart.Columns.Add("Description", GetType(String))
                dtCart.Columns.Add("Quantity", GetType(Integer))
                dtCart.Columns.Add("Price", GetType(Decimal))
                dtCart.Columns.Add("Subtotal", GetType(Decimal))
                Session("Cart") = dtCart
            End If
            UpdateCartDisplay()
        End If
    End Sub

    Protected Sub Logout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    Protected Sub gvResults_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "AddToCart" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvResults.Rows(index)
            Dim productId As Integer = Convert.ToInt32(gvResults.DataKeys(index).Value)
            Dim desc As String = row.Cells(0).Text
            Dim price As Decimal = Decimal.Parse(row.Cells(3).Text, System.Globalization.NumberStyles.Currency)
            Dim txtQty As TextBox = DirectCast(row.FindControl("txtQty"), TextBox)
            Dim qty As Integer = 1
            Integer.TryParse(txtQty.Text, qty)

            Dim dtCart As DataTable = DirectCast(Session("Cart"), DataTable)
            ' Check if item exists, if so update qty
            Dim existingRow As DataRow() = dtCart.Select("ProductId = " & productId)
            If existingRow.Length > 0 Then
                existingRow(0)("Quantity") = Convert.ToInt32(existingRow(0)("Quantity")) + qty
                existingRow(0)("Subtotal") = Convert.ToDecimal(existingRow(0)("Quantity")) * price
            Else
                Dim newRow As DataRow = dtCart.NewRow()
                newRow("ProductId") = productId
                newRow("Description") = desc
                newRow("Quantity") = qty
                newRow("Price") = price
                newRow("Subtotal") = qty * price
                dtCart.Rows.Add(newRow)
            End If

            Session("Cart") = dtCart
            UpdateCartDisplay()
        End If
    End Sub

    Private Sub UpdateCartDisplay()
        Dim dtCart As DataTable = DirectCast(Session("Cart"), DataTable)
        If dtCart IsNot Nothing AndAlso dtCart.Rows.Count > 0 Then
            gvCart.DataSource = dtCart
            gvCart.DataBind()
            cartSummary.Visible = True

            Dim total As Decimal = 0
            For Each row As DataRow In dtCart.Rows
                total += Convert.ToDecimal(row("Subtotal"))
            Next
            lblTotal.Text = String.Format("{0:C}", total)
        Else
            cartSummary.Visible = False
        End If
    End Sub

    Protected Sub btnGoToOrder_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("Order.aspx")
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim sql As String = "SELECT Product_Id, Product_Description, Product_Line_Id, Product_Finish, Standard_Price " & _
                               "FROM PRODUCT_t WHERE 1 = 1"

            Dim parms As New List(Of SqlParameter)()


            If Not String.IsNullOrWhiteSpace(txtProductDesc.Text) Then
                sql &= " AND Product_Description LIKE @desc"
                parms.Add(New SqlParameter("@desc", "%" & txtProductDesc.Text.Trim() & "%"))
            End If

            If Not String.IsNullOrWhiteSpace(ddlProductLine.SelectedValue) Then
                sql &= " AND Product_Line_Id = @lineId"
                parms.Add(New SqlParameter("@lineId", Integer.Parse(ddlProductLine.SelectedValue)))
            End If

            sql &= " ORDER BY Product_Id"

            Dim dt As New DataTable()
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddRange(parms.ToArray())
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using

            dt.Columns.Add("ProductLineName", GetType(String))
            For Each row As DataRow In dt.Rows
                Dim id As Integer = Convert.ToInt32(row("Product_Line_Id"))
                row("ProductLineName") = If(LineNames.ContainsKey(id), LineNames(id), id.ToString())
            Next

            gvResults.DataSource = dt
            gvResults.DataBind()
            gvResults.Visible = True
            lblMessage.Visible = False
        Catch ex As Exception
            lblMessage.Text = "Error: " & ex.Message
            lblMessage.ForeColor = System.Drawing.Color.Red
            lblMessage.Visible = True
        End Try
    End Sub

    Protected Sub btnClear_Click(ByVal sender As Object, ByVal e As EventArgs)
        txtProductDesc.Text = ""
        ddlProductLine.SelectedIndex = 0
        gvResults.Visible = False
        lblMessage.Visible = False
    End Sub
End Class
