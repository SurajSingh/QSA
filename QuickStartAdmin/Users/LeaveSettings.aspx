<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="LeaveSettings.aspx.cs" Inherits="QuickStartAdmin.Users.LeaveSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets/css/invoice.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0">Leave Settings</h4>
                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Leave Settings</a></li>
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
                            <h3>Company Settings</h3>
                            <section>
                                <div class="row">
                                    <div class="col-4">
                                        <div class="mb-3">
                                            <label for="basicpill-firstname-input">First Month of the Year : *</label>
                                            <select class="form-select" id="dropStartMonth">
                                                <option value="01" selected="selected">January</option>
                                                <option value="02">February</option>
                                                <option value="03">March</option>
                                                <option value="04">April</option>
                                                <option value="05">May</option>
                                                <option value="06">June</option>
                                                <option value="07">July</option>
                                                <option value="08">August</option>
                                                <option value="09">September</option>
                                                <option value="10">October</option>
                                                <option value="11">November</option>
                                                <option value="12">December</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="mb-3">
                                            <label for="basicpill-firstname-input">Last Month of the Year : *</label>
                                            <select class="form-select" id="dropEndMonth">
                                                <option value="01">January</option>
                                                <option value="02">February</option>
                                                <option value="03">March</option>
                                                <option value="04">April</option>
                                                <option value="05">May</option>
                                                <option value="06">June</option>
                                                <option value="07">July</option>
                                                <option value="08">August</option>
                                                <option value="09">September</option>
                                                <option value="10">October</option>
                                                <option value="11">November</option>
                                                <option value="12" selected="selected">December</option>
                                            </select>
                                        </div>
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-lg-4">
                                        <div class="mb-3">
                                            <label class="form-label">Leave Rule : *</label>
                                            <select class="form-select" id="dropLeaveRule">
                                                <option value="1">Working Days Counts</option>
                                                <option value="2">Sandwich Leave Policy</option>

                                            </select>
                                        </div>
                                    </div>

                                </div>

                            </section>

                            <!-- Company Document -->
                            <h3>Leave Settings</h3>
                            <section>

                                <div class="DetailPart">

                                    <div class="clearfix"></div>
                                    <div class="detail-container">
                                        <table id="tblDetail" class="tableInput tableInput-select xpad table-bordered table-hover">
                                            <thead>
                                                <tr>
                                                    <th style="width: 30px;"></th>
                                                    <th>Leave Name
                                                    </th>
                                                    <th style="width: 100px;">Leave Type
                                                    </th>
                                                    <th style="width: 80px;">Per Month Accr.
                                                    </th>
                                                    <th style="width: 120px;">Total in a Year 
                                                    </th>
                                                    <th style="width: 120px;">Carry Forward
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
                            <h3>Working Days Settings</h3>
                            <section>
                                <table id="tblWeekDays" class="tblsimple tbldottedborder">
                                    <thead>
                                        <tr>
                                            <th>Week Days
                                            </th>
                                            <th style="width: 120px;">Start</th>
                                            <th style="width: 120px;">End</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        
                                        <tr id="trDayName2">
                                            <td>
                                                <input type="hidden" id="hidDayID2" value="0" />
                                                <div class="form-check form-switch form-switch-lg">
                                                    <input type="checkbox" class="form-check-input" id="chkDayName2">
                                                    <label class="form-check-label" for="chkDayName2">Monday</label>
                                                </div>
                                            </td>
                                            <td class="tdStartTime">
                                                <input id="txtStartTime2" type="text" class="form-control starttime" />
                                            </td>
                                            <td class="tdEndTime">
                                                <input id="txtEndTime2" type="text" class="form-control endtime" />
                                            </td>
                                        </tr>
                                        <tr id="trDayName3">
                                            <td>
                                                <input type="hidden" id="hidDayID3" value="0" />
                                                <div class="form-check form-switch form-switch-lg">
                                                    <input type="checkbox" class="form-check-input" id="chkDayName3">
                                                    <label class="form-check-label" for="chkDayName3">Tuesday</label>
                                                </div>
                                            </td>
                                            <td class="tdStartTime">
                                                <input id="txtStartTime3" type="text" class="form-control starttime" />
                                            </td>
                                            <td class="tdEndTime">
                                                <input id="txtEndTime3" type="text" class="form-control endtime" />
                                            </td>
                                        </tr>
                                        <tr id="trDayName4">
                                            <td>
                                                <input type="hidden" id="hidDayID4" value="0" />
                                                <div class="form-check form-switch form-switch-lg">
                                                    <input type="checkbox" class="form-check-input" id="chkDayName4">
                                                    <label class="form-check-label" for="chkDayName4">Wednesday</label>
                                                </div>
                                            </td>
                                            <td class="tdStartTime">
                                                <input id="txtStartTime4" type="text" class="form-control starttime" />
                                            </td>
                                            <td class="tdEndTime">
                                                <input id="txtEndTime4" type="text" class="form-control endtime" />
                                            </td>
                                        </tr>
                                        <tr id="trDayName5">
                                            <td>
                                                <input type="hidden" id="hidDayID5" value="0" />
                                                <div class="form-check form-switch form-switch-lg">
                                                    <input type="checkbox" class="form-check-input" id="chkDayName5">
                                                    <label class="form-check-label" for="chkDayName5">Thursday</label>
                                                </div>
                                            </td>
                                            <td class="tdStartTime">
                                                <input id="txtStartTime5" type="text" class="form-control starttime" />
                                            </td>
                                            <td class="tdEndTime">
                                                <input id="txtEndTime5" type="text" class="form-control endtime" />
                                            </td>
                                        </tr>
                                        <tr id="trDayName6">
                                            <td>
                                                <input type="hidden" id="hidDayID6" value="0" />
                                                <div class="form-check form-switch form-switch-lg">
                                                    <input type="checkbox" class="form-check-input" id="chkDayName6">
                                                    <label class="form-check-label" for="chkDayName6">Friday</label>
                                                </div>
                                            </td>
                                            <td class="tdStartTime">
                                                <input id="txtStartTime6" type="text" class="form-control starttime" />
                                            </td>
                                            <td class="tdEndTime">
                                                <input id="txtEndTime6" type="text" class="form-control endtime" />
                                            </td>
                                        </tr>
                                        <tr id="trDayName7">
                                            <td>
                                                <input type="hidden" id="hidDayID7" value="0" />
                                                <div class="form-check form-switch form-switch-lg">
                                                    <input type="checkbox" class="form-check-input" id="chkDayName7">
                                                    <label class="form-check-label" for="chkDayName7">Saturday</label>
                                                </div>
                                            </td>
                                            <td class="tdStartTime">
                                                <input id="txtStartTime7" type="text" class="form-control starttime" />
                                            </td>
                                            <td class="tdEndTime">
                                                <input id="txtEndTime7" type="text" class="form-control endtime" />
                                            </td>
                                        </tr>
                                        <tr id="trDayName1">
                                            <td>
                                                <input type="hidden" id="hidDayID1" value="0" />
                                                <div class="form-check form-switch form-switch-lg">
                                                    <input type="checkbox" class="form-check-input" id="chkDayName1">
                                                    <label class="form-check-label" for="chkDayName1">Sunday</label>
                                                </div>
                                            </td>
                                            <td class="tdStartTime">
                                                <input id="txtStartTime1" type="text" class="form-control starttime" />
                                            </td>
                                            <td class="tdEndTime">
                                                <input id="txtEndTime1" type="text" class="form-control endtime" />
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>



                            </section>

                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- jquery step -->
    <script src="assets/libs/jquery-steps/build/jquery.steps.min.js"></script>
  
    <script src="UserJs/Leave/LeaveSettings.js?version=14082022"></script>
    <!-- form wizard init -->

</asp:Content>
