<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="RptEmployeeTimesheet.aspx.cs" Inherits="QuickStartAdmin.Users.RptEmployeeTimesheet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="usercss/Schedule.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Employee Timesheet</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Timesheet Report</a></li>
                        <li class="breadcrumb-item active">Reports</li>
                        <li class="breadcrumb-item">QuickstartAdmin</li>
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
                                        <label>Date:</label>
                                        <select id="dropaterange" class="form-select w120" onchange="sowCustomDate(this.id);">
                                            <option value="All" selected="selected">All</option>
                                            <option value="This Calendar Year">This Calendar Year</option>
                                            <option value="Last Calendar Year">Last Calendar Year</option>
                                            <option value="Current Month">This Month</option>
                                            <option value="Last Month">Last Month</option>
                                            <option value="Current Week">This Week</option>
                                            <option value="Today">Today</option>
                                            <option value="Custom">Custom</option>
                                        </select>
                                    </div>
                                    <div class="col-sm-6 divdaterange" id="divcustomdate">
                                        <div class="row">
                                            <div class="col-sm-6 mar">
                                                <label>From Date:</label>
                                                <input type="text" class="form-control" id="txtfromdate" />
                                            </div>
                                            <div class="col-sm-6 mar">
                                                <label>To Date:</label>
                                                <input type="text" class="form-control" id="txttodate" />
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <div class="row">
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
                                    <th data-column="TaskDate" class="sorting tdTaskDate">Date</th>
                                    <th data-column="LoginID" class="sorting tdLoginID">Emp ID</th>
                                    <th data-column="EmpName" class="sorting tdEmpName">Employee</th>
                                    <th data-column="ProjectCode" class="sorting tdProjectCode">Project ID</th>
                                    <th data-column="ProjectName" class="sorting tdProjectName">Project Name</th>
                                    <th data-column="TaskName" class="sorting tdTaskName">Task</th>
                                    <th data-column="Description" class="sorting tdDescription">Remark</th>
                                    <th data-column="Memo" class="sorting tdMemo">Memo</th>
                                    <th data-column="TBHours" class="sorting tdTBHours tdclsnum bold">B-Hours</th>
                                    <th data-column="Hrs" class="sorting tdHrs tdclsnum bold">Hours</th>
                                    <th data-column="ApproveStatus" class="sorting tdApproveStatus">Status</th>
                                   
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

    <script src="UserJs/Reports/TimesheetReport/RptEmployeeTimesheet.js?version=27022023"></script>
</asp:Content>
