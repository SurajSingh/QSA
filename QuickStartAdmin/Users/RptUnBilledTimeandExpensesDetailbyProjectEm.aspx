<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="RptUnBilledTimeandExpensesDetailbyProjectEm.aspx.cs" Inherits="QuickStartAdmin.Users.RptUnBilledTimeandExpensesDetailbyProjectEm" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Un-Billed Time and Expenses Detail by Project & Employee</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Billing Report</a></li>
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
                                <label>Status:</label>
                                <select id="dropApproveStatusSrch" class="form-control">
                                    <option value="">All</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Approved">Approved</option>
                                    <option value="Rejected">Rejected</option>
                                </select>
                            </div>
                            <div class="col-sm-3 mar">
                                <label>Billable:</label>
                                <select id="dropBillableSrch" class="form-control">
                                    <option value="">All</option>
                                    <option value="1">Yes</option>
                                    <option value="0">No</option>

                                </select>
                                <input type="hidden" id="HidBilled" value="0" />
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
                    <iframe id="ifReport" src="Reports/EmployeeAndTimeReport.aspx" class="ifReport" style="margin: 0px; padding: 0px; height: 800px;"></iframe>


                </div>
            </div>
        </div>
    </div>
    <script src="UserJs/Reports/BillingReport/RptBilledTimeandExpensesDetailbyProjectEmplo.js"></script>
</asp:Content>