var pagename = "/Users/EnterTimeSheet.aspx";
var PKID = 0;
var JsonProject = null;
var JsonTask = null;
var DRowNo = 0;
var OpentrID = "";
var BillRateInTimesheet = false;
var PayRateInTimesheet = false;
var MemoInTimesheet = false;
var BillableCheckUncheckInTimesheet = false;
var IsApprove = false;
var ApproveType = '';


function AddNewDetailRow() {

    var roleType = $("#hfRoleType").val();

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
    NewRow += '<td class="tdHrs"> <input type="text" id="txtHrs' + trID + '" class="form-control" style="text-align:right;"   /></td>';
    NewRow += '<td class="tdDescription"> <input type="text" id="txtDescription' + trID + '" class="form-control"  readonly /></td>';
    
    if (roleType == "Admin") {
        NewRow += '<td class="tdIsBillable" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkIsBillable' + trID + '" /></td>';
        NewRow += '<td class="tdTBillRate"> <input type="text" id="txtTBillRate' + trID + '" class="form-control"  style="text-align:right;"   /></td>';
        NewRow += '<td class="tdTCostRate"> <input type="text" id="txtTCostRate' + trID + '" class="form-control"  style="text-align:right;"    /></td>';
    }
    else {
        NewRow += '<td class="tdIsBillable" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkIsBillable' + trID + '" onclick="return false" /></td>';
    }

    NewRow += '<td class="tdMemo" style="text-align:center;"> <a class="tbllink" id="linkMemo' + trID + '"  title="View Memo">Memo</a><div  id="divMemo' + trID + '" style="display:none;"></div></td>';
    NewRow += '<td class="tdApproveStatus" style="text-align:center;"></td>';
    NewRow += "</tr>";
    $("#tblTimeSheet tbody").append(NewRow);

    FunSetPageRoles();

    $('#tblTimeSheet').on('click', '#linkDelete' + trID, function (event) {
        event.stopImmediatePropagation();
        var newId = "";
        var rowNumber = $(this).attr("id");
        rowNumber = rowNumber.replace("linkDelete", "");
        newId = $("#hidPKID" + rowNumber).val();
        if (newId == 0) {
            $('#' + rowNumber).remove()
        }
        else {
            FunDelete(newId);
        }
    });

    //$('#linkDelete' + trID).click(function () {
    //    var NewID = $(this).attr("id");
    //    NewID = NewID.replace("linkDelete", "");



    //    //if (confirm("Delete this record?")) {
    //        //$("#" + NewID).addClass("trdeleted");
    //        //$('#linkDelete' + NewID).remove();
    //        FunSetTotal();
    //    //}
    //});

    $('#txtFKProjectID' + trID).GenexAutoCompleteWithCallBack(JsonProject, FunSetProjectDetail, 0, "ProjectID,Project,ClientID");
    $('#txtFKTaskID' + trID).GenexAutoCompleteWithCallBack(JsonTask, FunSetTaskDetail, 0, "TaskCode,Task Name,Description");

    SetDatePicker('txtTaskDate' + trID);
    SetNumberBox('txtHrs' + trID, 2, false, '');
    SetNumberBox('txtTBillRate' + trID, 2, false, '');
    SetNumberBox('txtTCostRate' + trID, 2, false, '');


    $('#txtHrs' + trID).change(function () {
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

//Added By Nilesh to Delete Entry
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
                            FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "");
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
//Added By Nilesh To delete timesheet entry - End
function FunSetProjectDetail(item, inputid) {

    var FKProjectID = $("#" + inputid).GenexAutoCompleteGet(0);
    var NewID = inputid;
    NewID = NewID.replace("txtFKProjectID", "");
    if (FKProjectID != 0) {

        if (item.TBillable) {
            $('#chkIsBillable' + NewID).prop('checked', item.TBillable);
        }
        if (item.TMemoRequired) {
            $('#' + NewID).attr('data-memoreq', '1');
        }
        else {
            $('#' + NewID).attr('data-memoreq', '0');
        }
        $('#txtDescription' + NewID).prop('disabled', item.TDesReadonly);
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
        $('#txtTBillRate' + NewID).val(item.BillRate);
        $('#txtTCostRate' + NewID).val(item.CostRate);
        $('#chkIsBillable' + NewID).prop('checked', item.IsBillable);
        $('#txtDescription' + NewID).val(item.Description);


    }
    else {
        $('#txtTBillRate' + NewID).val('');
        $('#txtTCostRate' + NewID).val('');
        $('#txtDescription' + NewID).val('');
    }

}

function FunSetTotal() {
    var TotalHours = 0;
    $('#tblTimeSheet tbody tr').each(function (row, tr) {
        var trID = $(tr).attr("id");

        if (!$(tr).hasClass("trdeleted")) {
            TotalHours = TotalHours + parseFloat($("#txtHrs" + trID).ValZero());

        }

    });

    $('#tblTimeSheet tfoot').find('.tdHrs').html(TotalHours.toFixed(2));
}

function FunValidate(Action1, Action2) {

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
        var IsSelected = false;
        if (Action1 == 'Submit') {

            IsSelected = true;
        }
        else {
            IsSelected = $('#chk' + trID).is(':checked');

        }
        if (IsSelected) {

            if (!$(tr).hasClass("trdeleted") || $("#hidPKID" + trID).val() != '0') {
                ItemCount = ItemCount + 1;
            }
        }

        if (!$(tr).hasClass("trdeleted")) {

            if (IsSelected) {


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
                if ($("#txtHrs" + trID).ValZero() == "0") {
                    fail = true;
                    $("#txtHrs" + trID).css("border-color", ColorE);
                }
                else {
                    $("#txtHrs" + trID).css("border-color", ColorN);
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
            if (Action2 == 'Save') {
                if (Action1 == 'Approved' || Action1 == 'Rejected') {
                    if (Action1 == 'Approved') {
                        $('#ConfirmApproveText').html('Do you want to approve selected entries?');
                    }
                    else {

                        $('#ConfirmApproveText').html('Do you want to reject selected entries?');
                    }
                    ApproveType = Action1;
                    opendivid = 'divConfirmApprove';
                    $('#otherdiv').fadeIn("slow");
                    $('#' + opendivid).fadeIn("slow");
                }
                else {
                    FunSave(Action1);
                }

            }
            else {
                opendiv('divSubmit');
            }


        }
        else {
            OpenAlert('Please fill data!');
        }
    }
}
function FunValidate2(Action1, Action2) {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    if ($('#chkSpecific').is(':checked')) {

        if ($('#dropSubmitToSpecific').ValZero() == '0') {

            fail = true;
            $("#dropSubmitToSpecific").css("border-color", ColorE);
        }
        else {
            $("#dropSubmitToSpecific").css("border-color", ColorN);
        }
    }

    if (!fail) {

        FunValidate(Action1, Action2);
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
                , "Hrs": parseFloat($("#txtHrs" + trid).ValZero()).toFixed(2)
                , "Description": $("#txtDescription" + trid).val()
                , "IsBillable": $("#chkIsBillable" + trid).is(':checked')
                , "Memo": $("#divMemo" + trid).html()
                , "TCostRate": parseFloat($("#txtTCostRate" + trid).ValZero()).toFixed(2)
                , "TBillRate": parseFloat($("#txtTBillRate" + trid).ValZero()).toFixed(2)
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

        if ($('#chkSpecific').is(':checked')) {
            FKManagerID = $('#dropSubmitToSpecific').ValZero();
            SubmitType = 'S';
        }
        else if ($('#chkClientManager').is(':checked')) {
            SubmitType = 'CM';
        }
        else if ($('#chkProjectManager').is(':checked')) {
            SubmitType = 'PM';
        }
        else if ($('#chkYourManager').is(':checked')) {
            SubmitType = 'M';
        }

    }

    var args = {
        FKEmpID: FKEmpID, FKManagerID: FKManagerID, SubmitType: SubmitType, ApproveAction: Action1, ApproveRemark: '', dtItemStr: StrItemList

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

    ShowDataLoader();
    $('#tblTimeSheet tbody').empty();
    DRowNo = 0;
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
        async: false,
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
                    $('#txtDescription' + trID).prop('readOnly', true);// ('disabled', this.TDesReadonly);
                    $("#txtFKTaskID" + trID).GenexAutoCompleteSet(this.FKTaskID, this.TaskName);
                    $("#txtHrs" + trID).val(this.Hrs.toFixed(2));
                    $("#txtDescription" + trID).val(this.Description);
                    $("#chkIsBillable" + trID).prop('checked', this.IsBillable);
                    $("#txtTBillRate" + trID).val(this.TBillRate.toFixed(2));
                    $("#txtTCostRate" + trID).val(this.TCostRate.toFixed(2));
                    $("#divMemo" + trID).html(this.Memo);
                    $("#" + trID).attr('data-isSubmitted', '1');



                    if (this.ApproveStatus != 'Pending' || this.FKAssignLogID != 0 || this.FKInvoiceID != 0) {
                        $("#" + trID).attr('data-isEdit', '0');

                        $("#linkDelete" + trID).hide();

                        $('#txtTaskDate' + trID).prop('disabled', true);
                        $('#txtFKProjectID' + trID).prop('disabled', true);
                        $('#txtFKTaskID' + trID).prop('disabled', true);
                        $('#txtHrs' + trID).prop('disabled', true);
                        $('#txtDescription' + trID).prop('disabled', true);
                        $('#chkIsBillable' + trID).prop('disabled', true);
                        $('#txtTBillRate' + trID).prop('disabled', true);
                        $('#txtTCostRate' + trID).prop('disabled', true);
                        $('#linkMemo' + trID).prop('readonly', true);
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
    if (BillRateInTimesheet == false) {
        $('#tblTimeSheet').find('.tdTBillRate').hide();
    }
    if (PayRateInTimesheet == false) {
        $('#tblTimeSheet').find('.tdTCostRate').hide();
    }
    //Commented by Nilesh to show Memo link to each employee - start
    //if (MemoInTimesheet == false) {
    //    $('#tblTimeSheet').find('.tdMemo').hide();
    //}
    //Commented by Nilesh to show Memo link to each employee - End
    if (BillableCheckUncheckInTimesheet == false) {
        $('#tblTimeSheet').find('.tdIsBillable').find('input').prop('disabled', true);
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
            BillRateInTimesheet = true;
        }
        if (jsonarr[2].IsFound == 1) {
            PayRateInTimesheet = true;
        }
        if (jsonarr[3].IsFound == 1) {
            MemoInTimesheet = true;
        }
        if (jsonarr[4].IsFound == 1) {
            BillableCheckUncheckInTimesheet = true;
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
    $("input[name='rbtnSubmitTo']").click(function () {
        $('#dropSubmitToSpecific').hide();

        if ($('#chkSpecific').is(':checked')) {
            $('#dropSubmitToSpecific').show();
        }
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
        FunValidate('Submit', 'Submit');
    });
    $("#btnSubmit").click(function () {
        FunValidate2('Submit', 'Save');
    });
    $("#btnApprove").click(function () {

        FunValidate('Approved', 'Save');
    });
    $("#btnReject").click(function () {
        FunValidate('Rejected', 'Save');
    });
    $("#btnApproveOK").click(function () {
        closediv();
        FunSave(ApproveType);
    });
    $("#btnImport").click(function () {
        var input = document.getElementById('excel-file-input');
        input.val('');
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
    GetUserInRole(SetOtherRoles, "202,207,208,209,210,");
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetTaskForAutoComplete(FunTaskCallBack, 0, 0, 'T', 'Active');
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

//************************************* import function ************************************************




function handleFile() {
    // Get the input element
    var input = document.getElementById('excel-file-input');

    // Get the files
    var files = input.files;

    // Check if a file is selected
    if (files.length > 0) {
        var file = files[0];

        // Create a new FileReader
        var reader = new FileReader();

        // Set up the onload callback function
        reader.onload = function (e) {
            // Get the binary data
            var data = e.target.result;

            // Parse the Excel file using SheetJS
            var workbook = XLSX.read(data, { type: 'binary' });

            // Get the first sheet
            var sheetName = workbook.SheetNames[0];
            var sheet = workbook.Sheets[sheetName];

            // Parse the sheet data into JSON
            var list = XLSX.utils.sheet_to_json(sheet, { header: 1 });

            // Log the JSON data to the console
            //console.log(list);
            //read1(list);
            setTimeout(function () {
                read1(list);
            }, 0);
        };

        // Read the file as binary data
        reader.readAsBinaryString(file);
    } else {
        OpenAlert('Please select an Excel file.');
    }
}



function read1(list) {


    var input = document.getElementById('excel-file-input');
    input.value = '';
    ShowDataLoader();
    var StrItemList = JSON.stringify(list);
    //console.log(StrItemList);
    var args = {
        FKManagerID: 0, SubmitType: 'CM', ApproveAction: 'Submit', ApproveRemark: '', dtItemStr: StrItemList

    };
    $.ajax({

        type: "POST",
        url: pagename + "/ImportExcel",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        cache: false,
        success: function (data) {
            var returnstr = data.d;
            HideDataLoader();
            if (returnstr.length > 0) {

                OpenAlert(returnstr);
            }
            else {
                OpenAlert("Import Sucessfully");
                FunFillData();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });

    //To reset file Input
    function resetFile() {
        const file =
            document.querySelector('.excel-file-input');
        file.value = '';
    }
}

