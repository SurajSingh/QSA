<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="RptAssignedTaskReport.aspx.cs" Inherits="QuickStartAdmin.Users.RptAssignedTaskReport" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />


  
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Assigned Task Report</h4>

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
                                    <div class="col-md-2 mar">
                                        <label>Assign Date:</label>
                                        <select id="dropaterange" class="form-select" onchange="sowCustomDate(this.id);">
                                            <option value="All">All</option>
                                            <option value="This Calendar Year">This Calendar Year</option>
                                            <option value="Last Calendar Year">Last Calendar Year</option>
                                            <option value="Current Month">This Month</option>
                                            <option value="Last Month">Last Month</option>
                                            <option value="Current Week">This Week</option>
                                            <option value="Custom">Custom</option>
                                        </select>
                                    </div>
                                    <div id="divcustomdate" class="col-md-4 divdaterange">
                                        <div class="row">
                                            <div class="mar col-md-6">
                                                <label class="lbl lbl1">From Date:</label>
                                                <input type="text" id="txtfromdate" class="form-control" />

                                            </div>
                                            <div class="mar col-md-6">
                                                <label>To Date:</label>
                                                <input type="text" id="txttodate" class="form-control" />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-2 mar" id="divEmployee">
                                        <label>Employee:</label>
                                        <select id="dropFKEmpIDSrch" class="form-select">
                                        </select>
                                    </div>
                                    <div class="col-sm-2 mar">
                                        <label>Manager:</label>
                                        <select id="dropFKManagerIDSrch" class="form-select">
                                        </select>
                                    </div>
                                    <div class="col-sm-2 mar">
                                        <label>Project:</label>
                                        <select id="dropFKProjectIDSrch" class="form-select">
                                        </select>
                                    </div>
                                    <div class="col-sm-2 mar">
                                        <label>Client:</label>
                                        <select id="dropFKClientIDSrch" class="form-select">
                                        </select>
                                    </div>
                                    <div class="col-sm-2 mar">
                                        <label>Status:</label>
                                        <select class="form-select" id="dropActiveStatusSrch">
                                            <option value="">-All-</option>
                                            <option value="Pending">Pending</option>
                                            <option value="Partially Completed">Partially Completed</option>
                                            <option value="Completed">Completed</option>
                                        </select>
                                    </div>
                                    <div class="col-sm-2 mar">

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
                                   
                                    <th data-column="AssignDate" class="sorting tdAssignDate">Assign Date</th>
                                    <th data-column="TaskName" class="sorting tdTaskName">Task ID</th>
                                    <th data-column="Description" class="sorting tdDescription">Description</th>
                                    <th data-column="EmpName" class="sorting tdEmpName">Employee</th>
                                    <th data-column="ProjectCode" class="sorting tdProjectCode">Project ID</th>
                                    <th data-column="ProjectName" class="sorting tdProjectName">Project</th>
                                    <th data-column="ClientCode" class="sorting tdClientCode">Client ID</th>
                                    <th data-column="TimeTaken" class="sorting tdTimeTaken tdclsnum">Time Taken</th>
                                    <th data-column="BHrs" class="sorting tdBHrs tdclsnum">Bud. Hours</th>
                                    <th data-column="CurrentStatus" class="sorting tdCurrentStatus">Status</th>
                                    <th data-column="ManagerName" class="sorting tdManagerName">Manager</th>                                   
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
   
      <script src="UserJs/Reports/TaskReport/RptAssignedTaskReport.js"></script>
</asp:Content>
