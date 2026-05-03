<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Teacher_AddQ.aspx.vb" Inherits="Teacher_AddQuestion" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="ctTitle" ContentPlaceHolderID="PageTitle" runat="server">Add Question</asp:Content>

<asp:Content ID="ctMain" ContentPlaceHolderID="MainContent" runat="server">

<h2>Add New Question</h2>

<asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-ok">
    Question saved! <a href="Teacher_AddQ.aspx">Add another</a> | <a href="Teacher_Bank.aspx">View Bank</a>
</asp:Panel>

<asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-err">
    <asp:Literal ID="litError" runat="server" />
</asp:Panel>

<div style="border:1px solid #0078d4; padding:10px; background:#f0f7ff; margin-bottom:10px;">
    <b>Select Type:</b><br />
    <asp:RadioButton ID="rbSingle" runat="server" GroupName="qType" Checked="true" Text="Single Choice" /><br />
    <asp:RadioButton ID="rbMultiple" runat="server" GroupName="qType" Text="Multiple Choice" /><br />
    <asp:RadioButton ID="rbParagraph" runat="server" GroupName="qType" Text="Short Answer" />
    <asp:HiddenField ID="hfQType" runat="server" Value="Radio" />
</div>

<div class="main-area" style="margin:0 0 10px 0;">
    Subject: <asp:DropDownList ID="ddlSubject" runat="server" /><br />
    Difficulty: 
    <asp:DropDownList ID="ddlDifficulty" runat="server">
        <asp:ListItem>Easy</asp:ListItem>
        <asp:ListItem Selected="True">Medium</asp:ListItem>
        <asp:ListItem>Hard</asp:ListItem>
    </asp:DropDownList>
    <br /><br />
    Question Text:<br />
    <asp:TextBox ID="txtStatement" runat="server" TextMode="MultiLine" Rows="3" Width="100%" /><br /><br />
    Upload Image (Optional):<br />
    <asp:FileUpload ID="fuImage" runat="server" />
</div>

<div id="secOptions" style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
    <b>Options:</b><br />
    A: <asp:TextBox ID="txtA" runat="server" /><br />
    B: <asp:TextBox ID="txtB" runat="server" /><br />
    C: <asp:TextBox ID="txtC" runat="server" /><br />
    D: <asp:TextBox ID="txtD" runat="server" />
</div>

<div id="secCorrectRadio" style="border:1px solid #28a745; padding:10px; background:#f0fff4; margin-bottom:10px;">
    <b>Correct Option (Single):</b><br />
    <asp:RadioButton ID="rbA" runat="server" GroupName="Correct" Text="A" />
    <asp:RadioButton ID="rbB" runat="server" GroupName="Correct" Text="B" />
    <asp:RadioButton ID="rbC" runat="server" GroupName="Correct" Text="C" />
    <asp:RadioButton ID="rbD" runat="server" GroupName="Correct" Text="D" />
</div>

<div id="secCorrectCheckbox" style="border:1px solid #28a745; padding:10px; background:#f0fff4; margin-bottom:10px; display:none;">
    <b>Correct Options (Multiple):</b><br />
    <asp:CheckBox ID="cbCA" runat="server" Text="A" />
    <asp:CheckBox ID="cbCB" runat="server" Text="B" />
    <asp:CheckBox ID="cbCC" runat="server" Text="C" />
    <asp:CheckBox ID="cbCD" runat="server" Text="D" />
</div>

<div id="secCorrectParagraph" style="border:1px solid #28a745; padding:10px; background:#f0fff4; margin-bottom:10px; display:none;">
    <b>Model Answer (Text):</b><br />
    <asp:TextBox ID="txtModelAnswer" runat="server" Width="100%" />
</div>

<asp:Button ID="btnSave" runat="server" Text="Save Question" OnClick="btnSave_Click" CssClass="btn btn-blue" />
<a href="Teacher_Bank.aspx" style="margin-left:10px; color:red;">Cancel</a>

<script>
    function updateVisibility() {
        var type = "";
        if (document.getElementById('<%= rbSingle.ClientID %>').checked) type = "Radio";
        else if (document.getElementById('<%= rbMultiple.ClientID %>').checked) type = "Checkbox";
        else type = "Paragraph";

        document.getElementById('<%= hfQType.ClientID %>').value = type;
        document.getElementById('secOptions').style.display = (type === 'Paragraph') ? 'none' : 'block';
        document.getElementById('secCorrectRadio').style.display = (type === 'Radio') ? 'block' : 'none';
        document.getElementById('secCorrectCheckbox').style.display = (type === 'Checkbox') ? 'block' : 'none';
        document.getElementById('secCorrectParagraph').style.display = (type === 'Paragraph') ? 'block' : 'none';
    }
    document.getElementById('<%= rbSingle.ClientID %>').onclick = updateVisibility;
    document.getElementById('<%= rbMultiple.ClientID %>').onclick = updateVisibility;
    document.getElementById('<%= rbParagraph.ClientID %>').onclick = updateVisibility;
    updateVisibility();
</script>

</asp:Content>
