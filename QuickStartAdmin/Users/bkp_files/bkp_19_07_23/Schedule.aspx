<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="Schedule.aspx.cs" Inherits="QuickStartAdmin.Users.Schedule" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="usercss/Schedule.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="modal-dialog modal-sm divpopup" id="divViewDetail" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>View Schedule</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">

                <div class="row">
                    <div class="col-lg-12">
                        <table class="tblReport">
                            <tr>
                                <td title="Scheduled Date">
                                    <i class="fa fa-clock"></i>&nbsp;<span id="tdDate"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Scheduled Employee">
                                    <i class="fa fa-users"></i>&nbsp;<span id="tdEmployee"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Client">
                                    <i class="fa fa-user"></i>&nbsp;<span id="tdClient"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Status">
                                    <i class="fa fa-compass"></i>&nbsp;<span id="tdStatus"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Reamrks">
                                    <i class="fa fa-text-height"></i>&nbsp;<span id="tdRemark"></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="clearfix"></div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">

                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" onclick="closediv();" />

            </div>
        </div>
    </div>

 

    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>New Schedule</span></h4>
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
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">From Date: *</label>
                            <input class="form-control" id="txtStartDate" maxlength="50" />
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">To Date: *</label>
                            <input class="form-control" id="txtEndDate" maxlength="50" />
                        </div>
                    </div>


                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3" style="position: relative;">
                            <label class="form-label">Time: </label>
                            <input class="form-control" id="txtTime" maxlength="50" style="position: relative;" />
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Work Type: *</label>
                            <select id="dropFKWorkTypeID" class="form-select">
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Client: *</label>
                            <input class="form-control" id="txtFKClientID" />
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Project: *</label>
                            <input class="form-control" id="txtFKProjectID" />
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3 genex-multiselect-box-parent">
                            <label class="form-label">Employee: *</label>
                            <div id="divFKEmpID"></div>
                            <div class="clearfix"></div>
                        </div>


                    </div>

                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Default Status: *</label>
                            <select id="dropFKStatusID" class="form-select">
                            </select>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <div class="mb-3">
                            <label class="form-label">Remarks: </label>
                            <input id="txtRemarks" type="text" class="form-control" maxlength="100" />
                        </div>
                    </div>
                </div>
                <div class="clearfix"></div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Save" id="btnSave" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose" onclick="closediv();" />

            </div>
        </div>
    </div>


    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Client Schedule</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Client Schedule</a></li>
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
                    <div class="col-12">
                        <div class="row">

                            <div class="col-md-2">
                                <a class="popup-form btn btn-primary bg-green" id="btnAddNew"><i class="mdi mdi-plus me-1"></i>Add New</a>

                            </div>
                            <div class="col-md-10 divtopcontrol">
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
                                    <a class="btn btn-primary bg-green" id="btnSearch1"><i class="uil-search me-1"></i>Search</a>
                                </div>
                            </div>
                        </div>

                    </div>


                </div>
            </div>
        </div>
        <!-- end col -->
    </div>
    <div class="row">
        <div class="col-sm-12 pull-right">
            <div class="row">

                <div class="col-md-12 divtopcontrol" id="tbldata_control">
                </div>
            </div>

        </div>
        <div id="tbldata_divfilter" class="hidetd divFilter" style="background: #ffffff;">

            <div class="divFilter-inner">
                <div class="col-md-12">
                    <div class="row">

                        <div class="col-sm-3 mar">
                            <label>Employee:</label>
                            <input type="text" class="form-control" id="txtFKEmpIDSrch" />
                        </div>
                        <div class="col-sm-3 mar">
                            <label>Project:</label>
                            <input type="text" class="form-control" id="txtFKProjectIDSrch" />
                        </div>
                        <div class="col-sm-3 mar">
                            <label>Client:</label>
                            <input type="text" id="txtFKClientIDSrch" class="form-control" />
                        </div>
                        <div class="col-sm-3 mar">
                            <label>Work Type:</label>
                            <select class="form-select" id="dropFKWorkTypeIDSrch">
                            </select>
                        </div>
                        <div class="col-sm-3 mar">
                            <label>Status:</label>
                            <select class="form-select" id="dropFKStatusIDSrch">
                            </select>
                        </div>
                        <div class="col-sm-3 mar">

                            <a id="btnSearch" class="btn btn-primary bg-green mr-b-20 mr-t-50"><i class="uil-search me-1"></i>Search</a>
                        </div>
                    </div>

                </div>
            </div>

        </div>
        <div class="col-sm-12">
            <div>
                <div class="divreport">
                    <ul id="tbldata" class="ulreport">
                    </ul>

                    <div id="divDataloader" style="text-align: center;">
                        <img src="images/smallLoader.gif" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- end row -->

    <script src="UserJs/Schedule/Schedule.js?version=<%=PageVersion%>"></script>
</asp:Content>
