
var json;
var pagename = "/Users/ProfilePicture.aspx";
var LogoURL = "", IconURL = "";
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
                if (jsonarr.data.Table.length > 0) {
                    LogoURL = jsonarr.data.Table[0].LogoURL;
                    IconURL = jsonarr.data.Table[0].SmallLogoURL;
                    if (LogoURL != "") {
                        $("#btnfileselect").css("background-image", "url(/Users/UserFiles/Logo/" + LogoURL + ")");
                        $('#btnRest1').show();
                    }
                    else {
                        $("#btnfileselect").css("background-image", "url(/Users/images/noimage.png)");
                        $('#btnRest1').hide();
                    }
                    if (IconURL != "") {
                        $("#btnfileselect1").css("background-image", "url(/Users/UserFiles/Logo/" + IconURL + ")");
                        $('#btnRest2').show();
                    }
                    else {
                        $("#btnfileselect1").css("background-image", "url(/Users/images/noimage.png)");
                        $('#btnRest2').hide();
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





function FunSave(RecType,ImgURL) {


    var args = {
        RecType: RecType,
        LogoURL: ImgURL

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
            HideLoader();
            if (data.d != "failure") {
               
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {

                    if (jsonarr[0].Result == "1") {   
                        OpenAlert('Saved Successfully!');
                        FunFillData();

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
function FunUploadAttachment(trid, UploadType,btnID) {
   
    var status = 1;
    var FileType = ".PNG,.JPG,.JPEG,.BMP";
    if (status == 1) {
        var iframe = document.getElementById("ifuploadfile");
        var args = [];
        args[0] = UploadType;
        args[1] = FileType;
        args[2] = trid;
        args[3] = btnID;
        iframe.contentWindow.selectAttachment(args);
    }
}
function AttachClientFileCall(Result, Msg, trID, id, filesize, filename, filext) {
    if (trID == 'Logo') {

        HideFileLoader("btnfileselect");
    }
    else {
        HideFileLoader("btnfileselect1");

    }
    if (Result == 1) {
       
        if (trID == 'Logo') {
            LogoURL = id;
            $("#btnfileselect").css("background-image", "url(/Users/UserFiles/Logo/" + id + ")");
            FunSave('Logo',id);
        }
        else {
            IconURL = id;
            $("#btnfileselect").css("background-image", "url(/Users/UserFiles/Logo/" + id + ")");
            FunSave('SmallLogo', id);

        }       
      
    }
    else {

        HideFileLoader("btnFileSelectInner");
        OpenAlert(Msg);
    }
}


function InitilizeEvents() {

    $('#btnUpload1').click(function () {
        FunUploadAttachment('Logo', 'Logo','btnfileselect');

    });
    $('#btnUpload2').click(function () {
        FunUploadAttachment('SmallLogo', 'Logo', 'btnfileselect1');

    });
    $('#btnRest1').click(function () {
        if (confirm('Do you want to remove company logo?')) {
            FunSave("Logo", "");
        }

    });
    $('#btnRest2').click(function () {
        if (confirm('Do you want to remove company icon?')) {
            FunSave("SmallLogo", "");
        }

    });
}

function PageLoadFun() {
   
    InitilizeEvents();  
    FunFillData();
    
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});