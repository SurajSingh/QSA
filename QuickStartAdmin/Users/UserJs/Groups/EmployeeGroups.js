
var json;
var pagename = "/Users/EmployeeGroups.aspx";
var PKID = 0;
var jsonList = null;
var JsonReportLayout = null;

function FunFillData(NewPageSize, OffSet, SortBy, SortDir, ExportType, RecType) {
    var str = "";
    if (ExportType == null || ExportType == "") {
        if (PKID == 0) {
            $("#tbldata").DataTable().clear().destroy(); //$("#tbldata tbody").empty();
        }
        
        ShowDataLoader();
    }
    else {
        ShowLoader();
    }

    var args = {
        PageSize: NewPageSize, OffSet: OffSet, SortBy: SortBy, SortDir: SortDir,
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
                        if (ExportType == null || ExportType == "") {
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

                                if (jsonarr.data.Table.length > 0) {
                                    RCount = jsonarr.data.Table[0].RCount;
                                }
                                else {
                                    RCount = 0;
                                }

                                $("#tbldata tbody").append(str);
                                $("#tbldata").GenexTable(RCount, JsonReportLayout, FunFillData, true, true, true);

                                $('#tbldata').on('click', '.linkEditRec', function (event) {
                                    event.stopImmediatePropagation();
                                    var newid = $(this).attr("id");
                                    newid = newid.replace("linkEditRec", "");
                                    PKID = parseInt(newid);
                                    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "", 'Edit');
                                    
                                });
                                $('#tbldata').on('click', '.linkView', function (event) {
                                    event.stopImmediatePropagation();
                                    var newid = $(this).attr("id");
                                    newid = newid.replace("linkView", "");
                                    PKID = parseInt(newid);
                                    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "", 'view');
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
                            $("#tbldata").GenexTableExport(JsonReportLayout, jsonarr.data.Table, ExportType);
                        }
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
    FunBlank();
    $('#popupTitle').find('span').html("Modify Employee Group");
    PKID = jsonarr.data.Table[0].PKID;
    $("#txtGroupName").val(jsonarr.data.Table[0].GroupName);
    $("#txtDescription").val(jsonarr.data.Table[0].Description);
    $.each(jsonarr.data.Table1, function (i, item) {
        $('#listcode1').val(item.FKEmpID);
        MoveListItem(false, 'listcode1', 'listcode2');
    });




    opendiv('divAddNew');
}
//function FunFillGroupDetail(jsonarr) {
//    var str = '';
//    $("#tdGroupName").html(jsonarr.data.Table[0].GroupName);

//    $.each(jsonarr.data.Table1, function (i, item) {
//        str += '<tr><td><i class="fa fa-angle-right"></i>&nbsp;' + item.EmpName + '</td></tr>';


//    });
//    $('#tblDetail tbody').empty();
//    $('#tblDetail tbody').append(str);
//    opendiv('divView');
//}
function FunBlank() {
    PKID = 0;
    FunFillList();
    $('#divAddNew').find('.form-control').val('');
    $('#popupTitle').find('span').html("New Employee Group");

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
                        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "", "");

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
                            FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "", "");
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
    /*FunFillData();*/
}
function FunFillList() {
    var str = '';
    if (jsonList.length > 0) {
        $.each(jsonList, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
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

    $("#btnRefresh").click(function () {
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "d", "");
    });
}

function PageLoadFun() {
    SetLeftRightListBox('btnMoveLeft', 'btnMoveRight', 'listcode1', 'listcode2');
    FunGetEmpForAutoComplate(FunListCallback, 0, 'Active');
    InitilizeEvents();
    FunSetTabKey();
    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "", "");

    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
}



$("#searchTxt").on("keyup", function () {
    var value = $(this).val().toLowerCase();
    $("tbody tr").filter(function () {
        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
});

function FunGridLayoutCallback(jsonarr) {

    JsonReportLayout = jsonarr;
    //PageLoadComplete();
}
function FunGridLayoutSetArray(jsonarr, id) {
    JsonReportLayout = jsonarr;
}


//function PageLoadComplete() {
//    //LoadEntity = LoadEntity - 1;
//    //if (LoadEntity == 0) {

//    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "", "");
//    //}

//}

$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});