<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="RptBudgetedTaskReport.aspx.cs" Inherits="QuickStartAdmin.Users.RptBudgetedTaskReport" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />





    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Budgeted Task Report</h4>

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
                    <div class="col-sm-12 pull-right">
                        <div class="row">
                           
                            <div class="col-md-2 divtopcontrol">
                                <ul class="ulpaging">
                                    <li><a title="Refresh" id="btnRefresh" class="buttons-filter"><i class="uil-refresh"></i>&nbsp;Refresh</a></li>

                                </ul>
                            </div>
                            <div class="col-md-10 divtopcontrol" id="tbldata_control">
                            </div>
                        </div>

                    </div>
                    <div id="tbldata_divfilter" class="hidetd divFilter">

                        <div class="divFilter-inner">
                            <div class="col-md-12">

                                <div class="row">
                                    <div class="col-sm-3 mar">
                                        <label>Task Code/Name :</label>
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
                    <div class="divreport">
                        <table id="tbldata" class="dataTable  genexcustomtable">
                            <colgroup>
                            </colgroup>
                            <thead>
                                <tr class="headmain">
                                   
                                    <th data-column="TaskCode" class="sorting tdTaskCode">Task Code</th>
                                    <th data-column="TaskName" class="sorting tdTaskName">Task Name</th>
                                    <th data-column="Description" class="sorting tdDescription">Description</th>
                                     <th data-column="DeptName" class="sorting tdDeptName">Department</th>
                                    <th data-column="BHours" class="sorting tdBHours">Hours/Units</th>
                                    <th data-column="BillRate" class="sorting tdBillRate tdclscurrency">Rate</th>                                   
                                    <th data-column="TaxAmt" class="sorting tdTaxAmt tdclscurrency">Tax</th>
                                     <th data-column="BillAmt" class="sorting tdBillAmt tdclscurrency">Amount</th>
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
        </div>
        <!-- end col -->
    </div>

    <!-- end row -->

    <script src="UserJs/Reports/TaskReport/RptBudgetedTaskReport.js"></script>
</asp:Content>

