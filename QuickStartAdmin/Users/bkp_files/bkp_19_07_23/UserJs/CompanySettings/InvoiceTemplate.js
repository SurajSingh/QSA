
var json;
var pagename = "/Users/InvoiceTemplate.aspx";
var PKID = 0;
var FKTemplateID = 1;




function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if (FKTemplateID == "0" || FKTemplateID == "") {
        fail = true;

    }


    if (!fail) {
       
        FunSave();

    } else {
        OpenAlert('Select Invoice Template');
    }
}

function FunSave() {


    var args = {
        FKTemplateID: FKTemplateID

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
   
    FKTemplateID = jsonarr[0].InvoiceTempID;
    $('.imgbox').removeClass('selected');
    $('#divTemp' + jsonarr[0].InvoiceTempID).addClass('selected');
   
    HideLoader();

}
function InitilizeEvents() {
   
   
    $("#btnsave").click(function () {
        FunValidate();
    });


   
    $('.divinvtemplate').on('click', '.imgbox', function (event) {
        event.stopImmediatePropagation();
        var target = $(event.target);
        $('.imgbox').removeClass('selected');
        $(this).addClass('selected');
        FKTemplateID = $(this).attr('data-id');
        if (target.is("i")) {

            var newid = $(this).attr("data-img");
            opendivid = "divShowImage";
            $("#divShowImage").show();
            $("#imgItem").attr("src", newid);
        }
       


        event.preventDefault();


    });
}


function PageLoadFun() {
  
   
    InitilizeEvents();

   
   
   
    FunSetTabKey();
    if (IsEdit == 0) {

        $("#btnsave").remove();
    }

    FunFillData();
  
   
   
   
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});