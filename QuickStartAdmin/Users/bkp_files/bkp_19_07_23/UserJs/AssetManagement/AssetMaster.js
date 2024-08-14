
var json;
var pagename = "AssetMaster.aspx";
var PKID = 0;
var PKRoleGroupID = 0;
var IsValidLogin = 0;
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
        PKID: 0, AssetCode: $('#txtAssetNameSrch').val(), FKCategoryID: $('#dropFKCategoryIDSrch').ValZero(), FKConditionID: $('#dropFKConditionIDSrch').ValZero(),
        FKLocationID: $('#dropFKLocationIDSrch').ValZero(),
        FKDeptID: 0, FKEmpID: 0, FKRepairPartyID: 0

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
                                if (IsEdit==1) {
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

                                            if (attr == "ImgURL") {
                                                if (item[attr] == '') {
                                                    strval = '<a href="/Users/Images/NoImage.jpg" class="gridimg itemimg" style="background-image: url(/Users/Images/NoImage.jpg);"></a>';
                                                }
                                                else {
                                                    strval = '<a href="/webfiles/itemimg/' + item[attr] + '" class="gridimg itemimg" style="background-image: url(/webfiles/itemimg/' + item[attr] + ');"></a>';
                                                }
                                            }
                                            else if (attr == "LocationName"){
                                                if (item["FKLocationID"] == "1") {
                                                    strval = '<i class="fa fa-user"></i>&nbsp;' + item[attr];
                                                }
                                                else if (item["FKLocationID"] == "2") {
                                                    strval = '<i class="fa fa-building"></i>&nbsp;' + item[attr];
                                                }
                                                else if (item["FKLocationID"] == "3") {
                                                    strval = '<i class="fas fa-store"></i>&nbsp;' + item[attr];
                                                }
                                                else if (item["FKLocationID"] == "4") {
                                                    strval = '<i class="fa-solid fa-wrench"></i>&nbsp;' + item[attr];
                                                }
                                                else {
                                                    strval = item[attr];
                                                }
                                            }
                                            else {
                                                strval = item[attr];
                                            }
                                            if ($(th).hasClass('tdclscurrency')) {
                                                strclass = strclass + ' tdclscurrency';
                                                var TranCurrency = CurrencyName;
                                                strval = TranCurrency + ' ' + strval;
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
                            $('#tbldata').on('click', '.gridimg', function (event) {
                                event.stopImmediatePropagation();
                                var target = $(event.target);
                                var newid = $(this).attr("href");
                                opendivid = "divShowImage";
                                $("#divShowImage").show();
                                $("#imgItem").attr("src", newid);
                                event.preventDefault();
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
function FunFillDetail() {
    ShowLoader();
    var args = {
        PageSize: 0, OffSet: 0, SortBy: "", SortDir: "",
        PKID: PKID, AssetCode: '', FKCategoryID: 0, FKConditionID: 0,
        FKLocationID: 0,
        FKDeptID: 0, FKEmpID: 0, FKRepairPartyID: 0

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
                        FunBlank();
                        $('#popupTitle').find('span').html("Modify Asset");
                        PKID = jsonarr.data.Table[0].PKID;
                        SavedFileName = jsonarr.data.Table[0].ImgURL;
                        if (SavedFileName != "") {
                            $("#btnfileselect").css("background-image", "url(" + UploadPath + SavedFileName + ")");
                        }

                        $("#txtAssetCode").val(jsonarr.data.Table[0].AssetCode);
                        $("#txtAssetName").val(jsonarr.data.Table[0].AssetName);
                        $("#txtAssetDesc").val(jsonarr.data.Table[0].AssetDesc);
                        $("#dropFKCategoryID").val(jsonarr.data.Table[0].FKCategoryID);
                        $("#txtSerialNo").val(jsonarr.data.Table[0].SerialNo);
                        $("#txtBarcode").val(jsonarr.data.Table[0].Barcode);
                        $("#txtManufacturer").val(jsonarr.data.Table[0].Manufacturer);
                        $("#dropFKPartyID").val(jsonarr.data.Table[0].FKPartyID);
                        $("#txtPurchaseDate").val(jsonarr.data.Table[0].PurchaseDate);
                        $("#txtPurchaseRate").val(jsonarr.data.Table[0].PurchaseRate);
                        $("#txtInvoiceID").val(jsonarr.data.Table[0].InvoiceID);
                        $("#txtPONo").val(jsonarr.data.Table[0].PONo);
                        $("#dropFKConditionID").val(jsonarr.data.Table[0].FKConditionID);
                        $("#dropFKLocationID").val(jsonarr.data.Table[0].FKLocationID);
                        $("#dropFKDeptID").val(jsonarr.data.Table[0].FKDeptID);
                        $("#dropFKEmpID").val(jsonarr.data.Table[0].FKEmpID);

                        $("#dropFKRepairPartyID").val(jsonarr.data.Table[0].FKRepairPartyID);
                        $("#txtRemarks").val(jsonarr.data.Table[0].Remarks);

                        FunSetShowHideLocation();


                        opendiv('divAddNew');
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
    $('#divAddNew').find('.form-control').val('');
    $('#divAddNew').find('.form-select').val('0');
    SavedFileName = "";
    $("#btnfileselect").css("background-image", "url(Images/NoImage.jpg)");
    FunSetShowHideLocation();
    $('#popupTitle').find('span').html("New Asset");

}



function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtAssetCode").val() == "") {
        fail = true;
        $("#txtAssetCode").css("border-color", ColorE);
        strError += "<li>Enter Asset Code</li>";
    }
    else {
        $("#txtAssetCode").css("border-color", ColorN);
    }
    if ($("#txtAssetName").val() == "") {
        fail = true;
        $("#txtAssetName").css("border-color", ColorE);
        strError += "<li>Enter Asset Name</li>";
    }
    else {
        $("#txtAssetName").css("border-color", ColorN);
    }

    if ($("#dropFKCategoryID").ValZero() == "0") {
        fail = true;
        $("#dropFKCategoryID").css("border-color", ColorE);
        strError += "<li>Select Category</li>";
    }
    else {
        $("#dropFKCategoryID").css("border-color", ColorN);
    }
    if ($("#dropFKPartyID").ValZero() == "0") {
        fail = true;
        $("#dropFKPartyID").css("border-color", ColorE);
        strError += "<li>Select Vendor</li>";
    }
    else {
        $("#dropFKPartyID").css("border-color", ColorN);
    }
    if ($("#txtPurchaseDate").val() == "") {
        fail = true;
        $("#txtPurchaseDate").css("border-color", ColorE);
        strError += "<li>Enter Acquire Date</li>";
    }
    else {
        $("#txtPurchaseDate").css("border-color", ColorN);
    }
    if ($("#dropFKConditionID").ValZero() == "0") {
        fail = true;
        $("#dropFKConditionID").css("border-color", ColorE);
        strError += "<li>Select Asset Condition</li>";
    }
    else {
        $("#dropFKConditionID").css("border-color", ColorN);
    }


    if ($("#dropFKLocationID").ValZero() == "0") {
        fail = true;
        $("#dropFKLocationID").css("border-color", ColorE);
        strError += "<li>Select Current Location</li>";
    }
    else {
        $("#dropFKLocationID").css("border-color", ColorN);

        if ($("#dropFKLocationID").ValZero() == "1") {
            if ($("#dropFKEmpID").ValZero() == "0") {
                fail = true;
                $("#dropFKEmpID").css("border-color", ColorE);
                strError += "<li>Select Employee</li>";
            }
            else {
                $("#dropFKEmpID").css("border-color", ColorN);
            }
        }
        else if ($("#dropFKLocationID").ValZero() == "2") {
            if ($("#dropFKDeptID").ValZero() == "0") {
                fail = true;
                $("#dropFKDeptID").css("border-color", ColorE);
                strError += "<li>Select Department</li>";
            }
            else {
                $("#dropFKDeptID").css("border-color", ColorN);
            }
        }
        else if ($("#dropFKLocationID").ValZero() == "4") {
            if ($("#dropFKRepairPartyID").ValZero() == "0") {
                fail = true;
                $("#dropFKRepairPartyID").css("border-color", ColorE);
                strError += "<li>Select Repairing Location</li>";
            }
            else {
                $("#dropFKRepairPartyID").css("border-color", ColorN);
            }
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

    var FKDeptID = 0, FKEmpID = 0, FKRepairPartyID = 0;
    if ($("#dropFKLocationID").ValZero() == "1") {
        FKEmpID = $("#dropFKEmpID").ValZero();
    }
    else if ($("#dropFKLocationID").ValZero() == "2") {
        FKDeptID = $("#dropFKDeptID").ValZero();
    }
    else if ($("#dropFKLocationID").ValZero() == "4") {
        FKRepairPartyID = $("#dropFKRepairPartyID").ValZero();
    }

    var args = {
        PKID: PKID, AssetCode: $("#txtAssetCode").val(), AssetName: $("#txtAssetName").val(), AssetDesc: $("#txtAssetDesc").val(),
        FKCategoryID: $("#dropFKCategoryID").ValZero(), Manufacturer: $("#txtManufacturer").val(), FKPartyID: $("#dropFKPartyID").ValZero(), PurchaseRate: $("#txtPurchaseRate").ValZero(),
        CurrentRate: $("#txtPurchaseRate").ValZero(), PurchaseDate: $("#txtPurchaseDate").val(), InvoiceID: $("#txtInvoiceID").val(), PONo: $("#txtPONo").val(), Barcode: $("#txtBarcode").val(), SerialNo: $("#txtSerialNo").val(), Remarks: $("#txtRemarks").val(),
        ImgURL: SavedFileName, FKConditionID: $("#dropFKConditionID").ValZero(), FKLocationID: $("#dropFKLocationID").ValZero(),
        FKDeptID: FKDeptID, FKEmpID: FKEmpID, FKRepairPartyID: FKRepairPartyID,
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

function FunSetShowHideLocation() {
    $('#divFKDeptID').hide();
    $('#divFKEmpID').hide();
    $('#divFKRepairPartyID').hide();

    if ($('#dropFKLocationID').ValZero() == "1") {
        $('#divFKEmpID').show();

    }
    else if ($('#dropFKLocationID').ValZero() == "2") {
        $('#divFKDeptID').show();

    }
    else if ($('#dropFKLocationID').ValZero() == "4") {
        $('#divFKRepairPartyID').show();

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

    $("#btnSearch").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });
    $("#dropFKLocationID").change(function () {
        FunSetShowHideLocation();
    });
    UploadPath = "/webfiles/itemimg/";
    $('#btnfileselect').click(function () {
        FunUploadAttachment("Item", "btnFileSelectInner", "/webfiles/itemimg/");

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
    FunSetTabKey();
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }

    SetDatePicker('txtPurchaseDate');
    SetAmountBox("txtPurchaseRate", 2, false, "");

    LoadEntity = 7;


    FunGetEmpForAutoComplate(FunEmpCallBack, 0, '');
    FunFillDept(FunDeptCallback);
    FunFillLocationMaster(FunLocationCallback);
    FunFillParty(FunPartyCallback);
    FunFillAssetConditionMaster(FunAssetConditionCallback);
    FunFillAssetCategory(FunAssetCategoryCallback);

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

    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });
    }

    $('#dropFKEmpID').append('<option value="0">Select One</option>' + str);

    PageLoadComplete();
}
function FunPartyCallback(str) {

    $('#dropFKRepairPartyID').append(str);
    $('#dropFKPartyID').append(str);
    PageLoadComplete();
}
function FunDeptCallback(str) {

    $('#dropFKDeptID').append(str);
    PageLoadComplete();
}
function FunLocationCallback(str) {

    $('#dropFKLocationIDSrch').append(str);
    $('#dropFKLocationID').append(str);
    PageLoadComplete();
}
function FunAssetConditionCallback(str) {

    $('#dropFKConditionIDSrch').append(str);
    $('#dropFKConditionID').append(str);
    PageLoadComplete();
}
function FunAssetCategoryCallback(str) {

    $('#dropFKCategoryIDSrch').append(str);
    $('#dropFKCategoryID').append(str);
    PageLoadComplete();
}

$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});