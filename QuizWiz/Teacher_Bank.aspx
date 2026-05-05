<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Teacher_Bank.aspx.vb" Inherits="Teacher_ManageQuestions" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>
<%@ Register Src="~/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>QuizWiz - Question Bank</title>
    <link href="Styles/site.css" rel="stylesheet" />
</head>
<body style="margin:0; padding:0;">
<form id="form1" runat="server">
    <uc:Header runat="server" ID="Header" />
    <div class="layout-container">
        <uc:Navbar runat="server" ID="Navbar" />
        <div class="main-area">
            <h1>Question Bank</h1>
            <hr />

            <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert">
                <asp:Literal ID="litMsg" runat="server" />
            </asp:Panel>

            <a href="Teacher_AddQ.aspx" class="btn btn-blue">Add New Question</a>
            <br /><br />

            <div style="border:1px solid #0078d4; padding:10px; background:#f0f7ff; margin-bottom:10px;">
                <b>Filters:</b><br />
                Subject: <asp:DropDownList ID="ddlFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFilter_Changed" />
                Difficulty: 
                <asp:DropDownList ID="ddlDiffFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFilter_Changed">
                    <asp:ListItem Value="">All</asp:ListItem>
                    <asp:ListItem>Easy</asp:ListItem>
                    <asp:ListItem>Medium</asp:ListItem>
                    <asp:ListItem>Hard</asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:GridView ID="gvQuestions" runat="server" AutoGenerateColumns="false" Width="100%"
                OnRowCommand="gvQuestions_RowCommand" OnRowEditing="gvQuestions_RowEditing"
                OnRowCancelingEdit="gvQuestions_CancelEdit" OnRowUpdating="gvQuestions_RowUpdating"
                DataKeyNames="QuestionID" BorderStyle="Solid" BorderWidth="1px">
                <Columns>
                    <asp:BoundField DataField="QuestionID" HeaderText="ID" ReadOnly="true" />
                    <asp:TemplateField HeaderText="Question">
                        <ItemTemplate><%# Eval("QuestionStatement") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditStmt" runat="server" TextMode="MultiLine" Rows="2" Width="100%" Text='<%# Eval("QuestionStatement") %>' />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="SubjectName" HeaderText="Subject" ReadOnly="true" />
                    <asp:TemplateField HeaderText="Difficulty">
                        <ItemTemplate><%# Eval("DifficultyLevel") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditDiff" runat="server">
                                <asp:ListItem>Easy</asp:ListItem>
                                <asp:ListItem>Medium</asp:ListItem>
                                <asp:ListItem>Hard</asp:ListItem>
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CorrectOptions" HeaderText="Ans" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton CommandName="Edit" runat="server" Text="Edit" style="color:blue;" /> |
                            <asp:LinkButton CommandName="DeleteQ" runat="server" CommandArgument='<%# Eval("QuestionID") %>' Text="Delete" style="color:red;" OnClientClick="return confirm('Delete?')" />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton CommandName="Update" runat="server" Text="Save" style="color:green;" /> |
                            <asp:LinkButton CommandName="Cancel" runat="server" Text="Cancel" style="color:gray;" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</form>
</body>
</html>
