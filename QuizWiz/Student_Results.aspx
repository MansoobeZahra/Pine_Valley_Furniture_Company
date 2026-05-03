<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Student_Results.aspx.vb" Inherits="Student_MyResults" MasterPageFile="~/MasterPage.master" %>

<asp:Content ID="ctTitle" ContentPlaceHolderID="PageTitle" runat="server">My Results</asp:Content>

<asp:Content ID="ctMain" ContentPlaceHolderID="MainContent" runat="server">

<asp:Panel ID="pnlJustDone" runat="server" Visible="false" CssClass="alert alert-ok">
    Quiz submitted! Result below.
</asp:Panel>

<asp:Panel ID="pnlHero" runat="server" Visible="false" style="border:1px solid #0078d4; padding:10px; margin-bottom:10px; background:#f0f7ff;">
    <h2 style="color:#0078d4; margin-top:0;">Quiz: <asp:Literal ID="litQuizName" runat="server" /></h2>
    <p>Score: <strong style="font-size:18px; color:#0078d4;"><asp:Literal ID="litPct" runat="server" /></strong></p>
    <p>Marks: <asp:Literal ID="litObtained" runat="server" /> / <asp:Literal ID="litTotal" runat="server" /></p>
    <hr />
    <h3>Review</h3>
    <asp:GridView ID="gvDetail" runat="server" AutoGenerateColumns="false" Width="100%">
        <Columns>
            <asp:BoundField DataField="QNo" HeaderText="#" />
            <asp:BoundField DataField="QuestionStatement" HeaderText="Question" />
            <asp:TemplateField HeaderText="Your Ans">
                <ItemTemplate>
                    <span style='color:<%# If(Eval("Marks") > 0, "green", "red") %>'>
                        <%# Eval("StudentAns") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="CorrectAns" HeaderText="Correct" />
        </Columns>
    </asp:GridView>
</asp:Panel>

<div class="main-area" style="margin:0;">
    <h3 style="margin-top:0;">History</h3>
    <asp:GridView ID="gvAllResults" runat="server" AutoGenerateColumns="false" Width="100%">
        <Columns>
            <asp:BoundField DataField="QuizTitle" HeaderText="Quiz" />
            <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
            <asp:TemplateField HeaderText="Score">
                <ItemTemplate>
                    <span style='color:<%# If(Eval("Percentage") >= 50, "green", "red") %>'>
                        <%# Eval("Percentage") %>%
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="AttemptDate" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy}" />
        </Columns>
    </asp:GridView>
</div>

</asp:Content>
