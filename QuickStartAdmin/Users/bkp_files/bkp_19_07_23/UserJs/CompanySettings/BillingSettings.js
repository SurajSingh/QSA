
var json;
var pagename = "/Users/BillingSettings.aspx";
var PKID = 0;


function FunBlank() {
    PKID = 0;

    $('#divAddForm').find('.form-control').val('');

}


function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
   


    if (!fail) {
        $("#divValidateSummary").hide();
        FunSave();

    } else {
        $("#divValidateSummary").show();
        $("#divValidateSummary").find(".validate-box ul").empty();
        $("#divValidateSummary").find(".validate-box ul").html(fail_log + strError);
        $('html, body').animate({
            scrollTop: (0)
        }, 500);
    }
}

function FunSave() {


    var args = {
        InvoicePrefix: $("#txtInvoicePrefix").val(), InvoiceSuffix: $("#txtInvoiceSuffix").val(), InvoiceSNo: $("#txtInvoiceSNo").ValZero()

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

                        HideLoader();
                        
                        OpenAlert('Saved Successfully!');

                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                        HideLoader();
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
    var str = "";
    ShowLoader();
    var args = {
       
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

                if (jsonarr.length > 0) {

                    if (jsonarr[0].Result == "1") {
                        FunFillDetail(jsonarr);
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
                OpenAlert("Session Timeout!");
                window.location.href = "Logout.aspx";
            }
        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();          
            return;
        }

    });



}
function FunFillDetail(jsonarr) {
    FunBlank();

    $('#txtInvoicePrefix').val(jsonarr[0].InvoicePrefix);
    $('#txtInvoiceSuffix').val(jsonarr[0].InvoiceSuffix);
    $('#txtInvoiceSNo').val(jsonarr[0].InvoiceSNo);
   
    HideLoader();

}
function InitilizeEvents() {
   
    $("#btnsave").click(function () {
        FunValidate();
    });

}


function PageLoadFun() {
  
    PKID = parseInt($("#HidID").val());
    InitilizeEvents();

   
    SetNumberBox('txtInvoiceSNo',0,false,'');
   
    FunSetTabKey();
    if (IsEdit == 0) {

        $("#btnsave").remove();
    }

    FunFillData();
  
   
   
   
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});