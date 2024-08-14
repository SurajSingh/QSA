<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ProjectAllocation.aspx.cs" Inherits="QuickStartAdmin.Users.ProjectAllocation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets/css/invoice.css" rel="stylesheet" />
    <link href="usercss/ProjectAllocation.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 400px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>Assign Activity</span></h4>
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
                            <label class="form-label">Date: *</label>
                            <input type="text" class="form-control" id="txtAssignDate" />
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Employee: *</label>
                            <input type="text" class="form-control" id="txtFKEmpID" />
                        </div>
                    </div>

                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Manager: *</label>
                            <input type="text" class="form-control" id="txtFKManagerID" />
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

    <div class="modal-dialog modal-sm divpopup" id="divAddStatus" style="width: 400px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>Update Activity Status</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <div class="row" id="divValidateSummary1" style="display: none;">
                    <div class="col-md-12 col-xs-12">
                        <div class="validate-box">
                            <ul></ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">New Status: *</label>
                            <select id="dropNewStatus" class="form-control">
                                <option value="">Select</option>
                                <option value="Started">Started</option>
                                <option value="Process">Process</option>
                                <option value="Complete">Complete</option>
                            </select>

                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3" id="divCompletePer" style="display: none;">
                            <label class="form-label">Complete %: *</label>
                            <input type="text" class="form-control" id="txtCompletePer" />
                        </div>
                        <div class="mb-3" id="divStartDate" style="display: none;">
                            <label class="form-label">Start Date: *</label>
                            <input type="text" class="form-control" id="txtStartDate" />
                        </div>
                        <div class="mb-3" id="divEndDate" style="display: none;">
                            <label class="form-label">End Date: *</label>
                            <input type="text" class="form-control" id="txtEndDate" />
                        </div>
                        
                    </div>

                </div>


            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Save" id="btnSaveStatus" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose1" onclick="closediv();" />

            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Project Allocation</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0" id="divStep1Control">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Project Management</a></li>
                        <li class="breadcrumb-item active">Project Allocation</li>
                    </ol>
                    <ol class="breadcrumb m-0" id="divStep2Control" style="display: none;">
                    </ol>
                </div>

            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">

                    <div id="divStep1" style="min-height: 400px;">
                        <div class="row mr-t-50">

                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label>Project: </label>
                                    <input type="text" class="form-control" id="txtFKProjectID" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="text-end">

                                    <a class="btn btn-primary bg-green" id="btnNext">View Detail <i class="uil-arrow-right "></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="divStep2" style="display: none; min-height: 400px;">
                        <div class="row">
                            <div class="col-xl-3">
                                <div class="leftsummarybox" id="divSummary">

                                    <h4 class="card-title" id="divProjectName"></h4>
                                    <div class="leftsummarybox-inner">
                                        <%--<h5 id="projectname" class="project-title"></h5>--%>
                                        <div class="clearfix"></div>
                                        <div id="divProjectModule" class="treecombo simple"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-9">
                                <div class="row">
                                    <div class="col-sm-4">
                                        <h5>Project Activity </h5>
                                    </div>
                                    <div class="col-sm-8 text-right">
                                        <a class="popup-form btn btn-secondary  mr-b-20" id="btnBackStep1"><i class="uil-arrow-left "></i>Back</a>

                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="divreport" style="max-height: 400px; overflow: auto;">
                                            <ul id="tbldata" class="ulProjectAllocation">
                                                <li>
                                                    <div class="row">
                                                        <div class="col-md-6 col-sm-6">
                                                            <span class="task-code"></span>
                                                        </div>
                                                        <div class="col-md-6 col-sm-6 text-right">
                                                            <span class="emp-assign"></span>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-12 col-sm-12">
                                                            <div class="detail-box">
                                                                <div class="row">
                                                                    <div class="col-9">
                                                                        <h2>Sample
                                                                        </h2>
                                                                    </div>
                                                                    <div class="col-3">
                                                                        <div class="module-status">
                                                                            Status: <span>0%</span>
                                                                        </div>
                                                                        <div class="module-status-set">
                                                                            <a>Set Status</a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-12">
                                                                        <p class="module-desc"></p>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-md-12 col-sm-12">
                                                                        <div class="sub-detail-box">
                                                                            <div class="row">
                                                                                <div class="col-6 col-md-3 sub-detail-box-item">
                                                                                    Est. Start Date<br />
                                                                                    <span></span>
                                                                                </div>
                                                                                <div class="col-6 col-md-3 sub-detail-box-item">
                                                                                    Est. End Date<br />
                                                                                    <span></span>
                                                                                </div>
                                                                                <div class="col-6 col-md-3 sub-detail-box-item">
                                                                                    Est. Hours<br />
                                                                                    <span></span>
                                                                                </div>
                                                                                <div class="col-6 col-md-3 sub-detail-box-item">
                                                                                    Actual Hours<br />
                                                                                    <span></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </li>
                                            </ul>

                                        </div>
                                        <div class="error" id="divNoData" style="display: none;">No activity exists.</div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- end col -->
    </div>

    <!-- end row -->
    <script src="UserJs/ProjectManagement/ProjectAllocationTree.js"></script>
    <script src="UserJs/ProjectManagement/ProjectAllocation.js?v=13122022"></script>
</asp:Content>
