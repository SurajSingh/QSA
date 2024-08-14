var RoleAPIURL = "/Users/MasterAPI/MasterPageAPI.aspx";
var FKRoleID = 0;
var RoleType = '';
var IsView = 0;
var IsAdd = 0;
var IsEdit = 0;
var IsDelete = 0;
var OrgType = '';
function SetUserRoles(PageLoadCallBack) {
    if ($('#HidPageRoleID').val() != "0" && $('#HidPageRoleID').val() != "") {
        IsLoadingRole = true;
        ShowLoader();
        var args = { FKRoleID: $('#HidPageRoleID').val() };
        $.ajax({

            type: "POST",
            url: RoleAPIURL + "/GetUserInRole",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            cache: false,
            success: function (data) {
                
                if (data.d != "failure" && data.d != "") {
                    
                    var jsonarr = $.parseJSON(data.d);

                    if (jsonarr.length > 0) {
                        FKRoleID = $('#HidPageRoleID').val();                       
                        RoleType = jsonarr[0].RoleType;
                        IsAdd = jsonarr[0].IsAdd;
                        IsEdit = jsonarr[0].IsEdit;
                        IsDelete = jsonarr[0].IsDelete;
                        IsView = jsonarr[0].IsView;
                        OrgType = jsonarr[0].OrgType;
                       
                        

                    }

                }

                HideLoader();
                PageLoadCallBack();

            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                HideLoader();
                return;
            }

        });
    }
    else {
        PageLoadCallBack();
    }



}
function GetUserInRole(CallBackFunction, StrRoleID) {   
    //ShowLoader();
    var args = { StrRoleID: StrRoleID };
    $.ajax({

        type: "POST",
        url: RoleAPIURL + "/GetUserInRoles",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            //HideLoader();
            if (data.d != "failure" && data.d != "") {

                var jsonarr = $.parseJSON(data.d);
                CallBackFunction(jsonarr);

            }           
           

        },
        error: function (x, e) {
            alert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });



}