

var pagename = "ProjectBudgeting.aspx";
var PKID = 0;
var FKPageID = 0;
var RCount = 0;
var JsonExport = null;
var IsColCreated = false;
var JsonReportLayout = null;
var JsonTask = null;
var DRowNo = 0;
var OpentrID = "";

function FunFillData(NewPageSize, OffSet, SortBy, SortDir, ExportType) {
    $('#spanProjectName').html('');
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
        PKID: 0, FKProjectID: $("#txtFKProjectIDSrch").GenexAutoCompleteGet('0')

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
                                str = str + '<td style="text-align:center">  <a class="linkView text-primary" id="linkView' + this.PKID + '"  title="View Detail"> <i class="uil uil-eye font-size-18t"></i></a></td>';

                                if (IsEdit == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkEditRec text-primary" id="linkEditRec' + this.PKID + '"  title="Edit Record"> <i class="uil uil-pen font-size-18t"></i></a></td>';

                                }
                                else {
                                    str += "<td></td>";
                                }
                                if (IsDelete == 1) {
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
                                               
                                                strval = strval+'%';
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
                                FunFillDetail('E');
                              
                            });
                            $('#tbldata').on('click', '.linkView', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkView", "");
                                PKID = parseInt(newid);
                                FunFillBudgetLog();

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
                    if (jsonarr.data.Table[0].Result == "1") {
                        $('#divView').hide();
                        $('#divAddNew2').show();
                        if (RecType != 'T') {
                            FunBlank();
                            PKID = jsonarr.data.Table[0].PKID;
                            $("#txtTitle").val(jsonarr.data.Table[0].BudgetTitle);
                            $("#spanProjectName").html('(' + jsonarr.data.Table[0].ProjectName + ')');
                            $("#txtFKProjectID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKProjectID, jsonarr.data.Table[0].ProjectName);
                        }
                        else {
                            PKID = 0;
                        }
                         
                        $("#txtfromdate").val(jsonarr.data.Table[0].FromDate);
                        $("#txttodate").val(jsonarr.data.Table[0].ToDate);
                        
                        $.each(jsonarr.data.Table1, function () {
                            AddNewDetailRow();
                            var trID = "";
                            trID = "trDRow" + DRowNo;
                            if (RecType != 'T') {
                                $("#hidPKID" + trID).val(this.PKID);
                            } 
                            $('#txtDescription' + trID).prop('disabled', this.TDesReadonly);
                            $("#txtFKTaskID" + trID).GenexAutoCompleteSet(this.FKTaskID, this.TaskName);
                            $("#txtHrs" + trID).val(this.BudHrs.toFixed(2));
                            $("#txtDescription" + trID).val(this.Description);
                            $("#chkIsBillable" + trID).prop('checked', this.IsBillable);
                            $("#txtTBillRate" + trID).val(this.BillRate.toFixed(2));
                            $("#txtTCostRate" + trID).val(this.CostRate.toFixed(2));

                        });
                       
                        
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
function FunFillBudgetLog() {
    ShowLoader();
    var args = {
        PageSize: 0, OffSet: 0, SortBy: '', SortDir: '',
        PKID: PKID, FKProjectID: 0

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
                        $("#tdTitle").html(jsonarr.data.Table[0].BudgetTitle);
                        $("#tdProject").html( jsonarr.data.Table[0].ProjectName);

                        $("#tdBudgetDate").html('From ' + jsonarr.data.Table[0].FromDate + ' to ' + jsonarr.data.Table[0].ToDate);

                        $('#tblPreviousLog tbody').empty();
                        var str = '';
                        var BudHrs = 0;
                        var ActualHrs = 0;
                        $("#tdBudHrs").html('0.00');
                        $("#tdActualHrs").html('0.00');
                        $.each(jsonarr.data.Table1, function () {
                           
                            str += '<tr>';
                            str += '<td>' + this.TaskCode + ':' + this.TaskName + '</td>';
                            str += '<td>' + this.Description + '</td>';
                            str += '<td style="text-align:right;">' + this.BudHrs.toFixed(2) + '</td>';
                            str += '<td style="text-align:right;">' + this.TimesheetHrs.toFixed(2) + '</td>';
                            str += '</tr>';

                            BudHrs += this.BudHrs;
                            ActualHrs += this.TimesheetHrs;

                          

                        });
                        $("#tdBudHrs").html(BudHrs.toFixed(2));
                        $("#tdActualHrs").html(ActualHrs.toFixed(2));
                        $('#tblPreviousLog tbody').append(str);
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
function FunBlank() {
    PKID = 0;   
    $('#spanProjectName').html('');
    $('#txtFKBudgetID').GenexAutoCompleteBlank();
    $('#txtFKProjectID').GenexAutoCompleteBlank();

    $("#txtfromdate").val('');
    $("#txttodate").val('');
    $("#txtTitle").val('');
    $('#tblTimeSheet tbody').empty();
    DRowNo = 0;
}



function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtFKProjectID").GenexAutoCompleteGet(0) == "0") {
        fail = true;
        $("#txtFKProjectID").css("border-color", ColorE);
        strError += "<li>Select Project</li>";
    }
    else {
        $("#txtFKProjectID").css("border-color", ColorN);
    }
   
    if (!fail) {
        $("#divValidateSummary").hide();
        closediv();
        $('#spanProjectName').html('('+$("#txtFKProjectID").val()+')');
        if ($("#txtFKBudgetID").GenexAutoCompleteGet(0) == "0") {           
            $('#divView').hide();
            $('#divAddNew2').show();
           
        }
        else {
            PKID = $("#txtFKBudgetID").GenexAutoCompleteGet(0);
            FunFillDetail('T');
        }



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

function FunValidate2() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    var ItemCount = 0;

    $('#tblTimeSheet tbody tr').each(function (row, tr) {
        var str = '';
        var trID = $(tr).attr("id");

        if (!$(tr).hasClass("trdeleted")  && $("#txtFKTaskID" + trID).GenexAutoCompleteGet(0) == "0") {
            $(tr).addClass('trdeleted');
        }
        
        if (!$(tr).hasClass("trdeleted") || $("#hidPKID" + trID).val() != '0') {
            ItemCount = ItemCount + 1;
        }

        if (!$(tr).hasClass("trdeleted")) {

            
           

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

           
        }


    });
    if ($("#txtfromdate").val() == "") {
        fail = true;
        $("#txtfromdate").css("border-color", ColorE);
        strError += "<li>Enter From Date</li>";
    }
    else {
        $("#txtfromdate").css("border-color", ColorN);
    }
    if ($("#txttodate").val() == "") {
        fail = true;
        $("#txttodate").css("border-color", ColorE);
        strError += "<li>Enter To Date</li>";
    }
    else {
        $("#txttodate").css("border-color", ColorN);
    }
    if ($("#txtTitle").val() == "") {
        fail = true;
        $("#txtTitle").css("border-color", ColorE);
        strError += "<li>Enter Budget Title</li>";
    }
    else {
        $("#txtTitle").css("border-color", ColorN);
    }
    if (ItemCount == 0) {
        OpenAlert('No row added to sheet');
    }
    else {

        if (!fail) {
            $("#divValidateSummary2").hide();
            FunSave();
        }
        else {

            $("#divValidateSummary2").show();
            $("#divValidateSummary2").find(".validate-box ul").empty();
            $("#divValidateSummary2").find(".validate-box ul").html(fail_log + strError);
            $('html, body').animate({
                scrollTop: $("#divValidateSummary2").offset().top
            }, 500);
            return false;
        }
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
        TableData[i] = {
            "PKID": $("#hidPKID" + trid).ValZero()          
            , "FKTaskID": $("#txtFKTaskID" + trid).GenexAutoCompleteGet(0)           
            , "BudHrs": parseFloat($("#txtHrs" + trid).ValZero()).toFixed(2)
            , "Description": $("#txtDescription" + trid).val()
            , "IsBillable": $("#chkIsBillable" + trid).is(':checked')           
            , "CostRate": parseFloat($("#txtTCostRate" + trid).ValZero()).toFixed(2)
            , "BillRate": parseFloat($("#txtTBillRate" + trid).ValZero()).toFixed(2)
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
        PKID: PKID, BudgetTitle: $('#txtTitle').val(), FromDate: $('#txtfromdate').val(), ToDate: $('#txttodate').val(), FKProjectID: $('#txtFKProjectID').GenexAutoCompleteGet(0), dtItemStr: StrItemList

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
                        OpenAlert('Saved Successfully!');
                        $('#divView').show();
                        $('#divAddNew2').hide();
                        FunBlank();
                        FunGetBudgetForAutoComplete();
                        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");


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
                            FunGetBudgetForAutoComplete();
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
function AddNewDetailRow() {


    var trID = "";
    DRowNo = DRowNo + 1;
    trID = "trDRow" + DRowNo;

    var NewRow = '<tr id="' + trID + '" data-memoreq="0" data-isEdit="1" data-isSubmitted="0">';
    
    NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';

    NewRow += '<td class="tdFKTaskID"> <input type="text" id="txtFKTaskID' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdHrs"> <input type="text" id="txtHrs' + trID + '" class="form-control" style="text-align:right;"   /></td>';
    NewRow += '<td class="tdDescription"> <input type="text" id="txtDescription' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdIsBillable" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkIsBillable' + trID + '"  /></td>';
    NewRow += '<td class="tdTBillRate"> <input type="text" id="txtTBillRate' + trID + '" class="form-control"  style="text-align:right;"   /></td>';
    NewRow += '<td class="tdTCostRate"> <input type="text" id="txtTCostRate' + trID + '" class="form-control"  style="text-align:right;"    /></td>';
   
    NewRow += "</tr>";
    $("#tblTimeSheet tbody").append(NewRow);

   

    $('#linkDelete' + trID).click(function () {
        var NewID = $(this).attr("id");
        NewID = NewID.replace("linkDelete", "");

        if (confirm("Delete this record?")) {
            $("#" + NewID).addClass("trdeleted");
            $('#linkDelete' + NewID).remove();
            FunSetTotal();
        }
    });
   
    $('#txtFKTaskID' + trID).GenexAutoCompleteWithCallBack(JsonTask, FunSetTaskDetail, 0, "TaskCode,Task Name,Description");
       
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
function FunSetTaskDetail(item, inputid) {

    var FKTaskID = $("#" + inputid).GenexAutoCompleteGet(0);
    var NewID = inputid;
    NewID = NewID.replace("txtFKTaskID", "");
    if (FKTaskID != 0) {
        $('#txtTBillRate' + NewID).val(item.BillRate);
        $('#txtTCostRate' + NewID).val(item.CostRate);
        $('#txtHrs' + NewID).val(item.BHours);
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

function InitilizeEvents() {

    $("#btnCreate").click(function () {
        FunValidate();
    });
    $("#btnsave").click(function () {
        FunValidate2();
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
    $("#btnBack").click(function () {
        $('#spanProjectName').html('');
        $('#divView').show();
        $('#divAddNew2').hide();
    });
    $("#btnSearch").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });
    $("#btnRefresh").click(function () {

        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
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
    SetDatePicker('txtfromdate');
    SetDatePicker('txttodate');


    FunSetTabKey();
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
      
    LoadEntity = 4;
    FunGetBudgetForAutoComplete();
    FunGetTaskForAutoComplete(FunTaskCallBack, 0, 0, 'T', 'Active');
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);
   
  
    
}
function FunProjectCallBack(JsonArr) {
    $("#txtFKProjectIDSrch").GenexAutoComplete(JsonArr, "ProjectID,Project,ClientID");
    $("#txtFKProjectID").GenexAutoComplete(JsonArr, "ProjectID,Project,ClientID");
    PageLoadComplete();
}
function FunTaskCallBack(JsonArr) {

    JsonTask = JsonArr;
    PageLoadComplete();
}
function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}



function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}

function FunGetBudgetForAutoComplete() {

    var jsonarr = [];
    var args = {
        FKProjectID: 0
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetBudgetForAutoComplete",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var str = '';
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                $("#txtFKBudgetID").GenexAutoComplete(jsonarr, "Title,ProjectID,Project");
                PageLoadComplete();
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();

        }

    });
}
$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});