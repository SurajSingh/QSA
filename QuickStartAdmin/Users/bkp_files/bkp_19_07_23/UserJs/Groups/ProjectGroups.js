
var json;
var pagename = "/Users/ProjectGroups.aspx";
var PKID = 0;
var jsonList = null;


function FunFillData(RecType) {
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
        PKID: PKID
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
                if (jsonarr.data.Table.length > 0) {
                    if (jsonarr.data.Table[0].Result == "1") {
                        if (PKID == 0) {
                            $.each(jsonarr.data.Table, function (i, item) {


                                str = str + '<tr>';
                                str = str + '<td>' + item.GroupName + '</td>';
                                str = str + '<td>' + item.Description + '</td>';

                                str = str + '<td>  <a class="linkView tbllink" id="linkView' + item.PKID + '"  title="View Detail">' + item.ChildCount + '</a></td>';

                               
                                str = str + '<td>' + item.CreatedByName + '</td>';
                                str = str + '<td>' + item.CreationDate + '</td>';

                                if (IsEdit == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkEditRec tbllink" id="linkEditRec' + item.PKID + '"  title="Edit Record"><i class="fa  fa-edit"></i></a></td>';
                                }
                                else {
                                    str += "<td></td>";
                                }
                                if (IsDelete == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkDeleteRec tbllink" id="linkDeleteRec' + item.PKID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a></td>';
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
                                FunFillData('Edit');
                            });
                            $('#tbldata').on('click', '.linkView', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkView", "");
                                PKID = parseInt(newid);
                                FunFillData('View');
                            });
                            $('#tbldata').on('click', '.linkDeleteRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkDeleteRec", "");
                                FunDelete(newid);
                            });
                        }
                        else {
                            if (RecType == 'Edit') {
                                FunFillDetail(jsonarr);
                            }
                            else {
                                FunFillGroupDetail(jsonarr);

                            }
                        }
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
    $('#popupTitle').find('span').html("Modify Project Group");
    PKID = jsonarr.data.Table[0].PKID;
    $("#txtGroupName").val(jsonarr.data.Table[0].GroupName);
    $("#txtDescription").val(jsonarr.data.Table[0].Description);
    $.each(jsonarr.data.Table1, function (i, item) {
        $('#listcode1').val(item.FKProjectID);
        MoveListItem(false, 'listcode1', 'listcode2');
    });

 


    opendiv('divAddNew');
}
function FunFillGroupDetail(jsonarr) {
    var str = '';
    $("#tdGroupName").html(jsonarr.data.Table[0].GroupName);

    $.each(jsonarr.data.Table1, function (i, item) {
        str += '<tr><td><i class="fa fa-angle-right"></i>&nbsp;' + item.ProjectName + '</td></tr>';


    });
    $('#tblDetail tbody').empty();
    $('#tblDetail tbody').append(str);
    opendiv('divView');
}
function FunBlank() {
    PKID = 0;
    FunFillList();
    $('#divAddNew').find('.form-control').val('');
    $('#popupTitle').find('span').html("New Project Group");

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

    var receiver = '';
    $("#listcode2 > option").each(function () {
        receiver = receiver + this.value + ',';
    });
    if (receiver == '') {
        fail = true;
        $('#listcode2').css("border-color", ColorE);
    }
    else {
        $('#listcode2').css("border-color", ColorN);
    }

    if (!fail) {
        FunSave();

    } else {
        OpenAlert("Please fill required fields!");
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
        PKID: PKID,
        GroupName: $("#txtGroupName").val(), Description: $("#txtDescription").val(), GroupItems: receiver

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
                        closediv();
                        OpenAlert('Saved Successfully!');
                        FunFillData();

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
        var args = { PKID: RecID };
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
                            OpenAlert("Record deleted successfully!");

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


function FunListCallback(JsonArr) {
    jsonList = JsonArr;
    FunFillList();
    FunFillData();
}
function FunFillList() {
    var str = '';
    if (jsonList.length > 0) {
        $.each(jsonList, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.ProjectName + '</option>';
        });
    }
    $('#listcode1').empty();
    $('#listcode2').empty();

    $('#listcode1').append(str);
    
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
    SetLeftRightListBox('btnMoveLeft', 'btnMoveRight', 'listcode1', 'listcode2');
    FunGetProjectForAutoComplete(FunListCallback, 0, 'Active',0);
    InitilizeEvents();
    FunSetTabKey();
  
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});