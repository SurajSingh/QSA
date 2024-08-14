<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintInvoice.aspx.cs" Inherits="QuickStartAdmin.Users.PrintInvoice" %>

<!DOCTYPE html>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Print Invoice</title>
    <link href="usercss/PrintInvoice.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
       <asp:ScriptManager runat="server" EnableCdn="true"></asp:ScriptManager>
    <div class="divmain" align="center" >
        <rsweb:ReportViewer ID="ReportViewer1"  runat="server" Width="100%" overflow="visible" PageCountMode="Actual" DocumentMapWidth="100%" >
        </rsweb:ReportViewer>
        <div class="clearfix"></div>
    </div>
    </form>
</body>
</html>
