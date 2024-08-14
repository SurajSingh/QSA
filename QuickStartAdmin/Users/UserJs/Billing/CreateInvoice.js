
var pagename = "/Users/CreateInvoice.aspx";
var PKID = 0;
var DRowNo = 0;
var FKPCurrencyID = 0;
var PCurrencyName = '$';
var TaxPercentage = 0;

var TotalSubAmt = 0;
var TotalTaxAmt = 0;
var TotalAmount = 0;
var TotalDiscount = 0;
var NetAmount = 0;
var Received = 0;
var NetDueAmt = 0;
var ClientRetainer = 0;
var stepsWizard = null;
var PrintPKID = 0;
var invoicedExpenseItems = [];
var invoiceTimesheetItem = [];
var budgetHours = 0;
var totalHours = 0
var contractType = '';


function AddNewDetailRow() {


    var trID = "";
    DRowNo = DRowNo + 1;
    trID = "trDRow" + DRowNo;

    var NewRow = '<tr id="' + trID + '" >';

    NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';

    NewRow += '<td class="tdItemDesc"> <input type="text" id="txtItemDesc' + trID + '" class="form-control"   /></td>';
    NewRow += '<td class="tdRate"> <input type="text" id="txtRate' + trID + '" class="form-control"  style="text-align:right;"    /></td>';
    NewRow += '<td class="tdQty"> <input type="text" id="txtQty' + trID + '" class="form-control" style="text-align:right;"   /></td>';


    NewRow += '<td class="tdAmount"> <input type="text" id="txtAmount' + trID + '" class="form-control"  style="text-align:right;" readonly="readonly"  /></td>';

    NewRow += "</tr>";
    $("#tblDetail tbody").append(NewRow);



    $('#linkDelete' + trID).click(function () {
        var NewID = $(this).attr("id");
        NewID = NewID.replace("linkDelete", "");

        if (confirm("Delete this record?")) {
            $("#" + NewID).addClass("trdeleted");
            $('#linkDelete' + NewID).remove();
            FunSetTotal();
        }
    });




    SetNumberBox('txtRate' + trID, 2, false, '');
    SetNumberBox('txtQty' + trID, 2, false, '');


    $('#txtRate' + trID).change(function () {
        FunSetTotal();

        var temp = $(this).val();
        if (temp != "") {
            $(this).val(parseFloat(temp).toFixed(2));
        }
    });
    $('#txtQty' + trID).change(function () {
        FunSetTotal();

        var temp = $(this).val();
        if (temp != "") {
            $(this).val(parseFloat(temp).toFixed(2));
        }
    });


}



function FunSetTotal() {
    $("#txtServiceAmount").html('0.00')
    $("#txtExpenseAmount").html('0.00')
    TotalSubAmt = 0;
    TotalTaxAmt = 0;
    TotalAmount = 0;
    TotalDiscount = 0;
    NetAmount = 0;
    Received = 0;
    NetDueAmt = 0;
    totalHours = 0;

    var Qty = 0;
    var Rate = 0;
    var Amount = 0;
    var TaxRate = 0;
    var totalServiceAmnt = 0;
    var totalExpenseAmnt = 0;
    var TotalSubAmountAfterDisc = 0;

    $('#tblDetail tbody tr').each(function (row, tr) {
        var trID = $(tr).attr("id");

        if (!$(tr).hasClass("trdeleted")) {
            Qty = parseFloat($("#txtQty" + trID).ValZero());
            Rate = parseFloat($("#txtRate" + trID).ValZero());

            
            if ($("#tdName" + trID).val() == "Timesheet") {
                totalHours = totalHours + Qty;
                Amount = Qty * Rate;
                totalServiceAmnt = totalServiceAmnt + Amount;
                $("#txtAmount" + trID).val(Amount.toFixed(2));
                $('#txtServiceAmount').html(PCurrencyName + totalServiceAmnt.toFixed(2));
                
            }
            else if ($("#tdName" + trID).val() == "Expense") {
                var MURate = $("#tdMU" + trID).val()
                Amount = Qty * Rate;
                Amount = Amount + ((Amount * MURate) / 100);
                totalExpenseAmnt = totalExpenseAmnt + Amount
                $("#txtAmount" + trID).val(Amount.toFixed(2));
                $('#txtExpenseAmount').html(PCurrencyName + totalExpenseAmnt.toFixed(2));
                //$("#txtExpenseAmount").val(totalExpenseAmnt.toFixed(2))
            }
            else {
                Amount = Qty * Rate;
                $("#txtAmount" + trID).val(Amount.toFixed(2));
            }
            TotalSubAmt = TotalSubAmt + Amount;
            
        }

    });
    TotalDiscount = parseFloat($("#txtDiscount").ValZero());
    TaxRate = document.getElementById('txtTaxPer').innerHTML;
    TaxRateConvert = parseFloat(TaxRate).toFixed(2);
    //Added by Nilesh. Discount amount will get deduct from the total subamount, instead of total amount
    TotalSubAmountAfterDisc = TotalSubAmt - TotalDiscount;

    if (TaxPercentage == 'undefined' || TaxPercentage == '' || TaxPercentage == null) {
        TaxPercentage = TaxRateConvert;
    }
    
    if (TaxPercentage > 0 && TotalSubAmountAfterDisc > 0) {
        TotalTaxAmt = TotalSubAmountAfterDisc * TaxPercentage / 100;

    } 
    
    //TotalAmount = TotalSubAmt + TotalTaxAmt; 
    //if ($("#tdName" + trID).val() !== "Timesheet" || $("#tdName" + trID).val() !== "Expense") {
    TotalAmount = TotalSubAmountAfterDisc + TotalTaxAmt;
    //}
    //else {
    //    TotalAmount = totalServiceAmnt + TotalTaxAmt; //Added by Nilesh (Modified)        
    //}
    
    NetAmount = TotalAmount; // - TotalDiscount;
    if (ClientRetainer > 0 && NetAmount > 0) {
        if (NetAmount > ClientRetainer) {
            Received = ClientRetainer;
        }
        else {
            Received = NetAmount;
        }

    }
    NetDueAmt = NetAmount - Received;

    $("#FTotalSubAmt").html(PCurrencyName + TotalSubAmt.toFixed(2));//PCurrencyName +
    $("#FTotalAmtAfterDisc").html(PCurrencyName + TotalSubAmountAfterDisc.toFixed(2));//PCurrencyName +
    $("#txtSubTotalAfterDiscount").html(PCurrencyName + TotalSubAmountAfterDisc.toFixed(2));//PCurrencyName +
    $("#FTotalTax").html(PCurrencyName + TotalTaxAmt.toFixed(2));
    $("#txtDiscount").val( TotalDiscount.toFixed(2));
    $("#FNetAmt").html(PCurrencyName + NetAmount.toFixed(2));
    $("#FTotalDisc").html(PCurrencyName + TotalDiscount.toFixed(2));
    
    $("#FReceived").html(PCurrencyName + Received.toFixed(2));
    $("#FNetDueAmt").html(PCurrencyName + NetDueAmt.toFixed(2));


    $('#txtSubTotal').html(PCurrencyName + TotalSubAmt.toFixed(2));
    $('#txtTotalTax').html(PCurrencyName + TotalTaxAmt.toFixed(2));    
    $('#txtTotalDisc').html(PCurrencyName + TotalDiscount.toFixed(2));    
    $('#txtNetAmt').html(PCurrencyName + NetAmount.toFixed(2));    
    $('#txtReceived').html(PCurrencyName + Received.toFixed(2));    
    $('#txtNetDueAmt').html(PCurrencyName + NetDueAmt.toFixed(2));

    

}
function FunBlank(rectype, clearSummary) {
    clearSummary = clearSummary ?? false;
    if (rectype != 'P') {

        PKID = 0;
        $('#txtFKProjectID').GenexAutoCompleteBlank();

    }

    FKPCurrencyID = FKCurrencyID;
    PCurrencyName = CurrencyName;
    $("#txtFKProjectID").prop('disabled', false);

    $('#tblTimeSheet tbody').empty();
    $('#tblExpenseLog tbody').empty();
    $('#tblDetail tbody').empty();
    $("#ulProjectTime").find('span').html('-');
    $("#ulProjectContract").find('span').html('-');
    $("#ulLastInv").find('span').html('-');
    $('#projectname').html('');
    

    if (!clearSummary) {
        $('#txtInvDate').val('');
        $('#txtInFromvDate').val(''); // Added By nilesh
        $('#txtInvEndDate').val(''); // Added by Nilesh
    }
   

    $('#txtPrefix').val('');
    $('#txtSNo').val('');
    $('#txtSuffix').val('');

    $('#txtCPerson').val('');
    $('#txtCPersonTitle').val('');
    $('#txtAddress1').val('');
    $('#txtAddress2').val('');
    $('#dropFKCountryID').val('0');
    $('#dropFKStateID').val('0');
    $('#dropFKCityID').val('0');
    $('#dropFKTahsilID').val('0');
    $('#txtZIP').val('');

    tinymce.get("txtMemo").setContent('');
    $('#linkMemo').find('span').html('Add Memo');
    $('.summary').find('ul').find('span').html('0');


    TotalSubAmt = 0;
    TotalTaxAmt = 0;
    TotalAmount = 0;
    TotalDiscount = 0;
    NetAmount = 0;
    Received = 0;
    NetDueAmt = 0;
    ClientRetainer = 0;

    $("#txtServiceAmount").html('0.00')
    $("#txtExpenseAmount").html('0.00')
    $("#FTotalSubAmt").html('0.00');//PCurrencyName +
    $("#FTotalAmtAfterDisc").html('0.00');//PCurrencyName +
    $("#txtSubTotalAfterDiscount").html('0.00');
    $("#FTotalTax").html('0.00');
    $("#FNetAmt").html('0.00');
    $("#FReceived").html('0.00');
    $("#FNetDueAmt").html('0.00');
    $("#FTotalDisc").html('0.00');
    $('#txtSubTotal').html('0.00');
    $('#txtTotalTax').html('0.00');
    $('#txtTotalDisc').html('0.00');
    $('#txtNetAmt').html('0.00');
    $('#txtReceived').html('0.00');
    $('#txtNetDueAmt').html('0.00');

    $('#dropFKTaxID').val('0');
    //$('#txtTaxPer').val('0.00');
    $('#txtTaxPer').html('0.00')
    $('#txtDiscount').val('0.00');
    $('#txtClientRetainer').html('0.00');

    $("#txtTaxPer").prop('disabled', true);

    $("#tabsinvoice").steps("setStep", 0);




}

function FunValidate(StepNo) {
    var isTaskSelected = '';
    var isExpenseSelected = '';

        var fail = false;
        var fail_log = "<li>Please fill required fields marked as *</li>";
        var strError = "";

        if (StepNo == -1 || StepNo == 0) {
            if ($("#txtFKProjectID").GenexAutoCompleteGet('0') == "0") {
                fail = true;
                $("#txtFKProjectID").css("border-color", ColorE);
                strError += "<li>Select Project</li>";
            }
            else {
                $("#txtFKProjectID").css("border-color", ColorN);
            }
            if ($("#txtInvDate").val() == "") {
                fail = true;
                $("#txtInvDate").css("border-color", ColorE);
                strError += "<li>Enter Date</li>";
            }
            else {
                $("#txtInvDate").css("border-color", ColorN);
            }

            if ($('#chkDateRange').is(':checked') == true) {
                //$('#invoiceDateRange').show();
                InvFromDate = $("#txtInvFromDate").val();
                InvToDate = $("#txtInvEndDate").val();

                if (InvFromDate == "" && InvToDate == "") {
                    fail = true;
                    $("#txtInvFromDate").css("border-color", ColorE);
                    $("#txtInvEndDate").css("border-color", ColorE);
                    strError += "<li>Enter Invoice From and To Date</li>";
                }
                else {
                    $("#txtInvFromDate").css("border-color", ColorN);
                    $("#txtInvEndDate").css("border-color", ColorN);
                }

            }
        }

        if (StepNo == -1 || StepNo == 1) {

            if ($("#txtCPerson").val() == "") {
                fail = true;
                $("#txtCPerson").css("border-color", ColorE);
                strError += "<li>Enter Contact Person</li>";
            }
            else {
                $("#txtCPerson").css("border-color", ColorN);
            }
            if ($("#txtAddress1").val() == "") {
                fail = true;
                $("#txtAddress1").css("border-color", ColorE);
                strError += "<li>Enter Address</li>";
            }
            else {
                $("#txtAddress1").css("border-color", ColorN);
            }

        }
        if (StepNo == -1) {
            var InvoiceItemCount = 0;
            $('#tblDetail tbody tr').each(function (row, tr) {
                var str = '';
                var trID = $(tr).attr("id");



                if (!$(tr).hasClass("trdeleted")) {
                    InvoiceItemCount = InvoiceItemCount + 1;


                }

            });

             isTaskSelected = FunStoreSelectedTask();
             isExpenseSelected = FunStoreSelectedExpense();

            if (InvoiceItemCount == 0 && isTaskSelected == '' && isExpenseSelected == '') {
                fail = true;
                //OpenAlert('Add Invoice Items');
                OpenAlert('Add atleast one unbilled item');
            }

            //below function written to validate the contract amount should not exceed
            var errStr = funContractTypeValidation();
            if (errStr !== "") {   
                fail = true;
                OpenAlert(errStr);                
            }


        }
        var ItemCount = 0;
        if (!fail) {
            $("#divValidateSummary").hide();
            return true;           

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

function FunValidateApproval() {
    
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

    return !fail;
}

function FunStoreItemData() {
    var TableData = new Array();
    var i = 0;
    $('#tblDetail tbody tr').each(function (row, tr) {
        var trid = $(tr).attr("id");


        var ModeForm = 0;
        if ($(tr).hasClass("trdeleted")) {
            ModeForm = 2;
        }
        TableData[i] = {
            "PKID": $("#hidPKID" + trid).ValZero()
            , "ItemType": $("#tdName" + trid).val()
            , "ItemPKID": parseInt(trid)
            , "ItemDesc": $("#txtItemDesc" + trid).val()
            , "Rate": parseFloat($("#txtRate" + trid).ValZero()).toFixed(2)
            , "Qty": parseFloat($("#txtQty" + trid).ValZero()).toFixed(2)
            , "Amount": parseFloat($("#txtAmount" + trid).ValZero()).toFixed(2)
            , "ModeForm": ModeForm
        };

        i++;

    });



    return TableData;
}
function FunStoreSelectedTask() {
    var str = '';
    
    invoiceTimesheetItem.forEach(function (e) {
        str = str + "," + e.toString();
    });
    //$('#tblTimeSheet tbody tr').each(function (row, tr) {
    //    var trid = $(tr).attr("id");
    //    trid = trid.replace('trTimeSheet', '');


    //    if ($('#chkSelect' + trid).is(":checked")) {
    //        if (str != '') {
    //            str = str + ',';
    //        }
    //        str = str + $('#chkSelect' + trid).val();
    //    }


    //});
    return (str.length > 0) ? str.substring(1) : "";

}

//Added by Nilesh to add Unbilled Expense - Start
function FunStoreSelectedExpense() {
    var str = '';
    

    invoicedExpenseItems.forEach(function (e) {
        str = str + "," + e.toString();
    });

    //$('#tblExpenseLog tbody tr').each(function (row, tr) {
    //    var trid = $(tr).attr("id");
    //    trid = trid.replace('trExpenseLog', '');


    //    if ($('#chkSelectExpense' + trid).is(":checked")) {
    //        if (str != '') {
    //            str = str + ',';
    //        }
    //        str = str + $('#chkSelectExpense' + trid).val();
    //    }


    //});
    return (str.length>0)?str.substring(1):"";

}

//Added by Nilesh to add Unbilled Expense - End

function funContractTypeValidation() {
    //Adde by nilesh to check the contract type here- start
    //contractType = document.getElementById('spancontracttype').innerHTML;
    var contractAmount = document.getElementById('spancontractamt').innerHTML;
    var actualContractAmt = contractAmount.replace(PCurrencyName, "");

    var availableBalAmount = document.getElementById('spanavailamt').innerHTML;
    var actualavailableBalAmt = availableBalAmount.replace(PCurrencyName, "");

    var actualsubTotalAmt = document.getElementById('txtSubTotal').innerHTML;
    var subTotalAmt = actualsubTotalAmt.replace(PCurrencyName, "");

    var actualsubTotalAmtAfterDisc = document.getElementById('txtSubTotalAfterDiscount').innerHTML;
    var subTotalAmtAfterDisc = actualsubTotalAmtAfterDisc.replace(PCurrencyName, "");

    var actualTotalNetAmt = document.getElementById('txtNetAmt').innerHTML;
    var totalAmt = actualTotalNetAmt.replace(PCurrencyName, ""); 

    //var budgetedhour = document.getElementById('spanbudgetedhours').innerHTML;
    //var billedHours = document.getElementById('spanbudgetedhours').innerHTML;
    var availabledHours = document.getElementById('spanavailablehours').innerHTML; 

    var actualRecurringAmt = document.getElementById('spanrecurringamt').innerHTML;
    var RecurringAmt = actualRecurringAmt.replace(PCurrencyName, ""); 

    var skippedCycle = document.getElementById('spanskippedcycle').innerHTML;

    var actualRecurringAmountLimit = document.getElementById('spanreclimit').innerHTML;
    var RecurringAmountLimit = actualRecurringAmountLimit.replace(PCurrencyName, ""); 


    
    

    switch (contractType) { 
        case "Fixed":
            if (parseFloat(subTotalAmtAfterDisc) > parseFloat(actualavailableBalAmt)) {
                return "Contract Amount is exceeding, please check the details !";
            }
            break;
        case "Hourly Not To Exceed":
            //if (parseFloat(subTotalAmt) > parseFloat(actualavailableBalAmt)) 
            if (parseFloat(totalHours) > parseFloat(availabledHours)) {
                return "Budgeted hours are exceeding, please check the details !";
            }
            break;
        case "Hourly":
            //if (parseFloat(totalHours) > parseFloat(availabledHours) & parseFloat(totalHours) != 0) {
            //    return "Budgeted hours are exceeding, please check the details !";
            //}
            break;
        case "Recurring": 
                if (parseFloat(subTotalAmtAfterDisc) > parseFloat(RecurringAmt)) {
                    return "Recurring Amount is exceeding, please check the details !";
                }
            break;
         case "Percentage":
            if (parseFloat(subTotalAmtAfterDisc) > parseFloat(actualavailableBalAmt)) {
                return "Contract Amount is exceeding, please check the details !";
            }
            break;
        case "Recurring With Cap":
            if (skippedCycle > 0) {
                if (parseFloat(subTotalAmtAfterDisc) > parseFloat(RecurringAmountLimit)) {
                    return "Recurring Amount is exceeding, please check the details !";
                }
            }
            else {
                if (parseFloat(subTotalAmtAfterDisc) > parseFloat(RecurringAmt)) {
                    return "Recurring Amount is exceeding, please check the details !";
                }
            }
            break

    }
    return "";


    
}


function FunSave() {
    ProgCount = 0;
    ShowLoader();   

    var StrItemList = "";
    StrItemList = FunStoreItemData();
    StrItemList = JSON.stringify(StrItemList);
    var StrSeletedTask = FunStoreSelectedTask();
    var StrSelectedExpense = FunStoreSelectedExpense(); // Added By Nilesh To add unbilled Expense
    FunSetTotal();
    var myContent = tinymce.get("txtMemo").getContent();

    var InvFromDate = $("#txtInvFromDate").val();
    var InvToDate = $("#txtInvEndDate").val();

    //Added By Nilesh for Approval Feature - 21_12_23 - Start
    var FKManagerID = 0;
    var SubmitType = 'CM';

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
    //else if ($('#chkYourManager').is(':checked')) {
    //    SubmitType = 'M';
    //}
    //Added By Nilesh for Approval Feature - 21_12_23 - End
    
    var args = {};
    if (InvFromDate != undefined && InvToDate != undefined) {
        args = {
            PKID: PKID, InvDate: $('#txtInvDate').val(), InvFromDate: InvFromDate, InvToDate: InvToDate, FKProjectID: $('#txtFKProjectID').GenexAutoCompleteGet('0'), SNo: $('#txtSNo').ValZero(),
            Prefix: $('#txtPrefix').val(), Suffix: $('#txtSuffix').val(),
            CPerson: $('#txtCPerson').val(), CPersonTitle: $('#txtCPersonTitle').val(), Address1: $('#txtAddress1').val(), Address2: $('#txtAddress2').val(),
            FKTahsilID: $('#dropFKTahsilID').ValZero(), FKCityID: $('#dropFKCityID').ValZero(), FKStateID: $('#dropFKStateID').ValZero(), FKCountryID: $('#dropFKCountryID').ValZero(),
            ZIP: $('#txtZIP').val(), SubAmt: TotalSubAmt, FKTaxID: $('#dropFKTaxID').ValZero(), TaxPer: document.getElementById('txtTaxPer').innerHTML,
            TaxAmt: TotalTaxAmt, Amount: TotalAmount, Discount: TotalDiscount, NetAmount: NetAmount, Retainage: Received, Remarks: myContent, FKCurrencyID: FKPCurrencyID, StrTimeEntries: StrSeletedTask, StrExpenseEntries: StrSelectedExpense, dtItemStr: StrItemList,
            IsDeleted: 0, IsArchieved: 0, FKManagerID: FKManagerID, SubmitType: SubmitType, ApproveAction: 'Submit', ApproveRemark: ''
        };
    }
    else {
        args = {
            PKID: PKID, InvDate: $('#txtInvDate').val(), InvFromDate: '', InvToDate: InvToDate, FKProjectID: $('#txtFKProjectID').GenexAutoCompleteGet('0'), SNo: $('#txtSNo').ValZero(),
            Prefix: $('#txtPrefix').val(), Suffix: $('#txtSuffix').val(),
            CPerson: $('#txtCPerson').val(), CPersonTitle: $('#txtCPersonTitle').val(), Address1: $('#txtAddress1').val(), Address2: $('#txtAddress2').val(),
            FKTahsilID: $('#dropFKTahsilID').ValZero(), FKCityID: $('#dropFKCityID').ValZero(), FKStateID: $('#dropFKStateID').ValZero(), FKCountryID: $('#dropFKCountryID').ValZero(),
            ZIP: $('#txtZIP').val(), SubAmt: TotalSubAmt, FKTaxID: $('#dropFKTaxID').ValZero(), TaxPer: document.getElementById('txtTaxPer').innerHTML,
            TaxAmt: TotalTaxAmt, Amount: TotalAmount, Discount: TotalDiscount, NetAmount: NetAmount, Retainage: Received, Remarks: myContent, FKCurrencyID: FKPCurrencyID, StrTimeEntries: StrSeletedTask, StrExpenseEntries: StrSelectedExpense, dtItemStr: StrItemList,
            IsDeleted: 0, IsArchieved: 0, FKManagerID: FKManagerID, SubmitType: SubmitType, ApproveAction: 'Submit', ApproveRemark: ''
        };
    }

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
                        FunBlank();
                        PrintPKID = jsonarr[0].PKID;
                        closediv("divAddNew");
                        opendiv('divSuccessMsg');
                        invoiceTimesheetItem = [];
                        invoicedExpenseItems = [];

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

    ShowLoader();
    var args = {
        PKID: PKID
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
            HideLoader();
            if (data.d != "failure" && data.d != "Invalid Request") {
                var jsonarr = $.parseJSON(data.d);
                FunBlank();
                if (jsonarr.data != null && jsonarr.data.Table.length > 0) {
                    PKID = jsonarr.data.Table[0].PKID;
                    $('#txtFKProjectID').GenexAutoCompleteGet();

                    $("#txtFKProjectID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKProjectID, jsonarr.data.Table[0].ProjectCode);
                    $("#txtFKProjectID").prop('disabled',true);


                    FKPCurrencyID = jsonarr.data.Table[0].FKCurrencyID;
                    PCurrencyName = jsonarr.data.Table[0].Symbol;
                    FunFillProjectDetail(jsonarr.data.Table[0].FKProjectID, '', jsonarr.data.Table[0].InvDate );


                    $('#txtInvDate').val(jsonarr.data.Table[0].InvDate);
                    $('#txtPrefix').val(jsonarr.data.Table[0].Prefix);
                    $('#txtSNo').val(jsonarr.data.Table[0].SNo);
                    $('#txtSuffix').val(jsonarr.data.Table[0].Suffix); 
                    TaxPercentage = jsonarr.data.Table[0].TaxPer;
                    $('#txtTaxPer').html(jsonarr.data.Table[0].TaxPer);
                    $('#txtTotalTax').html(jsonarr.data.Table[0].TaxAmt);
                    $('#dropFKTaxID').val(jsonarr.data.Table[0].FKTaxID);
                    $('#txtDiscount').val(jsonarr.data.Table[0].Discount);

                    if ($("#dropFKTaxID").ValZero() != '0') {
                       
                        $("#txtTaxPer").prop('disabled', false);
                    }
                    else {
                        $("#txtTaxPer").prop('disabled', true);
                    }

                    $("#txtCPerson").val(jsonarr.data.Table[0].CPerson);
                    $("#txtCPersonTitle").val(jsonarr.data.Table[0].CPersonTitle);
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
                    tinymce.get("txtMemo").setContent(jsonarr.data.Table[0].Remarks);

                    ClientRetainer = ClientRetainer + jsonarr.data.Table[0].Retainage;


                    $.each(jsonarr.data.Table1, function () {
                        AddNewDetailRow();
                        var trID = "";
                        trID = "trDRow" + DRowNo;
                        if (this.ItemType == 'Timesheet') {
                            invoiceTimesheetItem.push(this.ItemPKID);
                        }
                        else if (this.ItemType == 'Expense') {
                            invoicedExpenseItems.push(this.ItemPKID);
                        }
                        
                        $("#hidPKID" + trID).val(this.PKID);
                      
                        $("#txtItemDesc" + trID).val(this.ItemDesc);
                        document.getElementById('txtItemDesc' + trID).setAttribute('readonly', 'readonly');
                        $("#txtRate" + trID).val(this.Rate.toFixed(2));
                        document.getElementById('txtRate' + trID).setAttribute('readonly', 'readonly');
                        $("#txtQty" + trID).val(this.Qty.toFixed(2));
                        document.getElementById('txtQty' + trID).setAttribute('readonly', 'readonly');
                        $("#txtAmount" + trID).val(this.Amount.toFixed(2));

                    });

                    FunSetTotal();

                }
                if (jsonarr.data.Table6.length > 0) {
                    $('#txtServiceAmount').html(PCurrencyName + jsonarr.data.Table6[0].taskAmount.toFixed(2));
                }
                if (jsonarr.data.Table7.length > 0) {
                    $('#txtExpenseAmount').html(PCurrencyName + jsonarr.data.Table7[0].expenseAmount.toFixed(2));
                }
                else {
                    OpenAlert(jsonarr[0].Msg);
                }


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



function FunSetProjectDetail(item, inputid) {
    FunBlank('P',true);
    var FKProjectID = $("#" + inputid).GenexAutoCompleteGet(0);
    var chkInvoiceDateAll = ""
    var InvFromDate = '';
    var InvToDate = '';
    
    var strError = "";    

    if ($('#chkAllInvoices').is(':checked') == true) {
        $('#invoiceDateRange').hide();
        if ($("#txtInvDate").val() != '') {
             InvFromDate = $("#txtInvFromDate").val();
             InvToDate = $("#txtInvDate").val();
            FunFillProjectDetail(FKProjectID, '', InvToDate);
        }
        //else {
        //    OpenAlert("Please Select the Invoice Date !")
        //}

        
    }

    if ($('#chkDateRange').is(':checked') == true) {
        $('#invoiceDateRange').show();

        InvFromDate = $("#txtInvFromDate").val();
        InvToDate = $("#txtInvEndDate").val();

        if (FKProjectID != 0 && InvFromDate != '' && InvToDate != '') {

            if (InvFromDate > InvToDate) {
                OpenAlert('Billing from Date Should not be greater than Billing To Date');
                $('#txtInvEndDate').val('');
            }

            FunFillProjectDetail(FKProjectID, InvFromDate, InvToDate);

        }
    }
    
}
function FunFillProjectDetail(FKProjectID, InvFromDate, InvToDate) {
    if (FKProjectID != '' && InvToDate != '') {
        var args = {};

        if (InvFromDate != undefined && InvToDate != undefined) {
            args = {
                PKID: PKID, FKProjectID: FKProjectID, InvFromDate: InvFromDate, InvToDate: InvToDate
            };
        }
        else {
            args = {
                PKID: PKID, FKProjectID: FKProjectID, InvFromDate: '', InvToDate: InvToDate
            };
        }



        ShowLoader();
        $.ajax({
            type: "POST",
            url: pagename + "/GetProjectDetail",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            cache: false,
            success: function (data) {
                if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                    var ContractAmt = 0;
                    var AvailableAmt = 0;
                    var jsonarr = $.parseJSON(data.d);
                    HideLoader();

                    if (jsonarr.data.Table1.length > 0) {
                        if (jsonarr.data.Table1[0].FKCurrencyID != 0) {
                            FKPCurrencyID = jsonarr.data.Table1[0].FKCurrencyID;
                            PCurrencyName = jsonarr.data.Table1[0].Symbol;
                            $('#dropFKTaxID').val(jsonarr.data.Table1[0].FKTaxID);
                            TaxPercentage = jsonarr.data.Table1[0].TaxPer
                            $('#txtTaxPer').html(jsonarr.data.Table1[0].TaxPer);
                            //'#txtTaxPer').val(jsonarr.data.Table1[0].GRT);
                            $('#spandiscCurrency').html(PCurrencyName);

                        }

                    }

                    if (jsonarr.data.Table.length > 0) {
                        $("#projectname").html(jsonarr.data.Table[0].ProjectName);
                        $("#txtCPerson").val(jsonarr.data.Table[0].CPerson);
                        $("#txtCPersonTitle").val(jsonarr.data.Table[0].CPersonTitle);

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


                        $('#spanclientname').html(jsonarr.data.Table[0].Company);
                        $('#spanprojectname').html(jsonarr.data.Table[0].ProjectName);
                        contractType = jsonarr.data.Table[0].ContractType
                        $('#spancontracttype').html(contractType);

                        budgetHours = jsonarr.data.Table[0].BudgetedHours;

                        $('#spanbudgetedhours').html(budgetHours);
                        //$('#spanbudgetedhours').html(spanavailablehours);


                        if (contractType == "Hourly") {
                            document.getElementById('liAvailableAmt').style.display = 'none';
                            document.getElementById('liContractAmt').style.display = 'none';
                        }

                        if (contractType == "Hourly Not To Exceed") {
                            document.getElementById("liBilledHours").style.display = 'block';
                            document.getElementById("liAvailableHours").style.display = 'block';
                        }
                        else {
                            document.getElementById("liBilledHours").style.display = 'none';
                            document.getElementById("liAvailableHours").style.display = 'none';
                        }

                        if (contractType == "Hourly Not To Exceed" || contractType == "Hourly") {
                            document.getElementById("liBudgetedHour").style.display = 'block';
                            //document.getElementById("btnAddUnbilledTask").style.display = 'block';
                            //document.getElementById("btnAddUnbilledExpenses").style.display = 'block';
                            document.getElementById("btnAddNew").style.display = 'none';
                        }
                        else {
                            document.getElementById("liBudgetedHour").style.display = 'none';
                            //document.getElementById("btnAddUnbilledTask").style.display = 'none';
                            //document.getElementById("btnAddUnbilledExpenses").style.display = 'none';
                            document.getElementById("btnAddNew").style.display = 'block';
                        }

                        ContractAmt = jsonarr.data.Table[0].ContractAmt.toFixed(2);
                        $('#spancontractamt').html(PCurrencyName + ContractAmt);
                        $('#spanserviceamt1').html(PCurrencyName + jsonarr.data.Table[0].ServiceAmt.toFixed(2));
                        $('#spanexpamt1').html(PCurrencyName + jsonarr.data.Table[0].ExpAmt.toFixed(2));
                        if (jsonarr.data.Table[0].BillPerCycle != 'undefined' || jsonarr.data.Table[0].BillPerCycle != '' || jsonarr.data.Table[0].BillPerCycle != null) { }
                        

                        if (contractType == "Recurring With Cap") {
                            $('#spanrecurringamt').html(PCurrencyName + jsonarr.data.Table[0].BillPerCycle.toFixed(2));
                            document.getElementById("liRecurringAmt").style.display = 'block';
                            document.getElementById("liSkippedCycle").style.display = 'block';
                            document.getElementById("liRecLimit").style.display = 'block';

                        }
                        else if (contractType == "Recurring") {
                            $('#spanrecurringamt').html(PCurrencyName + jsonarr.data.Table[0].BillPerCycle.toFixed(2));
                            document.getElementById("liRecurringAmt").style.display = 'block';
                        }
                        else {
                            document.getElementById("liRecurringAmt").style.display = 'none';
                            document.getElementById("liSkippedCycle").style.display = 'none';
                            document.getElementById("liRecLimit").style.display = 'none';
                        }

                        //Added new filed details : available contract amount and invoiced amount- start
                        //$('#spanexpamt1').html(PCurrencyName + jsonarr.data.Table[0].ExpAmt.toFixed(2));
                        //$('#spanexpamt1').html(PCurrencyName + jsonarr.data.Table[0].ExpAmt.toFixed(2));
                        //Added new filed details : available contract amount and invoiced amount- End                     
                        //$('#spanpercomplete').html(jsonarr.data.Table[0].CompletePercent + '%');
                        ClientRetainer = jsonarr.data.Table[0].Retainer;
                        $('#txtClientRetainer').val(PCurrencyName + ClientRetainer.toFixed(2));

                    }


                    if (jsonarr.data.Table2.length > 0) {
                        $('#spantime').html(jsonarr.data.Table2[0].TotalHrs.toFixed(2) + ' Hrs');
                        $('#spanserviceamt').html(PCurrencyName + jsonarr.data.Table2[0].TotalBillAmt.toFixed(2));

                    }
                    if (jsonarr.data.Table3.length > 0) {

                        $('#spanexpamt').html(PCurrencyName + jsonarr.data.Table3[0].TotalExpAmt.toFixed(2));

                    }
                    if (jsonarr.data.Table4.length > 0) {
                        var prebilledAmount = jsonarr.data.Table4[0].TotalBillAmt.toFixed(2);
                        $('#spanpreebilled').html(prebilledAmount);
                        $('#spaninvamt').html(PCurrencyName + jsonarr.data.Table4[0].TotalBillAmt.toFixed(2));
                        AvailableAmt = ContractAmt - jsonarr.data.Table4[0].TotalBillAmt.toFixed(2);

                        var projectCompletedInPerc = prebilledAmount / ContractAmt * 100;
                        $('#spanpercomplete').html(projectCompletedInPerc.toFixed(2) + '%');
                        if (contractType == 'Hourly' || contractType == "Recurring") {
                            document.getElementById("liProjectPercent").style.display = 'none';
                        } else {
                            document.getElementById("liProjectPercent").style.display = 'block';
                        }

                        $('#spanavailamt').html(PCurrencyName + AvailableAmt.toFixed(2));
                    }
                    if (jsonarr.data.Table5.length > 0) {
                        $('#spanDate').html(jsonarr.data.Table5[0].InvDate);
                        //$("#txtInvFromDate").val(jsonarr.data.Table5[0].InvDate);
                        $('#spanLastInvNo').html(jsonarr.data.Table5[0].InvoiceID);
                        $('#spanLastInvAmt').html(PCurrencyName + jsonarr.data.Table5[0].NetAmount.toFixed(2));
                    }
                    if (jsonarr.data.Table6.length > 0) {
                        $('#txtPrefix').val(jsonarr.data.Table6[0].InvoicePrefix);
                        $('#txtSNo').val(jsonarr.data.Table6[0].InvoiceSNo);
                        $('#txtSuffix').val(jsonarr.data.Table6[0].InvoiceSuffix);
                    }
                    if (jsonarr.data.Table7.length > 0) {
                        $.each(jsonarr.data.Table7, function () {

                            var str = '';
                            str = str + '<tr id="trTimeSheet' + this.PKID + '">';
                            str += '<td class="tdApprove" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkSelect' + this.PKID + '" value="' + this.PKID + '"  /></td>';
                            str = str + '<td data-attrname = "LoginId">' + this.LoginID + '</td>';
                            str = str + '<td data-attrname = "TaskDate">' + this.TaskDate + '</td>';
                            str = str + '<td data-attrname = "TaskName">' + this.TaskName + '</td>';
                            str = str + '<td style="text-align:right;" data-attrname = "Hrs">' + this.Hrs.toFixed(2) + '</td>';
                            str = str + '<td data-attrname = "Description">' + this.Description + '</td>';
                            str = str + '<td style="text-align:right;" data-attrname = "TBillRate">' + this.TBillRate.toFixed(2) + '</td>';
                            var amt = this.TBillRate * this.Hrs;
                            str = str + '<td style="text-align:right;" data-attrname = "amt">' + amt.toFixed(2) + '</td>';
                            str += '</tr>';

                            $('#tblTimeSheet tbody').append(str);

                            if (this.IsBilled == true || this.IsBillable == true) {
                                if (this.FKInvoiceID == PKID) {
                                    $("#chkSelect" + this.PKID).prop('checked', true);
                                }
                            }


                        });

                    }
                    if (jsonarr.data.Table8.length > 0) {

                        $.each(jsonarr.data.Table8, function () {
                            var str = '';
                            str = str + '<tr id="trExpenseLog' + this.PKID + '">';
                            str += '<td class="tdApprove" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkSelectExpense' + this.PKID + '" value="' + this.PKID + '"  /></td>';
                            str = str + '<td data-attrname = "LoginID">' + this.LoginID + '</td>';
                            str = str + '<td data-attrname = "TaskDate">' + this.TaskDate + '</td>';
                            str = str + '<td data-attrname = "TaskName">' + this.TaskName + '</td>';
                            str = str + '<td style="text-align:right;" data-attrname = "Unit">' + this.Unit + '</td>';
                            str = str + '<td data-attrname = "Description">' + this.Description + '</td>';
                            str = str + '<td style="text-align:right;" data-attrname = "TCostRate">' + this.TCostRate.toFixed(2) + '</td>';
                            str = str + '<td style="text-align:right;" data-attrname = "MU">' + this.MU + '</td>';
                            //var amt = this.TCostRate * this.Unit;
                            str = str + '<td style="text-align:right;" data-attrname = "Amount">' + this.Amount.toFixed(2) + '</td>';
                            str += '</tr>';

                            $('#tblExpenseLog tbody').append(str);

                            if (this.IsBilled == true || this.IsBillable == true) {
                                if (this.FKInvoiceID == PKID) {
                                    $("#chkSelectExpense" + this.PKID).prop('checked', true);
                                }
                            }


                        });

                    }
                    if (jsonarr.data.Table9.length > 0) {
                        var billedHours = jsonarr.data.Table9[0].billedHours.toFixed(2)
                        var availableHour = parseFloat(budgetHours) - parseFloat(billedHours);

                        $('#spanbilledhours').html(billedHours);
                        $('#spanavailablehours').html(parseFloat(availableHour).toFixed(2));
                    }
                    if (contractType == 'Recurring With Cap') {
                        if (jsonarr.data.SkippedRecCycle.length > 0) {
                            $('#spanskippedcycle').html(jsonarr.data.SkippedRecCycle[0].SkippedCycle);
                            $('#spanreclimit').html(PCurrencyName + jsonarr.data.SkippedRecCycle[0].InvoiceLimit.toFixed(2));
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

//Added By Nilesh
function FunFillAllUnbilledTask(FKProjectID, InvFromDate, InvToDate, chkIsChecked) {
    $('#tblTimeSheet tbody').empty();
    var args = {};

    args = {
        PKID: PKID, FKProjectID: FKProjectID, InvFromDate: InvFromDate, InvToDate: InvToDate, ChkIsChecked: chkIsChecked
    };



    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetAllUnbilledTask",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                
                if (jsonarr.data.Table.length > 0) {

                    $.each(jsonarr.data.Table, function () {
                        var str = '';
                        str = str + '<tr id="trTimeSheet' + this.PKID + '">';
                        str += '<td class="tdApprove" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkSelect' + this.PKID + '" value="' + this.PKID + '"  /></td>';
                        str = str + '<td data-attrname = "LoginId">' + this.LoginID + '</td>';
                        str = str + '<td data-attrname = "TaskDate">' + this.TaskDate + '</td>';
                        str = str + '<td data-attrname = "TaskName">' + this.TaskName + '</td>';
                        str = str + '<td style="text-align:right;" data-attrname = "Hrs">' + this.Hrs.toFixed(2) + '</td>';
                        str = str + '<td data-attrname = "Description">' + this.Description + '</td>';
                        str = str + '<td style="text-align:right;" data-attrname = "TBillRate">' + this.TBillRate.toFixed(2) + '</td>';
                        var amt = this.TBillRate * this.Hrs;
                        str = str + '<td style="text-align:right;" data-attrname = "amt">' + amt.toFixed(2) + '</td>';
                        str += '</tr>';

                        $('#tblTimeSheet tbody').append(str);

                        if (this.IsBilled == true || this.IsBillable == true) {
                            if (this.FKInvoiceID == PKID) {
                                $("#chkSelect" + this.PKID).prop('checked', true);
                            }
                        }


                    });

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

function FunFillAllUnbilledExpenses(FKProjectID, InvFromDate, InvToDate, chkIsChecked) {
    $('#tblExpenseLog tbody').empty();
    var args = {};

    args = {
        PKID: PKID, FKProjectID: FKProjectID, InvFromDate: InvFromDate, InvToDate: InvToDate, ChkIsChecked: chkIsChecked
    };



    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetAllUnbilledExpenses",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();

                if (jsonarr.data.Table.length > 0) {

                    $.each(jsonarr.data.Table, function () {
                        var str = '';
                        str = str + '<tr id="trExpenseLog' + this.PKID + '">';
                        str += '<td class="tdApprove" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chkSelectExpense' + this.PKID + '" value="' + this.PKID + '"  /></td>';
                        str = str + '<td data-attrname = "LoginID">' + this.LoginID + '</td>';
                        str = str + '<td data-attrname = "TaskDate">' + this.TaskDate + '</td>';
                        str = str + '<td data-attrname = "TaskName">' + this.TaskName + '</td>';
                        str = str + '<td style="text-align:right;" data-attrname = "Unit">' + this.Unit + '</td>';
                        str = str + '<td data-attrname = "Description">' + this.Description + '</td>';
                        str = str + '<td style="text-align:right;" data-attrname = "TCostRate">' + this.TCostRate.toFixed(2) + '</td>';
                        str = str + '<td style="text-align:right;" data-attrname = "MU">' + this.MU.toFixed(2) + '</td>';
                        //var amt = this.TCostRate * this.Unit;
                        str = str + '<td style="text-align:right;" data-attrname = "Amount">' + this.Amount.toFixed(2) + '</td>';
                        str += '</tr>';

                        $('#tblExpenseLog tbody').append(str);

                        if (this.IsBilled == true || this.IsBillable == true) {
                            if (this.FKInvoiceID == PKID) {
                                $("#chkSelectExpense" + this.PKID).prop('checked', true);
                            }
                        }


                    });

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
function FunProjectCallBack(JsonArr) {
    $('#txtFKProjectID').GenexAutoCompleteWithCallBack(JsonArr, FunSetProjectDetail, 0, "ProjectID,Project,ClientID");

    PageLoadComplete();
}

function FunEmpCallBack(JsonArr) {

    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });
    }
    $('#dropSubmitToSpecific').append('<option value="0">Select One</option>' + str);
}

function FunFillTaxMasterCallBack(str) {
    $('#dropFKTaxID').append(str);
    PageLoadComplete();
}

function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;  

    if ($('#chkAllInvoices').is(':checked') == true) {
        $('#invoiceDateRange').hide();

        //FunFillProjectDetail(FKProjectID, '', '');
    }

    if (LoadEntity == 0) {
        FunBlank('');

        PKID = parseInt($("#HidID").val());
        
        var currentDate = new Date();
       
        if (PKID != 0 ) {
            FunFillData();
        }


    }
}
function InitilizeEvents() {
    $("#btnSaveMemo").click(function () {
        var myContent = tinymce.get("txtMemo").getContent();
        if (myContent != '') {
            $('#linkMemo').find('span').html('Add Memo');
        }
        else {
            $('#linkMemo').find('span').html('Add Memo(1)');
        }
        closediv();
    });
    $("#linkMemo").click(function () {
        opendiv('divMemo');
    });

    $("#dropFKTaxID").change(function () {
        //'#txtTaxPer').val(''); // Commented By Nilesh
        if ($("#dropFKTaxID").ValZero() != '0') {
            var option = $('option:selected', this).attr('data-per');
            //$('#txtTaxPer').val(option);
            $('#txtTaxPer').html(option)
            $("#txtTaxPer").prop('disabled', false);
        }
        else {
            $("#txtTaxPer").prop('disabled', true);
        }
        FunSetTotal();
    });
    $("#txtTaxPer").change(function () {

        FunSetTotal();
    });
    $("#txtDiscount").change(function () {

        FunSetTotal();
    });

    $("#btnAddUnbilledTask").click(function () {
        //AddNewDetailRow();
        if (IsAdd == 1) {
            //FunBlank();
            opendiv("divUnbilledTask");
        }
    });
    $("#btnAddUnbilledExpenses").click(function () {
        //AddNewDetailRow();
        if (IsAdd == 1) {
            //FunBlank();
            opendiv("divUnbilledExpenses");
        }
    });

    $("#btnAddNew").click(function () {
        AddNewDetailRow();
        if (IsAdd == 1) {
            //FunBlank();
           
        }
    });

    

    $('#btnTask').click(function () {
        //var IsChecked = $('#chkSelect').is(':checked');
        $('#tblTimeSheet tbody tr').each(function (row, tr) {
            var trID = $(tr).attr("id");
            trID = trID.replace('trTimeSheet', '');

            //var IsChecked = $("#chkSelect" + trID).prop("checked", IsChecked);
            var IsChecked = $("#chkSelect" + trID).prop("checked");
            if (IsChecked == true && invoiceTimesheetItem.indexOf(trID) == -1) {
                invoiceTimesheetItem.push(trID);
                var NewRow = '<tr id="' + trID + '" >';
                NewRow += '<td class="tdName" hidden> <input type="hidden" id="tdName' + trID + '" class="form-control"  value= "Timesheet" hidden/></td>';
                NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '" data-Id="' + trID + '" data-type="ts" title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';

                if ($(tr).find("td[data-attrname='Description']").text() == '') {
                    NewRow += '<td class="tdItemDesc"> <input type="text" id="txtItemDesc' + trID + '" class="form-control" readonly="readonly"  value= "' + $(tr).find("td[data-attrname = 'TaskName']").text() + '"/></td>';
                } else {
                    NewRow += '<td class="tdItemDesc"> <input type="text" id="txtItemDesc' + trID + '" class="form-control" readonly="readonly"  value= "' + $(tr).find("td[data-attrname='Description']").text() + '"/></td>';
                }
                
                NewRow += '<td class="tdRate"> <input type="text" id="txtRate' + trID + '" class="form-control"  style="text-align:right;" readonly="readonly"   value="' + $(tr).find("td[data-attrname='TBillRate']").text() + '" /></td>';

                if (contractType == 'Hourly Not To Exceed') {
                    NewRow += '<td class="tdQty"> <input type="text" id="txtQty' + trID + '" class="form-control" style="text-align:right;" value="' + $(tr).find("td[data-attrname='Hrs']").text() + '" /></td>';
                }
                else {
                    NewRow += '<td class="tdQty"> <input type="text" id="txtQty' + trID + '" class="form-control" style="text-align:right;" readonly="readonly" value="' + $(tr).find("td[data-attrname='Hrs']").text() + '" /></td>';
                }
                


                NewRow += '<td class="tdAmount"> <input type="text" id="txtAmount' + trID + '" class="form-control"  style="text-align:right;" readonly="readonly" value="' + $(tr).find("td[data-attrname='amt']").text() + '" /></td>';

                NewRow += "</tr>";
                $("#tblDetail tbody").append(NewRow);

                FunSetTotal();


            }
            closediv();
            SetNumberBox('txtRate' + trID, 2, false, '');
            SetNumberBox('txtQty' + trID, 2, false, '');

            $('#txtRate' + trID).change(function () {
                FunSetTotal();

                var temp = $(this).val();
                if (temp != "") {
                    $(this).val(parseFloat(temp).toFixed(2));
                }
            });
            $('#txtQty' + trID).change(function () {
                FunSetTotal();

                var temp = $(this).val();
                if (temp != "") {
                    $(this).val(parseFloat(temp).toFixed(2));
                }
            });

            $('#linkDelete' + trID).click(function () {
                var ItemID = $(this).attr("id");
                ItemID = ItemID.replace("linkDelete", "");

                //var row = document.getElementById(ItemID);
                //row.parentElement.removeChild(row)

                if (confirm("Delete this record?")) {
                    $("#" + ItemID).addClass("trdeleted");
                    $('#linkDelete' + ItemID).remove();

                    var row = document.getElementById(ItemID);
                    row.parentElement.removeChild(row)
                                        
                    var ItemValue = invoiceTimesheetItem.indexOf(ItemID);
                    if (invoiceTimesheetItem.indexOf(ItemID) > -1) {
                        invoiceTimesheetItem.splice(ItemValue, 1);
                    }
                    FunSetTotal();
                }
            });

        });
    })

    $('#btnExpense').click(function () {
        // var IsChecked = $('#chkSelect').is(':checked');
        $('#tblExpenseLog tbody tr').each(function (row, tr) {
            var trID = $(tr).attr("id");
            trID = trID.replace('trExpenseLog', '');
            var IsChecked = $("#chkSelectExpense" + trID).prop("checked");
            if (IsChecked == true && invoicedExpenseItems.indexOf(trID) == -1) {
                invoicedExpenseItems.push(trID);

                var NewRow = '<tr id="' + trID + '" >';
                NewRow += '<td class="tdName" hidden> <input type="hidden" id="tdName' + trID + '" class="form-control"  value= "Expense" hidden/></td>';
                NewRow += '<td class="tdMU" hidden> <input type="hidden" id="tdMU' + trID + '" class="form-control"  value= "' + $(tr).find("td[data-attrname='MU']").text() + '" hidden/></td>';
                NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '" data-Id="' + trID + '" data-type="es" title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';

                if ($(tr).find("td[data-attrname='Description']").text() == '') {
                    NewRow += '<td class="tdItemDesc"> <input type="text" id="txtItemDesc' + trID + '" class="form-control" readonly="readonly"  value= "' + $(tr).find("td[data-attrname = 'TaskName']").text() + '"/></td>';
                } else {
                    NewRow += '<td class="tdItemDesc"> <input type="text" id="txtItemDesc' + trID + '" class="form-control" readonly="readonly"  value= "' + $(tr).find("td[data-attrname='Description']").text() + '"/></td>';
                }
                NewRow += '<td class="tdRate"> <input type="text" id="txtRate' + trID + '" class="form-control"  style="text-align:right;" readonly="readonly"  value="' + $(tr).find("td[data-attrname='TCostRate']").text() + '" /></td>';
                if (contractType == 'Hourly Not To Exceed') {
                    NewRow += '<td class="tdQty"> <input type="text" id="txtQty' + trID + '" class="form-control" style="text-align:right;" value="' + $(tr).find("td[data-attrname='Hrs']").text() + '" /></td>';
                }
                else {
                    NewRow += '<td class="tdQty"> <input type="text" id="txtQty' + trID + '" class="form-control" style="text-align:right;" readonly="readonly" value="' + $(tr).find("td[data-attrname='Hrs']").text() + '" /></td>';
                }


                NewRow += '<td class="tdAmount"> <input type="text" id="txtAmount' + trID + '" class="form-control"  style="text-align:right;" readonly="readonly" value="' + $(tr).find("td[data-attrname='Amount']").text() + '" /></td>';

                NewRow += "</tr>";
                $("#tblDetail tbody").append(NewRow);
                
                FunSetTotal();


            }
            closediv();

            SetNumberBox('txtRate' + trID, 2, false, '');
            SetNumberBox('txtQty' + trID, 2, false, '');

            $('#txtRate' + trID).change(function () {
                FunSetTotal();

                var temp = $(this).val();
                if (temp != "") {
                    $(this).val(parseFloat(temp).toFixed(2));
                }
            });
            $('#txtQty' + trID).change(function () {
                FunSetTotal();

                var temp = $(this).val();
                if (temp != "") {
                    $(this).val(parseFloat(temp).toFixed(2));
                }
            });

            $('#linkDelete' + trID).click(function () {
                var ItemID = $(this).attr("id");
                ItemID = ItemID.replace("linkDelete", "");

                if (confirm("Delete this record?")) {
                    $("#" + ItemID).addClass("trdeleted");
                    $('#linkDelete' + ItemID).remove();

                    var row = document.getElementById(ItemID);
                    row.parentElement.removeChild(row)

                    var ItemValue = invoicedExpenseItems.indexOf(ItemID);
                    if (invoicedExpenseItems.indexOf(ItemID) > -1) {
                        invoicedExpenseItems.splice(ItemValue, 1);
                    }
                    FunSetTotal();
                }
            });

        });
    })

    $("#btnsave").click(function () {
        FunValidate('Submit');
    });

    $("#btnClear").click(function () {
        FunBlank();
    });
    $("#chkAll").click(function () {
        var IsChecked = $('#chkAll').is(':checked');
        $('#tblTimeSheet tbody tr').each(function (row, tr) {
            var trID = $(tr).attr("id");
            trID = trID.replace('trTimeSheet', '');
            $("#chkSelect" + trID).prop("checked", IsChecked);
        });
    });

    //Added by Nilesh to show the Unbilled Expenses - Start
    $("#chkAllExpense").click(function () {
        var IsCheckedExpense = $('#chkAllExpense').is(':checked');
        $('#tblExpenseLog tbody tr').each(function (row, tr) {
            var trID = $(tr).attr("id");
            trID = trID.replace('trExpenseLog', '');
            $("#chkSelectExpense" + trID).prop("checked", IsCheckedExpense);
        });
    });

    

    //Added by Nilesh for approval feature - start
    $("#btnSubmit").click(function () {
        var IsValid = FunValidateApproval();
        if (IsValid) {
            FunSave();
        }
        else {
            OpenAlert("Error Occured");
        }
    });

    $("input[name='rbtnSubmitTo']").click(function () {
        $('#dropSubmitToSpecific').hide();

        if ($('#chkSpecific').is(':checked')) {
            $('#dropSubmitToSpecific').show();
        }
    });
    //Added by Nilesh for approval feature - End

    $('#txtInvDate').change(function () {
        if ($('#chkAllInvoices').is(':checked') == true) {
            FunSetProjectDetail(null, 'txtFKProjectID');
        } 
    })

    $('#txtInvFromDate').change(function () {
        FunSetProjectDetail(null, 'txtFKProjectID');
    })

    $('#txtInvEndDate').change(function () {
        FunSetProjectDetail(null, 'txtFKProjectID');
    })

    $("#chkAllInvoices").click(function () {
        var rdIsChecked = $('#chkAllInvoices').is(':checked');
        if (rdIsChecked == true) {
            FunSetProjectDetail(null, 'txtFKProjectID');
        }
    });

    $("#chkDateRange").click(function () {
        var rdIsChecked = $('#chkDateRange').is(':checked');
        if (rdIsChecked == true) {
            FunSetProjectDetail(null, 'txtFKProjectID');
        }
    });

    $("#btnPrintInvoice").click(function () {
        FunOpenHotLink("PrintInvoice.aspx", "PKID=" + PrintPKID, 1200, 800);
    });       

}

$.fn.steps.setStep = function (step) {
    var currentIndex = $(this).steps('getCurrentIndex');
    for (var i = 0; i < Math.abs(step - currentIndex); i++) {
        if (step > currentIndex) {
            $(this).steps('next');
        }
        else {
            $(this).steps('previous');
        }
    }
};
function PageLoadFun() {
    stepsWizard = $("#tabsinvoice").steps({
        headerTag: "h3",
        bodyTag: "section",
        transitionEffect: "slideLeft",
        autoFocus: true,
        onStepChanging: function (event, currentIndex, newIndex) {
            if (currentIndex < newIndex) {

                return FunValidate(currentIndex);
            }
            else {
                return true;
            }


        },        
        onFinished: function () {
            ///more code
            //FunValidate(2); //Step No 2 is added by NIlesh to call the sumbit to manager popup
            /*commented the below code, reason : approval of invoices flow feature.*/
            var IsValid = FunValidate(-1);
            if (IsValid) {
                opendiv("divSubmit");
                //FunSave();
            }
            else {
                return false;
            }


        }
    });

    InitilizeEvents();
    0 < $("#txtMemo").length && tinymce.init({
        selector: "textarea#txtMemo", height: 300,
        plugins: ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker", "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking", "save table contextmenu directionality emoticons template paste textcolor"], toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | l      ink image | print preview media fullpage | forecolor backcolor emoticons", style_formats: [{ title: "Bold text", inline: "b" }, { title: "Red text", inline: "span", styles: { color: "#ff0000" } }, { title: "Red header", block: "h1", styles: { color: "#ff0000" } }, { title: "Example 1", inline: "span", classes: "example1" }, { title: "Example 2", inline: "span", classes: "example2" }, { title: "Table styles" }, { title: "Table row 1", selector: "tr", classes: "tablerow1" }]
    });

    SetDatePicker("txtInvDate");
    SetDatePicker("txtInvEndDate"); 
    SetDatePicker("txtInvFromDate");
    

    SetAmountBox('txtTaxPer', 2, false, '');
    SetAmountBox('txtDiscount', 2, false, '');
    SetAmountBox('txtClientRetainer', 2, false, '');
    SetNumberBox('txtSNo', 0, false, '');

    LoadEntity = 2;
    
    setTimeout(function () {
        FunFillCountry("dropFKCountryID", "dropFKStateID", "dropFKCityID", "dropFKTahsilID");
        FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
        FunFillTaxMaster(FunFillTaxMasterCallBack);
        FunGetEmpForAutoComplate(FunEmpCallBack, 0, '');
    }, 1000);

    FunSetTabKey();



}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});