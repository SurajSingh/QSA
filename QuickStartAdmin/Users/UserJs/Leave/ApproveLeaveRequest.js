

var pagename = "ApproveLeaveRequest.aspx";
var PKID = 0;
var FKPageID = 0;
var RCount = 0;
var JsonExport = null;
var IsColCreated = false;
var JsonReportLayout = null;

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
        daterange: $("#dropaterange").val(), FromDate: $("#txtfromdate").val(), ToDate: $("#txttodate").val(),
        PKID: 0, FKEmpID: $('#dropFKEmpIDSrch').ValZero(), FKLeaveID: $("#dropFKLeaveIDSrch").ValZero(),
        LeaveType: $("#dropFKLeaveTypeIDSrch").val(), ApproveStatus: $("#dropApproveStatusSrch").val()

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

                                if (IsAdd == 1 && this.ApproveStatus=='Pending') {
                                    str = str + '<td style="text-align:center">  <a class="linkAction text-danger" id="linkAction' + this.PKID + '"  title="Take Action">Action</a></td>';
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
                                var TranCurrency = CurrencyName;
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
                                            if ($(th).hasClass('bold')) {
                                                strclass = strclass + ' bold';
                                            }
                                            strval = item[attr];
                                            if ($(th).hasClass('tdclscurrency')) {
                                                strclass = strclass + ' tdclscurrency';
                                               
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
                           
                            $('#tbldata').on('click', '.linkAction', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkAction", "");
                                PKID = parseInt(newid);
                                $('#dropApproveStatus').val('Approved');
                                $('#txtRemarks').val('');
                                $('#divRemark').hide();
                                opendiv('divAddNew');

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



function FunFillPayrollSetting() {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetPayrollSetting",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.data != null && jsonarr.data.Table.length > 0) {
                    $.each(jsonarr.data.Table1, function (i, item) {
                        str = str + '<option value="' + item.PKID + '">' + item.LeaveName + '</option>';
                    });


                }
                $('#dropFKLeaveIDSrch').append('<option value="0">All</option>' + str);
              
                PageLoadComplete();
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}
function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    if ($("#dropApproveStatus").val() == 'Reject') {

        if ($("#txtRemarks").val() == "") {
            fail = true;
            $("#txtRemarks").css("border-color", ColorE);
            strError += "<li>Enter Remark</li>";
        }
        else {
            $("#txtRemarks").css("border-color", ColorN);
        }
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
        PKID: PKID, ApproveStatus: $("#dropApproveStatus").val(), Remarks: $("#txtRemarks").val()
    };

    ShowLoader();
    $.ajax({

        type: "POST",
        url: pagename + "/ApproveEmpLeaveRequest",
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
                        IsColCreated = false;
                        RCount = 0;
                        $("#tbldata").GenexTableDestroy();
                        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "");

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

function FunFillEmpLeaveReport(IsPageLoad) {
    $('#tblLeaveDetail tbody').empty();
    var str = "";
    var args = {
        FKEmpID: $('#dropFKEmpID').ValZero()
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetEmpLeaveReport",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str += '<tr>';
                        str += '<td>' + item.LeaveName + '</td>';
                        str += '<td>' + item.PayType + '</td>';
                        str += '<td>' + item.CFCount + item.AccrCount + '</td>';
                        str += '<td>' + item.TakenCount + '</td>';
                        str += '<td>' + item.BalCount + '</td>';
                    });


                }
                $('#tblLeaveDetail tbody').append(str);
                if (IsPageLoad) {
                    PageLoadComplete();
                }

            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}

function FunCalculateEmployeeLeave() {
    $('#txtToDate').val('');
    var str = "";
    var args = {
        FKEmpID: $('#dropFKEmpID').ValZero(),FKLeaveID: $('#dropFKLeaveID').ValZero(), FormDate: $('#txtFromDate').val(), NoOfDays: $('#txtLeaveCount').ValZero()
    };
  
    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/CalculateEmployeeLeave",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    if (jsonarr[0].Result == 1) {

                        $('#txtLeaveCount').val(jsonarr[0].NoOfDays);
                        $('#txtToDate').val(jsonarr[0].ToDate);
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                        $('#txtLeaveCount').val('');
                        $('#txtToDate').val('');
                    }
                    


                }
                

            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}



function FunEmpCallBack(JsonArr) {

    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });
    }
    $('#dropFKEmpIDSrch').append('<option value="">All</option>' + str);
   
   
    PageLoadComplete();
}


function InitilizeEvents() {

   
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
   

   
    $("#btnSave").click(function () {
        FunValidate();
    });
    $("#dropApproveStatus").change(function () {
        if ($("#dropApproveStatus").val() == 'Approved') {
            $('#divRemark').hide();
            $('#txtRemarks').val('');
        }
        else {
            $('#divRemark').show();
        }
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

    FunSetTabKey();
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
    
    LoadEntity =3;   
    FunFillPayrollSetting();
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, '');
    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);
   
  
    
}
function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}



function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}



$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});