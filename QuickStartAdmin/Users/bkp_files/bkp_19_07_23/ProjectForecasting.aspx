<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ProjectForecasting.aspx.cs" Inherits="QuickStartAdmin.Users.ProjectForecasting" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets/css/invoice.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Project Forecasting</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0" id="divStep1Control">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Project Management</a></li>
                        <li class="breadcrumb-item active">Project Forecasting</li>
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
                    <div class="row" id="divValidateSummary" style="display: none;">
                        <div class="col-md-12 col-xs-12">
                            <div class="validate-box">
                                <ul></ul>
                            </div>
                        </div>
                    </div>
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

                                    <a class="btn btn-primary bg-green" id="btnNext">Next <i class="uil-arrow-right "></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="divStep2" style="display: none; min-height: 400px;">
                        <div class="row">
                            <div class="col-xl-4">
                                <div class="leftsummarybox" id="divSummary">

                                    <h4 class="card-title" id="divProjectName"></h4>
                                    <div class="leftsummarybox-inner">
                                        <%--<h5 id="projectname" class="project-title"></h5>--%>
                                        <div class="clearfix"></div>
                                        <div id="divProjectModule" class="treecombo simple"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-8">
                                <div class="row">
                                    <div class="col-sm-4">
                                        <h5>Project Module/Activity </h5>
                                    </div>
                                    <div class="col-sm-8 text-right">
                                        <a class="popup-form btn btn-secondary  mr-b-20" id="btnBackStep1"><i class="uil-arrow-left "></i>Back</a>
                                         <a class="popup-form btn btn-info  mr-b-20" id="btnAddNew1" style="display: none;"><i class="mdi mdi-plus me-1"></i>Add New Activity</a>

                                        <a class="popup-form btn btn-primary bg-green mr-b-20" id="btnAddNew" style="display: none;"><i class="mdi mdi-plus me-1"></i>Add New Sub Module</a>
                                     
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div id="divAddTask" style="display: none;">
                                           <div class="row">
                                                <div class="col-lg-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Activity Title: *</label>
                                                    <input id="txtTitle" class="form-control" maxlength="50" />
                                                </div>
                                            </div>
                                            <div class="col-lg-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Task Category: *</label>
                                                    <input id="txtFKTaskID" class="form-control" />
                                                </div>
                                            </div>
                                            <div class="col-lg-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Est. Start Date: </label>
                                                    <input id="txtEstStartDate" class="form-control" />
                                                </div>
                                            </div>
                                            <div class="col-lg-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Est. End Date: </label>
                                                    <input id="txtEstEndDate" class="form-control" />
                                                </div>
                                            </div>
                                            <div class="col-lg-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Est. Hours: </label>
                                                    <input id="txtEstHrs" class="form-control" />
                                                </div>
                                            </div>

                                            <div class="col-lg-6">
                                                <div class="mb-3">
                                                    <label class="form-label">% Complete: </label>
                                                    <input id="txtCompletePer" class="form-control" />
                                                </div>
                                            </div>
                                            <div class="col-lg-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Description: </label>
                                                    <textarea id="txtActvityDesc" class="form-control" style="height: 50px;" maxlength="500"></textarea>

                                                </div>
                                            </div>
                                            <div class="col-lg-12">
                                                <div class="text-end">
                                                    <a class="btn btn-primary bg-green" id="btnSaveActivity">Submit</a>
                                                    <a class="btn btn-danger bg-danger" id="btnDeleteActivity">Delete</a>
                                                </div>
                                            </div>
                                           </div>
                                        </div>
                                        <div id="divAddModule">
                                            <div class="col-lg-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Module Title: *</label>
                                                    <input id="txtModuleName" class="form-control" maxlength="50" />
                                                </div>
                                            </div>

                                            <div class="col-lg-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Description: </label>
                                                    <textarea id="txtModuleDesc" class="form-control" style="height: 50px;" maxlength="500"></textarea>

                                                </div>
                                            </div>
                                            <div class="col-lg-12">
                                                <div class="text-end">
                                                    <a class="btn btn-primary bg-green" id="btnSaveModule">Submit</a>
                                                    <a class="btn btn-danger bg-danger" id="btnDeleteModule">Delete</a>
                                                </div>
                                            </div>
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
    </div>

    <!-- end row -->
    <script src="UserJs/ProjectManagement/ProjectForcastingTree.js"></script>
    <script src="UserJs/ProjectManagement/ProjectForecasting.js"></script>

</asp:Content>
