
var json;
var pagename = "/Users/LeaveRequestEmailReceivers.aspx";
var PKID = 0;




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

    var receiver = '';
    $("#listcode2 > option").each(function () {
        receiver = receiver + this.value + ',';
    });
    if (receiver.length > 0) {
        receiver = receiver.replace(/,\s*$/, "");
    }
    var args = {
        FKEmailMsgLocID: 3, BodyContent: '', EmailSubject: '', EnableEmail: $("#chkEnableEmail").is(':checked'), Receiver: receiver
        

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
        FKEmailMsgLocID:3
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
                        $('#chkEnableEmail').prop("checked", jsonarr[0].EnableEmail);
                        var strrec = jsonarr[0].Receiver.split(',');
                        if (strrec.length > 0) {
                            for (var j = 0; j < strrec.length; j++) {
                                if (strrec[j] != '') {
                                    $('#listcode1').val(strrec[j]);
                                    MoveListItem(false, 'listcode1', 'listcode2');
                                }
                            }

                        }
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

function FunEmpCallBack(JsonArr) {
    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });


    }
    $('#listcode1').append(str);

    FunFillData();
}
function InitilizeEvents() {
   
    $("#btnsave").click(function () {
        FunValidate();
    });

}


function PageLoadFun() {
  
    PKID = parseInt($("#HidID").val());
    InitilizeEvents();
    SetLeftRightListBox('btnMoveLeft','btnMoveRight', 'listcode1', 'listcode2');
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, 'Active');
    
    FunSetTabKey();
    if (IsEdit == 0) {

        $("#btnsave").remove();
    }

   
  
   
   
   
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});