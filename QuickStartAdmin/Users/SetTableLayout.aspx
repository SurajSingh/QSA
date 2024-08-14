<%@ Page Title="Set Layout" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="SetTableLayout.aspx.cs" Inherits="QuickStartAdmin.Users.SetTableLayout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets/css/transaction.css?version=01122021" rel="stylesheet" />
    <link href="/Users/usercss/SetTableLayout.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="HidGridName" runat="server" ClientIDMode="Static" Value="0" />

    <div class="tranPage">
        <div class="row">
            <div class="col-md-12">

                <div class="card">

                    <div class="card-body form_design" id="divAddForm">
                        <div class="contentdiv">
                            <div class="col-md-12">
                                <div class="divReportContainer">
                                    <table id="tbldata" class="table  table-bordered" style="width: 100%">
                                        <colgroup>
                                            <col style="width: 30px;" />
                                            <col />
                                            <col />
                                            <col style="width: 50px;" />
                                            <col style="width: 50px;" />
                                            <col style="width: 50px;" />
                                            <col style="width: 50px;" />
                                            <col style="width: 50px;" />
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th style="width: 30px;">
                                                    <i class="fa fa-arrow-up"></i><i class="fa fa-arrow-down"></i>
                                                </th>
                                                <th>Field Name</th>
                                                <th>Display Name</th>
                                                <th style="width: 50px;">Readonly</th>
                                                <th style="width: 130px;">Col Width(px)</th>
                                                <th style="width: 50px;">Focus</th>
                                                <th style="width: 50px;">Visible</th>
                                                <th style="width: 50px;">Print</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                    <div id="divDataloader" style="text-align: center;">
                                        <img src="images/smallLoader.gif" />
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="btndiv">

                            <div style="float: left; margin-left: 20px;">
                                <label>&nbsp;</label>
                                <label class="checkbox">
                                    Save For All Users
                                                                <input id="chkForAllUsers" type="checkbox" checked="checked" />
                                    <span class="checkmark"></span>
                                </label>
                            </div>
                            <div class="text-right">
                                <input type="button" class="btn btn-warning hvr-glow" value="Reset Layout" id="btnReset">
                                <input type="button" class="btn btn-warning hvr-glow" value="Save" id="btnsave">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="MasterJs/SetTableLayout.js"></script>

</asp:Content>
