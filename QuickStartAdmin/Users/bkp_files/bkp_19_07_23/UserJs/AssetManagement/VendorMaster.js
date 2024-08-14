
var json;
var pagename = "VendorMaster.aspx";
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
        PKID: 0, Company: $('#txtCompanyNameSrch').val()

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
        PKID: PKID, Company:''
        
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
                        $('#popupTitle').find('span').html("Modify Vendor");
                        PKID = jsonarr.data.Table[0].PKID;                       
                       
                        
                        $("#txtCode").val(jsonarr.data.Table[0].Code);
                        $("#txtCompany").val(jsonarr.data.Table[0].Company);
                        $("#txtCPerson").val(jsonarr.data.Table[0].CPerson);
                        $("#txtCPersonTitle").val(jsonarr.data.Table[0].CPersonTitle);
                        $("#txtNotes").val(jsonarr.data.Table[0].Notes);
                        $("#txtAddress1").val(jsonarr.data.Table[0].Address1);
                        $("#txtAddress2").val(jsonarr.data.Table[0].Address2);
                        $("#dropFKCountryID").val(jsonarr.data.Table[0].FKCountryID);
                        $('#dropFKStateID').empty();
                        $('#dropFKCityID').empty();
                        $('#dropFKTahsilID').empty();

                        $('#dropFKStateID').append('<option value="0">Select State</option>');
                        $('#dropFKCityID').append('<option value="0">Select City</option>');
                        $('#dropFKTahsilID').append('<option value="0">Select Town</option>');
                        if (jsonarr.data.Table[0].FKStateID != 0) {
                            $('#dropFKStateID').append('<option value="' + jsonarr.data.Table[0].FKStateID + '">' + jsonarr.data.Table[0].StateName + '</option>');
                            $("#dropFKStateID").val(jsonarr.data.Table[0].FKStateID);
                        }
                        if (jsonarr.data.Table[0].FKCityID != 0) {
                            $('#dropFKCityID').append('<option value="' + jsonarr.data.Table[0].FKCityID + '">' + jsonarr.data.Table[0].CityName + '</option>');
                            $("#dropFKCityID").val(jsonarr.data.Table[0].FKCityID);
                        }

                        if (jsonarr.data.Table[0].FKTahsilID != 0) {
                            $('#dropFKTahsilID').append('<option value="' + jsonarr.data.Table[0].FKTahsilID + '">' + jsonarr.data.Table[0].TahsilName + '</option>');
                            $("#dropFKTahsilID").val(jsonarr.data.Table[0].FKTahsilID);
                        }


                        $("#txtZIP").val(jsonarr.data.Table[0].ZIP);
                        $("#txtEMailID").val(jsonarr.data.Table[0].EMailID);
                        $("#txtPhone1").val(jsonarr.data.Table[0].Phone1);
                        $("#txtPhone2").val(jsonarr.data.Table[0].Phone2);
                        $("#txtMobile").val(jsonarr.data.Table[0].Mobile);
                        $("#txtFax").val(jsonarr.data.Table[0].Fax);
                        $("#txtWebsite").val(jsonarr.data.Table[0].Website);
                       
                       
                      
                       

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
    IsValidLogin = 0;
    $('#divAddNew').find('.form-control').val('');
  
  
    $('#popupTitle').find('span').html("New Vendor");

}



function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtCode").val() == "") {
        fail = true;
        $("#txtCode").css("border-color", ColorE);
        strError += "<li>Enter Vendor Code</li>";
    }
    else {
        $("#txtCode").css("border-color", ColorN);
    }
    if ($("#txtCompany").val() == "") {
        fail = true;
        $("#txtCompany").css("border-color", ColorE);
        strError += "<li>Enter Vendor Name</li>";
    }
    else {
        $("#txtCompany").css("border-color", ColorN);
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
        PKID: PKID, Code: $("#txtCode").val(), Company: $("#txtCompany").val(),
        CPerson: $("#txtCPerson").val(), CPersonTitle: $("#txtCPersonTitle").val(),
        Address1: $("#txtAddress1").val(), Address2: $("#txtAddress2").val(), FKTahsilID: $("#dropFKTahsilID").ValZero(), FKCityID: $("#dropFKCityID").ValZero(), FKStateID: $("#dropFKStateID").ValZero(), FKCountryID: $("#dropFKCountryID").ValZero(), ZIP: $("#txtZIP").val(),
        EMailID: $("#txtEMailID").val(), Phone1: $("#txtPhone1").val(), Phone2: $("#txtPhone2").val(), Mobile: $("#txtMobile").val(), Fax: $("#txtFax").val(),
        Website: $("#txtWebsite").val(), Notes: $("#txtNotes").val()
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
    
    $("#btnSearch").click(function (event) {
        event.stopPropagation();
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
    FunSetTabKey();
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
    SetEmailBox("txtEMailID");
    SetMobileBox('txtPhone1');
    SetMobileBox('txtPhone2');
    SetMobileBox('txtMobile');
    SetMobileBox('txtFax');


    LoadEntity = 1;
    FunFillCountry("dropFKCountryID", "dropFKStateID", "dropFKCityID", "dropFKTahsilID");
  
   
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