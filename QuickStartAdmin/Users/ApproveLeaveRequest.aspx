<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ApproveLeaveRequest.aspx.cs" Inherits="QuickStartAdmin.Users.ApproveLeaveRequest" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />

    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 600px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-file-edit-alt font-size-18"></i>&nbsp;<span>Take Action</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">


                <div class="row" id="divValidateSummary" style="display: none;">
                    <div class="col-md-12 col-xs-12">
                        <div class="validate-box">
                            <ul></ul>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Action : *</label>
                            <select class="form-select" id="dropApproveStatus">
                                <option value="Approved">Approve</option>
                                <option value="Reject">Reject</option>
                            </select>
                        </div>
                    </div>

                </div>
                <div class="row">
                    <div class="col-lg-12" id="divRemark">
                        <div class="mb-3">
                            <label class="form-label" for="name">Description : *</label>
                            <textarea id="txtRemarks" class="form-control" style="height: 50px;">
                            </textarea>

                        </div>
                    </div>


                </div>


                <div class="clearfix"></div>

            </div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Submit" id="btnSave" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose" onclick="closediv();" />

            </div>

        </div>
    </div>


    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Approve Leave Request</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Approve Leave Request</a></li>
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
                                        <label>Date:</label>
                                        <select id="dropaterange" class="form-select" onchange="sowCustomDate(this.id);">
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
                                    <div class="col-sm-3 mar">
                                        <label>Employee:</label>
                                        <select class="form-select" id="dropFKEmpIDSrch">
                                        </select>

                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Pay Type:</label>
                                        <select class="form-select" id="dropFKLeaveTypeIDSrch">
                                            <option value="">All</option>
                                            <option value="Paid">Paid</option>
                                            <option value="Unpaid">Unpaid</option>
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Leave:</label>
                                        <select class="form-select" id="dropFKLeaveIDSrch">
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Approve Status:</label>
                                        <select class="form-select" id="dropApproveStatusSrch">
                                            <option value="">All</option>
                                            <option value="Approved">Approved</option>
                                            <option value="Rejected">Rejected</option>
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


                                    <th style="width: 20px;"></th>
                                     <th style="width: 30px;"></th>
                                    <th data-column="FromDate" class="sorting tdFromDate">From Date</th>
                                    <th data-column="ToDate" class="sorting tdToDate">To Date</th>
                                    <th data-column="LoginID" class="sorting tdLoginID">EmpID</th>
                                    <th data-column="EmpName" class="sorting tdEmpName">Employee</th>
                                    <th data-column="LeaveName" class="sorting tdLeaveName">Leave Name</th>
                                    <th data-column="PayType" class="sorting tdPayType">Leave Type</th>
                                    <th data-column="LeaveCount" class="sorting tdLeaveCount">No of Days</th>
                                     <th data-column="Remarks" class="sorting tdRemarks">Remarks</th>
                                     <th data-column="ApproveStatus" class="sorting tdAmount tdApproveStatus">Status</th>
                                     <th data-column="RejectReason" class="sorting  tdRejectReason">Approver Ramark</th>
                                    <th data-column="CreatedByName" class="sorting tdCreatedByName">Created By</th>
                                    <th data-column="CreationDate" class="sorting tdCreationDate">Creation Date</th>
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

    <script src="UserJs/Leave/ApproveLeaveRequest.js?version=<%=PageVersion%>"></script>
</asp:Content>
