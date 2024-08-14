
var json;
var pagename = "/Users/Announcements.aspx";
var PKID = 0;

function FunFillData() {
    var str = "";
    if (PKID == 0) {
        
        $("#tbldata tbody").empty();
        ShowDataLoader();
    }
    else {
       
        ShowLoader();
    }

    var args = {
        PKID: PKID, ForRead: false
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


                                str = str + '<tr class="titlerow">';
                                str += '<td rowspan="2" style="width: 20px; vertical-align: top !important;"><i class="bx bx-notification font-size-24"></i></td>';
                                str = str + '<td> <h6 class="font-size-15 mb-1 fw-normal">' + item.Title + '</h6> <p class="text-muted font-size-13 mb-0"><i class="mdi mdi-calendar"></i>&nbsp;' + item.DisplayDate + '</p></td>';
                                str = str + '<td style="width:80px;">' + item.ActiveStatus + '</td>';


                                if (IsEdit == 1) {
                                    str = str + '<td style="text-align:center;width:15px;" >  <a class="linkEditRec tbllink" id="linkEditRec' + item.PKID + '"  title="Edit Record"><i class="fa  fa-edit"></i></a></td>';
                                }

                                if (IsDelete == 1) {
                                    str = str + '<td style="text-align:center;width:15px;">  <a class="linkDeleteRec tbllink" id="linkDeleteRec' + item.PKID + '"  title="Delete Record"><i class="fa  fa-trash"></i></a></td>';
                                }
                                str += '</tr>';

                                str = str + '<tr class="detailrow">';
                                str = str + '<td colspan="4"><p class="text-muted font-size-13 mb-0">' + item.Announcement + '</p></td>';
                                
                                str += '</tr>';

                            });
                            $("#tbldata tbody").append(str);
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
                    str = '<tr><td>No announcement exists</td></tr>';
                    $("#tbldata tbody").append(str);
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

function FunFillRead(ReadID) {
    var str = "";
    $("#tbldetail tbody").empty();
    ShowLoader();

    var args = {
        PKID: ReadID, ForRead: true
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
                        $.each(jsonarr, function (i, item) {


                            str = str + '<tr class="titlerow">';
                            str += '<td rowspan="2" style="width: 20px; vertical-align: top !important;"><i class="bx bx-notification font-size-24"></i></td>';
                            str = str + '<td> <h6 class="font-size-15 mb-1 fw-normal">' + item.Title + '</h6> <p class="text-muted font-size-13 mb-0"><i class="mdi mdi-calendar"></i>&nbsp;' + item.DisplayDate + '</p></td>';

                            str += '</tr>';

                            str = str + '<tr class="detailrow">';
                            str = str + '<td><p class="text-muted font-size-13 mb-0">' + item.Announcement + '</p></td>';

                            str += '</tr>';

                        });
                        $("#tbldetail tbody").append(str);
                        opendiv('divView');
                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                    }
                }
                else {
                    str = '<tr><td>No announcement exists</td></tr>';
                    $("#tbldetail tbody").append(str);
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
    $('#popupTitle').find('span').html("Modify Announcement");
    PKID = jsonarr[0].PKID;
    $("#txtTitle").val(jsonarr[0].Title);
    $("#txtDisplayDate").val(jsonarr[0].DisplayDate);
    $("#dropActiveStatus").val(jsonarr[0].ActiveStatus);
    $("#txtAnnouncement").val(jsonarr[0].Announcement);
    opendiv('divAddNew');
}



function FunBlank() {
    PKID = 0;
    $('#divAddNew').find('.form-control').val('');
    $('#popupTitle').find('span').html("New Announcement");

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
        Title: $("#txtTitle").val(), DisplayDate: $("#txtDisplayDate").val(), Announcement: $("#txtAnnouncement").val(), ActiveStatus: $("#dropActiveStatus").val()

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
                        closediv();
                        FunBlank();
                        OpenAlert('Saved Successfully!');
                        FunFillData();

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
                          
                            FunFillData();
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
    InitilizeEvents();
    FunSetTabKey();
    SetDatePicker('txtDisplayDate');

    FunFillData();
    if ($('#HidID').ValZero() != '0') {
      
        FunFillRead(parseInt($('#HidID').ValZero()));
    }

    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});