<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Teacher_CreateQuiz.aspx.vb" Inherits="Teacher_CreateQuiz" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>
<%@ Register Src="~/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>QuizWiz - Create Quiz</title>
    <link href="Styles/site.css" rel="stylesheet" />
</head>
<body style="margin:0; padding:0;">
<form id="form1" runat="server">
    <uc:Header runat="server" ID="Header" />
    <div class="layout-container">
        <uc:Navbar runat="server" ID="Navbar" />
        <div class="main-area">
            <h1>Create Quiz</h1>
            <hr />

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-err">
                <asp:Literal ID="litError" runat="server" />
            </asp:Panel>

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-ok">
                <asp:Literal ID="litSuccess" runat="server" />
            </asp:Panel>

            <asp:MultiView ID="mvWizard" runat="server" ActiveViewIndex="0">

                <asp:View ID="vStep1" runat="server">
                    <div class="main-area" style="border:1px solid #0078d4; margin:0;">
                        <h3 style="margin-top:0;">1. Settings</h3>
                        Title: <asp:TextBox ID="txtTitle" runat="server" /><br />
                        Subject: <asp:DropDownList ID="ddlSubject" runat="server" /><br />
                        Questions Goal: <asp:TextBox ID="txtTotalQ" runat="server" Text="10" Width="50px" /><br />
                        Time (min): <asp:TextBox ID="txtTime" runat="server" Text="30" Width="50px" /><br />
                        <asp:CheckBox ID="chkRandomize" runat="server" Text=" Randomize" Checked="true" /><br />
                        <br />
                        <asp:Button ID="btnStep1Next" runat="server" Text="Next Step" CssClass="btn btn-blue" OnClick="btnStep1Next_Click" />
                    </div>
                </asp:View>

                <asp:View ID="vStep2" runat="server">
                    <asp:HiddenField ID="hfQuizID" runat="server" />
                    <div style="display:flex; gap:10px;">
                        <div style="flex:1; border:1px solid #ccc; padding:10px;">
                            <h3>2. Add Questions</h3>
                            <asp:Button ID="btnTabNew" runat="server" Text="Write" OnClick="btnTabNew_Click" CssClass="btn" />
                            <asp:Button ID="btnTabBank" runat="server" Text="Bank" OnClick="btnTabBank_Click" CssClass="btn" />
                            <hr />
                            <asp:Panel ID="pnlWriteNew" runat="server">
                                Text: <asp:TextBox ID="txtQStmt" runat="server" TextMode="MultiLine" Rows="2" Width="100%" /><br />
                                Type: <asp:DropDownList ID="ddlQType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlQType_Changed">
                                    <asp:ListItem Value="Radio">Single</asp:ListItem>
                                    <asp:ListItem Value="Checkbox">Multiple</asp:ListItem>
                                </asp:DropDownList><br />

                                A: <asp:RadioButton ID="rbAnsA" runat="server" GroupName="NewQ" Checked="true" /><asp:CheckBox ID="cbAnsA" runat="server" Visible="false" /><asp:TextBox ID="txtOptA" runat="server" /><br />
                                B: <asp:RadioButton ID="rbAnsB" runat="server" GroupName="NewQ" /><asp:CheckBox ID="cbAnsB" runat="server" Visible="false" /><asp:TextBox ID="txtOptB" runat="server" /><br />
                                C: <asp:RadioButton ID="rbAnsC" runat="server" GroupName="NewQ" /><asp:CheckBox ID="cbAnsC" runat="server" Visible="false" /><asp:TextBox ID="txtOptC" runat="server" /><br />
                                D: <asp:RadioButton ID="rbAnsD" runat="server" GroupName="NewQ" /><asp:CheckBox ID="cbAnsD" runat="server" Visible="false" /><asp:TextBox ID="txtOptD" runat="server" /><br />
                                <asp:Button ID="btnSaveQ" runat="server" Text="Save & Add" OnClick="btnSaveQ_Click" CssClass="btn btn-green" />
                            </asp:Panel>
                            <asp:Panel ID="pnlSelectBank" runat="server" Visible="false">
                                <asp:GridView ID="gvBank" runat="server" AutoGenerateColumns="false" DataKeyNames="QuestionID">
                                    <Columns>
                                        <asp:TemplateField><ItemTemplate><asp:CheckBox ID="chkSelect" runat="server" /></ItemTemplate></asp:TemplateField>
                                        <asp:BoundField DataField="QuestionStatement" HeaderText="Q" />
                                    </Columns>
                                </asp:GridView>
                                <asp:Button ID="btnAddSelected" runat="server" Text="Add Selected" OnClick="btnAddSelected_Click" CssClass="btn btn-green" />
                            </asp:Panel>
                        </div>
                        <div style="flex:1; border:1px solid #ccc; padding:10px; background:#f9f9f9;">
                            <h3>List (<asp:Literal ID="litCurQCount" runat="server">0</asp:Literal>)</h3>
                            <asp:Repeater ID="rptCurrentQ" runat="server" OnItemCommand="rptCurrentQ_Command">
                                <ItemTemplate>
                                    <div style="border-bottom:1px solid #eee; padding:5px;">
                                        <%# Eval("QuestionStatement") %> 
                                        <asp:LinkButton runat="server" CommandName="Remove" CommandArgument='<%# Eval("QuizQuestionID") %>' Text="[X]" style="color:red;" />
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Panel ID="pnlNoCurQ" runat="server" Visible="false">None.</asp:Panel>
                            <br />
                            <asp:Button ID="btnStep2Next" runat="server" Text="Finish" OnClick="btnStep2Next_Click" CssClass="btn btn-blue" />
                        </div>
                    </div>
                </asp:View>

                <asp:View ID="vStep3" runat="server">
                    <div class="alert alert-ok">
                        <h3>Done!</h3>
                        Quiz <asp:Literal ID="litFinalTitle" runat="server" /> is ready.<br /><br />
                        <asp:Button ID="btnPublish" runat="server" Text="Publish Now" OnClick="btnPublish_Click" CssClass="btn btn-green" />
                    </div>
                </asp:View>

            </asp:MultiView>
        </div>
    </div>
</form>
</body>
</html>
