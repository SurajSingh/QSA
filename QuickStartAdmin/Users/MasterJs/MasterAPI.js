

var jsonGoodsServices = null;
var jsonarrPage = null;
var MasterAPIURL = "/Users/MasterAPI/MasterPageAPI.aspx";
function htmlDecode(value) {
    return $("<textarea/>").html(value).text();
}
function htmlEncode(value) {
    return $('<textarea/>').text(value).html();
}
function FunDownloadPDF(HTML, FileName, FKPageID) {
    if (FKPageID == null) {
        FKPageID = 0;
    }
    var jsonarr = [];
    var args = {
        HTML: HTML, FileName: FileName, FKPageID: FKPageID
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: "/Users/MasterAPI/FileOperationAPI.aspx" + "/ExportHTMLToPDF",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var str = htmlDecode(data.d);
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    if (jsonarr[0].Result == "1") {
                        window.open("/TempFile/" + jsonarr[0].Msg, '', 'height=500,width=500,location=no,toolbar=no,menubar=no');
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
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();

        }

    });
}
function FunFillPageForAutoAcomplete() {

    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetPageForAutoAcomplete",

        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: true,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var str = htmlDecode(data.d);

                var jsonarrPage = $.parseJSON(str);

                if (jsonarrPage.length > 0) {
                    $("#txtSearchPage").GenexAutoCompleteWithCallBack(jsonarrPage, FunOpenQuickPage);
                    $("#txtSearchPage").keydown(function (e) {
                        if (e.key == "Enter") {
                            var $canfocus = $(':tabbable:visible');
                            e.preventDefault();
                            var index = $canfocus.index(document.activeElement) + 1;
                            if (index >= $canfocus.length) index = 0;
                            $canfocus.eq(index).focus();
                        }
                    });

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

function FunFillNotification() {

    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetNotification",

        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: true,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var str = '';
                var announCount = 0;
                var jsonarr = $.parseJSON(data.d);
                if (jsonarr.data.Table.length > 0 && jsonarr.data.Table2[0].IsAnnouncement == true) {

                    $.each(jsonarr.data.Table, function () {
                        if (this.IsRead == 0) {
                            announCount = announCount + 1;
                        }
                        str += ' <a href="Announcements.aspx?PKID='+this.PKID+'" class="text-reset notification-item">';
                        str += ' <div class="d-flex align-items-start"><div class="flex-shrink-0 me-3"><div class="avatar-xs"><span class="avatar-title bg-primary rounded-circle font-size-16">';
                        str += '<i class="uil-volume"></i></span></div></div><div class="flex-grow-1"><h6 class="mb-1">'+this.Title+'</h6><div class="font-size-12 text-muted">';
                        str += '<p class="mb-1">' + this.Announcement + '</p><p class="mb-0"><i class="mdi mdi-clock-outline"></i>&nbsp;' + this.DisplayDate+'</p></div></div></div>';
                        str += '</a>';
                    });
                }
                $('#divAnnounceNotification').html(str);
                if (announCount > 0) {
                    $('#spanannouncecount').html(announCount);
                }
                if (jsonarr.data.Table2[0].IsAnnouncement == false) {
                    $('#announcenotiviewmore').hide();
                }
                str = '';
                announCount = 0;
                if (jsonarr.data.Table1.length > 0 && jsonarr.data.Table3[0].IsSchedue == true) {

                    $.each(jsonarr.data.Table1, function () {
                        if (this.IsRead == 0) {
                            announCount = announCount + 1;
                        }
                        str += ' <a href="Schedule.aspx?PKID=' + this.PKID + '" class="text-reset notification-item">';
                        str += ' <div class="d-flex align-items-start"><div class="flex-shrink-0 me-3"><div class="avatar-xs"><span class="avatar-title bg-primary rounded-circle font-size-16">';
                        str += '<i class=""uil-schedule"></i></span></div></div><div class="flex-grow-1"><h6 class="mb-1">' + this.ClientName + '</h6><div class="font-size-12 text-muted">';
                        var strDate = this.FromDate;
                        if (this.FromDate != this.ToDate) {
                            strDate = 'From ' + strDate + ' to ' + this.ToDate;
                        }
                        if (jsonarr.data.Table[0].FromTime != '') {
                            strDate = strDate + ' @' + this.FromTime
                        }

                        str += '<p class="mb-1">' + this.Remarks + '</p><p class="mb-0"><i class="mdi mdi-clock-outline"></i>&nbsp;' + strDate + '</p></div></div></div>';
                        str += '</a>';
                    });
                }
                if (jsonarr.data.Table3[0].IsSchedue == false) {
                    $('#Schedulenotiviewmore').hide();
                }

             
                if (announCount>0) {
                    $('#divScheduleNotificationCount').html(announCount);
                }
                $('#divScheduleNotification').html(str);
            }


        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}

function FunOpenQuickPage(item, inputid) {
    if ($("#" + inputid).GenexAutoCompleteGet("") != "") {
        location.href = item.PKID;
    }
}
function FunFillTimezone(callback) {
    var str = "";
    var args = {
    };
   
    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetTimeZone",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: true,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str = str + '<option value="' + item.PKTimeZoneID + '">' + item.DisplayName + '</option>';
                    });
                  
                    
                }
                callback('<option value="0">Select One</option>' + str);
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}
function FunFillCurrency(callback) {
    var str = "";
    var args = {
    };
  
    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetCurrency",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str = str + '<option value="' + item.PKCurrencyID + '">' + item.ShortName + '(' + item.Symbol + ')' + '</option>';
                    });
                  

                }
                callback('<option value="0">Select One</option>' + str);
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}

function FunFillBillingFrequency(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetBillingFrequency",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str = str + '<option value="' + item.PKID + '">' + item.Frequency  + '</option>';
                    });


                }
                callback('<option value="0">Select One</option>' + str);
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}
function FunFillContractType(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetContractType",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str = str + '<option value="' + item.PKID + '">' + item.ContractType + '</option>';
                    });


                }
                callback('<option value="0">Select One</option>' + str);
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}

function FunFillPaymentModeMaster(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetPaymentModeMaster",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str = str + '<option value="' + item.PKID + '">' + item.PaymentMode + '</option>';
                    });


                }
                callback('<option value="0">Select One</option>' + str);
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}
function FunFillPaymentTypeMaster(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetPaymentTypeMaster",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str = str + '<option value="' + item.PKID + '">' + item.PaymentType + '</option>';
                    });


                }
                callback('<option value="0">Select One</option>' + str);
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}

function FunGetTableLayout(FKPageID, TableID, callback) {

    var args = {
        FKPageID: FKPageID, TableID: TableID
    };

    //ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetTableLayout",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {

                var jsonarr = $.parseJSON(data.d);
                //HideLoader();
                callback(jsonarr);

            }
            else {
                //HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}

//Company Configuration
function FunGetConfiguration(CallBack, ApplyOn) {
    var jsonarr = [];
    var args = {
        ApplyOn: ApplyOn
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetConfiguration",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {

                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                CallBack(jsonarr)


            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();

        }

    });
}


function FunFillTaxMaster(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetTaxMaster",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str = str + '<option value="' + item.PKID + '" data-per="' + item.TaxPercentage+'">' + item.TaxName + '</option>';
                    });


                }
                callback('<option value="0">Select One</option>' + str);
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}
function FunFillPaymentTerm(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetPaymentTerm",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str = str + '<option value="' + item.PKID + '" data-GraceDays="' + item.GraceDays + '">' + item.TermTitle + '</option>';
                    });


                }
                callback('<option value="0">Select One</option>' + str);
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}

function FunGetEmpForAutoComplate(callback, PKID, ActiveStatus) {

    var jsonarr = [];
    var args = {
        PKID: PKID, ActiveStatus: ActiveStatus
    };

    //ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetEmpForAutoComplate",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var str = '';
                var jsonarr = $.parseJSON(data.d);
                //HideLoader();
                callback(jsonarr);

            }
            else {
                //HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();

        }

    });
}
function FunGetClientForAutoComplete(callback, PKID, ActiveStatus) {

    var jsonarr = [];
    var args = {
        PKID: PKID, ActiveStatus: ActiveStatus
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetClientForAutoComplete",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var str = '';
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                callback(jsonarr);

            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();

        }

    });
}
function FunGetProjectForAutoComplete(callback, PKID, ActiveStatus, FKClientID) {

    var jsonarr = [];
    var args = {
        PKID: PKID, ActiveStatus: ActiveStatus, FKClientID: FKClientID
    };

    //ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetProjectForAutoComplete",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var str = '';
                var jsonarr = $.parseJSON(data.d);
                //HideLoader();
                callback(jsonarr);

            }
            else {
                //HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();

        }

    });
}
function FunGetTaskForAutoComplete(callback, PKID, FKDeptID, TType,ActiveStatus) {

    var jsonarr = [];
    var args = {
        PKID: PKID, FKDeptID: FKDeptID, TType: TType, ActiveStatus: ActiveStatus
    };

    //ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetTaskForAutoComplete",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var str = '';
                var jsonarr = $.parseJSON(data.d);
                //HideLoader();
                callback(jsonarr);

            }
            else {
                
                //HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();

        }

    });
}

function FunFillDept(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetDepartment",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: true,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {
                        str = str + '<option value="' + item.PKDeptID + '">' + item.DeptName + '</option>';
                    });


                }
                callback('<option value="0">Select One</option>' + str);
            }
            else {
                HideLoader();
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}