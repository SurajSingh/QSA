<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="usUpdateProgress.ascx.cs" Inherits="QuickStartAdmin.Users.usercontrol.usUpdateProgress" %>
<asp:UpdateProgress ID="UpdateProgress1" runat="server">
    <ProgressTemplate>
         <div id="divloader" class="progressdiv">
             <img src="/Users/images/progressBar2.gif" style="margin-top:10%;" /><span>Please wait</span>
        </div>
    </ProgressTemplate>
</asp:UpdateProgress>
