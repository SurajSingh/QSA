

var pagename = "RptTaskMasterFile.aspx";
var PKID = 0;
var FKPageID = 0;


function FunFillDepartment() {
    var str = "";
    var args = {
    };
    $("#dropFKDeptID").empty();
    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetDepartment",
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
                        $.each(jsonarr, function (i, item) {
                            str = str + '<option value="' + item.PKDeptID + '">' + item.DeptName + '</option>';
                        });

                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                    }
                }

                $("#dropFKDeptIDSrch").append('<option value="0">--All--</option>' + str);
                PageLoadComplete();
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

function InitilizeEvents() {

   
   
    $("#btnSearch").click(function () {
        var iframe = document.getElementById("ifReport");
        var args = [];
        args[0] = $('#txtTaskCodeSrch').val();
        args[1] = $("#dropFKDeptIDSrch").ValZero();
        args[2] = $('#dropActiveStatusSrch').val();       
        args[3] = FKPageID;
        iframe.contentWindow.SearchReport(args);


      

    });

}
function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    //if (LoadEntity == 0) {
    //    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    //}
}
function PageLoadFun() {
    InitilizeEvents();
    FunSetTabKey();
    LoadEntity = 1;
   
    FunFillDepartment();
   
   
}



$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});