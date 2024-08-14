
var json;
var pagename = "/Users/InvoiceEmailTemplate.aspx";
var PKID = 0;




function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
   
    if ($("#txtSubject").val() == "") {
        fail = true;
        $("#txtSubject").css("border-color", ColorE);
        strError += "<li>Enter Subject</li>";
    }
    else {
        $("#txtSubject").css("border-color", ColorN);
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

    var myContent = tinymce.get("txtEmailHTML").getContent();
    var args = {
        FKEmailMsgLocID: 1, BodyContent: myContent, EmailSubject: $("#txtSubject").val(), EnableEmail: $("#chkEnableEmail").is(':checked'), Receiver:''
        

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
        FKEmailMsgLocID:1
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



    $('#txtSubject').val(jsonarr[0].EmailSubject);
    $('#chkEnableEmail').prop("checked", jsonarr[0].EnableEmail);
    tinymce.get("txtEmailHTML").setContent(jsonarr[0].BodyContent);
   
   
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

   
    0 < $("#txtEmailHTML").length && tinymce.init({
        selector: "textarea#txtEmailHTML", height: 300,
        plugins: ["advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker", "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking", "save table contextmenu directionality emoticons template paste textcolor"], toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | l      ink image | print preview media fullpage | forecolor backcolor emoticons", style_formats: [{ title: "Bold text", inline: "b" }, { title: "Red text", inline: "span", styles: { color: "#ff0000" } }, { title: "Red header", block: "h1", styles: { color: "#ff0000" } }, { title: "Example 1", inline: "span", classes: "example1" }, { title: "Example 2", inline: "span", classes: "example2" }, { title: "Table styles" }, { title: "Table row 1", selector: "tr", classes: "tablerow1" }]
    })
   
    FunSetTabKey();
    if (IsEdit == 0) {

        $("#btnsave").remove();
    }

    FunFillData();
  
   
   
   
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});