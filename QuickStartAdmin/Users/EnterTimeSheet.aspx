<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="EnterTimeSheet.aspx.cs" Inherits="QuickStartAdmin.Users.EnterTimeSheet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="hfRoleType" value="<%=Session["RoleType"].ToString() %>" />
    <div class="divalert" id="divConfirmApprove" style="z-index: 9999999;">
        <a class="divalert-close" onclick="closediv();">
            <img src="images/cancel.png" /></a>
        <div class="clear"></div>
        <div class="divalert-text" id="ConfirmApproveText"></div>
        <div class="divalert-bottom">
            <input id="btnApproveCancel" type="button" value="No" class="btn btn-warning waves-effect waves-light" />
            <input id="btnApproveOK" type="button" value="Yes" class="divalert-ok btn btn-success waves-effect waves-light" />

            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-file-edit-alt font-size-18"></i>&nbsp;<span>Enter Memo</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
        </div>
    </div>
    <div class="modal-dialog modal-sm divpopup" id="divMemo" style="width: 500px; display: none;">
        <div class="modal-content">
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





    <div class="modal-dialog modal-sm divpopup" id="divSubmit" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="bx bx-user font-size-18"></i>&nbsp;<span>Submit your timesheet</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner" style="margin-top: 15px;">
                <div class="row">
                    <div class="col-3 col-lg-3">
                        <div class="mb-3">
                            <label class="form-label" for="name">Submit To : *</label>
                        </div>
                    </div>
                    <div class="col-9 col-lg-9">
                        <div class="row">
                            <div class="col-12 col-lg-12">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input name="rbtnSubmitTo" id="chkClientManager" type="radio" class="form-check-input" checked="checked">
                                        <label class="form-check-label" for="chkClientManager">Client Manager</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12 col-lg-12">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input name="rbtnSubmitTo" id="chkProjectManager" type="radio" class="form-check-input">
                                        <label class="form-check-label" for="chkClientManager">Project Manager</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12 col-lg-12">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input name="rbtnSubmitTo" id="chkYourManager" type="radio" class="form-check-input">
                                        <label class="form-check-label" for="chkYourManager">Your Manager</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-5 col-lg-5">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input name="rbtnSubmitTo" id="chkSpecific" type="radio" class="form-check-input">
                                        <label class="form-check-label" for="chkSpecific">Specific</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-7 col-lg-7">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <select id="dropSubmitToSpecific" class="form-select" style="display: none;"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Submit" id="btnSubmit" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose" onclick="closediv();" />

            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0">Enter Timesheet</h4>
                <div class="page-title-right">
                    <div class="nrbtn">
                        <%--***************************   import input btn    *****************************************--%>

                        <%--***************************   import input btn    *****************************************--%>

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
                    <div class="btn btn-primary bg-green" id="btnImport_div" style="margin-left: 15px;">
                        <label for="excel-file-input" id="file-input" class="btn-primary" style="padding: 0px; margin: 0px;">
                            <input type="file" id="excel-file-input" onchange="handleFile()" hidden>
                            <i class="uil-upload"></i>&nbsp;Import
                        </label>
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
                                <th class="tdFKTaskID">Task</th>
                                <th class="tdHrs" style="width: 70px; text-align: right;">Hours</th>
                                <th class="tdDescription">Description</th>
                                <th class="tdIsBillable" style="width: 30px; text-align: center;">B</th>
                                <%if (Session["RoleType"].ToString() == "Admin")
                                    { %>
                                <th class="tdTBillRate" style="width: 80px; text-align: right;">Bill Rate</th>
                                <th class="tdTCostRate" style="width: 80px; text-align: right;">Pay Rate</th>
                                <% } %>
                                <th class="tdMemo" style="width: 60px;">&nbsp;</th>
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
                                <th class="tdHrs" style="text-align: right;"></th>
                                <th class="tdDescription"></th>
                                <th class="tdIsBillable"></th>
                                <%if (Session["RoleType"].ToString() == "Admin")
                                    { %>
                                <th class="tdTBillRate"></th>
                                <th class="tdTCostRate"></th>
                                <% } %>


                                <th class="tdMemo">&nbsp;</th>
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
                                        <a class="btn btn-info" id="btnAddNew"><i class="uil-plus"></i>Add New</a>&nbsp;&nbsp;<a class="btn btn-default" href="#"><i class="uil-star"></i> Favourite Tasks</a>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="assets/libs/tinymce/tinymce.min.js"></script>
    <script src="UserJs/Timesheet/EnterTimeSheet.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.3/xlsx.full.min.js"></script>
</asp:Content>
