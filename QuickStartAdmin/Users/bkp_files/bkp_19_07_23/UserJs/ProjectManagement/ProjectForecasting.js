
var json;
var pagename = "/Users/ProjectForecasting.aspx";
var PKID = 0;
var FKParentID = 0;
var RecType = '';
var FKProjectID = 0;
var strProjectName=''


function FunBlankModule() {
    PKID = 0;
    
    $('#txtModuleName').val('');
    $('#txtModuleDesc').val('');
    $('#btnSaveModule').html('Submit');
    $('#btnDeleteModule').hide();
   

}
function FunBlankTask() {
    PKID = 0;

    $('#txtTitle').val('');
    $('#txtFKTaskID').GenexAutoCompleteBlank();
    $('#txtTitle').val('');
    $('#txtEstStartDate').val('');
    $('#txtEstEndDate').val('');
    $('#txtEstHrs').val('');
    $('#txtCompletePer').val('');
    $('#txtActvityDesc').val('');
    $('#btnSaveActivity').html('Submit');
    $('#btnDeleteActivity').hide();


}


function FunValidateProjectModule() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
   
    if ($("#txtModuleName").val() == "") {
        fail = true;
        $("#txtModuleName").css("border-color", ColorE);
        strError += "<li>Enter Module Title</li>";
    }
    else {
        $("#txtModuleName").css("border-color", ColorN);
    }

    if (!fail) {
        $("#divValidateSummary").hide();
        FunSaveProjectModule();

    } else {
        $("#divValidateSummary").show();
        $("#divValidateSummary").find(".validate-box ul").empty();
        $("#divValidateSummary").find(".validate-box ul").html(fail_log + strError);
        $('html, body').animate({
            scrollTop: (0)
        }, 500);
    }
}

function FunSaveProjectModule() {


    var args = {
        PKID: PKID, FKProjectID: FKProjectID, ModuleName: $("#txtModuleName").val(), ModuleDesc: $("#txtModuleDesc").val(), FKParentID: FKParentID, FKTaskID: 0, EstStartDate: '', EstEndDate: '',
        EstHrs:0, CompletePer:0, TaskStatus:'', RecType:'Module'
       
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
                        $("#btnAddNew1").hide();
                        HideLoader();
                        FunBlankModule();
                        FunFillData();
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

function FunValidateProjectModuleTask() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    if ($("#txtTitle").val() == "") {
        fail = true;
        $("#txtTitle").css("border-color", ColorE);
        strError += "<li>Enter Activity Title</li>";
    }
    else {
        $("#txtTitle").css("border-color", ColorN);
    }
    if ($("#txtFKTaskID").GenexAutoCompleteGet('0') == "0") {
        fail = true;
        $("#txtFKTaskID").css("border-color", ColorE);
        strError += "<li>Select Task Category</li>";
    }
    else {
        $("#txtFKTaskID").css("border-color", ColorN);
    }

    if (!fail) {
        $("#divValidateSummary").hide();
        FunSaveProjectModuleTask();

    } else {
        $("#divValidateSummary").show();
        $("#divValidateSummary").find(".validate-box ul").empty();
        $("#divValidateSummary").find(".validate-box ul").html(fail_log + strError);
        $('html, body').animate({
            scrollTop: (0)
        }, 500);
    }
}

function FunSaveProjectModuleTask() {


    var args = {
        PKID: PKID, FKProjectID: FKProjectID, ModuleName: $("#txtTitle").val(), ModuleDesc: $("#txtActvityDesc").val(),
        FKParentID: FKParentID, FKTaskID: $("#txtFKTaskID").GenexAutoCompleteGet('0'), EstStartDate: $("#txtEstStartDate").val(), EstEndDate: $("#txtEstEndDate").val(),
        EstHrs: $("#txtEstHrs").ValZero(), CompletePer: $("#txtCompletePer").ValZero(), TaskStatus: 'Pending', RecType: 'Task'

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

                        HideLoader();
                        FunBlankTask();
                        FunFillData();
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

function FunFillData() {
    var str = "";
    ShowLoader();
    var args = {
        PKID:0,
        FKProjectID: FKProjectID
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
                $('#divProjectModule').ComboTreeSelect(FKParentID);

                if (parseInt(FKParentID) == 0) {
                    $('#divAddTask').hide();
                    $('#divAddModule').hide();
                    $('#btnAddNew').hide();
                    $('#btnAddNew1').hide();
                    $('#divAddModule').show();
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
function FunFillDetail() {
  
    var str = "";
    ShowLoader();
    var args = {
        PKID: PKID, FKProjectID:0
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

                    if (jsonarr.data.Table[0].RecType == 'Module') {
                        FunBlankModule();
                        PKID = jsonarr.data.Table[0].PKID;
                        FKParentID = jsonarr.data.Table[0].FKParentID;
                        $('#txtModuleName').val(jsonarr.data.Table[0].ModuleName);
                        $('#txtModuleDesc').val(jsonarr.data.Table[0].ModuleDesc);
                        $('#btnSaveModule').html('Update');
                        $('#btnDeleteModule').show();

                    }
                    else {
                        FunBlankTask();
                        PKID = jsonarr.data.Table[0].PKID;
                        FKParentID = jsonarr.data.Table[0].FKParentID;
                        $('#txtTitle').val(jsonarr.data.Table[0].ModuleName);                      
                        $("#txtFKTaskID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKTaskID, jsonarr.data.Table[0].TaskCode + ':' + jsonarr.data.Table[0].TaskName);

                       
                        $('#txtEstStartDate').val(jsonarr.data.Table[0].EstStartDate);
                        $('#txtEstEndDate').val(jsonarr.data.Table[0].EstEndDate);
                        $('#txtEstHrs').val(jsonarr.data.Table[0].EstHrs);
                        $('#txtCompletePer').val(jsonarr.data.Table[0].CompletePer);
                        $('#txtActvityDesc').val(jsonarr.data.Table[0].ModuleDesc);
                        $('#btnSaveActivity').html('Update');
                        $('#btnDeleteActivity').show();

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
            return;
        }

    });

}
function FunGotoStep1() {

    if (FKProjectID != '0') {
        $('#divProjectName').html(strProjectName);
        FunBlankModule();
        FunBlankTask();
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
function FunSetTaskDetail(item, inputid) {

    var FKTaskID = $("#" + inputid).GenexAutoCompleteGet(0);
    var NewID = inputid;
    NewID = NewID.replace("txtFKTaskID", "");
    if (FKTaskID != 0) {
        $('#txtActvityDesc').val(item.Description);
        $('#txtEstHrs').val(item.BHours);
    }
    

}
function FunDelete() {
    if (confirm("Do you want to delete this record?")) {
        var args = { PKID: PKID };
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
                            FunBlankTask();
                            FunBlankModule();
                            HideLoader();
                            PKID = 0;
                            FunFillData();
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
function FunProjectCallBack(JsonArr) {
    $('#txtFKProjectID').GenexAutoCompleteWithCallBack(JsonArr, FunSetProjectDetail, 0, "ProjectID,Project,ClientID");

   
}
function FunTaskCallBack(JsonArr) {
    $('#txtFKTaskID').GenexAutoCompleteWithCallBack(JsonArr, FunSetTaskDetail, 0, "TaskCode,Task Name,Description");

   
}
function InitilizeEvents() {
    $("#btnDeleteActivity").click(function () {
        FunDelete();
    });
    $("#btnDeleteModule").click(function () {
        FunDelete();
    });
    $("#btnNext").click(function () {
        FunGotoStep1();
    });
    $("#btnBackStep1").click(function () {
        FKParentID = 0;
        $('#divStep1').show();
        $('#divStep2').hide();
    });
    $("#btnSaveActivity").click(function () {
        FunValidateProjectModuleTask();
    });
    $("#btnSaveModule").click(function () {
        FunSaveProjectModule();
    });
    $("#btnAddNew").click(function () {
        FKParentID = PKID;
        $("#btnAddNew").hide();
        FunBlankModule();

        $('#divAddTask').hide();
        $('#divAddModule').show();
    });
    $("#btnAddNew1").click(function () {
        $("#btnAddNew1").hide();
        $("#btnAddNew").hide();
        $('#divAddTask').show();
        $('#divAddModule').hide();
        if (PKID != '0') {
            FKParentID = PKID;
        }
        FunBlankTask();
    });
}


function PageLoadFun() {
  
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetTaskForAutoComplete(FunTaskCallBack, 0, 0, 'T', 'Active');
    InitilizeEvents();

   
    SetNumberBox('txtEstHrs',2, false, '');
    SetNumberBox('txtCompletePer', 0, false, '');
    SetDatePicker('txtEstStartDate');
    SetDatePicker('txtEstEndDate');
   
    FunSetTabKey();
    

   
  
   
   
   
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});