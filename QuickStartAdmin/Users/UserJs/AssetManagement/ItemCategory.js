
var json;
var pagename = "/Users/ItemCategory.aspx";
var PKID = 0;
var JsonReportLayout = null;


function FunBlank() {
    PKID = 0;
    $('#divAddNew').find('.form-control').val('');
    $('#popupTitle').find('span').html("New Asset Category");

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
        PKID: PKID,
        Code: $("#txtCode").val(), Name: $("#txtName").val(), CategDesc: $("#txtDesc").val()

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
                        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "","");

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
                    ActiveDataTable("tbldata", [-2, -1]);
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
                            FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "","");
                            OpenAlert("Record deleted successfully!");

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

function FunFillData(NewPageSize, OffSet, SortBy, SortDir, ExportType, RecType) {
    var str = "";
    if (ExportType == null || ExportType == "" || ExportType == 'undefined') {
        //if (PKID == 0) {
        //    if (tableData != null ||tableData != 'undefined') {
        //        $("#tbldata").DataTable().clear().destroy(); //$("#tbldata tbody").empty();
        //    }
        //}
        //$("#tbldata tbody").empty();
        ShowDataLoader();
    }
    else {
        ShowLoader();
    }
    //if (PKID == 0) {
    //    if (tableData != null) {
    //        $("#tbldata").DataTable().clear().destroy();

    //    }
    //    $("#tbldata tbody").empty();
    //    ShowDataLoader();
    //}
    //else {
    //    ShowLoader();
    //}

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

                            $("#tbldata tbody").empty();
                            $.each(jsonarr.data.Table, function (i, item) {


                                str = str + '<tr>';
                                str = str + '<td>' + item.CategCode + '</td>';
                                str = str + '<td>' + item.CategName + '</td>';
                                str = str + '<td>' + item.CategDesc + '</td>';


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
                                FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "", "Edit");
                            });
                            $('#tbldata').on('click', '.linkDeleteRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkDeleteRec", "");
                                FunDelete(newid);
                            });
                            } else {
                                if (RecType == "Edit") {
                                    FunFillDetail(jsonarr);
                                }
                            }
                        }
                        else {
                            $("#tbldata").GenexTableExport(JsonReportLayout, jsonarr.data.Table, ExportType);
                            //FunFillDetail(jsonarr);
                        }
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
    FunBlank();
    $('#popupTitle').find('span').html("Modify Asset Category");
    PKID = jsonarr.data.Table[0].PKID;
    $("#txtCode").val(jsonarr.data.Table[0].CategCode);
    $("#txtName").val(jsonarr.data.Table[0].CategName);
    $("#txtDesc").val(jsonarr.data.Table[0].CategDesc);
    opendiv('divAddNew');
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
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });
}

function FunGridLayoutCallback(jsonarr) {

    JsonReportLayout = jsonarr;
    PageLoadComplete();
}
function FunGridLayoutSetArray(jsonarr, id) {
    JsonReportLayout = jsonarr;
}
function PageLoadComplete() {
    //LoadEntity = LoadEntity - 1;
    //if (LoadEntity == 0) {

    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "","");
    //}

}
function PageLoadFun() {
    InitilizeEvents();
    FunSetTabKey();
  
    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "","");
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);
}

$("#searchTxt").on("keyup", function () {
    var value = $(this).val().toLowerCase();
    $("tbody tr").filter(function () {
        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
});
$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());

    SetUserRoles(PageLoadFun);
});