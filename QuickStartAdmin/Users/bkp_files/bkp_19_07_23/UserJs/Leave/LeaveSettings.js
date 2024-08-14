
var pagename = "/Users/LeaveSettings.aspx";
var PKID = 0;
var DRowNo = 0;

var ClientRetainer = 0;
var stepsWizard = null;
var PrintPKID = 0;


function AddNewDetailRow() {


    var trID = "";
    DRowNo = DRowNo + 1;
    trID = "trDRow" + DRowNo;

    var NewRow = '<tr id="' + trID + '" >';

    NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';

    NewRow += '<td class="tdLeaveName"> <input type="text" id="txtLeaveName' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdPayType"> <select  id="txtPayType' + trID + '" class="form-select"><option value="Paid">Paid</option><option value="Unpaid">Unpaid</option></select></td>';
    NewRow += '<td class="tdPerMonthAccr"> <input type="text" id="txtPerMonthAccr' + trID + '" class="form-control"    /></td>';
    NewRow += '<td class="tdLeaveCount"> <input type="text" id="txtLeaveCount' + trID + '" class="form-control"  /></td>';
    NewRow += '<td class="tdCFNextYear" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkCFNextYear' + trID + '"  /></td>';
    NewRow += "</tr>";
    $("#tblDetail tbody").append(NewRow);



    $('#linkDelete' + trID).click(function () {
        var NewID = $(this).attr("id");
        NewID = NewID.replace("linkDelete", "");

        if (confirm("Delete this record?")) {
            $("#" + NewID).addClass("trdeleted");
            $('#linkDelete' + NewID).remove();
            FunSetTotal();
        }
    });




    SetNumberBox('txtPerMonthAccr' + trID, 0, false, '');
    SetNumberBox('txtLeaveCount' + trID, 0, false, '');





    $('#txtPerMonthAccr' + trID).change(function () {
        var temp = $('#txtPayType' + trID).val();
        if (temp == "Paid") {
            var Leavecount = parseInt($('#txtPerMonthAccr' + trID).ValZero()) * 12;
            $('#txtLeaveCount' + trID).val(Leavecount);
        }

    });

    $('#txtPayType' + trID).change(function () {
        $('#txtPerMonthAccr' + trID).val('');
        $('#txtLeaveCount' + trID).val('');
        $('#chkCFNextYear' + trID).prop('checked', false);

        var temp = $(this).val();
        if (temp == "Paid") {
            $('#txtPerMonthAccr' + trID).prop('disabled', false);
            $('#txtLeaveCount' + trID).prop('disabled', false);
            $('#chkCFNextYear' + trID).prop('disabled', false);
            $('#chkCFNextYear' + trID).prop('checked', true);

        }
        else {
            $('#txtPerMonthAccr' + trID).prop('disabled', true);
            $('#txtLeaveCount' + trID).prop('disabled', true);
            $('#chkCFNextYear' + trID).prop('disabled', true);
           
        }
    });
    

}




function FunBlank(rectype) {
    PKID = 0;
    $('#tblDetail tbody').empty();
    $('#tblWeekDays tbody').find('input').val('');

    $("#tabsinvoice").steps("setStep", 0);

}

function FunValidate(StepNo) {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

  

    if (StepNo == -1 || StepNo ==1) {
        var ItemCount = 0;
        $('#tblDetail tbody tr').each(function (row, tr) {
            var str = '';
            var trID = $(tr).attr("id");



            if (!$(tr).hasClass("trdeleted")) {
                ItemCount = ItemCount + 1;

                if ($("#txtLeaveName" + trID).val() == "") {
                    fail = true;
                    $("#txtLeaveName" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtLeaveName" + trID).css("border-color", ColorN);
                }
               
            }

        });

        if (ItemCount == 0) {
            fail = true;
            OpenAlert('Select Leave Type');
        }


    }
    ItemCount = 0;

    if (StepNo == -1 || StepNo == 2) {

        $('#tblWeekDays tbody tr').each(function (row, tr) {
            var str = '';
            var trID = $(tr).attr("id");
            trID = trID.replace('trDayName', '');


            if ($('#chkDayName' + trID).is(":checked")) {
                ItemCount = ItemCount + 1;

                if ($("#txtStartTime" + trID).val() == "") {
                    fail = true;
                    $("#txtStartTime" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtStartTime" + trID).css("border-color", ColorN);
                }
                if ($("#txtEndTime" + trID).val() == "") {
                    fail = true;
                    $("#txtEndTime" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtEndTime" + trID).css("border-color", ColorN);
                }

            }

        });

        if (ItemCount == 0) {
            fail = true;
            OpenAlert('Select working days');
        }

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
            , "LeaveName": $("#txtLeaveName" + trid).val()
            , "PayType": $("#txtPayType" + trid).val()
            , "PerMonthAccr": parseFloat($("#txtPerMonthAccr" + trid).ValZero()).toFixed(2)
            , "LeaveCount": parseFloat($("#txtLeaveCount" + trid).ValZero()).toFixed(2)
            , "CFNextYear": $("#chkCFNextYear" + trid).is(':checked')
            , "ModeForm": ModeForm
        };

        i++;

    });



    return TableData;
}
function FunStoreWrokDays() {
    var TableData = new Array();
    var i = 0;
    $('#tblWeekDays tbody tr').each(function (row, tr) {
        var trid = $(tr).attr("id");
        trid = trid.replace('trDayName', '');

        var ModeForm = 0;
        
        TableData[i] = {
            "PKID": $("#hidDayID" + trid).ValZero()
            , "DayNum": trid
            , "IsOn": $('#chkDayName' + trid).is(":checked")
            , "StartTime": $("#txtStartTime" + trid).val()
            , "EndTime": $("#txtEndTime" + trid).val()
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

    var StrWorkDays = "";
    StrWorkDays = FunStoreWrokDays();
    StrWorkDays = JSON.stringify(StrWorkDays);


    var args = {
        PKID: PKID, StartMonth: $('#dropStartMonth').val(),
        EndMonth: $('#dropEndMonth').val(), LeaveRule: $('#dropLeaveRule').val(),
        dtItemStr: StrItemList, dtWorkingDaysStr: StrWorkDays
          
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
                        FunBlank();
                        OpenAlert('Leave plan updated successfully');
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



function FunFillData() {

    ShowLoader();
    var args = {
        PKID: PKID
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
                FunBlank();
                if (jsonarr.data != null && jsonarr.data.Table.length > 0) {
                    PKID = jsonarr.data.Table[0].PKID;
                  

                    $('#dropStartMonth').val(jsonarr.data.Table[0].StartMonth);
                    $('#dropEndMonth').val(jsonarr.data.Table[0].EndMonth);
                    $('#dropLeaveRule').val(jsonarr.data.Table[0].LeaveRule);


                  

                    $.each(jsonarr.data.Table1, function () {
                        AddNewDetailRow();
                        var trID = "";
                        trID = "trDRow" + DRowNo;

                        $("#hidPKID" + trID).val(this.PKID);

                        $("#txtLeaveName" + trID).val(this.LeaveName);
                        $("#txtPayType" + trID).val(this.PayType);
                        $("#txtPerMonthAccr" + trID).val(this.PerMonthAccr);
                        $("#txtLeaveCount" + trID).val(this.LeaveCount);
                        $("#chkCFNextYear" + trID).prop('checked', this.CFNextYear);

                        if (this.PayType == "Paid") {
                            $('#txtPerMonthAccr' + trID).prop('disabled', false);
                            $('#txtLeaveCount' + trID).prop('disabled', false);
                            $('#chkCFNextYear' + trID).prop('disabled', false);
                            $('#chkCFNextYear' + trID).prop('checked', true);
                        }
                        else {
                            $('#txtPerMonthAccr' + trID).prop('disabled', true);
                            $('#txtLeaveCount' + trID).prop('disabled', true);
                            $('#chkCFNextYear' + trID).prop('disabled', true);

                        }

                    });
                    $.each(jsonarr.data.Table2, function () {
                       
                        var trID = "";
                        trID = this.DayNum;

                        $("#hidDayID" + trID).val(this.PKID);

                        $("#chkDayName" + trID).prop('checked', this.IsOn);
                        $("#txtStartTime" + trID).val(this.StartTime);
                        $("#txtEndTime" + trID).val(this.EndTime);

                        if (this.IsOn) {

                            $('#txtStartTime' + trID).show();
                            $('#txtEndTime' + trID).show();
                        }
                        else {

                            $('#txtStartTime' + trID).hide();
                            $('#txtEndTime' + trID).hide();
                        }
                       

                    });
                   

                }
                else {
                    OpenAlert(jsonarr[0].Msg);
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


function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    if (LoadEntity == 0) {
        FunBlank('');

        FunFillData();

    }
}
function InitilizeEvents() {
   

    $("#btnAddRow").click(function () {
        AddNewDetailRow();
    });

   
    $('#tblWeekDays').on('click', '.form-check-input', function (event) {
        event.stopImmediatePropagation();
        var newid = $(this).attr("id");
        newid = newid.replace("chkDayName", "");
        $('#txtStartTime' + newid).val('');
        $('#txtEndTime' + newid).val('');
        if ($(this).is(':checked')) {

            $('#txtStartTime' + newid).show();
            $('#txtEndTime' + newid).show();
        }
        else {

            $('#txtStartTime' + newid).hide();
            $('#txtEndTime' + newid).hide();
        }

    });


    $('#tblWeekDays').find('.starttime').hide();
    $('#tblWeekDays').find('.endtime').hide();
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

    InitilizeEvents();

    $('.starttime').timepicker({
        timeFormat: 'hh:mm p',
        interval: 30,
       
        defaultTime: '10',
        startTime: '10:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
    });
    $('.endtime').timepicker({
        timeFormat: 'hh:mm p',
        interval: 30,        
        defaultTime: '10',
        startTime: '10:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
    });
  

    LoadEntity = 1;

    PageLoadComplete();
    FunSetTabKey();



}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});