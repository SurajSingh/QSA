<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ProjectBudgeting.aspx.cs" Inherits="QuickStartAdmin.Users.ProjectBudgeting" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />
    <div class="modal-dialog modal-sm divpopup" id="divLog" style="width: 700px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-clock font-size-18"></i>&nbsp;<span>Bugget Detail</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">

                <div class="row">
                    <div class="col-12 col-lg-12">
                        <table class="tblReport">
                            <tr>
                                <th>Title:
                                </th>
                                <td id="tdTitle"></td>
                            </tr>
                            <tr>
                                <th>Project:
                                </th>
                                <td id="tdProject"></td>
                            </tr>
                            <tr>
                                <th>Budget For:
                                </th>
                                <td id="tdBudgetDate"></td>
                            </tr>
                        </table>
                    </div>

                </div>


                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <table id="tblPreviousLog" class="tableInput table-bordered" style="width: 100%;">
                                <thead>
                                    <tr>

                                        <th>Task Code</th>
                                        <th>Task Description</th>
                                        <th style="text-align: right; width: 80px;">Bud. Hours</th>
                                        <th style="text-align: right; width: 80px;">Actual Hours</th>
                                    </tr>
                                </thead>

                                <tbody>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th colspan="2">Total
                                        </th>

                                        <th style="text-align: right; width: 80px;" id="tdBudHrs"></th>
                                        <th style="text-align: right; width: 80px;" id="tdActualHrs"></th>
                                    </tr>
                                </tfoot>
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

    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="bx bx-money font-size-18"></i>&nbsp;<span>Create New Budget</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner" style="margin-top: 15px;">
                <div class="row" id="divValidateSummary" style="display: none;">
                    <div class="col-md-12 col-xs-12">
                        <div class="validate-box">
                            <ul></ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 col-xs-12">
                        <div class="mb-3">
                            <label class="form-label">
                                Project: *
                            </label>
                            <input id="txtFKProjectID" type="text" class="form-control" />
                        </div>

                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 col-xs-12">
                        <div class="mb-3">
                            <label class="form-label">
                                Budget Template: 
                            </label>
                            <input id="txtFKBudgetID" type="text" class="form-control" />
                        </div>

                    </div>
                </div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Create Budget" id="btnCreate" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose" onclick="closediv();" />

            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Project Budgeting&nbsp; <span id="spanProjectName"></span></h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Project Budgeting</a></li>
                        <li class="breadcrumb-item active">QuickstartAdmin</li>
                    </ol>
                </div>

            </div>
        </div>
    </div>






    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body" id="divView">
                    <div class="col-sm-12 pull-right">
                        <div class="row">
                            <div class="col-md-2">
                                <a class="popup-form btn btn-primary bg-green" id="btnAddNew"><i class="mdi mdi-plus me-1"></i>Add New</a>
                            </div>
                            <div class="col-md-2 divtopcontrol">
                            </div>
                            <div class="col-md-8 divtopcontrol" id="tbldata_control">
                            </div>
                        </div>

                    </div>
                    <div id="tbldata_divfilter" class="hidetd divFilter">

                        <div class="divFilter-inner">
                            <div class="col-md-12">

                                <div class="row">

                                    <div class="col-sm-3 mar">
                                        <label>Project:</label>
                                        <input type="text" id="txtFKProjectIDSrch" class="form-control" />
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
                                    <th style="width: 20px;"></th>
                                    <th style="width: 20px;"></th>
                                    <th data-column="BudgetTitle" class="sorting tdBudgetTitle">Budget Title</th>
                                    <th data-column="ProjectCode" class="sorting tdProjectCode">Project ID</th>
                                    <th data-column="ProjectName" class="sorting tdProjectName">Project</th>
                                    <th data-column="FromDate" class="sorting tdFromDate">From Date</th>
                                    <th data-column="ToDate" class="sorting tdToDate">To Date</th>
                                    <th data-column="BudHrs" class="sorting tdBudHrs">Bud. Hrs.</th>
                                    <th data-column="TimesheetHrs" class="sorting tdTimesheetHrs">Actual Hrs.</th>
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
                <div class="card-body" id="divAddNew2" style="display: none;">
                    <div class="col-sm-12 pull-right">
                        <div class="row" id="divValidateSummary2" style="display: none;">
                            <div class="col-md-12 col-xs-12">
                                <div class="validate-box">
                                    <ul></ul>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2">
                                <a class="popup-form btn btn-secondary" id="btnBack"><i class="mdi mdi-arrow-left me-1"></i>Back</a>
                            </div>

                            <div class="col-md-12">
                                <div class="divctrl">
                                    <label class="lblAuto">
                                        From Date: *
                                    </label>
                                    <input type="text" id="txtfromdate" class="form-control w120" />
                                </div>
                                <div class="divctrl">
                                    <label class="lblAuto">
                                        To Date: *
                                    </label>
                                    <input type="text" id="txttodate" class="form-control w120" />
                                </div>
                                <div class="divctrl">
                                    <label class="lblAuto">
                                        Budget Title: *
                                    </label>
                                    <input type="text" id="txtTitle" class="form-control w180" maxlength="50" />

                                </div>
                            </div>
                        </div>

                    </div>






                    <div class="clearfix"></div>
                    <table id="tblTimeSheet" class="tableInput table-bordered" style="width: 100%;">
                        <thead>
                            <tr>

                                <th class="tdDelete" style="width: 30px;"></th>

                                <th class="tdFKTaskID">Task</th>
                                <th class="tdHrs" style="width: 70px; text-align: right;">Bud. Hours</th>
                                <th class="tdDescription">Description</th>
                                <th class="tdIsBillable" style="width: 30px; text-align: center;">B</th>
                                <th class="tdTBillRate" style="width: 80px; text-align: right;">Bill Rate</th>
                                <th class="tdTCostRate" style="width: 80px; text-align: right;">Pay Rate</th>
                            </tr>
                        </thead>

                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>

                                <th class="tdDelete"></th>
                                <th class="tdFKTaskID"></th>
                                <th class="tdHrs" style="text-align: right;"></th>
                                <th class="tdDescription"></th>
                                <th class="tdIsBillable"></th>
                                <th class="tdTBillRate"></th>
                                <th class="tdTCostRate"></th>
                            </tr>
                        </tfoot>
                    </table>
                    <div class="row">
                        <div class="col-12" id="divSubmitCtrl">
                            <div class="page-title-box d-flex align-items-center justify-content-between">
                                <div class="mb-0">
                                    <div class="nrbtn">
                                        <a class="btn btn-primary bg-green" id="btnsave">Submit&nbsp;<i class="uil-arrow-right"></i></a>
                                    </div>
                                </div>
                                <div class="page-title-right">
                                    <div class="nrbtn">
                                        <a class="btn btn-info" id="btnAddNewRow"><i class="uil-plus"></i>Add New</a>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- end col -->


    <!-- end row -->

    <script src="UserJs/ProjectManagement/ProjectBudgeting.js?version=<%=PageVersion%>"></script>
</asp:Content>
