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
        ' No Logic needed for Page_Load for Search.aspx.vb
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
