

var pagename = "InvoiceList.aspx";
var PKID = 0;
var FKPageID = 0;
var RCount = 0;
var JsonExport = null;
var IsColCreated = false;
var JsonReportLayout = null;
var item_id

function FunFillData(NewPageSize, OffSet, SortBy, SortDir, ExportType) {
    
    if (ExportType == null || ExportType == "") {
        $("#tbldata tbody").empty();
        ShowDataLoader();
    }
    else {
        ShowLoader();
    }

    var args = {
        PageSize: NewPageSize, OffSet: OffSet, SortBy: SortBy, SortDir: SortDir,
        daterange: $("#dropaterange").val(), FromDate: $("#txtfromdate").val(), ToDate: $("#txttodate").val(),
        PKID: 0, FKProjectID: $('#txtProjectNameSrch').GenexAutoCompleteGet(''), FKClientID: $("#txtFKClientIDSrch").GenexAutoCompleteGet(''),
        InvoiceID: $("#txtInvoiceIDSrch").val(), PaymentStatus: $('#dropActiveStatusSrch').val()

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
                            var i = 0;
                            var str = "";

                            var tblid = "tbldata";
                            var tblid1 = $("#tbldata");

                            if ($("#" + tblid).parent().parent().find('.floatThead-table').length) {
                                tblid1 = $("#" + tblid).parent().parent().find('.floatThead-table');
                            }


                            $.each(jsonarr.data.Table, function () {

                                var item = this;
                                var id = "trdata" + this.PKID;
                                var strtrClass = "even";
                                if (i % 2 == 0) {
                                    strtrClass = "odd";
                                }
                                str = str + '<tr id="' + id + '" class="' + strtrClass + '">';
                                str = str + '<td style="text-align:center;" id="tdchk"> <input type="checkbox" class="tdcheck form-check-input" id="chk' + this.PKID + '" data-id="' + this.PKID + '"  /></td>';
                                str = str + '<td style="text-align:center">  <a class="linkView text-primary" target="_blank" href="PrintInvoice.aspx?PKID=' + this.PKID + '" id="linkView' + this.PKID + '"  title="Print Invoice"> <i class="uil uil-eye font-size-18t"></i></a></td>';

                                if (IsEdit == 1) {
                                    //Added by Nilesh to disable/unclickable the Edit button for Paid Invoices 01 Sept 2023 Start
                                    if (item.PaymentStatus == 'Paid' || item.PaymentStatus == 'Partial Paid') {
                                        //str = str + '<td style="text-align:center">  <a class="linkEditRec text-primary"  "  title="Edit Record"> <i class="uil uil-pen font-size-18t"></i></a></td>';
                                        str = str + '<td style="text-align:center">  <a class="linkEditRec text-primary"  "  > </a></td>';
                                    }
                                    else {
                                        str = str + '<td style="text-align:center">  <a class="linkEditRec text-primary" href="CreateInvoice.aspx?PKID=' + this.PKID + '" id="linkEditRec' + this.PKID + '"  title="Edit Record"> <i class="uil uil-pen font-size-18t"></i></a></td>';
                                    }
                                    //Added by Nilesh to disable/unclickable the Edit button for Paid Invoices 01 Sept 2023 End

                                }
                                else {
                                    str += "<td></td>";
                                }
                              
                                if (IsDelete == 1) {
                                    if (item.PaymentStatus == 'Paid' || item.PaymentStatus == 'Partial Paid') {
                                        //str = str = str + '<td style="text-align:center">  <a class="linkDeleteRec text-danger" id="linkDeleteRec' + this.PKID + '"  title="Delete Record"><i class="uil uil-trash-alt font-size-18"></i></a></td>';;
                                        str = str + '<td style="text-align:center">  <a class="linkDeleteRec text-danger" id="linkDeleteRec' + this.PKID + '"  title="Delete Record"></a></td>';
                                    }
                                    else {
                                        str = str + '<td style="text-align:center">  <a class="linkDeleteRec text-danger" id="linkDeleteRec' + this.PKID + '"  title="Delete Record"><i class="uil uil-trash-alt font-size-18"></i></a></td>';
                                    }                                    
                                }
                                else {
                                    str += "<td></td>";
                                }

                                //To show archieved icon in the table coloumn - Nilesh --> Start
                                if (item.PaymentStatus == 'Paid') {
                                    //str = str = str + '<td style="text-align:center">  <a class="linkDeleteRec text-danger" id="linkDeleteRec' + this.PKID + '"  title="Delete Record"><i class="uil uil-trash-alt font-size-18"></i></a></td>';;
                                    str = str + '<td style="text-align:center">  <a class="linkArchiveRec text-danger" id="linkArchiveRec' + this.PKID + '"  title="Archive Record"><i class="uil uil-file font-size-18"></i></a></td>';
                                }
                                else {
                                    str += "<td></td>";
                                }
                                //To show archieved icon in the table coloumn - Nilesh --> End
                                var TranCurrency = this.Symbol;
                                tblid1.find('thead th').each(function (row, th) {
                                    var attr = $(th).attr('data-column');
                                    var strval = '';
                                    var strclass = '';
                                    if (typeof attr != typeof undefined && attr != false) {
                                        strclass = 'td' + attr;
                                        if (!$(th).hasClass('hidetd')) {
                                            if ($(th).hasClass('tdclsnum')) {
                                                strclass = strclass + ' tdclsnum';
                                            }
                                            if ($(th).hasClass('bold')) {
                                                strclass = strclass + ' bold';
                                            }
                                            strval = item[attr];
                                            if ($(th).hasClass('tdclscurrency')) {
                                                strclass = strclass + ' tdclscurrency';
                                               
                                                strval = TranCurrency + ' ' + strval;
                                            }
                                            if ($(th).hasClass('tdclsPer')) {
                                                strclass = strclass + ' tdclsPer';
                                               
                                                strval = strval+'%';
                                            }


                                        }

                                        if ($(th).hasClass('tdApproveStatus')) {
                                            //if (item[attr] != undefined && item[attr] != null && item[attr] != '') {

                                            if (item["ApprovedStatus"] === 'Pending') {
                                                strval = '<td id="' + attr + item.PKID + '" style="text-align:center;" data-value="' + item.ApprovedStatus + '"> <img src="images/submitted.png" title="Submitted" /></td>';
                                            }
                                            if (item["ApprovedStatus"] === 'Approved') {
                                                strval = '<td id="' + attr + item.PKID + '" style="text-align:center;" data-value="' + item.ApprovedStatus + '"> <img src="images/approved.png" title="Approved" /></td>';
                                            }
                                            if (item["ApprovedStatus"] === 'Rejected') {
                                                strval = '<td id="' + attr + item.PKID + '" style="text-align:center;" data-value="' + item.ApproveSdtatus + '"> <img src="images/rejected.png" title="Rejected" /></td>';
                                            }
                                            str = str + strval;
                                            //str = str + strval;
                                        }
                                        else
                                        {
                                            if ($(th).hasClass('hidetd')) {
                                                str = str + '<td id="' + attr + item.PKID + '" class="' + strclass + '" style="display:none; border: none;">' + strval + '</td>';
                                            }
                                            else {
                                                str = str + '<td id="' + attr + item.PKID + '" class="' + strclass + '">' + strval + '</td>';
                                            }
                                        }
                                        //str = str + '<td class="' + strclass + '">' + strval + '</td>';
                                    }



                                });



                                i++;
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
                           

                            $('#tbldata').on('click', '.linkDeleteRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkDeleteRec", "");
                                FunDelete(newid);
                            });

                            $('#tbldata').on('click', '.linkArchiveRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkArchiveRec", "");
                                FunArchive(newid);
                            });

                            $("#chkAll").click(function () {
                                var IsChecked = $('#chkAll').is(':checked');

                                $(".tdcheck").prop("checked", IsChecked);

                            });

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


//Added by Nilesh for approval featur
function FunValidate(Action1) {

    if (Action1 == 'Approved' || Action1 == 'Rejected') {
        if (Action1 == 'Approved') {
            $('#ConfirmApproveText').html('Do you want to approve selected entries?');
        }
        else {

            $('#ConfirmApproveText').html('Do you want to reject selected entries?');
        }
        ApproveType = Action1;
        opendivid = 'divConfirmApprove';
        $('#otherdiv').fadeIn("slow");
        $('#' + opendivid).fadeIn("slow");
    }
    else {
        FunSave(Action1);
    }
}
function FunSave(Action1) {
    ProgCount = 0;
    var item_id = null;
    ShowLoader();
    $('#tbldata tr').find('td:first input[type=checkbox]:checked').each((idx, chk) => {
        var tdArr = $(chk).parent().siblings();
         item_id = $(chk).data('id');
    });   


    var args = {
        PKID: item_id, ApproveAction: Action1, ApproveRemark: ''
    };

    $.ajax({

        type: "POST",
        url: pagename + "/SaveData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            HideLoader();
            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {

                    if (jsonarr[0].Result == "1") {
                        if (Action1 == 'Approved') {
                            //FunBlank();
                            PrintPKID = jsonarr[0].PKID;
                            OpenAlert('Approved Successfully!');
                        }
                        else {
                            PrintPKID = jsonarr[0].PKID;
                            OpenAlert('Rejected Successfully!');
                        }
                        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
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
//Added By nilesh for approval fetaure

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
                            PKID = 0;
                            IsColCreated = false;
                            RCount = 0;
                            $("#tbldata").GenexTableDestroy();
                            FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
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

//Added by Nilesh to implement Archival functionality - start
function FunArchive(RecID) {
    if (confirm("Do you want to archive this record?")) {
        var args = { PKID: RecID };
        ShowLoader();
        $.ajax({

            type: "POST",
            url: pagename + "/ArchiveData",
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
                            PKID = 0;
                            IsColCreated = false;
                            RCount = 0;
                            $("#tbldata").GenexTableDestroy();
                            FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
                            OpenAlert("Record Arvchived successfully!");

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
//Added by Nilesh to implement Archival functionality - start

function InitilizeEvents() {
    $("#btnApprove").click(function () {

        FunValidate('Approved');
    });
    $("#btnReject").click(function () {
        FunValidate('Rejected');
    });
    $("#btnApproveOK").click(function () {
        closediv();
        FunSave(ApproveType);
    });
   
    $("#btnRefresh").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });
    $("#btnSearch").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });

}

function FunSetPageRoles() {
    
    if (IsApprove == false) {
        $('#tbldata').find('.tdApprove').hide();
    }

    //FunShowHideEmployee();

}
function SetOtherRoles(jsonarr) {


    if (jsonarr.length > 0) {
        if (jsonarr[0].IsFound == 1) {
            IsApprove = true;
        }        
    }
    if (IsApprove) {
        $('#btnApprove').show();
        $('#btnReject').show();
    }

    FunSetPageRoles();
    PageLoadComplete();

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
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
    SetDatePicker("txtfromdate");
    SetDatePicker("txttodate");
    LoadEntity = 3;
    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");

    GetUserInRole(SetOtherRoles, "78");
    FunGetClientForAutoComplete(FunClientCallBack, 0, '');
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);
   
  
    
}
function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}



function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}

function FunProjectCallBack(JsonArr) {   
    $("#dropFKProjectIDSrch").GenexAutoComplete(JsonArr, "ProjectID,Project,ClientID");  
    PageLoadComplete();
}
function FunClientCallBack(JsonArr) {
    $("#txtFKClientIDSrch").GenexAutoComplete(JsonArr, "ClientID,Name,Status");   
    PageLoadComplete();
}


$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});