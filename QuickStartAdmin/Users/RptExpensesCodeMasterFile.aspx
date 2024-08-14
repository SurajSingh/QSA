<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="RptExpensesCodeMasterFile.aspx.cs" Inherits="QuickStartAdmin.Users.RptExpensesCodeMasterFile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Expenses Code Master File</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Task Report</a></li>
                        <li class="breadcrumb-item active">Reports</li>
                        <li class="breadcrumb-item active">QuickstartAdmin</li>
                    </ol>
                </div>

            </div>
        </div>
    </div>






    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="col-12">

                        <div class="row">
                            <div class="col-sm-3 mar">
                                        <label>Exp. Code/Name :</label>
                                        <input type="text" class="form-control" id="txtTaskCodeSrch" />
                                    </div>

                                    <div class="col-sm-3 mar">
                                        <label>Department:</label>
                                        <select class="form-select" id="dropFKDeptIDSrch">
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Status:</label>
                                        <select class="form-select" id="dropActiveStatusSrch">
                                            <option value="">-All-</option>
                                            <option value="Active">Active</option>
                                            <option value="Block">Block</option>
                                        </select>
                                    </div>

                            <div class="col-sm-3 mar">

                                <a id="btnSearch" class="btn btn-primary bg-green mr-b-20 mr-t-50"><i class="uil-search me-1"></i>Search</a>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>
        <!-- end col -->
    </div>
    <div class="row">


        <div class="col-sm-12">
            <div>
                <div class="divreport">
                    <iframe id="ifReport" src="Reports/TaskReport.aspx" class="ifReport" style="margin: 0px; padding: 0px; height: 800px;"></iframe>


                </div>
            </div>
        </div>
    </div>
    <script src="UserJs/Reports/TaskReport/RptTaskMasterFile.js"></script>
</asp:Content>
