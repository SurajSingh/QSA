<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ScheduleAvailability.aspx.cs" Inherits="QuickStartAdmin.Users.ScheduleAvailability" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets/css/invoice.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0">Schedule Employee Availability</h4>
                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Schedule Availability</a></li>
                        <li class="breadcrumb-item active">QuickstartAdmin</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="row" id="divValidateSummary" style="display: none;">
                <div class="col-md-12 col-xs-12">
                    <div class="validate-box">
                        <ul></ul>
                    </div>
                </div>
            </div>
            <div class="row">


                <div class="col-xl-12">
                    <div class="nrwizard">

                        <div id="tabsinvoice">
                            <!-- Seller Details -->
                            <h3>Select Employee</h3>
                            <section>
                                <div class="row">
                                    <div class="col-4">
                                        <div class="mb-3">
                                            <label for="basicpill-firstname-input">Employee : *</label>
                                            <select class="form-select" id="dropFKEmpID">
                                            </select>
                                        </div>
                                    </div>

                                </div>
                               

                            </section>

                            <!-- Company Document -->
                            <h3>Set Availability Time Interval</h3>
                            <section>
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
                                    <a class="btn btn-primary bg-green" id="btnSearch"><i class="uil-search me-1"></i>Search</a>
                                </div>

                                <div class="clearfix"></div>
                                <div class="DetailPart">

                                    <div class="clearfix"></div>
                                    <div class="detail-container">
                                        <table id="tblDetail" class="tableInput tableInput-select xpad table-bordered table-hover">
                                            <thead>
                                                <tr>
                                                    <th style="width: 30px;"></th>
                                                    <th>Date
                                                    </th>
                                                    <th style="width: 120px;">From Time
                                                    </th>
                                                    <th style="width: 120px;">To Time
                                                    </th>
                                                    <th style="width: 80px;">Total Time
                                                    </th>
                                                    <th style="width: 60px;">Booked?
                                                    </th>
                                                   
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="clearfix"></div>
                                    <div class="tablePart BottomRadius">

                                        <div class="RightLink addmore">
                                            <a id="btnAddRow">
                                                <i class="fa fa-fw fa-plus topicon"></i>Add New</a>
                                        </div>
                                    </div>

                                    <div class="clearfix"></div>
                                </div>

                            </section>


                            <!-- Bank Details -->


                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- jquery step -->
    <script src="assets/libs/jquery-steps/build/jquery.steps.min.js"></script>

    <script src="UserJs/Appointment/ScheduleAvailability.js?version=22062022"></script>
    <!-- form wizard init -->

</asp:Content>
