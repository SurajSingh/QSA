
var json;
var pagename = "/Users/Designations.aspx";
var PKID = 0;
var JsonReportLayout = null;

function FunBlank() {
    PKID = 0;
    $('#divAddNew').find('.form-control').val('');
    $('#popupTitle').find('span').html("New Designation");

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
        DeptName: $("#txtDepartment").val(), DeptDesc: $("#txtDesc").val()

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
                            //FunFillData();
                            //FunCallParentFun();
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
                    else {
                        ActiveDataTable("tbldata", [-2, -1]);
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

function FunFillData(NewPageSize, OffSet, SortBy, SortDir, ExportType) {
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
                if (jsonarr.data.Table.length > 0) {
                    if (jsonarr.data.Table[0].Result == "1") {
                        if (PKID == 0)
                        {
                            if (ExportType == null || ExportType == "") {
                            
                            $.each(jsonarr.data.Table, function (i, item) {


                                str = str + '<tr>';
                                str = str + '<td>' + item.DesigName + '</td>';
                                str = str + '<td>' + item.DesigDesc + '</td>';


                                if (IsEdit == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkEditRec tbllink" id="linkEditRec' + item.PKDesigID + '"  title="Edit Record"><i class="fa  fa-edit"></i></a></td>';
                                }
                                else {
                                    str += "<td></td>";
                                }
                                if (IsDelete == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkDeleteRec tbllink" id="linkDeleteRec' + item.PKDesigID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a></td>';
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
                            //ActiveDataTable("tbldata", [-2, -1]);
                            $("#tbldata").GenexTable(RCount, JsonReportLayout, FunFillData, true, true, true);
                            //$("#tbldata").GenexTable( 0, null, FunFillData, true, true, true);

                            $('#tbldata').on('click', '.linkEditRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkEditRec", "");
                                PKID = parseInt(newid);
                                FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "","Edit");
                            });
                            $('#tbldata').on('click', '.linkDeleteRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkDeleteRec", "");
                                FunDelete(newid);
                            });
                            }
                            else {
                                $("#tbldata").GenexTableExport(JsonReportLayout, jsonarr.data.Table, ExportType);                                
                            }
                        }
                        else {
                                FunFillDetail(jsonarr);
                        }
                    }
                    else if (jsonarr.data.Table[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr.data.Table[0].Msg);
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
    $('#popupTitle').find('span').html("Modify Designation");
    PKID = jsonarr.data.Table[0].PKDesigID;
    $("#txtDepartment").val(jsonarr.data.Table[0].DesigName);
    $("#txtDesc").val(jsonarr.data.Table[0].DesigDesc);
    opendiv('divAddNew');
}
//function FunCallParentFun() {

//    if ($("#HidHasParent").val() != "0") {

//        window.parent.FunDesigCallFromChild();
//    }
//    else {
//        OpenAlert('Saved Successfully!');
//    }
//}

function FunGridLayoutCallback(jsonarr) {

    JsonReportLayout = jsonarr;
}
function FunGridLayoutSetArray(jsonarr, id) {
    JsonReportLayout = jsonarr;
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
    InitilizeEvents();
    FunSetTabKey();
    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "","");
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }

    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);
}
$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});


$("#searchTxt").on("keyup", function () {
    var value = $(this).val().toLowerCase();
    $("tbody tr").filter(function () {
        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
});
