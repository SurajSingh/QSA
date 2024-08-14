
var json;
var pagename = "RptEmployeeTimesheet.aspx";
var PKID = 0;
var PKRoleGroupID = 0;
var IsValidLogin = 0;
var FKPageID = 0;
var RCount = 0;
var JsonExport = null;
var IsColCreated = false;
var JsonReportLayout = null;
var JsonSchedueStatus = null;
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
        FKEmpID: $('#divFKEmpIDSrch').GenexMultiSelectGet(),
        FKClientID: $("#divFKClientIDSrch").GenexMultiSelectGet(),
        FKProjectID: $('#divFKProjectIDSrch').GenexMultiSelectGet(),
        FKManagerID: $("#dropFKManagerIDSrch").ValZero(), ApproveStatus: $("#dropApproveStatusSrch").val(), Billed: $("#dropBilledSrch").val(), Billable: $("#dropBillableSrch").val()

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
function InitilizeEvents() {



    $("#btnSearch").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "TaskDate", "A", "");
    });
    $("#btnRefresh").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "TaskDate", "A", "");
    });

}
function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    if (LoadEntity == 0) {
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "TaskDate", "A", "");
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

    SetDatePicker("txtStartDate");
    SetDatePicker("txtEndDate");

   




    LoadEntity = 3;



    FunGetClientForAutoComplete(FunClientCallBack, 0, '');
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, '');



}




function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}



function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}


function FunProjectCallBack(JsonArr) {
    $("#divFKProjectIDSrch").GenexMultiSelect(JsonArr);
    PageLoadComplete();
}
function FunClientCallBack(JsonArr) {
    $("#divFKClientIDSrch").GenexMultiSelect(JsonArr);
    PageLoadComplete();
}

function FunEmpCallBack(JsonArr) {

    $("#divFKEmpIDSrch").GenexMultiSelect(JsonArr);
    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });
    }
    $('#dropFKManagerIDSrch').append('<option value="0">All</option>' + str);
    PageLoadComplete();

}

$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});