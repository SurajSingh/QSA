

var pagename = "PaymentReview.aspx";
var PKID = 0;
var FKPageID = 0;
var RCount = 0;
var JsonExport = null;
var IsColCreated = false;
var JsonReportLayout = null;

function FunFillData(NewPageSize, OffSet, SortBy, SortDir, ExportType) {
    var str = "";
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
        PKID: 0,  FKClientID: $("#txtFKClientIDSrch").GenexAutoCompleteGet(''),
        PayID: $("#txtInvoiceIDSrch").val(), FKPaymentTypeID: $('#dropFKPaymentTypeIDSrch').ValZero(), FKPaymodeID: $('#dropFKPaymodeIDSrch').ValZero()

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
                                str = str + '<td style="text-align:center">  <a class="linkView text-primary"  id="linkView' + this.PKID + '"  title="View Detail"> <i class="uil uil-eye font-size-18t"></i></a></td>';

                                if (IsEdit == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkEditRec text-primary" href="ReceivePayment.aspx?PKID='+this.PKID+'" id="linkEditRec' + this.PKID + '"  title="Edit Record"> <i class="uil uil-pen font-size-18t"></i></a></td>';

                                }
                                else {
                                    str += "<td></td>";
                                }
                              
                                if (IsDelete == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkDeleteRec text-danger" id="linkDeleteRec' + this.PKID + '"  title="Delete Record"><i class="uil uil-trash-alt font-size-18"></i></a></td>';
                                }
                                else {
                                    str += "<td></td>";
                                }
                                var TranCurrency = CurrencyName;
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

                                        str = str + '<td class="' + strclass + '">' + strval + '</td>';
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
                           
                            $('#tbldata').on('click', '.linkView', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkView", "");
                                PKID = parseInt(newid);
                                FunFillDetail();

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

function FunFillDetail() {
    ShowLoader();
    var args = {
        PageSize: 0, OffSet: 0, SortBy: "", SortDir: "",
        daterange: 'All', FromDate: '', ToDate: '',
        PKID: PKID, FKClientID: '',
        PayID: '', FKPaymentTypeID:0, FKPaymodeID: 0


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
                HideLoader();
                if (jsonarr.data.Table.length > 0) {
                    if (jsonarr.data.Table[0].Result == "1") {
                       
                        PKID = jsonarr.data.Table[0].PKID;

                        $("#spanClientName").html(jsonarr.data.Table[0].ClientName); 
                        $('#txtPayID').html(jsonarr.data.Table[0].PayID);
                        $('#txtTranDate').html(jsonarr.data.Table[0].TranDate);
                        $('#dropFKPaymentTypeID').html(jsonarr.data.Table[0].PaymentType);
                        $('#dropFKPaymodeID').html(jsonarr.data.Table[0].PaymentMode);
                        $('#txtTranID').html(jsonarr.data.Table[0].TranID);
                        $('#txtAmount').html(jsonarr.data.Table[0].Amount.toFixed(2));
                        if (jsonarr.data.Table[0].IsRetainer) {
                            $('#chkIsRetainer').html('Yes');
                        }
                        else {
                            $('#chkIsRetainer').html('No');
                        }
                       


                        if (jsonarr.data.Table[0].IsRetainer) {
                            $('#divInvoice').hide();
                        }
                        else {
                            $('#divInvoice').show();

                            $('#tblAdjustList tbody').empty();
                            $.each(jsonarr.data.Table1, function () {
                                var str = '';                                

                                $('#tblAdjustList tbody').append(str);
                                if (this.IsSelected == true) {
                                    var trID = 'trInvoice' + this.PKID;
                                    str = str + '<tr id="' + trID + '">';
                                    str = str + '<td><a target="_blank" class="tbllink1" href="PrintInvoice.aspx?PKID=' + this.PKID + '">' + this.InvoiceID + '</a></td>';
                                    str = str + '<td>' + this.ProjectName + '</td>';
                                    str = str + '<td>' + this.InvDate + '</td>';
                                    str = str + '<td style="text-align:right;">' + this.NetAmount.toFixed(2) + '</td>';
                                    str = str + '<td style="text-align:right;">' + this.NetDueAmount.toFixed(2) + '</td>';
                                    str = str + '<td style="text-align:right;">' + this.AdjAmt.toFixed(2) + '</td>';
                                    str += '</tr>';
                                    $('#tblAdjustList tbody').append(str);
                                }   
                            });
                        }




                        opendiv('divViewDetail');
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



function InitilizeEvents() {

   
    $("#btnSearch").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
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
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
    SetDatePicker("txtfromdate");
    SetDatePicker("txttodate");
    LoadEntity = 4;
    FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");

   
    FunGetClientForAutoComplete(FunClientCallBack, 0, '');
    FunFillPaymentModeMaster(FunPaymentModeMasterCallback);
    FunFillPaymentTypeMaster(FunPaymentTypeMasterCallback);
    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);
   
  
    
}
function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}



function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}

function FunPaymentModeMasterCallback(str) {
    $('#dropFKPaymodeIDSrch').append(str);

    PageLoadComplete();
}
function FunPaymentTypeMasterCallback(str) {
    $('#dropFKPaymentTypeIDSrch').append(str);

    PageLoadComplete();
}
function FunClientCallBack(JsonArr) {
    $("#txtFKClientIDSrch").GenexAutoComplete(JsonArr, "ClientID,Name,Status");   
    PageLoadComplete();
}


$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});