<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Header.ascx.vb" Inherits="Header" %>
<div class="top-nav" style="display:flex; align-items:center;">
    <img src='<%= ResolveUrl("Assets/discard.png") %>' alt="QuizWiz" style="height:60px; margin-right:15px;" />
    <span style="margin-left:15px;">User: <%=SessionFullName%> (<%=SessionRole%>)</span>
    <a href="Logout.aspx" style="margin-left:auto;">Logout</a>
</div>
