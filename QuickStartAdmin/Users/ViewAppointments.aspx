<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ViewAppointments.aspx.cs" Inherits="QuickStartAdmin.Users.ViewAppointments" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="usercss/ViewAppointments.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="modal-dialog modal-sm divpopup" id="divViewDetail" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>View Appointment</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">

                <div class="row">
                    <div class="col-lg-12">
                        <table class="tblReport">
                            <tr>
                                <td title="Appointment Date">
                                    <i class="fa fa-clock"></i>&nbsp;<span id="tdDate"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Scheduled Employee">
                                    <i class="fa fa-users"></i>&nbsp;<span id="tdEmployee"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Visitor">
                                    <i class="fa fa-user"></i>&nbsp;<span id="tdCustomer"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Email">
                                    <i class="fa fa-envelope"></i>&nbsp;<span id="tdEmail"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Visitor">
                                    <i class="fa fa-mobile"></i>&nbsp;<span id="tdMobile"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Reamrks">
                                    <i class="fa fa-text-height"></i>&nbsp;<span id="tdRemark"></span>
                                </td>
                            </tr>
                            <tr>
                                <td title="Status">
                                    <i class="fa fa-compass"></i>&nbsp;<span id="tdStatus"></span>
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



    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 600px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>New Appointment</span></h4>
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
                            <label class="form-label">Date: *</label>
                            <input class="form-control" id="txtOnDate" maxlength="50" />
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Employee: *</label>
                            <select class="form-select" id="dropFKEmpID">
                            </select>
                        </div>
                    </div>


                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Interval: *</label>
                            <select class="form-select" id="dropFKIntervalID">
                            </select>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="mb-3" style="position: relative;">
                            <label class="form-label">From Time: *</label>
                            <input class="form-control" id="txtFromTime" maxlength="50" style="position: relative;" />
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">To Time: *</label>
                            <input class="form-control" id="txtToTime" maxlength="50" style="position: relative;" />
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Visitor Name: *</label>
                            <input class="form-control" id="txtCutomerName" maxlength="50" />
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Visitor Company: </label>
                            <input class="form-control" id="txtCompanyName" maxlength="50" />
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Visitor Email: *</label>
                            <input class="form-control" id="txtEmailID" maxlength="50"/>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Mobile: </label>
                            <input class="form-control" id="txtMobile" maxlength="50" />
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Status: *</label>
                            <select id="dropApproveStatus" class="form-select">
                                <option value="Confirmed">Confirmed</option>
                                <option value="Unconfirmed">Unconfirmed</option>
                                 <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>
                            </select>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <div class="mb-3">
                            <label class="form-label">Remarks: *</label>
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
                <h4 class="mb-0" id="pagetitle">Appointments</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Appointments</a></li>
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
                                <div class="divctrl" id="divEmp">
                                    <label class="lblAuto">
                                        Employee:
                                    </label>

                                    <select id="dropFKEmpIDSrch" class="form-select w180">
                                    </select>
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
                            <label>Status:</label>
                            <select class="form-select" id="dropApproveStatusSrch">
                                <option value="">All</option>
                                <option value="Confirmed">Confirmed</option>
                                <option value="Unconfirmed">Unconfirmed</option>
                                <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>

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

    <script src="UserJs/Appointment/ViewAppointments.js?version=<%=PageVersion%>"></script>
</asp:Content>
