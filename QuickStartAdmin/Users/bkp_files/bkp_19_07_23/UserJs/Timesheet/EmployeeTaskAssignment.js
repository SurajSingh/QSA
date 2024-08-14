

var pagename = "EmployeeTaskAssignment.aspx";
var PKID = 0;
var FKPageID = 0;
var RCount = 0;
var JsonExport = null;
var IsColCreated = false;
var JsonReportLayout = null;
var JsonProject = null;
var JsonTask = null;
var DRowNo = 0;

var FKLogPKID = 0;
var FKLogFKProjectID = 0;
var FKLogFKTaskID = 0;
var FKLogEmpID = 0;
var FKLogManagerID = 0;

function FunFillData(NewPageSize, OffSet, SortBy, SortDir, ExportType) {
    var str = "";
    if (ExportType == null || ExportType == "") {
        $("#tbldata tbody").empty();
        ShowDataLoader();
    }
    else {
        ShowLoader();
    }

    var args = {
        PageSize: NewPageSize, OffSet: OffSet, SortBy: SortBy, SortDir: SortDir,
        daterange: $("#dropaterange").val(), FromDate: $("#txtfromdate").val(), ToDate: $("#txttodate").val(), PKID: 0,
        FKEmpID: $("#dropFKEmpIDSrch").val(),
        FKProjectID: $("#dropFKProjectIDSrch").val(), FKClientID: $("#dropFKClientIDSrch").val(), FKTaskID: '', CurrentStatus: $("#dropActiveStatusSrch").val(), FKManagerID: $("#dropFKManagerIDSrch").ValZero()


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

                HideDataLoader();
                HideLoader();
                if (jsonarr.data.Table.length > 0) {
                    if (jsonarr.data.Table[0].Result == "1") {
                        if (ExportType == null || ExportType == "") {
                            var i = 0;

                            var tblid = "tbldata";
                            var tblid1 = $("#tbldata");

                            if ($("#" + tblid).parent().parent().find('.floatThead-table').length) {
                                tblid1 = $("#" + tblid).parent().parent().find('.floatThead-table');
                            }


                            $.each(jsonarr.data.Table, function () {

                                var item = this;
                                var id = "trdata" + this.PKID;
                                var strtrClass = "even";
                                if (i % 2 == 0) {
                                    strtrClass = "odd";
                                }
                                str = str + '<tr id="' + id + '" class="' + strtrClass + '">';
                                if (this.CurrentStatus == 'Completed') {
                                    str += "<td></td>";
                                }
                                else {
                                    if ((IsAdd == 1 && parseInt($('#HidUserID').ValZero()) == this.FKCreatedBy) || parseInt($('#HidUserID').ValZero()) == this.FKEmpID || parseInt($('#HidUserID').ValZero()) == this.FKManagerID) {
                                        str = str + '<td style="text-align:center">  <a class="linkEditRec text-warning" id="linkEditRec' + this.PKID + '"  title="Add Log"> <i class="uil uil-clock-two font-size-18"></i></a></td>';

                                    }
                                    else {
                                        str += "<td></td>";
                                    }
                                }

                                if (IsDelete == 1 && this.LogCount == 0 && parseInt($('#HidUserID').ValZero()) == this.FKCreatedBy) {
                                    str = str + '<td style="text-align:center">  <a class="linkDeleteRec text-danger" id="linkDeleteRec' + this.PKID + '"  title="Delete Record"><i class="uil uil-trash-alt font-size-18"></i></a></td>';
                                }
                                else {
                                    str += "<td></td>";
                                }

                                tblid1.find('thead th').each(function (row, th) {
                                    var attr = $(th).attr('data-column');
                                    var strval = '';
                                    var strclass = '';
                                    if (typeof attr != typeof undefined && attr != false) {
                                        strclass = 'td' + attr;
                                        if (!$(th).hasClass('hidetd')) {
                                            if ($(th).hasClass('tdclsnum')) {
                                                strclass = strclass + ' tdclsnum';
                                            }

                                            strval = item[attr];
                                            if ($(th).hasClass('tdclscurrency')) {
                                                strclass = strclass + ' tdclscurrency';
                                                var TranCurrency = CurrencyName;
                                                strval = TranCurrency + ' ' + strval;
                                            }
                                            if ($(th).hasClass('tdclsPer')) {
                                                strclass = strclass + ' tdclsPer';

                                                strval = strval + '%';
                                            }


                                        }

                                        str = str + '<td class="' + strclass + '">' + strval + '</td>';
                                    }



                                });



                                i++;
                                str += '</tr>';
                            });
                            if (jsonarr.data.Table.length > 0) {
                                RCount = jsonarr.data.Table[0].RCount;
                            }
                            else {
                                RCount = 0;
                            }
                            $("#tbldata tbody").append(str);

                            $("#tbldata").GenexTable(RCount, JsonReportLayout, FunFillData, true, true, true);
                            $('#tbldata').on('click', '.linkEditRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkEditRec", "");
                                PKID = parseInt(newid);
                                FunFillDetail();

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

                if (ExportType == null || ExportType == "") {
                    if (RCount == 0) {
                        $("#tbldata").GenexTable(RCount, JsonReportLayout, FunFillData, true, true, true);
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
function FunFillDetail() {
    ShowLoader();
    var args = {
        PageSize: 0, OffSet: 0, SortBy: '', SortDir: '',
        daterange: 'All', FromDate: '', ToDate: '', PKID: PKID,
        FKEmpID: '',
        FKProjectID: '', FKClientID: '', FKTaskID: '', CurrentStatus: '', FKManagerID: 0


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
                HideLoader();
                var str = '';
                var jsonarr = $.parseJSON(data.d);
                FunBlankLog('');
                if (jsonarr.data.Table.length > 0) {
                    if (jsonarr.data.Table[0].Result == "1") {

                        PKID = jsonarr.data.Table[0].PKID;
                        FKLogFKProjectID = jsonarr.data.Table[0].FKProjectID;
                        FKLogFKTaskID = jsonarr.data.Table[0].FKTaskID;
                        FKLogEmpID = jsonarr.data.Table[0].FKEmpID;
                        FKLogManagerID = jsonarr.data.Table[0].FKManagerID;

                        $.each(jsonarr.data.Table1, function () {
                            var id = "trlogdata" + this.PKID;
                            str = str + '<tr id="' + id + '" data-pkid="' + this.PKID+'">';
                            if (this.ApproveStatus == 'Pending') {

                                str = str + '<td style="text-align:center">  <a class="linkDeleteLog text-danger" id="linkDeleteLog' + this.PKID + '"  title="Delete Record"><i class="uil uil-trash-alt font-size-18"></i></a></td>';
                                str = str + '<td style="text-align:center">  <a class="linkEditLog text-primary" id="linkEditLog' + this.PKID + '"  title="Edit Log"> <i class="uil uil-pen font-size-18"></i></a></td>';

                            }
                            else {
                                str = str + '<td></td>';
                                str = str + '<td></td>';
                            }
                            str = str + '<td class="tdTaskDate">' + this.TaskDate + '</td>';
                            str = str + '<td class="tdHrs" style="text-align:right;">' + this.Hrs + '</td>';
                            str = str + '<td class="tdDescription">' + this.Description + '</td>';
                            str = str + '<td class="tdTaskStatus">' + this.TaskStatus + '</td>';
                            str += '</tr>';
                        });


                        $('#tblPreviousLog tbody').append(str);

                        $('#tblPreviousLog').on('click', '.linkEditLog', function (event) {
                            event.stopImmediatePropagation();
                            var newid = $(this).attr("id");
                            newid = newid.replace("linkEditLog", "");
                            FunBlankLog('clear');
                            FKLogPKID = parseInt(newid);
                            $('#txtLogDate').val($('#trlogdata' + newid).find('.tdTaskDate').html());
                            $('#txtTimeTaken').val($('#trlogdata' + newid).find('.tdHrs').html());
                            $('#dropNewStatus').val($('#trlogdata' + newid).find('.tdTaskStatus').html());
                            $('#txtLogRemark').val($('#trlogdata' + newid).find('.tdDescription').html());
                            $('#btnSaveLog').val('Update');
                            $('#btnClearLog').show();
                        });
                        $('#tbldata').on('click', '.linkDeleteLog', function (event) {
                            event.stopImmediatePropagation();
                            var newid = $(this).attr("id");
                            newid = newid.replace("linkDeleteLog", "");
                            FunDeleteAssignmentLog(newid);
                        });
                        opendiv('divLog');
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



function AddNewDetailRow() {


    var trID = "";
    DRowNo = DRowNo + 1;
    trID = "trDRow" + DRowNo;

    var NewRow = '<tr id="' + trID + '" data-memoreq="0" data-isEdit="1" data-isSubmitted="0">';

    NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';
    NewRow += '<td  class="tdFKProjectID"> <input type="text" id="txtFKProjectID' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdFKTaskID"> <input type="text" id="txtFKTaskID' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdHrs"> <input type="text" id="txtHrs' + trID + '" class="form-control" style="text-align:right;"   /></td>';
    NewRow += '<td class="tdDescription"> <input type="text" id="txtDescription' + trID + '" class="form-control"   /></td>';

    NewRow += "</tr>";
    $("#tblTimeSheet tbody").append(NewRow);



    $('#linkDelete' + trID).click(function () {
        var NewID = $(this).attr("id");
        NewID = NewID.replace("linkDelete", "");

        $("#" + NewID).addClass("trdeleted");
        $('#linkDelete' + NewID).remove();
    });

    $('#txtFKProjectID' + trID).GenexAutoCompleteWithCallBack(JsonProject, FunSetProjectDetail, 0, "ProjectID,Project,ClientID");
    $('#txtFKTaskID' + trID).GenexAutoCompleteWithCallBack(JsonTask, FunSetTaskDetail, 0, "TaskCode,Task Name,Description");


    SetNumberBox('txtHrs' + trID, 2, false, '');

}
function FunSetProjectDetail(item, inputid) {

    var FKProjectID = $("#" + inputid).GenexAutoCompleteGet(0);
    var NewID = inputid;
    NewID = NewID.replace("txtFKProjectID", "");


}
function FunSetTaskDetail(item, inputid) {

    var FKTaskID = $("#" + inputid).GenexAutoCompleteGet(0);
    var NewID = inputid;
    NewID = NewID.replace("txtFKTaskID", "");
    if (FKTaskID != 0) {
        $('#txtDescription' + NewID).val(item.Description);
    }
    else {
        $('#txtDescription' + NewID).val('');
    }

}
function FunBlank() {
    PKID = 0;
    $('#tblTimeSheet tbody').empty();
    DRowNo = 0;

    $('#txtFKEmpID').GenexAutoCompleteBlank();
    $('#txtFKManagerID').GenexAutoCompleteBlank();
    $("#txtAssignDate").val('');
    AddNewDetailRow();

}
function FunBlankLog(Rectype) {
   
  
    FKLogPKID = 0;
    $('#btnSaveLog').val('Save');
    $('#btnClearLog').hide();
    if (Rectype != 'clear') {
        $('#tblPreviousLog tbody').empty();
        PKID = 0;
        FKLogFKTaskID = 0;
        FKLogFKProjectID = 0;
        FKLogEmpID = 0;
    }
    
    $('#txtTimeTaken').val('');
    $("#txtLogDate").val(GetTodayDate());
    $('#txtLogRemark').val('');


}
function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtAssignDate").val() == "") {
        fail = true;
        $("#txtAssignDate").css("border-color", ColorE);
    }
    else {
        $("#txtAssignDate").css("border-color", ColorN);
    }
    if ($("#txtFKEmpID").GenexAutoCompleteGet('0') == '0') {
        fail = true;
        $("#txtFKEmpID").css("border-color", ColorE);
        strError += "<li>Select Client</li>";
    }
    else {
        $("#txtFKEmpID").css("border-color", ColorN);
    }

    if ($("#txtFKManagerID").GenexAutoCompleteGet('0') == '0') {
        fail = true;
        $("#txtFKManagerID").css("border-color", ColorE);
        strError += "<li>Select Client</li>";
    }
    else {
        $("#txtFKManagerID").css("border-color", ColorN);
    }
    var ItemCount = 0;

    $('#tblTimeSheet tbody tr').each(function (row, tr) {
        var str = '';
        var trID = $(tr).attr("id");

        if (!$(tr).hasClass("trdeleted")) {
            var IsSelected = true;

            if (IsSelected) {
                ItemCount = ItemCount + 1;


                if ($("#txtFKProjectID" + trID).GenexAutoCompleteGet(0) == "0") {
                    fail = true;
                    $("#txtFKProjectID" + trID).css("border-color", ColorE);

                }
                else {
                    $("#txtFKProjectID" + trID).css("border-color", ColorN);
                }

                if ($("#txtFKTaskID" + trID).GenexAutoCompleteGet(0) == "0") {
                    fail = true;
                    $("#txtFKTaskID" + trID).css("border-color", ColorE);

                }
                else {
                    $("#txtFKTaskID" + trID).css("border-color", ColorN);
                }
                if ($("#txtHrs" + trID).ValZero() == "0") {
                    fail = true;
                    $("#txtHrs" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtHrs" + trID).css("border-color", ColorN);
                }
                if ($("#txtDescription" + trID).val() == "") {
                    fail = true;
                    $("#txtDescription" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtDescription" + trID).css("border-color", ColorN);
                }


            }
        }


    });

    if (ItemCount == 0) {
        fail = true;
        OpenAlert('Add Task Rows');
    }

    if (!fail) {
        $("#divValidateSummary").hide();
        FunSave();

    } else {

        return false;
    }
}
function FunStoreItemData() {
    var TableData = new Array();
    var i = 0;
    $('#tblTimeSheet tbody tr').each(function (row, tr) {
        var trid = $(tr).attr("id");

        var ModeForm = 0;
        if ($(tr).hasClass("trdeleted")) {
            ModeForm = 2;
        }

        if (ModeForm == 0) {

            TableData[i] = {
                "PKID": 0
                , "AssignDate": $("#txtAssignDate").val()
                , "FKTaskID": $("#txtFKTaskID" + trid).GenexAutoCompleteGet(0)
                , "FKProjectID": $("#txtFKProjectID" + trid).GenexAutoCompleteGet(0)
                , "BHrs": parseFloat($("#txtHrs" + trid).ValZero()).toFixed(2)
                , "Description": $("#txtDescription" + trid).val()
                , "Remark": ''
                , "ModeForm": ModeForm
            };

            i++;
        }

    });



    return TableData;
}
function FunSave() {

    ProgCount = 0;
    ShowLoader();
    var StrItemList = "";
    StrItemList = FunStoreItemData();
    StrItemList = JSON.stringify(StrItemList);
    var FKEmpID = $("#txtFKEmpID").GenexAutoCompleteGet('0');
    var FKManagerID = $("#txtFKManagerID").GenexAutoCompleteGet('0');

    var args = {
        FKEmpID: FKEmpID, FKManagerID: FKManagerID, dtItemStr: StrItemList

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


function FunValidateLog() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtLogDate").val() == "") {
        fail = true;
        $("#txtLogDate").css("border-color", ColorE);
    }
    else {
        $("#txtLogDate").css("border-color", ColorN);
    }
    if ($("#txtTimeTaken").ValZero() == '0') {
        fail = true;
        $("#txtTimeTaken").css("border-color", ColorE);
        strError += "<li>Select Client</li>";
    }
    else {
        $("#txtTimeTaken").css("border-color", ColorN);
    }

    

    if (!fail) {
        
        FunSaveLog();

    } else {

        return false;
    }
}
function FunStoreLogData() {
    var TableData = new Array();
    TableData[0] = {
        "PKID": FKLogPKID
        , "TaskDate": $("#txtLogDate").val()
        , "FKTaskID": FKLogFKTaskID
        , "FKProjectID": FKLogFKProjectID
        , "Hrs": parseFloat($("#txtTimeTaken").ValZero()).toFixed(2)
        , "Description": $("#txtLogRemark").val()
        , "IsBillable":false
        , "Memo": ''
        , "TCostRate":0
        , "TBillRate": 0
        , "ModeForm": 0
    };



    return TableData;
}
function FunSaveLog() {

    ProgCount = 0;
    ShowLoader();
    var StrItemList = "";
    StrItemList = FunStoreLogData();
    StrItemList = JSON.stringify(StrItemList);
   
    var args = {
        FKEmpID: FKLogEmpID, FKManagerID: FKLogManagerID, SubmitType: 'S', ApproveAction: 'Submit', ApproveRemark:'', TaskStatus: $("#dropNewStatus").val(), FKAssignLogID: PKID, dtItemStr: StrItemList

    };


    $.ajax({

        type: "POST",
        url: pagename + "/SaveTimeSheetData",
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
                        FunBlankLog('clear');
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
function FunDeleteAssignmentLog(RecID) {
    if (confirm("Do you want to delete this record?")) {
        var args = { PKID: RecID };
        ShowLoader();
        $.ajax({

            type: "POST",
            url: pagename + "/DeleteAssignmentLog",
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
                            OpenAlert("Record deleted successfully!");
                            FunFillDetail();
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

function InitilizeEvents() {

    $("#btnSave").click(function () {
        FunValidate();
    });
    $("#btnAddNew").click(function () {
        if (IsAdd == 1) {
            FunBlank();
            opendiv("divAddNew");
        }
    });
    $("#btnAddNewRow").click(function () {
        AddNewDetailRow();
    });
    $("#btnSearch").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });
    $("#btnSaveLog").click(function () {
        FunValidateLog();
    });

    $("#btnClearLog").click(function () {
        FunBlankLog('clear');
    });

}
function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    if (LoadEntity == 0) {
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "");
    }
}
function PageLoadFun() {
    InitilizeEvents();
    SetDatePicker('txtfromdate');
    SetDatePicker('txttodate');
    SetDatePicker('txtAssignDate');
    SetDatePicker('txtLogDate');
    SetNumberBox('txtTimeTaken', 2, false, '');

    FunSetTabKey();
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }

    LoadEntity = 5;

    FunGetEmpForAutoComplate(FunEmpCallBack, 0, 'Active');
    FunGetClientForAutoComplete(FunClientCallBack, 0, '');
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetTaskForAutoComplete(FunTaskCallBack, 0, 0, 'T', 'Active');
    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);

}
function FunGridLayoutCallback(JsonArr) {
    JsonReportLayout = JsonArr;
    PageLoadComplete();
}
function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}

function FunEmpCallBack(JsonArr) {
    $("#txtFKManagerID").GenexAutoComplete(JsonArr, "EmpID,Name,Status");

    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });
    }
    $('#dropFKEmpIDSrch').append('<option value="">All</option>' + str);
    $('#dropFKManagerIDSrch').append('<option value="0">All</option>' + str);

    $("#txtFKManagerID").GenexAutoComplete(JsonArr, "EmpID,Name,Status");
    $("#txtFKEmpID").GenexAutoComplete(JsonArr, "EmpID,Name,Status");

    if (IsAdd == false) {
        $('#divEmployee').hide();
        $('#dropFKEmpIDSrch').val($('#HidUserID').val());
    }



    PageLoadComplete();
}
function FunClientCallBack(JsonArr) {
    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });


    }
    $('#dropFKClientIDSrch').append('<option value="">All</option>' + str);

    PageLoadComplete();
}
function FunProjectCallBack(JsonArr) {
    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });


    }
    $('#dropFKProjectIDSrch').append('<option value="">All</option>' + str);
    JsonProject = JsonArr;
    PageLoadComplete();
}
function FunTaskCallBack(JsonArr) {

    JsonTask = JsonArr;
    PageLoadComplete();
}
$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});