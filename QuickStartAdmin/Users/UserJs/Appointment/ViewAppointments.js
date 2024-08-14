
var json;
var pagename = "ViewAppointments.aspx";
var PKID = 0;
var PKRoleGroupID = 0;
var IsValidLogin = 0;
var FKPageID = 0;
var RCount = 0;
var JsonExport = null;
var IsColCreated = false;
var JsonReportLayout = null;
var JsonSchedueStatus = null;
var ScheduleAvailabilityOthers = false;
var ViewAppoinetmentOthers = false;
var JsonSchedueStatus = null;

function FunFillData(NewPageSize, OffSet, SortBy, SortDir, ExportType) {
    var str = "";
    if (ExportType == null || ExportType == "") {
        $("#tbldata").empty();
        ShowDataLoader();
    }
    else {
        ShowLoader();
    }

    var args = {
        PageSize: NewPageSize, OffSet: OffSet, SortBy: SortBy, SortDir: SortDir,
        PKID: 0,
        daterange: $("#dropaterange").val(), FromDate: $("#txtfromdate").val(), ToDate: $("#txttodate").val(),
        FKEmpID: $("#dropFKEmpIDSrch").val(),
        ApproveStatus: $("#dropApproveStatusSrch").val()

    };

    $.ajax({
        type: "POST",
        url: pagename + "/GetData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {

            if (data.d != "failure" && data.d != "Invalid Request") {
                var jsonarr = $.parseJSON(data.d);

                HideDataLoader();
                HideLoader();
                if (jsonarr.data.Table.length > 0) {
                    if (jsonarr.data.Table[0].Result == "1") {
                        if (ExportType == null || ExportType == "") {
                            var i = 0;




                            $.each(jsonarr.data.Table, function () {

                                var item = this;
                                var id = "trdata" + this.PKUserID;
                                var strtrClass = "";

                                str = str + '<li id="' + id + '" class="' + strtrClass + '"><div class="ulreport-box">';

                                str = str + '<div class="cellbox" style="width: 70px;">';
                                str = str + '<div class="datebox-outer"> <div class="datebox dateviewdet">';
                                str += '<div class="datedetail">' + this.DayName1 + ' <span>' + this.Day1 + '</span></div>';
                                str += '<div class="monthdetail">' + this.Month1 + ' ' + this.Year1 + ' </div>';
                                str += '</div></div>';


                                str += '</div>';

                                str += ' <div class="cellbox">';
                                //Middle Box Row
                                str += '<div class="row">';
                                str += '<div class="col-sm-6"> <h2>' + this.CutomerName + '';
                                if (this.CompanyName != '') {
                                    str += ' (' + this.CompanyName + ')';
                                }

                                str += '</h2><div class="descbox"><p>' + this.Remarks + '</p></div></div>'

                                str += ' <div class="col-sm-3 worktype">';
                                str += '<div class="empbox"><i class="fa fa-user"></i>&nbsp;' + this.EmpName + '</div>';
                                str += '<div class="divtime"><i class="fa fa-clock"></i>&nbsp;' + this.FromTime + '-' + this.ToTime + '</div>';
                               
                              


                                str += '</div>';

                                //Status box
                                str += '<div class="col-sm-3 text-right" style="position:relative;"><a  class="btn waves-effect btnstatus btnstatus' + this.ApproveStatus + '" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">' + this.ApproveStatus + ' <i class="uil-angle-down d-none d-xl-inline-block font-size-15"></i></a>';

                                str += FunStatusType(this.PKID, this.ApproveStatus);
                                str += '</div>';
                                //End Status Box


                                str += '</div>';
                                //End Middle Box Row


                                //Middle Botton
                                str += ' <div class="row"><div class="col-12">';
                                if (this.Mobile != '') {
                                    str += '<div class="bx-pull-left"><div class="divMobile"><i class="fa fa-mobile"></i>&nbsp;' + this.Mobile + '</div></div>';
                                }

                                if (this.EmailID != '') {
                                    str += '<div class="bx-pull-left"><div class="divEmailID"><i class="fa fa-envelope"></i>&nbsp;' + this.EmailID + '</div></div>';
                                }

                               
                                
                               
                                //Button
                                str += ' <div class="bx-pull-right customlink">';
                                str += '<a class="linkView" id="linkView' + this.PKID + '" title="View Detail"><i class="fa  fa-list"></i></a>';
                                if (IsEdit) {
                                    str += '<a class="linkEditRec" id="linkEditRec' + this.PKID + '" title="Edit Record"><i class="fa  fa-edit"></i></a>';

                                }
                                if (IsDelete) {
                                    str += ' <a class="linkDeleteRec" id="linkDeleteRec' + this.PKID + '" title="Delete Record"><i class="fa  fa-trash"></i></a>';

                                }
                              
                                str += ' </div>';

                                //End Button
                                str += '</div></div>';

                                //End Middle 
                                str += '</div>'


                                str = str + '</div></li>';
                                i++;

                            });

                            if (jsonarr.data.Table.length > 0) {
                                RCount = jsonarr.data.Table[0].RCount;
                            }
                            else {
                                RCount = 0;
                            }
                            $("#tbldata").append(str);

                            $("#tbldata").GenexList(RCount, FunFillData, true);

                            $('#tbldata').on('click', '.linkEditRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkEditRec", "");
                                PKID = parseInt(newid);
                                FunFillDetail('edit');

                            });
                            $('#tbldata').on('click', '.linkView', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkView", "");
                                PKID = parseInt(newid);
                                FunFillDetail('view');

                            });



                            $('#tbldata').on('click', '.linkChangeStatus', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("data-pkid");
                                var newid1 = $(this).attr("data-status");
                                FunUpdateScheduleStatus(newid, newid1);
                            });
                            $('#tbldata').on('click', '.linkDeleteRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkDeleteRec", "");
                                FunDelete(newid);
                            });


                        }
                        else {
                            $("#tbldata").GenexTableExport(JsonReportLayout, jsonarr.data.Table, ExportType);

                        }
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                    }
                }
            }
            else {
                OpenAlert("Session Timeout!");
                window.location.href = "Logout.aspx";
            }
        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            HideDataLoader();
            return;
        }

    });



}
function FunFillDetail(RecType) {
    ShowLoader();
    var args = {
        PageSize: 0, OffSet: 0, SortBy: '', SortDir: '',
        PKID: PKID, daterange: 'all', FromDate: '', ToDate: '', FKEmpID: '', ApproveStatus: ''


    };


    $.ajax({
        type: "POST",
        url: pagename + "/GetData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure" && data.d != "Invalid Request") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.data.Table.length > 0) {
                    if (jsonarr.data.Table[0].Result == "1") {
                        if (RecType == 'edit') {

                            FunBlank();
                            $('#popupTitle').find('span').html("Modify Appointment");
                            PKID = jsonarr.data.Table[0].PKID;
                           


                            $("#dropFKEmpID").val(jsonarr.data.Table[0].FKEmpID);

                            var strinterval = '<option value="' + jsonarr.data.Table[0].FKIntervalID + '">' + jsonarr.data.Table[0].FromTime + '-' + jsonarr.data.Table[0].ToTime + '</option>';
                            $("#dropFKIntervalID").append(strinterval);
                            $("#dropFKIntervalID").val(jsonarr.data.Table[0].FKIntervalID);

                            $("#txtOnDate").val(jsonarr.data.Table[0].OnDate);
                            $("#txtFromTime").val(jsonarr.data.Table[0].FromTime);
                            $("#txtToTime").val(jsonarr.data.Table[0].ToTime);
                            $("#txtCutomerName").val(jsonarr.data.Table[0].CutomerName);
                            $("#txtCompanyName").val(jsonarr.data.Table[0].CompanyName);
                            $("#txtEmailID").val(jsonarr.data.Table[0].EmailID);
                            $("#txtMobile").val(jsonarr.data.Table[0].Mobile);
                            $("#txtRemarks").val(jsonarr.data.Table[0].Remarks);
                            $("#dropApproveStatus").val(jsonarr.data.Table[0].ApproveStatus);

                            


                            opendiv('divAddNew');
                        }
                        else {

                            var strDate = jsonarr.data.Table[0].OnDate;
                            strDate = 'From ' + jsonarr.data.Table[0].FromTime + ' to ' + jsonarr.data.Table[0].ToTime;
                            $("#tdDate").html(strDate);


                            $("#tdEmployee").html(jsonarr.data.Table[0].EmpName);

                            $("#tdCustomer").html(jsonarr.data.Table[0].CutomerName + ' (' + jsonarr.data.Table[0].CompanyName + ')');
                          
                            $("#tdEmail").html(jsonarr.data.Table[0].EmailID);
                            $("#tdMobile").html(jsonarr.data.Table[0].Mobile);
                            $("#tdStatus").html(jsonarr.data.Table[0].ApproveStatus);
                            $("#tdRemark").html(jsonarr.data.Table[0].Remarks);
                            opendiv('divViewDetail');
                        }

                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                    }
                }
            }
            else {
                OpenAlert("Session Timeout!");
                window.location.href = "Logout.aspx";
            }
        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            HideDataLoader();
            return;
        }

    });



}
function FunFillIterval() {
    $('#dropFKIntervalID').empty();
    ShowLoader();
    var args = {
        OnDate: $("#txtOnDate").val(),
        FKEmpID: $('#dropFKEmpID').ValZero()
    };

    $.ajax({
        type: "POST",
        url: pagename + "/GetAppointmentAvailability",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            HideLoader();
            if (data.d != "failure" && data.d != "Invalid Request") {
                var jsonarr = $.parseJSON(data.d);
                var str = '';
                if (jsonarr.data != null && jsonarr.data.Table.length > 0) {

                    $.each(jsonarr.data.Table, function () {

                        str += '<option value="' + this.PKID + '" data-fromtime="' + this.FromTime + '" data-totime="' + this.ToTime + '">' + this.FromTime + '-' + this.ToTime + '</option>';

                    });



                }
                else {
                    OpenAlert('No availability added on selected date!');

                }
                $('#dropFKIntervalID').append('<option value="0">Select One</option>' + str);


            }
            else {
                OpenAlert("Session Timeout!");
                window.location.href = "Logout.aspx";
            }
        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideDataLoader();
            return;
        }

    });



}
function FunStatusType(RecID, FKStatusID) {
    var str = '<div class="dropdown-menu">';
    if (JsonSchedueStatus.length > 0) {
        $.each(JsonSchedueStatus, function (i, item) {
            if (item.PKID != FKStatusID && FKStatusID !='Cancelled') {
                str += ' <a data-pkid="' + RecID + '" data-status="' + item.PKID + '" class="dropdown-item linkChangeStatus" id="linkChangeStatus' + RecID + '_' + item.PKID + '" >' + item.StatusTitle + '</a>';

            }

        });


    }
    str += '</div>';
    return str;
}
function FunBlank() {
    PKID = 0;

    $('#divAddNew').find('.form-control').val('');
    $("#dropFKEmpID").val('0');
    $("#dropFKIntervalID").val('0');
    $("#dropApproveStatus").val('Confirmed');
    $("#dropFKIntervalID").empty();
    $('#popupTitle').find('span').html("New Appointment");

}



function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtOnDate").val() == "") {
        fail = true;
        $("#txtOnDate").css("border-color", ColorE);
        strError += "<li>Select Date</li>";
    }
    else {
        $("#txtOnDate").css("border-color", ColorN);
    }
    if ($("#dropFKEmpID").ValZero() == "0") {
        fail = true;
        $("#dropFKEmpID").css("border-color", ColorE);
        strError += "<li>Select Employee</li>";
    }
    else {
        $("#dropFKEmpID").css("border-color", ColorN);
    }

    if ($("#dropFKIntervalID").ValZero() == "0") {
        fail = true;
        $("#dropFKIntervalID").css("border-color", ColorE);
        strError += "<li>Select Interval</li>";
    }
    else {
        $("#dropFKIntervalID").css("border-color", ColorN);
    }

    if ($("#txtFromTime").val() == "") {
        fail = true;
        $("#txtFromTime").css("border-color", ColorE);
        strError += "<li>Select Start Time</li>";
    }
    else {
        $("#txtFromTime").css("border-color", ColorN);
    }
    if ($("#txtToTime").val() == "") {
        fail = true;
        $("#txtToTime").css("border-color", ColorE);
        strError += "<li>Select End Time</li>";
    }
    else {
        $("#txtToTime").css("border-color", ColorN);
    }

    if ($("#txtCutomerName").val() == "") {
        fail = true;
        $("#txtCutomerName").css("border-color", ColorE);
        strError += "<li>Enter Visitor Name</li>";
    }
    else {
        $("#txtCutomerName").css("border-color", ColorN);
    }
    if ($("#txtEmailID").val() == "") {
        fail = true;
        $("#txtEmailID").css("border-color", ColorE);
        strError += "<li>Enter Visitor Email ID</li>";
    }
    else {
        $("#txtEmailID").css("border-color", ColorN);
    }
    

    if ($("#txtRemarks").val() == "") {
        fail = true;
        $("#txtRemarks").css("border-color", ColorE);
        strError += "<li>Enter Remarks</li>";
    }
    else {
        $("#txtRemarks").css("border-color", ColorN);
    }

    if (!fail) {
        $("#divValidateSummary").hide();
        FunSave();

    } else {
        $("#divValidateSummary").show();
        $("#divValidateSummary").find(".validate-box ul").empty();
        $("#divValidateSummary").find(".validate-box ul").html(fail_log + strError);
        $('html, body').animate({
            scrollTop: $("#divValidateSummary").offset().top
        }, 500);
        return false;
    }
}

function FunSave() {



    var args = {
        PKID: PKID, FKEmpID: $("#dropFKEmpID").ValZero(), FKIntervalID: $("#dropFKIntervalID").ValZero(), OnDate: $("#txtOnDate").val(),
        FromTime: $("#txtFromTime").val(), ToTime: $("#txtToTime").val(), CutomerName: $("#txtCutomerName").val(),
        CompanyName: $("#txtCompanyName").val(), EmailID: $("#txtEmailID").val(),
        Mobile: $("#txtMobile").val(), Remarks: $("#txtRemarks").val(), ApproveStatus: $("#dropApproveStatus").val()
    };



    ShowLoader();
    $.ajax({

        type: "POST",
        url: pagename + "/SaveData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {

                    if (jsonarr[0].Result == "1") {
                        closediv();

                        HideLoader();
                        FunBlank();
                        OpenAlert('Saved Successfully!');

                        IsColCreated = false;
                        RCount = 0;
                        $("#tbldata").GenexTableDestroy();
                        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "");

                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                        HideLoader();
                    }
                }
                else {
                    OpenAlert("The call to the server side failed. ");

                }


            }
            else {
                OpenAlert(data.d);
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}

function FunDelete(RecID) {
    if (confirm("Do you want to delete this record?")) {
        var args = { PKID: RecID };
        ShowLoader();
        $.ajax({

            type: "POST",
            url: pagename + "/DeleteData",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);

                    if (jsonarr.length > 0) {
                        if (jsonarr[0].Result == "1") {

                            HideLoader();
                            PKID = 0;
                            IsColCreated = false;
                            RCount = 0;
                            $("#tbldata").GenexTableDestroy();
                            FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
                            OpenAlert("Record deleted successfully!");

                        }
                        else if (jsonarr[0].Result == "9") {
                            location.href = "Logout.aspx";
                        }
                        else {
                            HideLoader();
                            OpenAlert(jsonarr[0].Msg);
                        }

                    }

                }


            },
            error: function (x, e) {
                OpenAlert("The call to the server side failed. " + x.responseText);
                HideLoader();
                return;
            }

        });
    }
}

function FunUpdateScheduleStatus(RecID, FKStatusID) {
    if (confirm("Do you want to update the status?")) {
        var args = { PKID: RecID, FKStatusID: FKStatusID };
        ShowLoader();
        $.ajax({

            type: "POST",
            url: pagename + "/UpdateAppointmentsStatus",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {
                    var jsonarr = $.parseJSON(data.d);

                    if (jsonarr.length > 0) {
                        if (jsonarr[0].Result == "1") {

                            HideLoader();
                            PKID = 0;
                            IsColCreated = false;
                            RCount = 0;
                            $("#tbldata").GenexTableDestroy();
                            FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
                            OpenAlert("Record updated successfully!");

                        }
                        else if (jsonarr[0].Result == "9") {
                            location.href = "Logout.aspx";
                        }
                        else {
                            HideLoader();
                            OpenAlert(jsonarr[0].Msg);
                        }

                    }

                }


            },
            error: function (x, e) {
                OpenAlert("The call to the server side failed. " + x.responseText);
                HideLoader();
                return;
            }

        });
    }
}



function FunFillStatus() {
    var TableData = new Array();
    TableData[0] = {
        "PKID": 'Unconfirmed'
        , "StatusTitle": 'Unconfirmed'

    };
    TableData[1] = {
        "PKID": 'Confirmed'
        , "StatusTitle": 'Confirmed'

    };
    TableData[2] = {
        "PKID": 'Completed'
        , "StatusTitle": 'Completed'

    };
    TableData[3] = {
        "PKID": 'Cancelled'
        , "StatusTitle": 'Cancelled'

    };
    JsonSchedueStatus = TableData;
}

function FunCallToTimeEvent(NewID) {


    var newtime = $('#txtFromTime' + NewID).val();


    if (newtime == '') {

        $('#txtToTime' + NewID).val('');
        OpenAlert('Select From Time First');
    }
}

function InitilizeEvents() {

    $("#dropFKEmpID").change(function () {
        $('#dropFKIntervalID').empty();

        if ($("#dropFKEmpID").ValZero() != '0' && $("#txtOnDate").val() != '') {
            FunFillIterval();

        }
    });

    $("#txtOnDate").change(function () {
        $('#dropFKIntervalID').empty();

        if ($("#dropFKEmpID").ValZero() != '0' && $("#txtOnDate").val() != '') {
            FunFillIterval();

        }
    });

    $("#dropFKIntervalID").change(function () {
        $('#txtFromTime').val('');
        $('#txtToTime').val('');

        if ($("#dropFKIntervalID").ValZero() != '0') {

            var mintime = $('option:selected', this).attr('data-fromtime');
            var maxtime = $('option:selected', this).attr('data-totime');

            $('#txtFromTime').timepicker("destroy");
            $('#txtToTime').timepicker("destroy");


            var newtime = mintime;
            var AMPM = 'AM';
            if (newtime.indexOf('PM') > -1) {
                AMPM = 'PM';
            }
            newtime = newtime.replace('AM', '');
            newtime = newtime.replace('PM', '');
            newtime = newtime.replace(' ', '');          
            if (newtime != '') {

                var netime1 = newtime.split(':');
                var hours = netime1[0];
                var mins = netime1[1];

                if (parseInt(mins) == 15) {
                    
                    mins = '30';
                }
                else if (parseInt(mins) == 30) {

                    mins = '45';
                }
                else if (parseInt(mins) == 45) {

                    hours = parseInt(hours) + 1;
                    mins = '00';
                }
                else {
                    mins = parseInt(mins) + 15;
                }
                if (parseInt(hours) < 10) {
                    hours = '0' + parseInt(hours);

                }
                if (parseInt(mins) < 10) {
                    mins = '0' + parseInt(mins);

                }

                newtime = hours + ':' + mins + ':00';
               
            }


            $('#txtFromTime').timepicker({
                timeFormat: 'h:mm p',
                interval: 15,
                minTime: mintime,
                maxTime: maxtime,               
                startTime: mintime,
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });
            $('#txtToTime').timepicker({
                timeFormat: 'h:mm p',
                interval: 15,
                minTime: newtime,
                maxTime: maxtime,                
                startTime: newtime,
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });

            $('#txtFromTime').val(mintime);
            $('#txtToTime').val(maxtime);

        }
    });

    $("#btnSave").click(function () {
        FunValidate();
    });
    $("#btnAddNew").click(function () {
        if (IsAdd == 1) {
            FunBlank();
            opendiv("divAddNew");
        }
    });

    $("#btnSearch").click(function (event) {
        event.stopImmediatePropagation();
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        $("#tbldata").empty();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });
    $("#btnSearch1").click(function (event) {
        event.stopImmediatePropagation();
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        $("#tbldata").empty();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });

}
function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    if (LoadEntity == 0) {
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    }
}
function PageLoadFun() {
    InitilizeEvents();
    FunSetTabKey();
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
    SetDatePicker("txtfromdate");
    SetDatePicker("txttodate");

    SetDatePicker("txtOnDate");

    SetEmailBox("txtEmailID");
    SetMobileBox('txtMobile');

    FunFillStatus();

    LoadEntity = 3;

    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);
    GetUserInRole(SetOtherRoles, "23,24,");




}




function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}



function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}
function FunEmpCallBack(JsonArr) {


    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            if (ScheduleAvailabilityOthers == false) {
                if (item.PKID == $('#HidUserID').val()) {
                    str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
                }
            }
            else {
                str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
            }

        });
    }
    $('#dropFKEmpID').append('<option value="0">Select one</option>' + str);

    str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            if (ViewAppoinetmentOthers == false) {
                if (item.PKID == $('#HidUserID').val()) {
                    str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
                }
            }
            else {
                str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
            }

        });
    }

    $('#dropFKEmpIDSrch').append('<option value="">All</option>' + str);
    if (ViewAppoinetmentOthers == false) {
        $('#dropFKEmpIDSrch').val($('#HidUserID').val());
    }

    PageLoadComplete();
}
function SetOtherRoles(jsonarr) {


    if (jsonarr.length > 0) {
        if (jsonarr[0].IsFound == 1) {
            ScheduleAvailabilityOthers = true;
        }
        if (jsonarr[1].IsFound == 1) {
            ViewAppoinetmentOthers = true;
        }

    }
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, 'ForAppointment');

    PageLoadComplete();

}



$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});