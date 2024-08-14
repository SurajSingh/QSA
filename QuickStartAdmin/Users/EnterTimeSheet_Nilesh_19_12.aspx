<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="EnterTimeSheet.aspx.cs" Inherits="QuickStartAdmin.Users.EnterTimeSheet" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />

    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitleTimesheet"><i class="uil-user-plus font-size-18"></i><span> New Timesheet Entry </span></h4>
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

                <!-- Tab panes -->
                <div class="tab-content">
                    <div class="tab-pane active" id="navpills2-home" role="tabpanel">
                        <div class="row">

                            <div class="col-sm-4 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">Date: *</label>
                                    <input type="text" class="form-control" id="txtTaskDate" />
                                </div>

                            </div>  
                            
                            <div class="col-sm-4 col-xs-6">
                                <div class="mb-3">
                                    <label class="lblAuto">
                                        Employee:
                                    </label>

                                    <select id="dropFKEmpIDSrch" class="form-select w180">
                                    </select>
                                </div>

                            </div> 

                        </div>
                        <div class="clearfix"></div>
                        <div class="row">

                            <div class="col-sm-4 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Project: *                       
                                    </label>
                                    <input type="text" id="txtFKProjectID" class="form-control" maxlength="50" />
                                </div>
                            </div>
                            <div class="col-sm-4 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Task: *                       
                                    </label>
                                    <input type="text" id="txtFKTaskID" class="form-control" maxlength="50" />
                                </div>
                            </div>
                            <div class="col-sm-4 col-xs-12">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Hours: *                       
                                    </label>
                                    <input id="txtHrs" type="text" class="form-control" />
                                </div>
                            </div>
                        </div>
                        <div class="clearfix"></div>


                        <div class="row">
                                                        
                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Description: 
                       
                                    </label>
                                    <input type="text" id="txtDescription" class="form-control" />

                                </div>
                            </div>
                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Bill Rate:                        
                                    </label>
                                    <input type="text" id="txtTBillRate" class="form-control" readonly />

                                </div>
                            </div>

                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Cost Rate:  *
                       
                                    </label>
                                    <input id="txtTCostRate" type="text" class="form-control" maxlength="50" readonly/>
                                </div>
                            </div>
                                                        

                        </div>
                        <div class="clearfix"></div>


                        <div class="clearfix"></div>


                        <div class="clearfix"></div>
                        <div class="row">                                                        
                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <input id="chkIsBillable" type="checkbox" class="form-check-input">
                                    <label class="form-check-label" for="chkIsBillable">IsBillable</label>
                                </div>
                            </div>
                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">                                    
                                    <input type="button" class="btn btn-success waves-effect waves-light" value="Memo" id="linkMemo" />
                                </div>
                            </div>                                                      
                        </div>
                        <div class="form-check">
                            
                            
                        </div>
                        



                        <div class="clearfix"></div>
                    </div>                                    
                    
                </div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Submit" id="btnsave" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnCloseNewEtry" onclick="closediv();" />

            </div>
        </div>
    </div>

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
                <button type="button" class="close" onclick="closediv('divAddNew');"><span aria-hidden="true">×</span></button>
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
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnCloseMemo" onclick="closediv('divAddNew');" />

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
                        <a class="btn btn-success" id="btnApprove" style="display: none;"><i class="uil-check"></i>Approve</a>
                        <a class="btn  btn-danger" id="btnReject" style="display: none;"><i class="uil-cancel"></i>Reject</a>                        
                    </div>

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
                                <a class="popup-form btn btn-primary bg-green" id="btnAddNew"><i class="mdi mdi-plus me-1"></i>New Timesheet Entry</a>
                            </div>
                            <div class="col-md-2 divtopcontrol">
                               <ul class="ulpaging">
                                    <li><a title="Refresh" id="btnRefresh" class="buttons-filter"><i class="uil-refresh"></i>&nbsp;Refresh</a></li>

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
                                    <div class="col-sm-3 mar">
                                        <label>Date:</label>
                                        <select id="dropaterange" class="form-select" onchange="sowCustomDate(this.id);">
                                            <option value="All" selected="selected">All</option>
                                            <option value="This Calendar Year">This Calendar Year</option>
                                            <option value="Last Calendar Year">Last Calendar Year</option>
                                            <option value="Current Month">This Month</option>
                                            <option value="Last Month">Last Month</option>
                                            <option value="Current Week" >This Week</option>
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
                                        <label class="lblAuto">
                                            Project:
                                        </label>
                                        <select id="dropFKProjectIDSrch" class="form-select w120">
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label class="lblAuto">
                                            Employee:
                                        </label>

                                        <select id="dropFKEmpIDSrchInFilter" class="form-select w180">
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                                                      
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
                                    <th class="tdApprove" style="width: 20px; text-align: center; vertical-align: center;">
                                    <input type="checkbox" class="form-check-input" id="chkAll" /></th>
                                    <th style="width: 20px;"></th>       
                                    <th  data-column="FKEmpID" class="hidetd" style="width: 130px;">Employee</th>
                                    <th data-column="FKProjectID" class="hidetd tdProjectID">ProjectID</th>
                                    <th data-column="FKTaskID" class="hidetd tdTaskID">TaskID</th>
                                    <th data-column="TaskDate" class="sorting tdTaskDate">Date</th>
                                    <th data-column="ProjectCode" class="sorting tdProjectCode">Project</th>                                    
                                    <th data-column="TaskName" class="sorting tdTaskName">Task</th>                                    
                                    <th data-column="Hrs" class="sorting tdHrs">Hours</th>
                                    <th data-column="Description" class="sorting tdDescription">Description</th>
                                    <th data-column="IsBillable" class="sorting tdIsBillable ">B</th>
                                    <th data-column="TBillRate" class="sorting tdBillaRate ">Bill Rate</th>
                                    <th data-column="TCostRate" class="sorting tdCostRate bold">Pay Rate</th>                                    
                                    <th data-column="Memo" class="tdMemo">Memo</th>
                                    <th data-column="ApproveStatus" class="tdApproveStatus">Status</th>
                                </tr>
                            </thead>

                            <tbody>
                            </tbody>
                            <tfoot style="position:sticky;top: 0;bottom:0;">
                            <tr class="headmain">
                                <td class="tdApprove" ></td>
                                <td>   </td>   
                                <td id="tdFKEmpID" class="hidetd" ></td>
                                <td id="tdFKProjectID" class="hidetd" ></td>
                                <td id="tdFKTaskID" class="hidetd"></td>
                                <td id="tdTaskDate" ></td>
                                <td id="tdProjectCode" ></td>                                   
                                <td id="tdTaskName" ></td>                                 
                                <td id="tdHrs" ></td>
                                <td id="tdDescription" ></td>
                                <td id="tdIsBillable" ></td>
                                <td id="tdTBillRate" ></td>
                                <td id="tdTCostRate" ></td>                                  
                                <td id="tdMemo" ></td>
                                <td id="tdApproveStatus"></td>
                            </tr>
                        </tfoot>

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

        <script src="assets/libs/tinymce/tinymce.min.js"></script>
    <script src="UserJs/Timesheet/EnterTimeSheet.js?version=30092022"></script>
</asp:Content>

