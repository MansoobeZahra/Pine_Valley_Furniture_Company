<%@ Page Language="VB" AutoEventWireup="false" CodeFile="TakeSurvey.aspx.vb" Inherits="TakeSurvey" %>
<%@ Register TagPrefix="uc" TagName="Navbar" Src="~/Navbar.ascx" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FeedBACK - Take Survey</title>
    <link rel="stylesheet" href="Site.css" runat="server" />
    <style>
    .answer-option {
        display: flex;
        align-items: center;
        gap: .75rem;
        padding: .75rem 1rem;
        border-radius: var(--radius-sm);
        border: 1.5px solid var(--border);
        cursor: pointer;
        transition: var(--transition);
        margin-bottom: .5rem;
        font-size: .9rem;
        font-weight: 500;
        background: var(--white);
    }
    .answer-option:hover { border-color: var(--blue); background: rgba(37,150,190,.04); }
    .answer-option input[type=radio] {
        width: 18px; height: 18px;
        accent-color: var(--blue);
        flex-shrink: 0;
        cursor: pointer;
    }
    .question-block {
        background: var(--white);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        margin-bottom: 1.5rem;
        overflow: hidden;
        box-shadow: 0 2px 12px rgba(37,150,190,.07);
    }
    .question-block-header {
        display: flex;
        align-items: center;
        gap: .75rem;
        padding: 1rem 1.5rem;
        background: linear-gradient(135deg, rgba(247,59,49,.04), rgba(242,159,65,.04));
        border-bottom: 1px solid var(--border);
    }
    .question-block-body { padding: 1.25rem 1.5rem; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Navbar ID="Navbar1" runat="server" />
        <div class="page-wrapper" style="max-width:780px;">
            <!-- Survey Banner -->
            <div class="take-survey-header">
                <div style="display:flex;align-items:center;gap:.75rem;margin-bottom:.3rem;">
                    <span class="badge" style="background:rgba(255,255,255,.2);color:white;" id="anonBadge" runat="server"></span>
                </div>
                <h2 id="surveyTitle" runat="server">Loading</h2>
                <p id="surveyDesc" runat="server"></p>
                <div class="progress-bar-wrap">
                    <div class="progress-bar-fill" id="progressFill" runat="server" style="width:100%;"></div>
                </div>
            </div>

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="alert alert-danger"> <asp:Literal ID="litError" runat="server" /></div>
            </asp:Panel>

            <asp:Panel ID="pnlAlreadyDone" runat="server" Visible="false">
                <div class="card">
                    <div class="card-body" style="text-align:center;padding:3rem;">
                        <div style="font-size:3rem;margin-bottom:1rem;">(Active)</div>
                        <h3 style="font-size:1.25rem;font-weight:700;margin-bottom:.5rem;">Already Submitted</h3>
                        <p style="color:var(--muted);margin-bottom:1.5rem;">You have already completed this survey.</p>
                        <div style="display:flex;gap:1rem;justify-content:center;flex-wrap:wrap;">
                            <a href="SurveyorDashboard.aspx" class="btn btn-outline"><- Back to Surveys</a>
                            <a id="lnkResults2" runat="server" href="#" class="btn btn-warning"> View Results</a>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlSurvey" runat="server">
                <!-- Questions rendered server-side -->
                <asp:PlaceHolder ID="phQuestions" runat="server" />

                <div style="display:flex;gap:1rem;margin-top:2rem;flex-wrap:wrap;">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Survey "
                        CssClass="btn btn-danger btn-lg"
                        OnClick="btnSubmit_Click"
                        OnClientClick="return validateForm();" />
                    <a href="SurveyorDashboard.aspx" class="btn btn-outline btn-lg">Cancel</a>
                </div>
            </asp:Panel>
        </div>
    </form>

    <script>
    function validateForm() {
        var questions = document.querySelectorAll('[data-qid]');
        for (var i = 0; i < questions.length; i++) {
            var qid = questions[i].getAttribute('data-qid');
            var answered = document.querySelector('input[name="q_' + qid + '"]:checked');
            if (!answered) {
                alert('Please answer question ' + (i + 1) + ' before submitting.');
                questions[i].scrollIntoView({ behavior: 'smooth', block: 'center' });
                return false;
            }
        }
        return true;
    }
    </script>
</body>
</html>

