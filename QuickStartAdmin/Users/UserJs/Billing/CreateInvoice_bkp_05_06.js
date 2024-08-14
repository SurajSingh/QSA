
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
    TotalSubAmt = 0;
    TotalTaxAmt = 0;
    TotalAmount = 0;
    TotalDiscount = 0;
    NetAmount = 0;
    Received = 0;
    NetDueAmt = 0;

    var Qty = 0;
    var Rate = 0;
    var Amount = 0;
    var TaxRate = 0;
    $('#tblDetail tbody tr').each(function (row, tr) {
        var trID = $(tr).attr("id");

        if (!$(tr).hasClass("trdeleted")) {
            Qty = parseFloat($("#txtQty" + trID).ValZero());
            Rate = parseFloat($("#txtRate" + trID).ValZero());

            Amount = Qty * Rate;
            TotalSubAmt = TotalSubAmt + Amount;
            $("#txtAmount" + trID).val(Amount.toFixed(2));
        }

    });
    TotalDiscount = parseFloat($("#txtDiscount").ValZero());
    TaxRate = parseFloat($("#txtTaxPer").ValZero());

    if (TaxRate > 0 && TotalSubAmt > 0) {
        TotalTaxAmt = TotalSubAmt * TaxRate / 100;

    }
    TotalAmount = TotalSubAmt + TotalTaxAmt;
    NetAmount = TotalAmount - TotalDiscount;
    if (ClientRetainer > 0 && NetAmount > 0) {
        if (NetAmount > ClientRetainer) {
            Received = ClientRetainer;
        }
        else {
            Received = NetAmount;
        }

    }
    NetDueAmt = NetAmount - Received;

    $("#FTotalSubAmt").val(PCurrencyName + TotalSubAmt.toFixed(2));
    $("#FTotalTax").val(PCurrencyName + TotalTaxAmt.toFixed(2));
    $("#txtDiscount").val(PCurrencyName + TotalDiscount.toFixed(2));
    $("#FNetAmt").val(PCurrencyName + NetAmount.toFixed(2));
    $("#FReceived").val(PCurrencyName + Received.toFixed(2));
    $("#FNetDueAmt").val(PCurrencyName + NetDueAmt.toFixed(2));


    //$('#FTotalSubAmt').html(PCurrencyName + TotalSubAmt.toFixed(2));
    //$('#FTotalTax').html(PCurrencyName + TotalTaxAmt.toFixed(2));    
    //$('#FTotalDisc').html(PCurrencyName + TotalDiscount.toFixed(2));    
    //$('#FNetAmt').html(PCurrencyName + NetAmount.toFixed(2));    
    //$('#FReceived').html(PCurrencyName + Received.toFixed(2));    
    //$('#FNetDueAmt').html(PCurrencyName + NetDueAmt.toFixed(2));
    

}
function FunBlank(rectype) {
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
    $('#txtInvDate').val('');
    $('#txtInFromvDate').val(''); // Added By nilesh
    //$('#txtInvEndDate').val(''); // Added by Nilesh

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

    $('#dropFKTaxID').val('0');
    $('#txtTaxPer').val('0.00');
    $('#txtDiscount').val('0.00');
    $('#txtClientRetainer').val('0.00');

    $("#txtTaxPer").prop('disabled', true);

    $("#tabsinvoice").steps("setStep", 0);




}

function FunValidate(StepNo) {
    

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

                    //if ($("#txtItemDesc" + trID).val() == "") {
                    //    fail = true;
                    //    $("#txtItemDesc" + trID).css("border-color", ColorE);
                    //}
                    //else {
                    //    $("#txtItemDesc" + trID).css("border-color", ColorN);
                    //}
                    //if ($("#txtRate" + trID).ValZero() == "0") {
                    //    fail = true;
                    //    $("#txtRate" + trID).css("border-color", ColorE);

                    //}
                    //else {
                    //    $("#txtRate" + trID).css("border-color", ColorN);
                    //}

                    //if ($("#txtQty" + trID).ValZero() == "0") {
                    //    fail = true;
                    //    $("#txtQty" + trID).css("border-color", ColorE);

                    //}
                    //else {
                    //    $("#txtQty" + trID).css("border-color", ColorN);
                    //}

                }

            });

            var isTaskSelected = FunStoreSelectedTask();
            var isExpenseSelected = FunStoreSelectedExpense();

            if (InvoiceItemCount == 0 && isTaskSelected == '' && isExpenseSelected == '') {
                fail = true;
                //OpenAlert('Add Invoice Items');
                OpenAlert('Add atleast one unbilled item');
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
    $('#tblTimeSheet tbody tr').each(function (row, tr) {
        var trid = $(tr).attr("id");
        trid = trid.replace('trTimeSheet', '');


        if ($('#chkSelect' + trid).is(":checked")) {
            if (str != '') {
                str = str + ',';
            }
            str = str + $('#chkSelect' + trid).val();
        }


    });
    return str;

}

//Added by Nilesh to add Unbilled Expense - Start
function FunStoreSelectedExpense() {
    var str = '';
    $('#tblExpenseLog tbody tr').each(function (row, tr) {
        var trid = $(tr).attr("id");
        trid = trid.replace('trExpenseLog', '');


        if ($('#chkSelectExpense' + trid).is(":checked")) {
            if (str != '') {
                str = str + ',';
            }
            str = str + $('#chkSelectExpense' + trid).val();
        }


    });
    return str;

}

//Added by Nilesh to add Unbilled Expense - End
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
    else if ($('#chkYourManager').is(':checked')) {
        SubmitType = 'M';
    }
    //Added By Nilesh for Approval Feature - 21_12_23 - End

    var args = {};
    if (InvFromDate != undefined && InvToDate != undefined) {
        args = {
            PKID: PKID, InvDate: $('#txtInvDate').val(), InvFromDate: InvFromDate, InvToDate: InvToDate, FKProjectID: $('#txtFKProjectID').GenexAutoCompleteGet('0'), SNo: $('#txtSNo').ValZero(),
            Prefix: $('#txtPrefix').val(), Suffix: $('#txtSuffix').val(),
            CPerson: $('#txtCPerson').val(), CPersonTitle: $('#txtCPersonTitle').val(), Address1: $('#txtAddress1').val(), Address2: $('#txtAddress2').val(),
            FKTahsilID: $('#dropFKTahsilID').ValZero(), FKCityID: $('#dropFKCityID').ValZero(), FKStateID: $('#dropFKStateID').ValZero(), FKCountryID: $('#dropFKCountryID').ValZero(),
            ZIP: $('#txtZIP').val(), SubAmt: TotalSubAmt, FKTaxID: $('#dropFKTaxID').ValZero(), TaxPer: $('#txtTaxPer').ValZero(),
            TaxAmt: TotalTaxAmt, Amount: TotalAmount, Discount: TotalDiscount, NetAmount: NetAmount, Retainage: Received, Remarks: myContent, FKCurrencyID: FKPCurrencyID, StrTimeEntries: StrSeletedTask, StrExpenseEntries: StrSelectedExpense, dtItemStr: StrItemList,
            IsDeleted: 0, IsArchieved: 0, FKManagerID: FKManagerID, SubmitType: SubmitType, ApproveAction: 'Submit', ApproveRemark: ''
        };
    }
    else {
        args = {
            PKID: PKID, InvDate: $('#txtInvDate').val(), InvFromDate: '', InvToDate: '', FKProjectID: $('#txtFKProjectID').GenexAutoCompleteGet('0'), SNo: $('#txtSNo').ValZero(),
            Prefix: $('#txtPrefix').val(), Suffix: $('#txtSuffix').val(),
            CPerson: $('#txtCPerson').val(), CPersonTitle: $('#txtCPersonTitle').val(), Address1: $('#txtAddress1').val(), Address2: $('#txtAddress2').val(),
            FKTahsilID: $('#dropFKTahsilID').ValZero(), FKCityID: $('#dropFKCityID').ValZero(), FKStateID: $('#dropFKStateID').ValZero(), FKCountryID: $('#dropFKCountryID').ValZero(),
            ZIP: $('#txtZIP').val(), SubAmt: TotalSubAmt, FKTaxID: $('#dropFKTaxID').ValZero(), TaxPer: $('#txtTaxPer').ValZero(),
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
                    FunFillProjectDetail(jsonarr.data.Table[0].FKProjectID);


                    $('#txtInvDate').val(jsonarr.data.Table[0].InvDate);
                    $('#txtPrefix').val(jsonarr.data.Table[0].Prefix);
                    $('#txtSNo').val(jsonarr.data.Table[0].SNo);
                    $('#txtSuffix').val(jsonarr.data.Table[0].Suffix);                    
                    $('#txtTaxPer').val(jsonarr.data.Table[0].TaxPer);
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
                        
                        $("#hidPKID" + trID).val(this.PKID);
                      
                        $("#txtItemDesc" + trID).val(this.ItemDesc);
                        $("#txtRate" + trID).val(this.Rate.toFixed(2));
                        $("#txtQty" + trID).val(this.Qty.toFixed(2));
                        $("#txtAmount" + trID).val(this.Amount.toFixed(2));

                    });

                    FunSetTotal();

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
    FunBlank('P');
    var FKProjectID = $("#" + inputid).GenexAutoCompleteGet(0);
    var chkInvoiceDateAll = ""
   
    var InvFromDate = '';// $("#txtInvFromDate").val();
    var InvToDate = '';// $("#txtInvEndDate").val();
    var strError = "";    

       

        if (FKProjectID != 0 ) {

            //if (InvFromDate > InvToDate) {
            //    OpenAlert('Billing from Date Should not be greater than Billing To Date');
            //    $('#txtInvEndDate').val('');
            //}

            FunFillProjectDetail(FKProjectID, InvFromDate, InvToDate);

        }
    


    
    
}
function FunFillProjectDetail(FKProjectID, InvFromDate, InvToDate) {
    var args = {};
    
    args = {
        PKID: PKID, FKProjectID: FKProjectID, InvFromDate: InvFromDate, InvToDate: InvToDate
    };
    
    

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
                var jsonarr = $.parseJSON(data.d);
                HideLoader();

                if (jsonarr.data.Table1.length > 0) {
                    if (jsonarr.data.Table1[0].FKCurrencyID != 0) {
                        FKPCurrencyID = jsonarr.data.Table1[0].FKCurrencyID;
                        PCurrencyName = jsonarr.data.Table1[0].Symbol;
                        $('#dropFKTaxID').val(jsonarr.data.Table1[0].FKTaxID);
                        $('#txtTaxPer').val(jsonarr.data.Table1[0].TaxPer);
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
                    $('#spancontracttype').html(jsonarr.data.Table[0].ContractType);
                    $('#spancontractamt').html(PCurrencyName + jsonarr.data.Table[0].ContractAmt.toFixed(2));
                    $('#spanserviceamt1').html(PCurrencyName + jsonarr.data.Table[0].ServiceAmt.toFixed(2));
                    $('#spanexpamt1').html(PCurrencyName + jsonarr.data.Table[0].ExpAmt.toFixed(2));
                    $('#spanpercomplete').html(jsonarr.data.Table[0].CompletePercent + '%');
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
                    $('#spanpreebilled').html(PCurrencyName + jsonarr.data.Table4[0].TotalBillAmt.toFixed(2));
                }
                if (jsonarr.data.Table5.length > 0) {
                    $('#spanDate').html(jsonarr.data.Table5[0].InvDate);
                    $("#txtInvFromDate").val(jsonarr.data.Table5[0].InvDate);
                    $('#spanLastInvNo').html(jsonarr.data.Table5[0].InvoiceID);
                    //$('#spanLastInvAmt').html(PCurrencyName + jsonarr.data.Table5[0].NetAmount.toFixed(2));
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
            $('#txtTaxPer').val(option);
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


    $('#btnTask').click(function ()  {
       // var IsChecked = $('#chkSelect').is(':checked');
        $('#tblTimeSheet tbody tr').each(function (row, tr) {
            var trID = $(tr).attr("id");
            trID = trID.replace('trTimeSheet', '');
            var IsChecked = $("#chkSelect" + trID).prop("checked", IsChecked);
            if (IsChecked = true) {

                var NewRow = '<tr id="' + trID + '" >';

                NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '" data-Id="' + trID + '" data-type="ts" title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';

                NewRow += '<td class="tdItemDesc"> <input type="text" id="txtItemDesc' + trID + '" class="form-control"  value= "'+ $(tr).find("td[data-attrname='Description']").text() +'"/></td>';
                NewRow += '<td class="tdRate"> <input type="text" id="txtRate' + trID + '" class="form-control"  style="text-align:right;"   value="' + $(tr).find("td[data-attrname='TBillRate']").text() +'" /></td>';
                NewRow += '<td class="tdQty"> <input type="text" id="txtQty' + trID + '" class="form-control" style="text-align:right;"  value="' + $(tr).find("td[data-attrname='Hrs']").text() +'" /></td>';


                NewRow += '<td class="tdAmount"> <input type="text" id="txtAmount' + trID + '" class="form-control"  style="text-align:right;" readonly="readonly" value="' + $(tr).find("td[data-attrname='amt']").text() + '" /></td>';

                NewRow += "</tr>";
                $("#tblDetail tbody").append(NewRow);

                FunSetTotal();

                closediv();
            }

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
                var NewID = $(this).attr("id");
                NewID = NewID.replace("linkDelete", "");

                if (confirm("Delete this record?")) {
                    $("#" + NewID).addClass("trdeleted");
                    $('#linkDelete' + NewID).remove();
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
            var IsChecked = $("#chkSelect" + trID).prop("checked", IsChecked);
            if (IsChecked = true) {

                var NewRow = '<tr id="' + trID + '" >';

                NewRow += '<td style="text-align:center;"><a class="tbllink" id="linkDelete' + trID + '" data-Id="' + trID + '" data-type="es" title="Delete Record"><i class="fa  fa-trash"></i></a><input type="hidden" id="hidPKID' + trID + '" value="0"  /></td>';

                NewRow += '<td class="tdItemDesc"> <input type="text" id="txtItemDesc' + trID + '" class="form-control"  value= "' + $(tr).find("td[data-attrname='Description']").text() + '"/></td>';
                NewRow += '<td class="tdRate"> <input type="text" id="txtRate' + trID + '" class="form-control"  style="text-align:right;"   value="' + $(tr).find("td[data-attrname='TCostRate']").text() + '" /></td>';
                NewRow += '<td class="tdQty"> <input type="text" id="txtQty' + trID + '" class="form-control" style="text-align:right;"  value="' + $(tr).find("td[data-attrname='Unit']").text() + '" /></td>';


                NewRow += '<td class="tdAmount"> <input type="text" id="txtAmount' + trID + '" class="form-control"  style="text-align:right;" readonly="readonly" value="' + $(tr).find("td[data-attrname='Amount']").text() + '" /></td>';

                NewRow += "</tr>";
                $("#tblDetail tbody").append(NewRow);
                FunSetTotal();

                closediv();

            }

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
                var NewID = $(this).attr("id");
                NewID = NewID.replace("linkDelete", "");

                if (confirm("Delete this record?")) {
                    $("#" + NewID).addClass("trdeleted");
                    $('#linkDelete' + NewID).remove();
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
        
    $("#chkShowAllTask").click(function () {
        var chkIsChecked = $('#chkShowAllTask').is(':checked');
        var FKProjectID = $("#txtFKProjectID").GenexAutoCompleteGet(0);
        if (chkIsChecked == true) {            
            var InvFromDate = '';
            var InvToDate = '';            
        }
        else {
            var InvFromDate =$('#txtInvFromDate').val();
            var InvToDate = '';            
        }
        FunFillAllUnbilledTask(FKProjectID, InvFromDate, InvToDate, chkIsChecked);
    });

    $("#chkShowAllExpenses").click(function () {
        var chkIsChecked = $('#chkShowAllExpenses').is(':checked');
        var FKProjectID = $("#txtFKProjectID").GenexAutoCompleteGet(0);
        if (chkIsChecked == true) {
            var InvFromDate = '';
            var InvToDate = '';
        }
        else {
            var InvFromDate = $('#txtInvFromDate').val();
            var InvToDate = '';
        }
        FunFillAllUnbilledExpenses(FKProjectID, InvFromDate, InvToDate, chkIsChecked);
    });

    //Added by Nilesh to show the Unbilled Expenses - End
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