
var json;
var pagename = "/Users/Departments.aspx";
var PKID = 0;

function FunFillData() {
    var str = "";
    if (PKID == 0) {
        if (tableData != null) {
            $("#tbldata").DataTable().clear().destroy();

        }
        $("#tbldata tbody").empty();
        ShowDataLoader();
    }
    else {
        ShowLoader();
    }

    var args = {
        PKDeptID: PKID
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
                HideDataLoader();
                HideLoader();
                if (jsonarr.length > 0) {
                    if (jsonarr[0].Result == "1") {
                        if (PKID == 0) {
                            $.each(jsonarr, function (i, item) {


                                str = str + '<tr>';
                                str = str + '<td>' + item.DeptName + '</td>';
                                str = str + '<td>' + item.DeptDesc + '</td>';
                                str = str + '<td>' + item.ManagerName + '</td>';

                                if (IsEdit == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkEditRec tbllink" id="linkEditRec' + item.PKDeptID + '"  title="Edit Record"><i class="fa  fa-edit"></i></a></td>';
                                }
                                else {
                                    str += "<td></td>";
                                }
                                if (IsDelete == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkDeleteRec tbllink" id="linkDeleteRec' + item.PKDeptID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a></td>';
                                }
                                else {
                                    str += "<td></td>";
                                }


                                str += '</tr>';
                            });

                            $("#tbldata tbody").append(str);
                            ActiveDataTable("tbldata", [-2, -1]);

                            $('#tbldata').on('click', '.linkEditRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkEditRec", "");
                                PKID = parseInt(newid);
                                FunFillData();
                            });
                            $('#tbldata').on('click', '.linkDeleteRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkDeleteRec", "");
                                FunDelete(newid);
                            });
                        }
                        else {
                            FunFillDetail(jsonarr);
                        }
                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                    }
                }
                else {
                    ActiveDataTable("tbldata", [-2, -1]);
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
    FunBlank();
    $('#popupTitle').find('span').html("Modify Department");
    PKID = jsonarr[0].PKDeptID;
    $("#txtDepartment").val(jsonarr[0].DeptName);
    $("#txtDesc").val(jsonarr[0].DeptDesc);
    $("#txtFKManagerID").GenexAutoCompleteSet(jsonarr[0].FKManagerID, jsonarr[0].ManagerName)
    opendiv('divAddNew');
}
function FunBlank() {
    PKID = 0;
    $('#divAddNew').find('.form-control').val('');
    $('#popupTitle').find('span').html("New Department");

}



function FunValidate() {

    var fail = false;
    var fail_log = '';
    $('#divAddNew').find('select, textarea, input').each(function () {
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

    } else {
        OpenAlert("Please fill required fields!");
    }
}

function FunSave() {


    var args = {
        PKDeptID: PKID,
        DeptName: $("#txtDepartment").val(), DeptDesc: $("#txtDesc").val(), FKManagerID: $("#txtFKManagerID").GenexAutoCompleteGet('0')

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
                      
                        $('#tbldata').DataTable().destroy();
                        HideLoader();
                        FunBlank();
                       
                        FunFillData();
                        FunCallParentFun();

                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                        HideLoader();
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

function FunDelete(RecID) {
    if (confirm("Do you want to delete this record?")) {
        var args = { PKDeptID: RecID };
        ShowLoader();
        $.ajax({

            type: "POST",
            url: pagename + "/DeleteData",
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
                            $('#tbldata').DataTable().destroy();
                            FunFillData();
                            FunCallParentFun();

                        }
                        else if (jsonarr[0].Result == "9") {
                            location.href = "Logout.aspx";
                        }
                        else {
                            HideLoader();
                            OpenAlert(jsonarr[0].Msg);
                        }

                    }

                }


            },
            error: function (x, e) {
                OpenAlert("The call to the server side failed. " + x.responseText);
                HideLoader();
                return;
            }

        });
    }
}
function FunCallParentFun() {

    if ($("#HidHasParent").val() != "0") {

        window.parent.FunDepartmentCallFromChild();
    }
    else {
        OpenAlert('Saved Successfully!');
    }
}

function FunEmpCallBack(JsonArr) {
    $("#txtFKManagerID").GenexAutoComplete(JsonArr, "EmpID,Name,Status");
   
}

function InitilizeEvents() {

    $("#btnSave").click(function () {
        FunValidate();
    });
    $("#btnAddNew").click(function () {
        if (IsAdd == 1) {
            FunBlank();
            opendiv('divAddNew');
        }
    });
}

function PageLoadFun() {
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, 'Active');
    InitilizeEvents();
    FunSetTabKey();
    FunFillData();
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
}
$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});