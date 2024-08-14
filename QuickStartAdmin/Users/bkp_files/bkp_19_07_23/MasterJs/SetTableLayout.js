
var json;
var pagename = "/Users/SetTableLayout.aspx";
var FKPageID = 0, GridName = "";


function FunBlank() {
    FKPageID = 0;
    GridName = "";


}



function FunValidate() {

    var fail = false;
    var fail_log = '';
    $('#tbldata').find('.form-control').each(function () {
        if (!$(this).prop('required')) {
            //do nothing
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
function FunStoreData() {
    var TableData = new Array();
    var sno = 1;
    $('#tbldata tbody tr').each(function (row, tr) {
        var trid = $(tr).attr("id");
        var FieldName = $(tr).attr("data-field");
        var ShowOnLayOutPage = $(tr).attr("data-show");
        var Editable = $(tr).attr("data-editable");

       

        TableData[row] = {
            "SNo": sno
            , "FieldName": FieldName
            , "HeaderName": $(tr).find(".colheadername").html()
            , "DisplayName": $("#txtDisplayName" + trid).val()           
            , "AutoFocus": $("#radioAutoFocus" + trid).is(':checked')
            , "Readonly": $("#chkReadonly" + trid).is(':checked')
            , "Visibility": $("#chkVisibility" + trid).is(':checked')
            , "ShowOnLayOutPage": Editable
            , "Editable": Editable
            , "IsPrint": $("#chkIsPrint" + trid).is(':checked')
            , "ColWidth": $("#txtColWidth" + trid).ValZero()+"px"
           

        }
        sno = sno + 1;
    });


    return TableData;
}
function FunSave() {

    var StrData;
    StrData = FunStoreData();
    StrData = JSON.stringify(StrData);

    var args = {
        FKPageID: FKPageID,
        GridName: GridName,
        XMLDef: StrData,
        ForAllUser: $("#chkForAllUsers").is(':checked')

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
                        HideLoader();
                        FunGetTableLayout(FKPageID, GridName, FunCallClientFunction);
                       

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
function FunResetData() {

    var StrData;
    StrData = FunStoreData();
    StrData = JSON.stringify(StrData);

    var args = {
        FKPageID: FKPageID,
        GridName: GridName, ForAllUser: $('#chkForAllUsers').is(':checked')
       

    };

    ShowLoader();
    $.ajax({

        type: "POST",
        url: pagename + "/ResetData",
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
                        FunGetTableLayout(FKPageID, GridName, FunCallClientFunction);


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
function FunCallClientFunction(jsonarr) {
    window.close()
    opener.FunDetailLayoutCallback(jsonarr, true);
    
}

function FunFillData(jsonarr) {
    

    HideDataLoader();
    if (jsonarr.length > 0) {
        $.each(jsonarr, function (i, item) {
            var str = "";
            var trID = "";

            trID = "trGRow" + i;
            str = str + '<tr id="' + trID + '" data-field="' + item.FieldName + '" data-show="' + item.ShowOnLayOutPage + '" data-editable="' + item.Editable + '">';
            str = str + '<td class="tdmove" title="Move Up-Down"></td>';
            str = str + '<td class="colheadername">' + item.HeaderName + '</td>';
            str = str +'<td><input type="text" id="txtDisplayName' + trID + '" class="form-control" max-width="50" /></td>';
            str = str + '<td><label class="checkbox"><input id="chkReadonly' + trID + '" type="checkbox" /><span class="checkmark"></span></label></td>';
            str = str+'<td><input type="text" id="txtColWidth' + trID + '" class="form-control" /></td>';
            str = str + '<td><label class="checkbox radiobox"><input name="radioAutoFocus"  id="radioAutoFocus' + trID + '" type="radio" /><span class="checkmark"></span></label></td>';
            str = str + '<td><label class="checkbox"><input id="chkVisibility' + trID + '" type="checkbox" /><span class="checkmark"></span></label></td>';
            str = str + '<td><label class="checkbox"><input id="chkIsPrint' + trID + '" type="checkbox" /><span class="checkmark"></span></label></td>';
            str += '</tr>';
            $("#tbldata tbody").append(str);
            SetNumberBox('txtColWidth' + trID, 0, false, "");

            $('#txtDisplayName' + trID).val(item.DisplayName);
            var colwidth = item.ColWidth;
            colwidth = colwidth.replace("px", "");
            $('#txtColWidth' + trID).val(colwidth);
            $('#chkReadonly' + trID).prop('checked', item.Readonly);
            $('#chkVisibility' + trID).prop('checked', item.Visibility);
            $('#chkIsPrint' + trID).prop('checked', item.IsPrint);
            if (item.AutoFocus) {
                $('#radioAutoFocus' + trID).prop('checked', true)
            }
            if (!item.ShowOnLayOutPage) {
                $("#" + trID).hide();
            }
            if (!item.Editable) {
                $("#" + trID).find("input").prop('disabled', true);
            }

           
        });

        var $table = $("#tbldata");

        $table.floatThead({
            scrollContainer: function ($table) {
                return $table.closest('.dataTables_wrapper');
            }
        });

        $(function () {
            $("#tbldata tbody").sortable();
            $("#tbldata tbody").disableSelection();
        });
 
    }

}



function InitilizeEvents() {

    $("#btnsave").click(function () {
        FunValidate();
    });
    $("#btnReset").click(function () {
        FunResetData();
    });

}

function PageLoadFun() {
    InitilizeEvents();
    FKPageID = $("#HidPageID").val();
    GridName = $("#HidGridName").val();
   
    FunGetTableLayout(FKPageID, GridName, FunFillData);



}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});