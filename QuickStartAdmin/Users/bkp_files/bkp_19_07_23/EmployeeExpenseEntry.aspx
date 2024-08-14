<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="EmployeeExpenseEntry.aspx.cs" Inherits="QuickStartAdmin.Users.EmployeeExpenseEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="divalert" id="divConfirmApprove" style="z-index: 9999999;">
        <a class="divalert-close" onclick="closediv();">
            <img src="images/cancel.png" /></a>
        <div class="clear"></div>
        <div class="divalert-text" id="ConfirmApproveText"></div>
        <div class="divalert-bottom">
            <input id="btnApproveCancel" type="button" value="No" class="btn btn-warning waves-effect waves-light" />
            <input id="btnApproveOK" type="button" value="Yes" class="divalert-ok btn btn-success waves-effect waves-light" />

        </div>
    </div>

    <div class="modal-dialog modal-sm divpopup" id="divMemo" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-file-edit-alt font-size-18"></i>&nbsp;<span>Enter Memo</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner" style="margin: 0px;">
                <div class="row">
                    <div class="col-lg-12">
                        <textarea id="txtMemo" name="area"></textarea>
                    </div>

                </div>

                <div class="clearfix"></div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton" style="border: 0px;">
                <input type="button" class="btn btn-success waves-effect waves-light" value="OK" id="btnSaveMemo" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnCloseMemo" onclick="closediv();" />

            </div>
        </div>
    </div>

    <div class="modal-dialog modal-sm divpopup" id="divAttachment" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="bx bx-file font-size-18"></i>&nbsp;<span>Attachments (JPG, JPEG, PNG, PDF)</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner" style="margin-top: 15px;">
                <div class="row">
                    <div class="col-12 col-lg-12">
                        <div class="mb-3">
                            <input type="button" class="btn btn-success waves-effect waves-light" value="Upload File" id="btnfileselect" />
                        </div>
                    </div>

                </div>
                <div class="row">
                    <div class="col-12 col-lg-12">
                        <h4 class="alert-heading heading">List of Uploaded Files:</h4>
                    </div>

                </div>
                <div class="row">
                    <div class="col-12 col-lg-12">
                        <table id="tblAttachment" class="tableInput table-bordered" style="width: 100%;">
                            <tbody>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="OK" id="btnOKAttach" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnCloseAttach" onclick="closediv();" />

            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0">Expenses  Entry</h4>
                <div class="page-title-right">
                    <div class="nrbtn">
                        <a class="btn btn-success" id="btnApprove" style="display: none;"><i class="uil-check"></i>Approve</a>
                        <a class="btn  btn-danger" id="btnReject" style="display: none;"><i class="uil-cancel"></i>Reject</a>
                        <a class="btn btn-info" id="btnRefresh"><i class="uil-refresh"></i>Refresh</a>
                    </div>

                </div>
            </div>
        </div>
    </div>




    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="divctrl">
                        <label class="lblAuto">
                            Date:
                        </label>
                        <select id="dropaterange" class="form-select w120" onchange="sowCustomDate(this.id);">
                            <option value="All">All</option>
                            <option value="This Calendar Year">This Calendar Year</option>
                            <option value="Last Calendar Year">Last Calendar Year</option>
                            <option value="Current Month">This Month</option>
                            <option value="Last Month">Last Month</option>
                            <option value="Current Week" selected="selected">This Week</option>
                            <option value="Today">Today</option>
                            <option value="Custom">Custom</option>
                        </select>
                    </div>
                    <div id="divcustomdate" class="divdaterange" style="float: left;">
                        <div class="divctrl">
                            <label class="lblAuto">
                                From Date:
                            </label>
                            <input type="text" id="txtfromdate" class="form-control w120" />
                        </div>
                        <div class="divctrl">
                            <label class="lblAuto">
                                To Date:
                            </label>
                            <input type="text" id="txttodate" class="form-control w120" />
                        </div>
                    </div>

                    <div class="divctrl">
                        <label class="lblAuto">
                            Project:
                        </label>
                        <select id="dropFKProjectIDSrch" class="form-select w120">
                        </select>
                    </div>
                    <div class="divctrl" id="divEmp" style="display: none;">
                        <label class="lblAuto">
                            Employee:
                        </label>

                        <select id="dropFKEmpIDSrch" class="form-select w180">
                        </select>
                    </div>
                    <div class="divctrl">
                        <a class="btn btn-primary bg-green" id="btnSearch"><i class="uil-search me-1"></i>Search</a>
                    </div>

                    <div class="clearfix"></div>
                    <table id="tblTimeSheet" class="tableInput table-bordered" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="tdApprove" style="width: 30px; text-align: center;">
                                    <input type="checkbox" class="form-check-input" id="chkAll" /></th>
                                <th class="tdDelete" style="width: 30px;"></th>
                                <th class="tdEmpID" style="width: 130px;">Employee</th>
                                <th class="tdTaskDate" style="width: 130px;">Date</th>
                                <th class="tdFKProjectID">Project</th>
                                <th class="tdFKTaskID">Expense</th>
                                <th class="tdDescription">Description</th>
                                <th class="tdUnit" style="width: 70px; text-align: right;">Unit</th>
                                <th class="tdTCostRate" style="width: 80px; text-align: right;">Cost Rate</th>
                                <th class="tdMU" style="width: 80px; text-align: right;">MU%</th>
                                <th class="tdAmount" style="width: 80px; text-align: right;">Amount</th>
                                <th class="tdIsBillable" style="width: 30px; text-align: center;" title="is Billable">B</th>
                                <th class="tdIsReimb" style="width: 30px; text-align: center;" title="is Reimbursable">R</th>
                                <th class="tdMemo" style="width: 60px;">&nbsp;</th>
                                <th class="tdAttachment " style="width: 80px; text-align: center;"></th>
                                <th class="tdApproveStatus" title="Approve Status" style="width: 30px; text-align: center;">S</th>
                            </tr>
                        </thead>

                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th class="tdApprove" style="width: 30px;"></th>
                                <th class="tdDelete"></th>
                                <th class="tdEmpID" style="width: 130px;"></th>
                                <th class="tdTaskDate"></th>
                                <th class="tdFKProjectID"></th>
                                <th class="tdFKTaskID"></th>
                                <th class="tdDescription"></th>
                                <th class="tdUnit" style="text-align: right;"></th>
                                <th class="tdTCostRate"></th>
                                <th class="tdMU"></th>
                                <th class="tdAmount" style="text-align: right;"></th>
                                <th class="tdIsBillable"></th>
                                <th class="tdIsReimb"></th>
                                <th class="tdMemo">&nbsp;</th>
                                <th class="tdAttachment"></th>
                                <th class="tdApproveStatus"></th>
                            </tr>
                        </tfoot>
                    </table>
                    <div id="divDataloader" style="text-align: center;">
                        <img src="images/smallLoader.gif" />
                    </div>
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
                                        <a class="btn btn-info" id="btnAddNew"><i class="uil-plus"></i>Add New</a>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <iframe src="Upload.aspx" id="ifuploadfile" style="display: none;"></iframe>
    <script src="assets/libs/tinymce/tinymce.min.js"></script>
    <script src="UserJs/Timesheet/EmployeeExpenseEntry.js?version=30092022"></script>
</asp:Content>
