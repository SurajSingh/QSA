
var pagename = "/Users/EmployeeExpenseEntry.aspx";
var PKID = 0;
var JsonProject = null;
var JsonTask = null;
var DRowNo = 0;
var DFileNo = 0;
var OpentrID = "";
var CostRateInExpenseEntry = false;
var MemoInExpenseEntry = false;
var BillableCheckUncheckInExpenseEntry = false;
var ReimbursableCheckUncheckInExpenseEntry = false;
var IsApprove = false;
var ApproveType = '';
var StrDeletedFiles = '';


function AddNewDetailRow() {


    var trID = "";
    DRowNo = DRowNo + 1;
    trID = "trDRow" + DRowNo;

    var NewRow = '<tr id="' + trID + '" data-memoreq="0" data-isEdit="1" data-isSubmitted="0">';
    NewRow += '<td class="tdApprove" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chk' + trID + '" style="display:none;" /></td>';
    NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';
    NewRow += '<td class="tdEmpID bold"></td>';
    NewRow += '<td class="tdTaskDate"> <input type="text" id="txtTaskDate' + trID + '" class="form-control"   /></td>';
    NewRow += '<td  class="tdFKProjectID"> <input type="text" id="txtFKProjectID' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdFKTaskID"> <input type="text" id="txtFKTaskID' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdDescription"> <input type="text" id="txtDescription' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdUnit"> <input type="text" id="txtUnit' + trID + '" class="form-control" style="text-align:right;"   /></td>';
    NewRow += '<td class="tdTCostRate"> <input type="text" id="txtTCostRate' + trID + '" class="form-control"  style="text-align:right;"    /></td>';
    NewRow += '<td class="tdMU"> <input type="text" id="txtMU' + trID + '" class="form-control"  style="text-align:right;"   /></td>';
    NewRow += '<td class="tdAmount"> <input type="text" id="txtAmount' + trID + '" class="form-control"  style="text-align:right;" readonly="readonly"  /></td>';
    NewRow += '<td class="tdIsBillable" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkIsBillable' + trID + '"  /></td>';
    NewRow += '<td class="tdIsReimb" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkIsReimb' + trID + '"  /></td>';


    NewRow += '<td class="tdMemo" style="text-align:center;"> <a class="tbllink" id="linkMemo' + trID + '"  title="View Memo">Memo</a><div  id="divMemo' + trID + '" style="display:none;"></div></td>';
    NewRow += '<td class="tdAttachment" > <a class="tbllink" id="linkAttachment' + trID + '"  title="Attach File">Attachment</a><input type="hidden"  id="hidSavedFileName' + trID + '" /><input type="hidden"  id="hidOriginalFileName' + trID + '" /></td>';
    NewRow += '<td class="tdApproveStatus" style="text-align:center;"></td>';
    NewRow += "</tr>";
    $("#tblTimeSheet tbody").append(NewRow);

    FunSetPageRoles();

    $('#linkDelete' + trID).click(function () {
        var NewID = $(this).attr("id");
        NewID = NewID.replace("linkDelete", "");

        if (confirm("Delete this record?")) {
            $("#" + NewID).addClass("trdeleted");
            $('#linkDelete' + NewID).remove();
            FunSetTotal();
        }
    });

    $('#txtFKProjectID' + trID).GenexAutoCompleteWithCallBack(JsonProject, FunSetProjectDetail, 0, "ProjectID,Project,ClientID");
    $('#txtFKTaskID' + trID).GenexAutoCompleteWithCallBack(JsonTask, FunSetTaskDetail, 0, "TaskCode,Task Name,Description");

    SetDatePicker('txtTaskDate' + trID);
    SetNumberBox('txtUnit' + trID, 2, false, '');
    SetNumberBox('txtMU' + trID, 2, false, '');
    SetNumberBox('txtTCostRate' + trID, 2, false, '');


    $('#txtUnit' + trID).change(function () {
        FunSetTotal();

        var temp = $(this).val();
        if (temp != "") {
            $(this).val(parseFloat(temp).toFixed(2));
        }
    });
    $('#txtTCostRate' + trID).change(function () {
        FunSetTotal();

        var temp = $(this).val();
        if (temp != "") {
            $(this).val(parseFloat(temp).toFixed(2));
        }
    });
    $('#txtMU' + trID).change(function () {
        FunSetTotal();

        var temp = $(this).val();
        if (temp != "") {
            $(this).val(parseFloat(temp).toFixed(2));
        }
    });
    $('#linkMemo' + trID).click(function () {
        var NewID = $(this).attr("id");
        NewID = NewID.replace("linkMemo", "");
        OpentrID = NewID;
        tinymce.get("txtMemo").setContent($('#divMemo' + NewID).html());
        opendiv('divMemo');

    });
    $('#linkAttachment' + trID).click(function () {
        var NewID = $(this).attr("id");
        NewID = NewID.replace("linkAttachment", "");
        OpentrID = NewID;
        var SavedFileName = $('#hidSavedFileName' + NewID).val();
        var OriginalFileName = $('#hidOriginalFileName' + NewID).val();
        $('#tblAttachment tbody').empty();
        if (SavedFileName != '') {
            var arrfile = SavedFileName.split(',');
            var arrfile1 = OriginalFileName.split(',');

            for (var i = 0; i < arrfile.length; i++) {
                if (arrfile[i] != '') {
                    AddNewFileRow(arrfile1[i], arrfile[i]);
                }
            }

        }
        if ($('#' + OpentrID).attr("data-isedit") == "1") {
            $('#btnfileselect').show();

        }
        else {
            $('#btnfileselect').hide();

        }
        opendiv('divAttachment');

    });
    $('#txtTaskDate' + trID).change(function () {
        var NewID = $(this).attr("id");
        if ($(this).val() != '') {
            NewID = NewID.replace("txtTaskDate", "");
            var CurrentRow = NewID.replace("trDRow", "");

            if (parseInt(CurrentRow) == DRowNo) {
                AddNewDetailRow();
            }
        }

    });

}
function AddNewFileRow(OriginalFileName, SavedFileName) {
    DFileNo = DFileNo + 1;
    var strfile = '';
    var trFileID = 'trAttach' + DFileNo;
    strfile += '<tr id="' + trFileID + '">';
    strfile += '<td style="text-align:center;width:40px;"><a class="tbllink" id="linkDelete' + trFileID + '"  title="Delete File"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidSavedFileName' + trFileID + '" value="' + SavedFileName + '"  /><input type="hidden" id="hidOriginalFileName' + trFileID + '" value="' + OriginalFileName + '"  /></td>';
    strfile += '<td><a href="downloadfile.aspx?fid=' + SavedFileName + '&fid1=' + OriginalFileName + '&rectype=exp"><i class="bx bx-file font-size-18"></i>&nbsp;' + OriginalFileName + '</a></td>';
    strfile += '</tr>';
    $('#tblAttachment tbody').append(strfile);
    $('#linkDelete' + trFileID).click(function () {
        var NewID = $(this).attr("id");
        NewID = NewID.replace("linkDelete", "");
        $("#" + NewID).addClass("trdeleted");
    });
    if ($('#' + OpentrID).attr("data-isedit") == "0") {
        $('#linkDelete' + trFileID).hide();

    }

}
function FunAddFiletoMainTable() {
    if (OpentrID != '') {
        var SavedFileName = '';
        var OriginalFileName = '';
        var count = 0;
        $('#tblAttachment tbody tr').each(function (row, tr) {
            var trid = $(tr).attr("id");

            var ModeForm = 0;
            if ($(tr).hasClass("trdeleted")) {
                if (StrDeletedFiles != '') {
                    StrDeletedFiles = StrDeletedFiles + ',';
                }
                StrDeletedFiles = StrDeletedFiles + $('#hidSavedFileName' + trid).val();
            }
            else {
                count = count + 1;
                if (SavedFileName != '') {

                    SavedFileName = SavedFileName + ',';
                    OriginalFileName = OriginalFileName + ',';

                }
                SavedFileName = SavedFileName + $('#hidSavedFileName' + trid).val();
                OriginalFileName = OriginalFileName + $('#hidOriginalFileName' + trid).val();
            }


        });


        $('#hidSavedFileName' + OpentrID).val(SavedFileName);
        $('#hidOriginalFileName' + OpentrID).val(OriginalFileName);
        if (count > 0) {
            $('#linkAttachment' + OpentrID).html('Attachments(' + count + ')');
            $("#linkAttachment" + trID).addClass('text-highlight');
        }
        else {
            $('#linkAttachment' + OpentrID).html('Attachment');
            $("#linkAttachment" + trID).removeClass('text-highlight');
        }
    }
    closediv();

}

function FunSetProjectDetail(item, inputid) {

    var FKProjectID = $("#" + inputid).GenexAutoCompleteGet(0);
    var NewID = inputid;
    NewID = NewID.replace("txtFKProjectID", "");
    if (FKProjectID != 0) {

        if (item.TBillable) {
            $('#chkIsBillable' + NewID).prop('checked', item.EBillable);
        }
        if (item.EMemoRequired) {
            $('#' + NewID).attr('data-memoreq', '1');
        }
        else {
            $('#' + NewID).attr('data-memoreq', '0');
        }
        $('#txtDescription' + NewID).prop('disabled', item.EDesReadonly);
    }
    else {
        $('#' + NewID).attr('data-memoreq', '0');
        $('#txtDescription' + NewID).prop('disabled', false);
    }

}
function FunSetTaskDetail(item, inputid) {

    var FKTaskID = $("#" + inputid).GenexAutoCompleteGet(0);
    var NewID = inputid;
    NewID = NewID.replace("txtFKTaskID", "");
    if (FKTaskID != 0) {

        $('#txtTCostRate' + NewID).val(item.CostRate);
        $('#chkIsBillable' + NewID).prop('checked', item.IsBillable);
        $('#txtDescription' + NewID).val(item.Description);
        $('#chkIsReimb' + NewID).prop('checked', item.isReimb);
        $('#txtMU' + NewID).val(item.MuRate);

    }
    else {

        $('#txtTCostRate' + NewID).val('');
        $('#txtDescription' + NewID).val('');
        $('#txtMU' + NewID).val('');
        $('#chkisReimb' + NewID).prop('checked', false);
    }

}

function FunSetTotal() {
    var TotalAmount = 0;
    var Unit = 0;
    var MU = 0;
    var CostRate = 0;
    var Amount = 0;

    $('#tblTimeSheet tbody tr').each(function (row, tr) {
        var trID = $(tr).attr("id");

        if (!$(tr).hasClass("trdeleted")) {
            Unit = parseFloat($("#txtUnit" + trID).ValZero());
            MU = parseFloat($("#txtMU" + trID).ValZero());
            CostRate = parseFloat($("#txtTCostRate" + trID).ValZero());

            Amount = Unit * CostRate;
            if (MU > 0) {
                var muamount = (Amount * MU) / 100;
                Amount = Amount + muamount;
            }
            TotalAmount = TotalAmount + Amount;
            $("#txtAmount" + trID).val(Amount.toFixed(2));



        }

    });

    $('#tblTimeSheet tfoot').find('.tdAmount').html(TotalAmount.toFixed(2));
}

function FunValidate(Action1) {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    var ItemCount = 0;

    $('#tblTimeSheet tbody tr').each(function (row, tr) {
        var str = '';
        var trID = $(tr).attr("id");

        if (!$(tr).hasClass("trdeleted") && $("#txtTaskDate" + trID).val() == '' && $("#txtFKProjectID" + trID).GenexAutoCompleteGet(0) == "0" && $("#txtFKTaskID" + trID).GenexAutoCompleteGet(0) == "0") {
            $(tr).addClass('trdeleted');
        }

        if (!$(tr).hasClass("trdeleted")) {
            var IsSelected = false;
            if (Action1 == 'Submit') {

                IsSelected = true;
            }
            else {
                IsSelected = $('#chk' + trID).is(':checked');

            }
            if (IsSelected) {
                ItemCount = ItemCount + 1;

                if ($("#txtTaskDate" + trID).val() == "") {
                    fail = true;
                    $("#txtTaskDate" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtTaskDate" + trID).css("border-color", ColorN);
                }
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
                if ($("#txtUnit" + trID).ValZero() == "0") {
                    fail = true;
                    $("#txtUnit" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtUnit" + trID).css("border-color", ColorN);
                }
                if ($("#txtTCostRate" + trID).ValZero() == "0") {
                    fail = true;
                    $("#txtTCostRate" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtTCostRate" + trID).css("border-color", ColorN);
                }

                if ($('#' + trID).attr('data-memoreq') == "1") {
                    if ($("#divMemo" + trID).html() == "0") {
                        fail = true;
                        $("#divMemo" + trID).addClass("error");
                    }
                    else {
                        $("#divMemo" + trID).removeClass("error");
                    }

                }
                else {
                    $("#divMemo" + trID).removeClass("error");
                }

            }
        }


    });
    if (ItemCount == 0) {
        if (Action1 == 'Submit') {
            OpenAlert('No row added to sheet');

        }
        else {
            OpenAlert('Please select entries to Approve or Reject');

        }
    }
    else {

        if (!fail) {
            $("#divValidateSummary").hide();
            if (Action1 == 'Approved') {
                $('#ConfirmApproveText').html('Do you want to approve selected entries?');
            }
            else if (Action1 == 'Rejected') {

                $('#ConfirmApproveText').html('Do you want to reject selected entries?');
            }
            else {

                $('#ConfirmApproveText').html('Do you want to submit entries?');
            }
            ApproveType = Action1;
            opendivid = 'divConfirmApprove';
            $('#otherdiv').fadeIn("slow");
            $('#' + opendivid).fadeIn("slow");


        }
        else {
            OpenAlert('Please fill data!');
        }
    }
}



function FunStoreItemData(Action1) {
    var TableData = new Array();
    var i = 0;
    $('#tblTimeSheet tbody tr').each(function (row, tr) {
        var trid = $(tr).attr("id");
        var IsSelected = false;
        if (Action1 == 'Submit') {
            if ($(tr).attr("data-isEdit") == "1") {
                IsSelected = true;
            }
        }
        else {
            IsSelected = $('#chk' + trid).is(':checked');

        }

        if (IsSelected) {
            var ModeForm = 0;
            if ($(tr).hasClass("trdeleted")) {
                ModeForm = 2;
            }
            TableData[i] = {
                "PKID": $("#hidPKID" + trid).ValZero()
                , "TaskDate": $("#txtTaskDate" + trid).val()
                , "FKTaskID": $("#txtFKTaskID" + trid).GenexAutoCompleteGet(0)
                , "FKProjectID": $("#txtFKProjectID" + trid).GenexAutoCompleteGet(0)
                , "Unit": parseFloat($("#txtUnit" + trid).ValZero()).toFixed(2)
                , "Description": $("#txtDescription" + trid).val()
                , "IsBillable": $("#chkIsBillable" + trid).is(':checked')
                , "Memo": $("#divMemo" + trid).html()
                , "TCostRate": parseFloat($("#txtTCostRate" + trid).ValZero()).toFixed(2)
                , "MU": parseFloat($("#txtMU" + trid).ValZero()).toFixed(2)
                , "Amount": parseFloat($("#txtAmount" + trid).ValZero()).toFixed(2)
                , "SavedFileName": $("#hidSavedFileName" + trid).val()
                , "OriginalFileName": $("#hidOriginalFileName" + trid).val()
                , "IsReimb": $("#chkIsReimb" + trid).is(':checked')
                , "ModeForm": ModeForm
            };

            i++;
        }

    });



    return TableData;
}

function FunSave(Action1) {
    ProgCount = 0;
    ShowLoader();
    var StrItemList = "";
    StrItemList = FunStoreItemData(Action1);
    StrItemList = JSON.stringify(StrItemList);
    var FKEmpID = 0;
    var FKManagerID = 0;
    var SubmitType = 'CM';
    if (Action1 == 'Submit') {
        if (IsApprove) {

            FKEmpID = $('#dropFKEmpIDSrch').ValZero();
        }



    }

    var args = {
        FKEmpID: FKEmpID, ApproveAction: Action1, ApproveRemark: '', dtItemStr: StrItemList, StrDeletedFiles: StrDeletedFiles

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
                        if (Action1 == 'Submit') {
                            closediv();
                            OpenAlert('Submitted Successfully!');
                        }
                        else {
                            OpenAlert('Updated Successfully!');
                        }

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
    StrDeletedFiles = '';
    DRowNo = 0;
    ShowDataLoader();
    $('#tblTimeSheet tbody').empty();
    var args = {
        PageSize: 0, OffSet: 0, SortBy: '', SortDir: 'D',
        daterange: $("#dropaterange").val(), FromDate: $("#txtfromdate").val(), ToDate: $("#txttodate").val(),
        FKEmpID: $("#dropFKEmpIDSrch").val(),
        FKProjectID: $("#dropFKProjectIDSrch").val()
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
                $.each(jsonarr.data.Table, function () {
                    AddNewDetailRow();
                    var trID = "";
                    trID = "trDRow" + DRowNo;
                    $('#' + trID).addClass(this.ApproveStatus);
                    $("#chk" + trID).show();
                    $("#hidPKID" + trID).val(this.PKID);
                    $("#" + trID).find('.tdEmpID').html(this.LoginID);
                    $("#txtTaskDate" + trID).val(this.TaskDate);

                    $("#txtFKProjectID" + trID).GenexAutoCompleteSet(this.FKProjectID, this.ProjectCode);
                    $('#txtDescription' + trID).prop('disabled', this.TDesReadonly);
                    $("#txtFKTaskID" + trID).GenexAutoCompleteSet(this.FKTaskID, this.TaskName);
                    $("#txtUnit" + trID).val(this.Unit.toFixed(2));
                    $("#txtDescription" + trID).val(this.Description);
                    $("#txtMU" + trID).val(this.MU);
                    $("#txtAmount" + trID).val(this.Amount.toFixed(2));
                    $("#chkIsBillable" + trID).prop('checked', this.IsBillable);
                    $("#chkIsReimb" + trID).prop('checked', this.IsReimb);
                    $("#txtTCostRate" + trID).val(this.TCostRate.toFixed(2));
                    $("#divMemo" + trID).html(this.Memo);

                    $("#hidSavedFileName" + trID).val(this.SavedFileName);
                    $("#hidOriginalFileName" + trID).val(this.OriginalFileName);

                    var arrfile = this.SavedFileName.split(',');
                    if (this.SavedFileName != '') {
                        if (arrfile.length > 0) {
                            $("#linkAttachment" + trID).html('Attachments(' + arrfile.length + ')');
                            $("#linkAttachment" + trID).addClass('text-highlight');
                        }

                    }


                    $("#" + trID).attr('data-isSubmitted', '1');
                    if (this.ApproveStatus != 'Pending') {
                        $("#" + trID).attr('data-isEdit', '0');

                        $("#linkDelete" + trID).hide();
                        $('#txtTaskDate' + trID).prop('disabled', true);
                        $('#txtFKProjectID' + trID).prop('disabled', true);
                        $('#txtFKTaskID' + trID).prop('disabled', true);
                        $('#txtUnit' + trID).prop('disabled', true);
                        $('#txtMU' + trID).prop('disabled', true);
                        $('#txtDescription' + trID).prop('disabled', true);
                        $('#chkIsBillable' + trID).prop('disabled', true);
                        $('#txtTCostRate' + trID).prop('disabled', true);
                        $('#chkIsReimb' + trID).prop('disabled', true);
                        $('#divMemo' + trID).prop('disabled', true);
                    }
                    if (this.ApproveStatus == 'Pending') {
                        $("#" + trID).find('.tdApproveStatus').html('<img src="images/submitted.png" title="Submitted" />');

                    }
                    else if (this.ApproveStatus == 'Approved') {
                        $("#" + trID).find('.tdApproveStatus').html('<img src="images/approved.png" title="Approved" />');

                    }
                    else if (this.ApproveStatus == 'Rejected') {
                        $("#" + trID).find('.tdApproveStatus').html('<img src="images/rejected.png" title="Rejected" />');

                    }




                });
                if ($("#dropFKEmpIDSrch").val() != '') {
                    AddNewDetailRow();
                }

                FunSetTotal();
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
function FunSetPageRoles() {
    if (CostRateInExpenseEntry == false) {
        $('#tblTimeSheet').find('.tdTCostRate').hide();
    }
    if (MemoInExpenseEntry == false) {
        $('#tblTimeSheet').find('.tdMemo').hide();
    }

    if (BillableCheckUncheckInExpenseEntry == false) {
        $('#tblTimeSheet').find('.tdIsBillable').find('input').prop('disabled', true);
    }
    if (ReimbursableCheckUncheckInExpenseEntry == false) {
        $('#tblTimeSheet').find('.tdIsReimb').hide();
    }

    if (IsApprove == false) {
        $('#tblTimeSheet').find('.tdApprove').hide();
    }

    FunShowHideEmployee();


}
function FunShowHideEmployee() {

    if ($('#dropFKEmpIDSrch').val() == '') {
        $('#tblTimeSheet').find('.tdEmpID').show();
        $('#divSubmitCtrl').hide();
    }
    else {
        $('#tblTimeSheet').find('.tdEmpID').hide();
        $('#divSubmitCtrl').show();
    }
}
function FunUploadAttachment(trid, UploadType, btnID) {

    var status = 1;
    var FileType = ".PNG,.JPG,.JPEG,.PDF";
    if (status == 1) {
        var iframe = document.getElementById("ifuploadfile");
        var args = [];
        args[0] = UploadType;
        args[1] = FileType;
        args[2] = trid;
        args[3] = btnID;
        iframe.contentWindow.selectAttachment(args);
    }
}
function AttachClientFileCall(Result, Msg, trID, id, filesize, filename, filext) {
    HideFileLoader("btnfileselect");
    if (Result == 1) {
        AddNewFileRow(filename, id);
    }
    else {

        OpenAlert(Msg);
    }
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
function FunEmpCallBack(JsonArr) {

    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });
    }
    $('#dropFKEmpIDSrch').append('<option value="">All</option>' + str);
    $('#dropSubmitToSpecific').append('<option value="0">Select One</option>' + str);
    $('#dropFKEmpIDSrch').val($('#HidUserID').val());
    PageLoadComplete();
}
function SetOtherRoles(jsonarr) {


    if (jsonarr.length > 0) {
        if (jsonarr[0].IsFound == 1) {
            IsApprove = true;
        }
        if (jsonarr[1].IsFound == 1) {
            CostRateInExpenseEntry = true;
        }
        if (jsonarr[2].IsFound == 1) {
            MemoInExpenseEntry = true;
        }
        if (jsonarr[3].IsFound == 1) {
            BillableCheckUncheckInExpenseEntry = true;
        }
        if (jsonarr[4].IsFound == 1) {
            ReimbursableCheckUncheckInExpenseEntry = true;
        }
    }
    if (IsApprove) {
        $('#btnApprove').show();
        $('#btnReject').show();
        $('#divEmp').show();
    }

    FunSetPageRoles();
    PageLoadComplete();

}
function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    if (LoadEntity == 0) {

        FunFillData();
    }
}
function InitilizeEvents() {
    $("#btnSaveMemo").click(function () {
        if (OpentrID != '') {
            var myContent = tinymce.get("txtMemo").getContent();
            $('#divMemo' + OpentrID).html(myContent);
        }
        closediv();
    });

    $("#dropFKEmpIDSrch").change(function () {

        FunShowHideEmployee();
        FunFillData();
    });
    $("#btnSearch").click(function () {
        FunFillData();
    });
    $("#btnRefresh").click(function () {
        FunFillData();
    });
    $("#btnAddNew").click(function () {
        AddNewDetailRow();
    });
    $("#chkAll").click(function () {
        var IsChecked = $('#chkAll').is(':checked');
        $('#tblTimeSheet tbody tr').each(function (row, tr) {
            var trID = $(tr).attr("id");
            $("#chk" + trID).prop("checked", IsChecked);
        });
    });
    $("#btnsave").click(function () {
        FunValidate('Submit');
    });

    $("#btnApprove").click(function () {

        FunValidate('Approved');
    });
    $("#btnReject").click(function () {
        FunValidate('Rejected');
    });
    $("#btnApproveOK").click(function () {
        closediv();
        FunSave(ApproveType);
    });
    $('#btnfileselect').click(function () {
        FunUploadAttachment(OpentrID, 'Transaction', 'btnfileselect');

    });
    $("#btnOKAttach").click(function () {
        FunAddFiletoMainTable();
        closediv();
    });
}


function PageLoadFun() {


    InitilizeEvents();
    0 < $("#txtMemo").length && tinymce.init({
        selector: "textarea#txtMemo", height: 300,
        plugins: ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker", "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking", "save table contextmenu directionality emoticons template paste textcolor"], toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | l      ink image | print preview media fullpage | forecolor backcolor emoticons", style_formats: [{ title: "Bold text", inline: "b" }, { title: "Red text", inline: "span", styles: { color: "#ff0000" } }, { title: "Red header", block: "h1", styles: { color: "#ff0000" } }, { title: "Example 1", inline: "span", classes: "example1" }, { title: "Example 2", inline: "span", classes: "example2" }, { title: "Table styles" }, { title: "Table row 1", selector: "tr", classes: "tablerow1" }]
    });

    SetDatePicker("txtfromdate");
    SetDatePicker("txttodate");

    LoadEntity = 4;
    GetUserInRole(SetOtherRoles, "205,211,212,213,214,");
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetTaskForAutoComplete(FunTaskCallBack, 0, 0, 'E', 'Active');
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, '');
    FunSetTabKey();
    if (IsEdit == 0) {
        $("#btnsave").remove();
    }


}
$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});