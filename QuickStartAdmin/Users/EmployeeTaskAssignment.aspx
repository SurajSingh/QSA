<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="EmployeeTaskAssignment.aspx.cs" Inherits="QuickStartAdmin.Users.EmployeeTaskAssignment" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />


    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>Assign New Tasks</span></h4>
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
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Date: *</label>
                            <input type="text" class="form-control" id="txtAssignDate" />
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Employee: *</label>
                            <input type="text" class="form-control" id="txtFKEmpID" />
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Manager: *</label>
                            <input type="text" class="form-control" id="txtFKManagerID" />
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <table id="tblTimeSheet" class="tableInput table-bordered" style="width: 100%;">
                                <thead>
                                    <tr>

                                        <th class="tdDelete" style="width: 30px;"></th>
                                        <th class="tdFKProjectID">Project</th>
                                        <th class="tdFKTaskID">Task</th>
                                        <th class="tdHrs" style="width: 90px; text-align: right;">Bud.Hours</th>
                                        <th class="tdDescription">Description</th>
                                    </tr>
                                </thead>

                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th colspan="5" style="text-align: right;">
                                            <a class="btn btn-default" id="btnAddNewRow"><i class="uil-plus"></i>Add New</a>
                                        </th>

                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                </div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Save" id="btnSave" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose" onclick="closediv();" />

            </div>
        </div>
    </div>

    <div class="modal-dialog modal-sm divpopup" id="divLog" style="width: 700px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-clock font-size-18"></i>&nbsp;<span>Log Entry</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">

                <div id="divNewLog">
                    <div class="row">
                        <div class="col-12 col-lg-12">
                            <div class="form-box">
                                <div class="row">
                                    <div class="col-12 col-lg-12">
                                        <h4 class="alert-heading heading">Enter New Log:</h4>
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-lg-4">
                                        <div class="mb-3">
                                            <label class="form-label">Date: *</label>
                                            <input type="text" class="form-control" id="txtLogDate" />
                                        </div>
                                    </div>
                                    <div class="col-lg-4">
                                        <div class="mb-3">
                                            <label class="form-label">Time Taken: *</label>
                                            <input type="text" class="form-control" id="txtTimeTaken" />
                                        </div>
                                    </div>
                                    <div class="col-lg-4">
                                        <div class="mb-3">
                                            <label class="form-label">New Status: *</label>
                                            <select class="form-select" id="dropNewStatus">
                                                <option value="Partially Completed">Partially Completed</option>
                                                <option value="Completed">Completed</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="mb-3">
                                            <label class="form-label">Remarks:</label>
                                            <textarea class="form-control" id="txtLogRemark" style="height: 30px;"></textarea>

                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="mb-3 text-right">
                                            <input type="button" class="btn btn-success waves-effect waves-light" value="Save" id="btnSaveLog" />
                                            <input type="button" class="btn btn-danger waves-effect waves-light" value="Cancel" id="btnClearLog" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-12 col-lg-12">
                        <h4 class="alert-heading heading">Previous Log History:</h4>
                    </div>

                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <table id="tblPreviousLog" class="tableInput table-bordered" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="tdDelete" style="width: 30px;"></th>
                                        <th class="tdEdit" style="width: 30px;"></th>
                                        <th style="width: 100px;">Date</th>
                                        <th style="text-align: right; width: 100px;">Time Taken</th>
                                        <th>Remarks</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>

                                <tbody>
                                </tbody>

                            </table>
                        </div>
                    </div>

                </div>





            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton" id="divLogButton">

                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnCloseLog" onclick="closediv();" />

            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Task Assignment</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Task Assignment</a></li>
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
                            <div class="col-md-2">
                                <a class="popup-form btn btn-primary bg-green" id="btnAddNew"><i class="mdi mdi-plus me-1"></i>Assign New Task</a>
                            </div>
                            <div class="col-md-2 divtopcontrol">
                                <ul class="ulpaging">
                                </ul>
                            </div>
                            <div class="col-md-8 divtopcontrol" id="tbldata_control">
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
                                    <th style="width: 20px;" class="tdDelete"></th>
                                    <th style="width: 20px;" class="tdAddLog"></th>
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
                                    <th data-column="CreatedByName" class="sorting tdCreatedByName">Created By</th>
                                    <th data-column="CreationDate" class="sorting tdCreationDate">Creation Date</th>
                                    <th data-column="ModificationDate" class="sorting tdModificationDate">Modificaction Date</th>
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
    <script src="MasterJs/AddressJs.js"></script>
    <script src="UserJs/Timesheet/EmployeeTaskAssignment.js?version=<%=PageVersion%>"></script>
</asp:Content>
