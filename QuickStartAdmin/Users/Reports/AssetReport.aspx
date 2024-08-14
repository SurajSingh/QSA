<%@ Page Title="" Language="C#" MasterPageFile="~/Users/Reports/ReportMaster.Master" AutoEventWireup="true" CodeBehind="AssetReport.aspx.cs" Inherits="QuickStartAdmin.Users.Reports.AssetReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Src="~/Users/usercontrol/usUpdateProgress.ascx" TagPrefix="uc1" TagName="usUpdateProgress" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="HidAssetName" runat="server" ClientIDMode="Static" Value="" />
    <asp:HiddenField ID="HidFKCategoryID" runat="server" ClientIDMode="Static" Value="0" />
    <asp:HiddenField ID="HidFKConditionID" runat="server" ClientIDMode="Static" Value="0" />
    <asp:HiddenField ID="HidFKLocationID" runat="server" ClientIDMode="Static" Value="0" />
    <asp:HiddenField ID="HidFKDeptID" runat="server" ClientIDMode="Static" Value="0" />
    <asp:HiddenField ID="HidFKEmpID" runat="server" ClientIDMode="Static" Value="0" />
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
            $("#HidAssetName").val(args[0]);
            $("#HidFKCategoryID").val(args[1]);
            $("#HidFKConditionID").val(args[2]);
            $("#HidFKLocationID").val(args[3]);
            $("#HidFKDeptID").val(args[4]);
            $("#HidFKEmpID").val(args[5]);
            $("#HidPageID").val(args[6]);
            $("#btnViewReport").trigger("click");
        }
    </script>
</asp:Content>
