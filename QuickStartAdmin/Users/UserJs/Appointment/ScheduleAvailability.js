
var pagename = "/Users/ScheduleAvailability.aspx";
var PKID = 0;
var DRowNo = 0;

var ClientRetainer = 0;
var stepsWizard = null;
var PrintPKID = 0;
var ScheduleAvailabilityOthers = false;
var ViewAppoinetmentOthers = false;

function AddNewDetailRow() {


    var trID = "";
    DRowNo = DRowNo + 1;
    trID = "trDRow" + DRowNo;

    var NewRow = '<tr id="' + trID + '" >';

    NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';

    NewRow += '<td class="tdOnDate"> <input type="text" id="txtOnDate' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdFromTime"> <input type="text" id="txtFromTime' + trID + '" class="form-control" readonly style="background-color: #ffffff;"  /></td>';
    NewRow += '<td class="tdToTime"> <input type="text" id="txtToTime' + trID + '" class="form-control" readonly  style="background-color: #ffffff;" /></td>';
    NewRow += '<td class="tdAMinutes"></td>';
    NewRow += '<td class="tdIsUsed"></td>';
    NewRow += "</tr>";
    $("#tblDetail tbody").append(NewRow);



    $('#linkDelete' + trID).click(function () {
        var NewID = $(this).attr("id");
        NewID = NewID.replace("linkDelete", "");

        if (confirm("Delete this record?")) {
            $("#" + NewID).addClass("trdeleted");
            $('#linkDelete' + NewID).remove();
           
        }
    });
    SetDatePicker('txtOnDate' + trID);
    $('#txtFromTime' + trID).timepicker({
        timeFormat: 'hh:mm p',
        interval: 30,

        defaultTime: '',
        startTime: '09:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true,
        change: function (time) {
            // the input field
            var element = $(this), text;
            var NewID = element[0].id;
            NewID = NewID.replace("txtFromTime", "");
            FunCallFromTimeEvent(NewID);
        }
    });
    $('#txtToTime' + trID).timepicker({
        timeFormat: 'hh:mm p',
        interval: 30,
        defaultTime: '',
        startTime: '09:30',
        dynamic: false,
        dropdown: true,
        scrollbar: true,
        change: function (time) {
            // the input field
            var element = $(this), text;
            var NewID = element[0].id;
            NewID = NewID.replace("txtToTime", "");
            FunCallToTimeEvent(NewID);
        }
    });
  
   

}

function FunCallFromTimeEvent(NewID) {

    
    var newtime = $('#txtFromTime' + NewID).val();
    var AMPM = 'AM';
    if (newtime.indexOf('PM') > -1) {
        AMPM = 'PM';
    }
    newtime = newtime.replace('AM', '');
    newtime = newtime.replace('PM', '');
    newtime = newtime.replace(' ', '');
    $('#txtToTime' + NewID).val('');
    if (newtime != '') {

        var netime1 = newtime.split(':');
        var hours = netime1[0];
        var mins = netime1[1];

        if (parseInt(mins) == 30) {

            hours = parseInt(hours) + 1;
            mins = '00';
        }
        else {
            mins = parseInt(mins) + 30;
        }
        if (parseInt(hours) < 10) {
            hours = '0' + parseInt(hours);

        }
        if (parseInt(mins) < 10) {
            mins = '0' + parseInt(mins);

        }

        newtime = hours + ':' + mins + ':00';
        $('#txtToTime' + NewID).timepicker("destroy");

        $('#txtToTime' + NewID).timepicker({
            timeFormat: 'hh:mm p',
            interval: 30,
            defaultTime: newtime,
            startTime: newtime,
            minTime: newtime,
            dynamic: false,
            dropdown: true,
            scrollbar: true,
            change: function (time) {
                // the input field
                var element = $(this), text;
                var NewID = element[0].id;
                NewID = NewID.replace("txtToTime", "");
                FunCallToTimeEvent(NewID);
            }
        });
    }
}
function FunCallToTimeEvent(NewID) {


    var newtime = $('#txtFromTime' + NewID).val();
   

    if (newtime == '') {

        $('#txtToTime' + NewID).val('');
        OpenAlert('Select From Time First');
    }
}

function FunBlank(rectype) {
    
    $('#tblDetail tbody').empty();
    if (rectype == 'all') {
        PKID = 0;
        $("#tabsinvoice").steps("setStep", 0);
    }
   

}

function FunValidate(StepNo) {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    if (StepNo == -1 || StepNo == 0) {

        if ($("#dropFKEmpID").ValZero() == "0") {
            fail = true;
            $("#dropFKEmpID").css("border-color", ColorE);
        }
        else {
            $("#dropFKEmpID").css("border-color", ColorN);
        }

    }


    if (StepNo == -1 || StepNo ==1) {
        var ItemCount = 0;
        $('#tblDetail tbody tr').each(function (row, tr) {
            var str = '';
            var trID = $(tr).attr("id");



            if (!$(tr).hasClass("trdeleted")) {
                ItemCount = ItemCount + 1;

                if ($("#txtOnDate" + trID).val() == "") {
                    fail = true;
                    $("#txtOnDate" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtOnDate" + trID).css("border-color", ColorN);
                }
                if ($("#txtFromTime" + trID).val() == "") {
                    fail = true;
                    $("#txtFromTime" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtFromTime" + trID).css("border-color", ColorN);
                }
                if ($("#txtToTime" + trID).val() == "") {
                    fail = true;
                    $("#txtToTime" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtToTime" + trID).css("border-color", ColorN);
                }
               
            }

        });

       


    }
    

    

    if (!fail) {
        $("#divValidateSummary").hide();
        return true;

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



function FunStoreItemData() {
    var TableData = new Array();
    var i = 0;
    $('#tblDetail tbody tr').each(function (row, tr) {
        var trid = $(tr).attr("id");


        var ModeForm = 0;
        if ($(tr).hasClass("trdeleted")) {
            ModeForm = 2;
        }
        TableData[i] = {
            "PKID": $("#hidPKID" + trid).ValZero()
            , "OnDate": $("#txtOnDate" + trid).val()
            , "FromTime": $("#txtFromTime" + trid).val()
            , "ToTime": $("#txtToTime" + trid).val()
            , "ModeForm": ModeForm
        };

        i++;

    });



    return TableData;
}

function FunSave() {
    ProgCount = 0;
    ShowLoader();
    var StrItemList = "";
    StrItemList = FunStoreItemData();
    StrItemList = JSON.stringify(StrItemList);

    


    var args = {
        PKID: PKID, FKEmpID: $('#dropFKEmpID').ValZero(),       
        dtItemStr: StrItemList
          
    };

    $.ajax({

        type: "POST",
        url: pagename + "/SaveData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            HideLoader();
            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {

                    if (jsonarr[0].Result == "1") {
                        FunBlank('all');
                        OpenAlert('Employee availability updated successfully');
                        FunFillData();

                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);

                    }
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



function FunFillData(rectype) {

    ShowLoader();
    var args = {
        daterange: $("#dropaterange").val(), FromDate: $("#txtfromdate").val(), ToDate: $("#txttodate").val(),
        FKEmpID: $('#dropFKEmpID').ValZero()
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
            HideLoader();
            if (data.d != "failure" && data.d != "Invalid Request") {
                var jsonarr = $.parseJSON(data.d);
                FunBlank(rectype);
                if (jsonarr.data != null && jsonarr.data.Table.length > 0) {                   
                  

                    $('#dropFKEmpID').val(jsonarr.data.Table[0].FKEmpID);
                   

                    $.each(jsonarr.data.Table, function () {
                        AddNewDetailRow();
                        var trID = "";
                        trID = "trDRow" + DRowNo;

                        $("#hidPKID" + trID).val(this.PKID);

                        $("#txtOnDate" + trID).val(this.OnDate);
                        $("#txtFromTime" + trID).val(this.FromTime);
                        $("#txtToTime" + trID).val(this.ToTime);
                        $("#" + trID).find('.tdAMinutes').html(this.TimeStr+' Hrs');
                       

                        if (this.IsUsed) {
                            $('#txtOnDate' + trID).prop('disabled', true);
                            $('#txtFromTime' + trID).prop('disabled', true);
                            $('#txtToTime' + trID).prop('disabled', true);

                            $('#linkDelete' + trID).hide();

                            $("#" + trID).find('.tdIsUsed').html(' <i class="fa fa-check-circle" title="Booked"></i>');
                        }
                       

                    });
                  
                   

                }
             


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
function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    if (LoadEntity == 0) {
        FunBlank('all');

       

    }
}
function InitilizeEvents() {
   

    $("#btnAddRow").click(function () {
        AddNewDetailRow();
    });


    $("#dropFKEmpID").change(function () {
        FunFillData('all');
    });
    $("#btnSearch").click(function () {
        FunFillData('');
    });
}

$.fn.steps.setStep = function (step) {
    var currentIndex = $(this).steps('getCurrentIndex');
    for (var i = 0; i < Math.abs(step - currentIndex); i++) {
        if (step > currentIndex) {
            $(this).steps('next');
        }
        else {
            $(this).steps('previous');
        }
    }
};
function PageLoadFun() {
    stepsWizard = $("#tabsinvoice").steps({
        headerTag: "h3",
        bodyTag: "section",
        transitionEffect: "slideLeft",
        autoFocus: true,
        onStepChanging: function (event, currentIndex, newIndex) {
            if (currentIndex < newIndex) {

                return FunValidate(currentIndex);
            }
            else {
                return true;
            }


        },
        onFinished: function () {
            ///more code
            var IsValid = FunValidate(-1);
            if (IsValid) {
                FunSave();
            }
            else {
                return false;
            }


        }
    });


    SetDatePicker("txtfromdate");
    SetDatePicker("txttodate");

    InitilizeEvents();

   
  

    LoadEntity = 2;

 
    GetUserInRole(SetOtherRoles, "23,24,");
    FunSetTabKey();



}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});