
var pagename = "UserProfile.aspx";
function FunFillData() {

    var str = "";
    ShowLoader();

    $.ajax({
        type: "POST",
        url: pagename + "/GetUsers",

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
            HideDataLoader();
            return;
        }

    });



}

function FunFillDetail(jsonarr) {
  
      
    $("#txtUserName").val(jsonarr[0].Name);
    $("#txtEmail").val(jsonarr[0].EmailID);
    $("#txtMOBILE").val(jsonarr[0].MobNo);
    $("#txtUserofficeCell").val(jsonarr[0].Phone1);
    $("#txtUserhomeCell").val(jsonarr[0].Phone2);   
    
    if (jsonarr[0].PhotoURL != "")
        $("#btnfileselect").css("background-image", "url(/Users/UserFiles/Profile/" + jsonarr[0].PhotoURL+")");
    else
        $("#btnfileselect").css("background-image", "url(/Users/Images/NoImage.jpg)");

    SavedFileName = jsonarr[0].PhotoURL;
  
}
function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    $('#divAddForm').find('textarea, input').each(function () {
        if (!$(this).prop('required')) {

        } else {
            if (!$(this).val()) {

                fail = true;
                $(this).css("border-color", ColorE);

            }
            else {
                $(this).css("border-color", ColorN);
            }

        }


    });
  
    
    if (!fail) {
       
        FunSave();

    }
}


function FunSave() {
   

    var args = {

        PKUserID: "",
        EmailID: $("#txtEmail").val(),
        Name: $("#txtUserName").val(),
        MobNo: $("#txtMOBILE").val(),
        Phone1: $("#txtUserofficeCell").val(),
        Phone2: $("#txtUserhomeCell").val(),     
        PhotoURL: SavedFileName
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
                HideLoader();
                if (jsonarr.length > 0) {

                    if (jsonarr[0].Result == "1") {
                                             
                        OpenAlert('Saved Successfully!');                       

                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                       
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


function PageLoadFun() {
  
    FunFillData();

}

$(document).ready(function () {

    SetMobileBox("txtUserofficeCell");
    SetMobileBox("txtUserhomeCell");
    SetMobileBox("txtMOBILE");
    PageLoadFun();
    $('#btnfileselect').click(function () {
        FunUploadAttachment("Profile", "btnFileSelectInner", "/Users/UserFiles/Profile/");

    });
  
    $('#btnsave').click(function () {

        FunValidate();

    });
});

