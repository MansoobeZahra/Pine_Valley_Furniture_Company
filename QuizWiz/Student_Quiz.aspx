<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Student_Quiz.aspx.vb" Inherits="Student_AttemptQuiz" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="ctTitle" ContentPlaceHolderID="PageTitle" runat="server">Attempt Quiz</asp:Content>

<asp:Content ID="ctMain" ContentPlaceHolderID="MainContent" runat="server">

<asp:Panel ID="pnlAlreadyDone" runat="server" Visible="false">
    <div class="alert alert-err">Already attempted. <a href="Student_Results.aspx">Results</a></div>
</asp:Panel>

<asp:Panel ID="pnlQuiz" runat="server" Visible="false">
    <div class="top-nav" style="background:#eee; color:black; border:1px solid #ccc; margin-bottom:10px;">
        <b><asp:Literal ID="litQuizTitle" runat="server" /></b> | 
        Q: <asp:Literal ID="litQNum" runat="server" /> / <asp:Literal ID="litQTotal" runat="server" /> |
        <span id="timerDisplay">--:--</span>
    </div>

    <div class="main-area" style="margin:0;">
        <b>Q: <asp:Literal ID="litQuestion" runat="server" /></b>
        <br /><br />
        
        <asp:Panel ID="pnlRadio" runat="server">
            <asp:RadioButtonList ID="rblOptions" runat="server" />
        </asp:Panel>

        <asp:Panel ID="pnlCheckbox" runat="server" Visible="false">
            <asp:CheckBoxList ID="cblOptions" runat="server" />
        </asp:Panel>

        <asp:Panel ID="pnlParagraph" runat="server" Visible="false">
            <asp:TextBox ID="txtParaAns" runat="server" TextMode="MultiLine" Rows="4" Width="100%" />
        </asp:Panel>
        
        <br />
        <asp:HiddenField ID="hfTimeLeft" runat="server" />
        <asp:Button ID="btnNext" runat="server" Text="Next" OnClick="btnNext_Click" CssClass="btn btn-blue" />
        <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" CssClass="btn btn-green" Visible="false" />
    </div>
</asp:Panel>

<script>
    var s = parseInt(document.getElementById('<%= hfTimeLeft.ClientID %>').value || '0');
    if (s > 0) {
        setInterval(function() {
            s--;
            var m = Math.floor(s/60), r = s%60;
            document.getElementById('timerDisplay').innerHTML = (m<10?'0':'')+m+':'+(r<10?'0':'')+r;
            if (s <= 0) location.reload();
        }, 1000);
    }
</script>

</asp:Content>
