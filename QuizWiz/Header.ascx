<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Header.ascx.vb" Inherits="Header" %>
<div class="top-nav" style="display:flex; align-items:center; justify-content:space-between; height: 60px; padding: 0 20px;">
    <div style="display:flex; align-items:center;">
        <img src='<%= ResolveUrl("~/Assets/discard.png") %>' alt="QuizWiz" style="height:40px; margin-right:15px;" />
        <strong style="font-size:22px;">QuizWiz</strong>
    </div>
    <div style="display:flex; align-items:center; gap: 20px;">
        <span style="font-size:14px; opacity: 0.9;">
            Logged in as: <strong><%=Session("FullName")%></strong> (<%=Session("Role")%>)
        </span>
        <a href='<%= ResolveUrl("~/Logout.aspx") %>' class="btn-logout" style="background: rgba(255,255,255,0.2); padding: 5px 15px; border-radius: 4px; border: 1px solid rgba(255,255,255,0.4); font-weight: bold;">Logout</a>
    </div>
</div>
