var MasterAPIURL = "/Users/SettingAccount.aspx";

function FunUserRoleSetting() {

    var args = {};
    $.ajax({

        type: "POST",
        url: MasterAPIURL + "/UserRoleSetting",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {

            if (data.d != "failure" && data.d != "") {

                var jsonarr = $.parseJSON(data.d);
                if (jsonarr.length > 0) {
                    location.href = "Dashboard.aspx";
                }


            }



        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            return;
        }

    });

}

$(document).ready(function () {
    FunUserRoleSetting();
});