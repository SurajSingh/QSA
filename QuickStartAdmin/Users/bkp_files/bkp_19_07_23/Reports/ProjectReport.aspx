<%@ Page Title="" Language="C#" MasterPageFile="~/Users/Reports/ReportMaster.Master" AutoEventWireup="true" CodeBehind="ProjectReport.aspx.cs" Inherits="QuickStartAdmin.Users.Reports.ProjectReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Src="~/Users/usercontrol/usUpdateProgress.ascx" TagPrefix="uc1" TagName="usUpdateProgress" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="txtClientNameSrch" runat="server" ClientIDMode="Static" Value="" />
    <asp:HiddenField ID="txtFKClientIDSrch" runat="server" ClientIDMode="Static" Value="0" />
    <asp:HiddenField ID="dropActiveStatusSrch" runat="server" ClientIDMode="Static" Value="" />
    <asp:HiddenField ID="dropFKContractTypeSrch" runat="server" ClientIDMode="Static" Value="0" />
    <asp:HiddenField ID="HidPageID" runat="server" ClientIDMode="Static" Value="0" />


    <uc1:usUpdateProgress runat="server" ID="usUpdateProgress" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="display: none;">
                <asp:Button ID="btnViewReport" runat="server" Text="Search" OnClick="btnViewReport_Click" ClientIDMode="Static" />
            </div>
            <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" PageCountMode="Actual" BackColor="#26AA98" Height="750px" SecondaryButtonForegroundColor="White">
            </rsweb:ReportViewer>
        </ContentTemplate>

    </asp:UpdatePanel>
    <script type="text/javascript">
        window.SearchReport = function (args) {
            $("#txtClientNameSrch").val(args[0]);
            $("#txtFKClientIDSrch").val(args[1]);
            $("#dropActiveStatusSrch").val(args[2]);
            $("#dropFKContractTypeSrch").val(args[3]);
            $("#HidPageID").val(args[4]);
            $("#btnViewReport").trigger("click");
        }
    </script>
</asp:Content>
