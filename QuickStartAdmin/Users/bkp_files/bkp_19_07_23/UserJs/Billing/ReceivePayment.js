
var pagename = "/Users/ReceivePayment.aspx";
var PKID = 0;
var DRowNo = 0;
var FKPCurrencyID = 0;
var PCurrencyName = '$';

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
var Remaining = 0;
var Balance = 0;




function FunSetTotal() {
    var TotalAmount = parseFloat($("#txtAmount").ValZero());
    var TotalAdjustment = 0;
    Remaining = 0;
    $('#tblAdjustList tbody tr').each(function (row, tr) {
        var trID = $(tr).attr("id");

        if ($("#chk" + trID).is(':checked')) {
            TotalAdjustment = TotalAdjustment + parseFloat($("#txtAdjAmt" + trID).ValZero());
        }

    });
    Remaining = TotalAmount - TotalAdjustment;
    $("#FTotalAamount").html(CurrencyName + RoundNumber(TotalAmount, 2));
    $("#FTotalAdjAmt").html(CurrencyName + RoundNumber(TotalAdjustment, 2));
    $("#FTotalRemaning").html(CurrencyName + RoundNumber(Remaining, 2));


}
function FunBlank() {
    PKID = 0;
    Remaining = 0;
    Balance = 0;
    $('#txtFKClientID').GenexAutoCompleteBlank();
    $("#txtFKClientID").prop('disabled', false);
    $("#chkIsRetainer").prop('disabled', true);
    $('#tblAdjustList tbody').empty();
    $('#txtTranDate').val('');
    $('#txtAmount').val('');
    $('#txtClientBalance').val('0.00');
    $('#txtTranID').val('');
    $('#dropFKPaymentTypeID').val('0');
    $('#dropFKPaymodeID').val('0');
    $('#divInvoice').show();
    FunSetTotal();


}

function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    if ($("#txtFKClientID").GenexAutoCompleteGet('0') == "0") {
        fail = true;
        $("#txtFKClientID").css("border-color", ColorE);
        strError += "<li>Select Client</li>";
    }
    else {
        $("#txtFKClientID").css("border-color", ColorN);
    }
    if ($("#txtTranDate").val() == "") {
        fail = true;
        $("#txtTranDate").css("border-color", ColorE);
        strError += "<li>Enter Date</li>";
    }
    else {
        $("#txtTranDate").css("border-color", ColorN);
    }
    if ($("#dropFKPaymentTypeID").ValZero() == "0") {
        fail = true;
        $("#dropFKPaymentTypeID").css("border-color", ColorE);
        strError += "<li>Select Payment Type</li>";
    }
    else {
        $("#dropFKPaymentTypeID").css("border-color", ColorN);
    }
    if ($("#txtAmount").ValZero() == "0") {
        fail = true;
        $("#txtAmount").css("border-color", ColorE);
        strError += "<li>Enter Amount</li>";
    }
    else {
        $("#txtAmount").css("border-color", ColorN);
    }
    if ($("#dropFKPaymentTypeID").ValZero() == "1") {
        if ($("#dropFKPaymodeID").ValZero() == "0") {
            fail = true;
            $("#dropFKPaymodeID").css("border-color", ColorE);
            strError += "<li>Select Payment Mode</li>";
        }
        else {
            $("#dropFKPaymodeID").css("border-color", ColorN);
        }
    }
    else if ($("#dropFKPaymentTypeID").ValZero() == "2") {
        if (parseFloat($("#txtAmount").ValZero()) > Balance) {
            fail = true;
            $("#txtAmount").css("border-color", ColorE);
            strError += "<li>Entered amount is greater then client balance</li>";

        }


    }
    var ItemCount = 0;
    Remaining = parseFloat($("#txtAmount").ValZero());
    var adjamt = 0;
    var amt = parseFloat($("#txtAmount").ValZero());
    if ($("#chkIsRetainer").is(':checked') == false) {
        $('#tblAdjustList tbody tr').each(function (row, tr) {
            var trid = $(tr).attr("id");
            if ($('#chk' + trid).is(":checked")) {
                ItemCount = ItemCount + 1;
                adjamt = adjamt + parseFloat($("#txtAdjAmt" + trid).val());
            }

        });

        if (ItemCount == 0) {
            fail = true;
            strError += "<li>No invoice selected for adjustment</li>";
        }
        else if (adjamt > amt) {
            fail = true;
            strError += "<li>Adjustment amount is greater then payment amount</li>";

        }

        Remaining = amt - adjamt;

    }
   
   
   
    if (!fail) {
        $("#divValidateSummary").hide();
        FunSave();

    } else {
        $("#divValidateSummary").show();
        $("#divValidateSummary").find(".validate-box ul").empty();
        $("#divValidateSummary").find(".validate-box ul").html(fail_log + strError);
        $('html, body').animate({
            scrollTop: $("#divValidateSummary").offset().top-50
        }, 500);
        return false;
    }

}



function FunStoreItemData() {
    var TableData = new Array();
    var i = 0;
    $('#tblAdjustList tbody tr').each(function (row, tr) {
        var trid = $(tr).attr("id");
        if ($('#chk' + trid).is(":checked")) {
            TableData[i] = {
                "FKInvoiceID": $("#chk" + trid).val()
                , "Amount": parseFloat($("#txtAdjAmt" + trid).val())
                , "ModeForm": 0

            }
            i++;
        }

    });

    return TableData;
}

function FunSave() {
    FunSetTotal();
    ProgCount = 0;
    ShowLoader();
    var UseRetainer = false;
    var FKPaymentModeID = 0;
    var RetainerAmt = 0;
    if ($('#dropFKPaymentTypeID').ValZero() == "1") {

        UseRetainer = $('#chkIsRetainer').is(':checked')
        FKPaymentModeID = $('#dropFKPaymodeID').ValZero();
    }


    var StrItemList = "";
    if (UseRetainer == false) {

        StrItemList = FunStoreItemData();
        StrItemList = JSON.stringify(StrItemList);

        if ($('#dropFKPaymentTypeID').ValZero() == "1") {

            RetainerAmt = Remaining;
        }


    }
    else {
        RetainerAmt = $('#txtAmount').ValZero();
    }
   
   
    var args = {
        PKID: PKID, FKClientID: $('#txtFKClientID').GenexAutoCompleteGet('0'), TranDate: $('#txtTranDate').val(), FKPaymentTypeID: $('#dropFKPaymentTypeID').ValZero(),
        FKPaymodeID: FKPaymentModeID, TranID: $('#txtTranID').val(),
        IsRetainer: UseRetainer, Amount: $('#txtAmount').ValZero(), RetainerAmount: RetainerAmt, dtItemStr: StrItemList

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
                        FunBlank();
                        FunGetClientForAutoComplete(FunClientCallBack, 0, '');
                        OpenAlert('Saved Successfully');

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
                    

                    $("#txtFKClientID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKClientID, jsonarr.data.Table[0].ClientName);
                    $("#txtFKClientID").prop('disabled', true);

                    Balance = jsonarr.data.Table[0].ClientBalance;
                    $('#txtClientBalance').val(Balance.toFixed(2));
                   


                    $('#txtTranDate').val(jsonarr.data.Table[0].TranDate);
                    $('#dropFKPaymentTypeID').val(jsonarr.data.Table[0].FKPaymentTypeID);
                    $('#dropFKPaymodeID').val(jsonarr.data.Table[0].FKPaymodeID);
                    $('#txtTranID').val(jsonarr.data.Table[0].TranID);
                    $('#txtAmount').val(jsonarr.data.Table[0].Amount);
                    $('#chkIsRetainer').prop('checked', jsonarr.data.Table[0].IsRetainer);


                    if ($("#chkIsRetainer").is(':checked')) {
                        $('#divInvoice').hide();
                    }
                    else {
                        $('#divInvoice').show();
                    }

                    if ($("#dropFKPaymentTypeID").ValZero() == "1") {
                        $('#chkIsRetainer').prop('disabled', false);
                        $('#divPaymentMode').show();

                    }
                    else {
                        $('#chkIsRetainer').prop('disabled', true);                       
                        $('#divPaymentMode').hide();  
                    }

                    FunFillInvForAdjustment(jsonarr.data.Table1);                  
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
function FunSetClientDetail(item, inputid) {
    $('#tblAdjustList tbody').empty();
    Remaining = parseFloat($('#txtAmount').ValZero());
    Balance = 0;
    $('#txtClientBalance').val('0.00');

    FunSetTotal();
    var FKClientID = $("#" + inputid).GenexAutoCompleteGet(0);
    if (FKClientID != 0) {
        Balance =item.Retainer;
        $('#txtClientBalance').val(Balance.toFixed(2));
        
        FunSetClientCallBack(FKClientID);
    }
}
function FunSetClientCallBack(FKClientID) {
    var args = {
        PKID: PKID, FKClientID: FKClientID
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetInvForAdjustment",
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
                    FunFillInvForAdjustment(jsonarr.data.Table);

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
function FunFillInvForAdjustment(jsonarr) {
    $('#tblAdjustList tbody').empty();
    $.each(jsonarr, function () {
        var str = '';
        var trID = 'trInvoice' + this.PKID;
        str = str + '<tr id="' + trID + '" data-dueamt="' + this.NetDueAmount + '">';
        str += '<td class="tdApprove" style="text-align:center;"> <input type="checkbox" class="form-check-input" id="chk' + trID + '" value="' + this.PKID + '"  /></td>';
        str = str + '<td><a target="_blank" class="tbllink1" href="PrintInvoice.aspx?PKID='+this.PKID+'">' + this.InvoiceID + '</a></td>';
        str = str + '<td>' + this.ProjectName + '</td>';
        str = str + '<td>' + this.InvDate + '</td>';
        str = str + '<td style="text-align:right;">' + this.NetAmount.toFixed(2) + '</td>';
        str = str + '<td style="text-align:right;">' + this.NetDueAmount.toFixed(2) + '</td>';

        str = str + '<td><input type="text" id="txtAdjAmt' + trID + '" value="' + this.AdjAmt.toFixed(2) + '" class="form-control" /></td>';
        str += '</tr>';

        $('#tblAdjustList tbody').append(str);

        if (this.IsSelected == true) {
            $("#chk" + trID).prop('checked', true);

        }
        else {
            $("#txtAdjAmt" + trID).prop('disabled', true);

        }
        SetAmountBox("txtAdjAmt" + trID, 2, false, '');

        $("#chk" + trID).click(function () {
            var NewID = $(this).attr("id");
            NewID = NewID.replace("chk", "");
            FunActivateAmount(NewID);
        });

        $("#txtAdjAmt" + trID).change(function () {
            FunSetTotal();
        });


    });

}
function FunActivateAmount(trID) {
    FunSetTotal();
    if ($("#chk" + trID).is(':checked')) {
        $("#txtAdjAmt" + trID).prop('disabled', false);
        var InvAmt = parseFloat($("#" + trID).attr("data-dueamt"));
        var Adjamt = 0;
        if (Remaining > 0) {
            if (Remaining > InvAmt) {
                Adjamt = InvAmt;
            }
            else {
                Adjamt = Remaining;
            }
        }
        $("#txtAdjAmt" + trID).RoundVal(Adjamt);
    }
    else {
        $("#txtAdjAmt" + trID).val("");


        $("#txtAdjAmt" + trID).prop('disabled', true);

    }
    FunSetTotal();
}
function FunClientCallBack(JsonArr) {
    $("#txtFKClientID").GenexAutoCompleteWithCallBack(JsonArr, FunSetClientDetail, 0, "ClientID,Name,Status");
    PageLoadComplete();
}
function FunClientCallBack1(JsonArr) {
    $("#txtFKClientID").GenexAutoCompleteWithCallBack(JsonArr, FunSetClientDetail, 0, "ClientID,Name,Status");
   
}
function FunPaymentModeMasterCallback(str) {
    $('#dropFKPaymodeID').append(str);

    PageLoadComplete();
}
function FunPaymentTypeMasterCallback(str) {
    $('#dropFKPaymentTypeID').append(str);

    PageLoadComplete();
}
function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    if (LoadEntity == 0) {
        FunBlank('');

        PKID = parseInt($("#HidID").val());
        if (PKID != 0) {
            FunFillData();
        }
    }
}
function InitilizeEvents() {

    $("#dropFKPaymentTypeID").change(function () {

        if ($("#dropFKPaymentTypeID").ValZero() == "1") {
            $('#chkIsRetainer').prop('disabled', false);
            $('#divPaymentMode').show();

        }
        else {
            $('#chkIsRetainer').prop('disabled', true);
            $('#chkIsRetainer').prop('checked', false);
            $('#divPaymentMode').hide();

            if ($("#dropFKPaymentTypeID").ValZero() == "2") {
                $('#txtAmount').val(Balance.toFixed(2));
               
            }

        }



    });
    $("#txtAmount").change(function () {
        FunSetTotal();
    });
    $("#chkIsRetainer").click(function () {

        if ($("#chkIsRetainer").is(':checked')) {
            $('#divInvoice').hide();
        }
        else {
            $('#divInvoice').show();
        }
    });
    $("#btnsave").click(function () {
        FunValidate();
    });


    $("#chkAll").click(function () {
        var IsChecked = $('#chkAll').is(':checked');
        $('#tblAdjustList tbody tr').each(function (row, tr) {
            var trID = $(tr).attr("id");
            trID = trID.replace('trInvoice', '');
            FunActivateAmount(trID);
        });
    });





}


function PageLoadFun() {


    InitilizeEvents();


    SetDatePicker("txtTranDate");
    SetAmountBox('txtAmount', 2, false, '');
    $('#chkIsRetainer').prop('disabled', true);

    LoadEntity = 3;
    FunGetClientForAutoComplete(FunClientCallBack, 0, '');
    FunFillPaymentModeMaster(FunPaymentModeMasterCallback);
    FunFillPaymentTypeMaster(FunPaymentTypeMasterCallback);

    FunSetTabKey();



}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});