

var pagename = "Projects.aspx";
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
        PKID: 0, ProjectName: $('#txtProjectNameSrch').val(), FKClientID: $("#txtFKClientIDSrch").GenexAutoCompleteGet('0'), ActiveStatus: $('#dropActiveStatusSrch').val(), FKContractTypeID: $('#dropFKContractTypeSrch').ValZero()

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
        PKID: PKID, ProjectName: '', FKClientID: 0, ActiveStatus: '', FKContractTypeID:0
         
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
                        $('#popupTitle').find('span').html("Modify Project");
                        PKID = jsonarr.data.Table[0].PKID;                       
                       
                        

                        $("#txtPKID").val(jsonarr.data.Table[0].PKID);
                        $("#txtFKClientID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKClientID, jsonarr.data.Table[0].ClientCompany);
                        $("#txtProjectCode").val(jsonarr.data.Table[0].ProjectCode);
                        $("#txtProjectName").val(jsonarr.data.Table[0].ProjectName);
                        $("#txtFKManagerID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKManagerID, jsonarr.data.Table[0].ManagerName);

                        $("#dropFKContractTypeID").val(jsonarr.data.Table[0].FKContractTypeID);
                        $("#dropProjectStatus").val(jsonarr.data.Table[0].ProjectStatus);
                        $("#txtContractAmt").val(jsonarr.data.Table[0].ContractAmt);
                        $("#txtExpAmt").val(jsonarr.data.Table[0].ExpAmt);
                        $("#txtServiceAmt").val(jsonarr.data.Table[0].ServiceAmt);
                        $("#txtBudgetedHours").val(jsonarr.data.Table[0].BudgetedHours);
                        $("#txtStartdate").val(jsonarr.data.Table[0].Startdate);
                        $("#txtDueDate").val(jsonarr.data.Table[0].DueDate);
                        $("#txtCompletePercent").val(jsonarr.data.Table[0].CompletePercent);
                        $("#txtPONo").val(jsonarr.data.Table[0].PONo);
                        $("#txtRemark").val(jsonarr.data.Table[0].Remark);

                        $("#dropFKCurrencyID").val(jsonarr.data.Table1[0].FKCurrencyID);
                        $("#chkISCustomInvoice").prop('checked',jsonarr.data.Table1[0].ISCustomInvoice);
                        $("#txtInvoicePrefix").val(jsonarr.data.Table1[0].InvoicePrefix);
                        $("#txtInvoiceSuffix").val(jsonarr.data.Table1[0].InvoiceSuffix);
                        $("#txtInvoiceSNo").val(jsonarr.data.Table1[0].InvoiceSNo);

                        if (jsonarr.data.Table1[0].ISCustomInvoice) {
                            $("#txtInvoicePrefix").prop('disabled', false);
                            $("#txtInvoiceSNo").prop('disabled', false);
                            $("#txtInvoiceSuffix").prop('disabled', false);
                        }
                       

                        $("#dropFKBillingFrequency").val(jsonarr.data.Table1[0].FKBillingFrequency);
                        
                        $("#txtExpenseTax").val(jsonarr.data.Table1[0].ExpenseTax);
                        $("#dropFKTaxID").val(jsonarr.data.Table1[0].FKTaxID);
                        $("#dropFKTermID").val(jsonarr.data.Table1[0].FKTermID);

                        $("#chkTBillable").prop('checked',jsonarr.data.Table1[0].TBillable);
                        $("#chkTMemoRequired").prop('checked',jsonarr.data.Table1[0].TMemoRequired);
                        $("#chkEBillable").prop('checked',jsonarr.data.Table1[0].EBillable);
                        $("#chkEMemoRequired").prop('checked',jsonarr.data.Table1[0].EMemoRequired);
                        $("#chkTDesReadonly").prop('checked',jsonarr.data.Table1[0].TDesReadonly);
                        $("#chkEDesReadOnly").prop('checked',jsonarr.data.Table1[0].EDesReadOnly);
                       
                       
                      
                       

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
  
    $("#dropActiveStatus").val('Active');   
    $('#txtFKManagerID').GenexAutoCompleteBlank();
    $('#txtFKClientID').GenexAutoCompleteBlank();

    $("#dropProjectStatus").val('Active');
    $("#dropFKCurrencyID").val('0');
    $("#dropFKBillingFrequency").val('0');
    $("#dropFKTaxID").val('0');
    $("#dropFKTermID").val('0');

    $("#chkISCustomInvoice").prop('checked', false);
    $("#txtInvoicePrefix").prop('disabled', true);
    $("#txtInvoiceSNo").prop('disabled', true);
    $("#txtInvoiceSuffix").prop('disabled', true);

    $("#chkTBillable").prop('checked', true);
    $("#chkEBillable").prop('checked', true);
    $("#chkTMemoRequired").prop('checked', false);
    $("#chkEMemoRequired").prop('checked', false);
    $("#chkEDesReadOnly").prop('checked', false);
    $("#chkTDesReadonly").prop('checked', false);


    $('#popupTitle').find('span').html("New Project");

}



function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtProjectCode").val() == "") {
        fail = true;
        $("#txtProjectCode").css("border-color", ColorE);
        strError += "<li>Enter Project ID</li>";
    }
    else {
        $("#txtProjectCode").css("border-color", ColorN);
    }
    if ($("#txtProjectName").val() == "") {
        fail = true;
        $("#txtProjectName").css("border-color", ColorE);
        strError += "<li>Enter Project Title</li>";
    }
    else {
        $("#txtProjectName").css("border-color", ColorN);
    }
    if ($("#txtFKClientID").GenexAutoCompleteGet('0')=='0') {
        fail = true;
        $("#txtFKClientID").css("border-color", ColorE);
        strError += "<li>Select Client</li>";
    }
    else {
        $("#txtFKClientID").css("border-color", ColorN);
    }
    if ($("#txtContractAmt").ValZero() == "0") {
        fail = true;
        $("#txtContractAmt").css("border-color", ColorE);
        strError += "<li>Enter Contract Amount</li>";
    }
    else {
        $("#txtContractAmt").css("border-color", ColorN);
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
        PKID: PKID, FKClientID: $("#txtFKClientID").GenexAutoCompleteGet('0'), ProjectCode: $("#txtProjectCode").val(), ProjectName: $("#txtProjectName").val(), FKManagerID: $("#txtFKManagerID").GenexAutoCompleteGet('0'), FKContractTypeID: $("#dropFKContractTypeID").ValZero(), ProjectStatus: $("#dropProjectStatus").ValZero(), ContractAmt: $("#txtContractAmt").ValZero(), ExpAmt: $("#txtExpAmt").ValZero(), ServiceAmt: $("#txtServiceAmt").ValZero(), BudgetedHours: $("#txtBudgetedHours").ValZero(),
        Startdate: $("#txtStartdate").val(), DueDate: $("#txtDueDate").val(), CompletePercent: $("#txtCompletePercent").ValZero(), PONo: $("#txtPONo").val(),
        Remark: $("#txtRemark").val(), FKCurrencyID: $("#dropFKCurrencyID").ValZero(), ISCustomInvoice: $("#chkISCustomInvoice").is(':checked'), InvoicePrefix: $("#txtInvoicePrefix").val(), InvoiceSuffix: $("#txtInvoiceSuffix").val(), InvoiceSNo: $("#txtInvoiceSNo").ValZero(), FKBillingFrequency: $("#dropFKBillingFrequency").ValZero(),
        GRT: 0, ExpenseTax: $("#txtExpenseTax").ValZero(), FKTaxID: $("#dropFKTaxID").ValZero(), FKTermID: $("#dropFKTermID").ValZero(), TBillable: $("#chkTBillable").is(':checked'), TMemoRequired: $("#chkTMemoRequired").is(':checked'), EBillable: $("#chkEBillable").is(':checked'), EMemoRequired: $("#chkEMemoRequired").is(':checked'), TDesReadonly: $("#chkTDesReadonly").is(':checked'),
        EDesReadOnly: $("#chkEDesReadOnly").is(':checked')
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

function FunSetClientCallBack(item, inputid) {
    var FKClientID = $("#" + inputid).GenexAutoCompleteGet(0);   
    if (FKClientID != 0) {

        $('#txtFKManagerID').GenexAutoCompleteSet(item.FKManagerID, item.ManagerName);
    }
    else {
        $("#" + inputid).GenexAutoCompleteBlank();
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
    $("#chkISCustomInvoice").click(function () {
        if ($(this).is(':checked')) {
            $("#txtInvoicePrefix").prop('disabled', false);
            $("#txtInvoiceSNo").prop('disabled', false);
            $("#txtInvoiceSuffix").prop('disabled', false);
        }
        else {
            $("#txtInvoicePrefix").prop('disabled', true);
            $("#txtInvoiceSNo").prop('disabled', true);
            $("#txtInvoiceSuffix").prop('disabled', true);
        }
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
    SetDatePicker('txtStartdate');
    SetDatePicker('txtDueDate');



    SetNumberBox('txtCompletePercent', 2, false, '');
    SetNumberBox('txtBudgetedHours', 2, false, '');
    SetAmountBox('txtContractAmt', 2, false, '');
    SetAmountBox('txtExpAmt', 2, false, '');
    SetAmountBox('txtServiceAmt', 2, false, '');
    SetAmountBox('txtExpenseTax', 2, false, '');
    SetNumberBox('txtInvoiceSNo', 0, false, '');



    FunSetTabKey();
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
      
    LoadEntity = 8;
   
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, 'Active');
    FunGetClientForAutoComplete(FunClientCallBack, 0, '');
    FunFillCurrency(FunFillCurrencyCallBack);
    FunFillContractType(FunFillContractTypeCallBack);
    FunFillBillingFrequency(FunFillBillingFrequencyCallBack);
    FunFillTaxMaster(FunFillTaxMasterCallBack);
    FunFillPaymentTerm(FunFillPaymentTermCallBack);
    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);
   
  
    
}
function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}



function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}
function FunFillTaxMasterCallBack(str) {
    $('#dropFKTaxID').append(str);
    PageLoadComplete();
}
function FunFillPaymentTermCallBack(str) {
    $('#dropFKTermID').append(str);
    PageLoadComplete();
}
function FunFillBillingFrequencyCallBack(str) {
    $('#dropFKBillingFrequency').append(str);
    PageLoadComplete();
}
function FunFillContractTypeCallBack(str) {
    $('#dropFKContractTypeSrch').append(str);
    $('#dropFKContractTypeID').append(str);
    PageLoadComplete();
}
function FunFillCurrencyCallBack(str) {
    $('#dropFKCurrencyID').append(str);
    PageLoadComplete();
}
function FunEmpCallBack(JsonArr) {
    $("#txtFKManagerID").GenexAutoComplete(JsonArr, "EmpID,Name,Status"); 
    PageLoadComplete();
}
function FunClientCallBack(JsonArr) {
    $("#txtFKClientIDSrch").GenexAutoComplete(JsonArr, "ClientID,Name,Status");
    $("#txtFKClientID").GenexAutoCompleteWithCallBack(JsonArr, FunSetClientCallBack,0, "ClientID,Name,Status");
    PageLoadComplete();
}


$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});