<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Teacher_AddQ.aspx.vb" Inherits="Teacher_AddQuestion" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>
<%@ Register Src="~/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>QuizWiz - Add Question</title>
    <link href="Styles/site.css" rel="stylesheet" />
</head>
<body style="margin:0; padding:0;">
<form id="form1" runat="server">
    <uc:Header runat="server" ID="Header" />
    <div class="layout-container">
        <uc:Navbar runat="server" ID="Navbar" />
        <div class="main-area">
            <h1>Add Question</h1>
            <hr />

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
        </div>
    </div>
</form>

<script>
    function updateVisibility() {
        var rbS = document.getElementById('<%= rbSingle.ClientID %>');
        var rbM = document.getElementById('<%= rbMultiple.ClientID %>');
        var type = "";
        if (rbS && rbS.checked) type = "Radio";
        else if (rbM && rbM.checked) type = "Checkbox";
        else type = "Paragraph";

        var hf = document.getElementById('<%= hfQType.ClientID %>');
        if (hf) hf.value = type;
        
        var secOptions = document.getElementById('secOptions');
        var secCR = document.getElementById('secCorrectRadio');
        var secCC = document.getElementById('secCorrectCheckbox');
        var secCP = document.getElementById('secCorrectParagraph');

        if (secOptions) secOptions.style.display = (type === 'Paragraph') ? 'none' : 'block';
        if (secCR) secCR.style.display = (type === 'Radio') ? 'block' : 'none';
        if (secCC) secCC.style.display = (type === 'Checkbox') ? 'block' : 'none';
        if (secCP) secCP.style.display = (type === 'Paragraph') ? 'block' : 'none';
    }
    window.onload = function() {
        var rbS = document.getElementById('<%= rbSingle.ClientID %>');
        var rbM = document.getElementById('<%= rbMultiple.ClientID %>');
        var rbP = document.getElementById('<%= rbParagraph.ClientID %>');
        if (rbS) rbS.onclick = updateVisibility;
        if (rbM) rbM.onclick = updateVisibility;
        if (rbP) rbP.onclick = updateVisibility;
        updateVisibility();
    };
</script>
</body>
</html>
