<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="RptTimeExpensesDetailbyClientProject.aspx.cs" Inherits="QuickStartAdmin.Users.RptTimeExpensesDetailbyClientProject" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Time & Expenses Detail by Client And Project</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Client Report</a></li>
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
                                <label>Date Range:</label>
                                <select id="dropaterange" class="form-select" onchange="sowCustomDate(this.id);">
                                    <option value="All" >All</option>
                                    <option value="This Calendar Year">This Calendar Year</option>
                                    <option value="Last Calendar Year">Last Calendar Year</option>
                                    <option value="Current Month" selected="selected">This Month</option>
                                    <option value="Last Month">Last Month</option>
                                    <option value="Current Week">This Week</option>
                                    <option value="Today">Today</option>
                                    <option value="Custom">Custom</option>
                                </select>
                            </div>

                            <div class="col-sm-6 divdaterange" id="divcustomdate">
                                <div class="row">
                                    <div class="col-sm-6 mar" id="divFromDateSrch">
                                        <label>From Date:</label>
                                        <input type="text" class="form-control" id="txtfromdate" />
                                    </div>
                                    <div class="col-sm-6 mar" id="divToDateSrch">
                                        <label>To Date:</label>
                                        <input type="text" class="form-control" id="txttodate" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-3 mar">
                                <label>Manager:</label>
                                <select id="dropFKManagerIDSrch" class="form-select">
                                </select>
                            </div>
                            <div class="col-sm-3 mar">
                                <label>Project:</label>
                                <div id="divFKProjectIDSrch"></div>

                            </div>
                            <div class="col-sm-3 mar">
                                <label>Client:</label>
                                <div id="divFKClientIDSrch"></div>
                            </div>
                            <div class="col-sm-3 mar">
                                <label>Employee:</label>
                                <div id="divFKEmpIDSrch"></div>
                            </div>
                             <div class="col-sm-3 mar">
                                <label>Approve Status:</label>
                                <select id="dropApproveStatusSrch" class="form-select">
                                    <option value="">All</option>
                                    <option value="Approved">Approved</option>
                                    <option value="Pending">Pending</option>
                                     <option value="Rejected">Rejected</option>
                                </select>
                            </div>
                            <div class="col-sm-3 mar">
                                <label>Billed:</label>
                                <select id="dropBilledSrch" class="form-select">
                                    <option value="">All</option>
                                    <option value="1">Yes</option>
                                    <option value="0">No</option>
                                </select>
                            </div>
                            <div class="col-sm-3 mar">
                                <label>Billable:</label>
                                <select id="dropBillableSrch" class="form-select">
                                    <option value="">All</option>
                                    <option value="1">Yes</option>
                                    <option value="0">No</option>
                                </select>
                            </div>
                             <div class="col-sm-3 mar">
                                <label>Task Type:</label>
                                <select id="dropTaskTypeSrch" class="form-select">
                                    <option value="">All</option>
                                    <option value="Task">Service</option>
                                    <option value="Expenses">Expenses</option>
                                </select>
                            </div>
                              <div class="col-sm-3 mar">
                                <label>Show Cost:</label>
                              <div class="clearfix"></div>
                                  <input type="checkbox" id="chkShowCostSrch" checked="checked" />
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
                    <iframe id="ifReport" src="Reports/TimeExpensesDetailbyClientProject.aspx" class="ifReport" style="margin: 0px; padding: 0px; height: 800px;"></iframe>


                </div>
            </div>
        </div>
    </div>
    <script src="UserJs/Reports/ClientReport/RptTimeExpensesDetailbyClientProject.js"></script>
</asp:Content>
