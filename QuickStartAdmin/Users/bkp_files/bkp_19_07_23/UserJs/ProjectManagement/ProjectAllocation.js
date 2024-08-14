
var json;
var pagename = "/Users/ProjectAllocation.aspx";
var PKID = 0;
var FKTaskID = 0;
var FKParentID = 0;
var RecType = '';
var FKProjectID = 0;
var strProjectName = ''


function FunBalnkStatus() {

    $('#dropNewStatus').val('');
    $('#txtCompletePer').val('');
    $('#txtStartDate').val('');
    $('#txtEndDate').val('');
    FunSetStatusDiv();

}
function FunBlankTask() {
    PKID = 0;

    $('#txtAssignDate').val('');
    $('#txtFKEmpID').GenexAutoCompleteBlank();
    $('#txtFKManagerID').GenexAutoCompleteBlank();



}


function FunValidateProjectStatus() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    if ($('#dropNewStatus').val() == '') {
        fail = true;
        $("#dropNewStatus").css("border-color", ColorE);
        strError += "<li>Select New Status</li>";

    }
    else {
        $("#dropNewStatus").css("border-color", ColorN);
    }

    if ($('#dropNewStatus').val() == 'Started') {
        if ($("#txtStartDate").val() == "") {
            fail = true;
            $("#txtStartDate").css("border-color", ColorE);
            strError += "<li>Enter Start Date</li>";
        }
        else {
            $("#txtStartDate").css("border-color", ColorN);
        }
    }
   
    else if ($('#dropNewStatus').val() == 'Complete') {
        if ($("#txtEndDate").val() == "") {
            fail = true;
            $("#txtEndDate").css("border-color", ColorE);
            strError += "<li>Enter End Date</li>";
        }
        else {
            $("#txtEndDate").css("border-color", ColorN);
        }
    }


    if (!fail) {
        $("#divValidateSummary1").hide();
        FunSaveProjectStatus();

    } else {
        $("#divValidateSummary1").show();
        $("#divValidateSummary1").find(".validate-box ul").empty();
        $("#divValidateSummary1").find(".validate-box ul").html(fail_log + strError);
        $('html, body').animate({
            scrollTop: (0)
        }, 500);
    }
}

function FunSaveProjectStatus() {

    var NewDate = '', CompletePer = 0;

    if ($('#dropNewStatus').val() == 'Started') {
        NewDate = $('#txtStartDate').val();
    }
    else if ($('#dropNewStatus').val() == 'Process') {
        CompletePer = $('#txtCompletePer').ValZero();
    }
    else if ($('#dropNewStatus').val() == 'Complete') {
        NewDate = $('#txtEndDate').val();
        CompletePer = '100';
    }

    var args = {
        PKID: PKID, NewStatus: $("#dropNewStatus").val(), NewDate: NewDate, CompletePer: CompletePer

    };
    ShowLoader();
    $.ajax({

        type: "POST",
        url: pagename + "/UpdateModuleStatus",
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
                        FunBalnkStatus();
                        FunFillDetail();
                        OpenAlert('Saved Successfully!');


                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                        HideLoader();
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

function FunValidateAssign() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    if ($("#txtAssignDate").val() == "") {
        fail = true;
        $("#txtAssignDate").css("border-color", ColorE);
        strError += "<li>Enter Assign Date</li>";
    }
    else {
        $("#txtAssignDate").css("border-color", ColorN);
    }
    if ($("#txtFKEmpID").GenexAutoCompleteGet('0') == "0") {
        fail = true;
        $("#txtFKEmpID").css("border-color", ColorE);
        strError += "<li>Select Employee</li>";
    }
    else {
        $("#txtFKEmpID").css("border-color", ColorN);
    }
    if ($("#txtFKManagerID").GenexAutoCompleteGet('0') == "0") {
        fail = true;
        $("#txtFKManagerID").css("border-color", ColorE);
        strError += "<li>Select Manager</li>";
    }
    else {
        $("#txtFKManagerID").css("border-color", ColorN);
    }

    if (!fail) {
        $("#divValidateSummary").hide();
        FunSaveAssign();

    } else {
        $("#divValidateSummary").show();
        $("#divValidateSummary").find(".validate-box ul").empty();
        $("#divValidateSummary").find(".validate-box ul").html(fail_log + strError);
        $('html, body').animate({
            scrollTop: (0)
        }, 500);
    }
}

function FunSaveAssign() {


    var args = {
        PKID: PKID, FKEmpID: $("#txtFKEmpID").GenexAutoCompleteGet('0'), FKManagerID: $("#txtFKManagerID").GenexAutoCompleteGet('0'),
        AssignDate: $("#txtAssignDate").val()

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
                        OpenAlert('Saved Successfully!');
                        FunFillDetail();



                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                        HideLoader();
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
    var str = "";
    ShowLoader();
    var args = {
        PKID: 0,
        FKProjectID: FKProjectID, FKParentID: 0, RecType: 'Module'
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

                $('#divProjectModule').ProjectModuleTree(jsonarr, false, false);
                FKParentID = 0;
                PKID = 0;
                FunFillDetail();
            }
            else {
                OpenAlert("Session Timeout!");
                window.location.href = "Logout.aspx";
            }
        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });



}
function FunFillDetail() {
    $("#tbldata").empty();
    $('#divNoData').hide();
    var str = "";
    ShowLoader();
    var args = {
        PKID: 0, FKProjectID: FKProjectID, FKParentID: FKParentID, RecType: 'TaskSearch'
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
                    $.each(jsonarr.data.Table, function (i, item) {


                        str += ' <li>';
                        str += ' <div class="row">';
                        str += '<div class="col-md-6"><span class="task-code">' + item.TaskCode + ':' + item.TaskName + '</span></div>';
                        str += '<div class="col-md-6 text-right">';
                        if (item.AssignedEmp != '') {
                            str += ' <span class="emp-assign"><i class="fa fa-users"></i>&nbsp;' + item.AssignedEmp + '</span>'
                        }
                        str += '<a class="linkAssign" id="linkAssign' + item.PKID + '"><i class="fa fa-plus"></i>&nbsp;Assign</a></div>';
                        str += '  </div>';



                        str += '   <div class="row"><div class="col-md-12"><div class="detail-box">';
                        str += ' <div class="row">';
                        str += ' <div class="col-9"><h2>' + item.ModuleName + '</h2><p class="module-desc">' + item.ModuleDesc + '</p></div>';
                        if (item.TaskStatus == 'Pending') {
                            str += '  <div class="col-3" style="text-align:right;"><span class="module-status">Status: <span style="color:red;">Pending</span> </span> ';

                        }
                        else if (item.TaskStatus == 'Started') {
                            str += '  <div class="col-3" style="text-align:right;"><span class="module-status">Status: <span style="color:orange;">Started</span> </span> ';

                        }
                        else if (item.TaskStatus == 'Process') {
                            str += '  <div class="col-3" style="text-align:right;"><span class="module-status">Status: <span style="color:green;">Process ' + item.CompletePer + '%</span> </span> ';

                        }
                        else if (item.TaskStatus == 'Complete') {
                            str += '  <div class="col-3" style="text-align:right;"><span class="module-status">Status: <span>Complete</span> </span> ';

                        }

                        str += '<span class="module-status-set"><a id="linkSetStatus' + item.PKID + '" class="linkSetStatus">(Set Status)</a>';

                        str += '</span></div>';
                        str += '</div>';

                        str += '<div class="row"><div class="col-12 parent-detail">' + item.ParentList + '</div></div>';

                        str += ' <div class="row"><div class="col-md-12"><div class="sub-detail-box"><div class="row">';
                        str += ' <div class="col-6 col-md-2"><div class="sub-detail-box-item">Est. Start Date<br /> <span>' + item.EstStartDate + '</span></div></div>';
                        str += ' <div class="col-6 col-md-2"><div class="sub-detail-box-item">Est. End Date<br /> <span>' + item.EstEndDate + '</span></div></div>';
                        if (item.StartDate == '') {
                            str += ' <div class="col-6 col-md-2"><div class="sub-detail-box-item">Start Date<br /> <span>N/A</span></div></div>';
                        }
                        else {
                            str += ' <div class="col-6 col-md-2"><div class="sub-detail-box-item">Start Date<br /> <span>' + item.StartDate + '</span></div></div>';
                        }
                        if (item.EndDate == '') {
                            str += ' <div class="col-6 col-md-2"><div class="sub-detail-box-item">End Date<br /> <span>N/A</span></div></div>';
                        }
                        else {
                            str += ' <div class="col-6 col-md-2"><div class="sub-detail-box-item">End Date<br /> <span>' + item.EndDate+'</span></div></div>';
                        }

                        str += ' <div class="col-6 col-md-2"><div class="sub-detail-box-item"> Est. Hours<br /> <span>' + item.EstHrs + '</span></div></div>';
                        str += ' <div class="col-6 col-md-2"><div class="sub-detail-box-item">Actual Hours<br /> <span>' + item.ActualHours + '</span></div></div>';
                        str += '</div> </div></div>';
                        str += '  </div></div></div></div>';
                        str += '</li>';



                    });
                    $("#tbldata").append(str);

                    $('#tbldata').on('click', '.linkAssign', function (event) {
                        event.stopImmediatePropagation();
                        var newid = $(this).attr("id");
                        newid = newid.replace("linkAssign", "");
                        FunBlankTask();
                        PKID = parseInt(newid);
                        opendiv('divAddNew');

                    });
                    $('#tbldata').on('click', '.linkSetStatus', function (event) {
                        event.stopImmediatePropagation();
                        var newid = $(this).attr("id");
                        newid = newid.replace("linkSetStatus", "");
                        FunBalnkStatus();
                        PKID = parseInt(newid);
                        opendiv('divAddStatus');

                    });
                }
                else {
                    $('#divNoData').show();
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
            return;
        }

    });

}
function FunGotoStep1() {

    if (FKProjectID != '0') {
        $('#divProjectName').html(strProjectName);
        FKParentID = 0;
        PKID = 0;
        $('#divStep1').hide();
        $('#divStep2').show();
        $('#divStep1Control').hide();
        $('#divStep2Control').show();
        FunFillData();

    }
    else {

        OpenAlert('Please choose a project');
    }


}
function FunSetProjectDetail(item, inputid) {

    FKProjectID = $("#" + inputid).GenexAutoCompleteGet(0);
    if (FKProjectID != '0') {
        strProjectName = item.ProjectName;
    }

}

function FunSetStatusDiv() {
    $('#divStartDate').hide();
    $('#divCompletePer').hide();
    $('#divEndDate').hide();
    if ($('#dropNewStatus').val() == 'Started') {
        $('#divStartDate').show();
    }
    else if ($('#dropNewStatus').val() == 'Process') {
        $('#divCompletePer').show();
    }
    else if ($('#dropNewStatus').val() == 'Complete') {
        $('#divEndDate').show();
    }
}
function FunProjectCallBack(JsonArr) {
    $('#txtFKProjectID').GenexAutoCompleteWithCallBack(JsonArr, FunSetProjectDetail, 0, "ProjectID,Project,ClientID");


}
function FunEmpCallBack(JsonArr) {
    $("#txtFKEmpID").GenexAutoComplete(JsonArr, "EmpID,Name,Status");
    $("#txtFKManagerID").GenexAutoComplete(JsonArr, "EmpID,Name,Status");

    PageLoadComplete();
}
function InitilizeEvents() {

    $("#btnNext").click(function () {
        FunGotoStep1();
    });
    $("#btnBackStep1").click(function () {
        FKParentID = 0;
        $('#divStep1').show();
        $('#divStep2').hide();
    });
    $("#btnSave").click(function () {
        FunValidateAssign();
    });
    $("#dropNewStatus").change(function () {
        FunSetStatusDiv();
    });
    $("#btnSaveStatus").click(function () {
        FunValidateProjectStatus();
    });
    
}


function PageLoadFun() {

    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, 'Active');
    InitilizeEvents();

    SetDatePicker('txtAssignDate');
    SetDatePicker('txtStartDate');
    SetDatePicker('txtEndDate');
    SetNumberBox('txtCompletePer',0,false,'');


    FunSetTabKey();







}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});