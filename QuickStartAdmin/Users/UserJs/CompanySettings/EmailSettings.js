
var json;
var pagename = "/Users/EmailSettings.aspx";
var PKID = 0;


function FunBlank() {
    PKID = 0;

    $('#divAddForm').find('.form-control').val('');

}


function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtSenderEmail").val() == "") {
        fail = true;
        $("#txtSenderEmail").css("border-color", ColorE);
        strError += "<li>Enter Email Account</li>";
    }
    else {
        $("#txtSenderEmail").css("border-color", ColorN);
    }
    if ($("#txtSenderPWD").val() == "") {
        fail = true;
        $("#txtSenderPWD").css("border-color", ColorE);
        strError += "<li>Enter Email Password</li>";
    }
    else {
        $("#txtSenderPWD").css("border-color", ColorN);
    }
    if ($("#txtSMTPServer").val() == "") {
        fail = true;
        $("#txtSMTPServer").css("border-color", ColorE);
        strError += "<li>Enter SMTP Server</li>";
    }
    else {
        $("#txtSMTPServer").css("border-color", ColorN);
    }
    if ($("#txtSMTPPort").val() == "") {
        fail = true;
        $("#txtSMTPPort").css("border-color", ColorE);
        strError += "<li>Enter SMTP Port</li>";
    }
    else {
        $("#txtSMTPPort").css("border-color", ColorN);
    }


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
        SenderEmail: $("#txtSenderEmail").val(), SenderPWD: $("#txtSenderPWD").val(), SMTPServer: $("#txtSMTPServer").val(), SMTPPort: $("#txtSMTPPort").ValZero(), EnableSSL: $("#chkEnableSSL").is(':checked')

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

    $('#txtSenderEmail').val(jsonarr[0].SenderEmail);
    $('#txtSenderPWD').val(jsonarr[0].SenderPWD);
    $('#txtSMTPServer').val(jsonarr[0].SMTPServer);
    $('#txtSMTPPort').val(jsonarr[0].SMTPPort);
    $('#chkEnableSSL').prop("checked", jsonarr[0].EnableSSL);
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

    SetEmailBox("txtSenderEmail");
    SetNumberBox('txtSMTPPort',0,false,'');
   
    FunSetTabKey();
    if (IsEdit == 0 && PKID != 0) {

        $("#btnsave").remove();
    }

    FunFillData();
  
   
   
   
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});