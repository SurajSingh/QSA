
var json;
var pagename = "Schedule.aspx";
var PKID = 0;
var PKRoleGroupID = 0;
var IsValidLogin = 0;
var FKPageID = 0;
var RCount = 0;
var JsonExport = null;
var IsColCreated = false;
var JsonReportLayout = null;
var JsonSchedueStatus = null;

function FunFillData(NewPageSize, OffSet, SortBy, SortDir, ExportType) {
    var str = "";
    if (ExportType == null || ExportType == "") {
        $("#tbldata").empty();
        ShowDataLoader();
    }
    else {
        ShowLoader();
    }

    var args = {
        PageSize: NewPageSize, OffSet: OffSet, SortBy: SortBy, SortDir: SortDir,
        PKID: 0,
        daterange: $("#dropaterange").val(), FromDate: $("#txtfromdate").val(), ToDate: $("#txttodate").val(),
        FKEmpID: $("#txtFKEmpIDSrch").GenexAutoCompleteGet(''),
        FKClientID: $("#txtFKClientIDSrch").GenexAutoCompleteGet(''),
        FKProjectID: $('#txtFKProjectIDSrch').GenexAutoCompleteGet(''),
        FKStatusID: $("#dropFKStatusIDSrch").ValZero(), FKWorkTypeID: $("#dropFKWorkTypeIDSrch").ValZero()

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




                            $.each(jsonarr.data.Table, function () {

                                var item = this;
                                var id = "trdata" + this.PKUserID;
                                var strtrClass = "";

                                str = str + '<li id="' + id + '" class="' + strtrClass + '"><div class="ulreport-box">';

                                str = str + '<div class="cellbox" style="width: 140px;">';
                                str = str + '<div class="datebox-outer"> <div class="datebox dateviewdet">';
                                str += '<div class="datedetail">' + this.DayName1 + ' <span>' + this.Day1 + '</span></div>';
                                str += '<div class="monthdetail">' + this.Month1 + ' ' + this.Year1 + ' </div>';
                                str += '</div></div>';

                                if (this.FromDate != this.ToDate) {
                                    str = str + ' <div class="datebox-arrow"><i class="fa fa-arrow-right"></i></div><div  class="datebox-outer"> <div class="datebox dateviewdet">';
                                    str += '<div class="datedetail">' + this.DayName2 + ' <span>' + this.Day2 + '</span></div>';
                                    str += '<div class="monthdetail">' + this.Month2 + ' ' + this.Year2 + ' </div>';
                                    str += '</div></div>';
                                }
                                str += '</div>';

                                str += ' <div class="cellbox">';
                                //Middle Box Row
                                str += '<div class="row">';
                                str += '<div class="col-sm-6"> <h2>' + this.ClientName + '</h2><div class="descbox"><p>' + this.Remarks + '</p></div></div>';

                                str += ' <div class="col-sm-3 worktype">';
                                if (this.FromTime != '') {
                                    str += '<div class="divtime"><i class="fa fa-clock"></i>&nbsp;' + this.FromTime + '</div>';
                                }
                                str += '<div class="worktype' + this.FKWorkTypeID + '">' + this.WorkType + '</div>'

                                

                                str += '</div>';

                                //Status box
                                str += '<div class="col-sm-3 text-right" style="position:relative;"><a  class="btn waves-effect btnstatus btnstatus' + this.FKStatusID + '" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">' + this.StatusTitle + ' <i class="uil-angle-down d-none d-xl-inline-block font-size-15"></i></a>';

                                str += FunStatusType(this.PKID,this.FKStatusID);
                                str += '</div>';
                                //End Status Box


                                str += '</div>';
                                //End Middle Box Row


                                //Middle Botton
                                str += ' <div class="row"><div class="col-12">';
                                str += '<div class="bx-pull-left"><div class="empbox"><i class="fa fa-user-friends"></i>&nbsp;' + this.EmpList + '</div></div>';

                                //Button
                                str += ' <div class="bx-pull-right customlink">';
                                str += '<a class="linkView" id="linkView' + this.PKID + '" title="View Detail"><i class="fa  fa-list"></i></a>';
                                if (IsEdit) {
                                    str += '<a class="linkEditRec" id="linkEditRec' + this.PKID + '" title="Edit Record"><i class="fa  fa-edit"></i></a>';

                                }
                                str += ' <a class="linkEmail" id="linkEmail' + this.PKID + '" title="Email"><i class="fa  fa-envelope"></i></a>';
                                if (IsDelete) {
                                    str += ' <a class="linkDeleteRec" id="linkDeleteRec' + this.PKID + '" title="Delete Record"><i class="fa  fa-trash"></i></a>';

                                }
                                str += ' </div>';

                                //End Button
                                str += '</div></div>';

                                //End Middle 
                                str += '</div>'


                                str = str + '</div></li>';
                                i++;

                            });
                            
                            if (jsonarr.data.Table.length > 0) {
                                RCount = jsonarr.data.Table[0].RCount;
                            }
                            else {
                                RCount = 0;
                            }
                            $("#tbldata").append(str);

                            $("#tbldata").GenexList(RCount, FunFillData, true);

                            $('#tbldata').on('click', '.linkEditRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkEditRec", "");
                                PKID = parseInt(newid);
                                FunFillDetail('edit');

                            });
                            $('#tbldata').on('click', '.linkView', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkView", "");
                                PKID = parseInt(newid);
                                FunFillDetail('view');

                            });

                            $('#tbldata').on('click', '.linkEmail', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkEmail", "");
                                FunSendScheduleEmail(newid);
                            });

                            $('#tbldata').on('click', '.linkChangeStatus', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("data-pkid");
                                var newid1 = $(this).attr("data-status");                               
                                FunUpdateScheduleStatus(newid, newid1);
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
function FunFillDetail(RecType) {
    ShowLoader();
    var args = {
        PageSize: 0, OffSet: 0, SortBy: '', SortDir: '',
        PKID: PKID, daterange: 'all', FromDate: '', ToDate: '', FKEmpID: '', FKClientID: '', FKProjectID: '', FKStatusID: 0, FKWorkTypeID: 0


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
                        if (RecType == 'edit') {

                            FunBlank();
                            $('#popupTitle').find('span').html("Modify Client Schedule");
                            PKID = jsonarr.data.Table[0].PKID;

                            $("#txtStartDate").val(jsonarr.data.Table[0].FromDate);
                            $("#txtEndDate").val(jsonarr.data.Table[0].ToDate);
                            $("#txtTime").val(jsonarr.data.Table[0].FromTime);

                            $("#dropFKWorkTypeID").val(jsonarr.data.Table[0].FKWorkTypeID);

                            $("#txtFKClientID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKClientID, jsonarr.data.Table[0].ClientName);
                            $("#txtFKProjectID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKProjectID, jsonarr.data.Table[0].ProjectName);

                            $("#dropFKStatusID").val(jsonarr.data.Table[0].FKStatusID);
                            $("#txtRemarks").val(jsonarr.data.Table[0].Remarks);


                            $.each(jsonarr.data.Table1, function () {

                                var id = 'divFKEmpID';
                                var containerid = id + '_container';
                                if ($("#" + containerid).find("input[value='" + this.FKEmpID + "'][type='checkbox']").length) {
                                    var ctrl = $("#" + containerid).find("input[value='" + this.FKEmpID + + "'][type='checkbox']")
                                    var val = this.FKEmpID;
                                    var name = this.EmpName;
                                    $("#" + containerid).find("input[value='" + this.FKEmpID + + "'][type='checkbox']").prop("checked", true);
                                    var elespan = '<span data-val="' + val + '"><label>' + this.EmpName + '</label><i class="fa  fa-trash"></i></span>';
                                    $('#divFKEmpID').append(elespan);
                                }

                            });


                            opendiv('divAddNew');
                        }
                        else {

                            var strDate = jsonarr.data.Table[0].FromDate;
                            if (jsonarr.data.Table[0].FromDate != jsonarr.data.Table[0].ToDate) {
                                strDate = 'From ' + strDate + ' to ' + jsonarr.data.Table[0].ToDate;
                            }
                            if (jsonarr.data.Table[0].FromTime != '') {
                                strDate = strDate + ' @' + jsonarr.data.Table[0].FromTime
                            }
                            $("#tdDate").html(strDate);
                           

                            $("#tdEmployee").html(jsonarr.data.Table[0].EmpList);

                            $("#tdClient").html(jsonarr.data.Table[0].ClientName + ' (' + jsonarr.data.Table[0].ProjectName+')');

                            $("#tdStatus").html(jsonarr.data.Table[0].StatusTitle);
                            $("#tdRemark").html(jsonarr.data.Table[0].Remarks);
                            opendiv('divViewDetail');
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

function FunStatusType(RecID,FKStatusID) {
    var str = '<div class="dropdown-menu">';
    if (JsonSchedueStatus.length > 0) {
        $.each(JsonSchedueStatus, function (i, item) {
            if (item.PKID != FKStatusID) {
                str += '<a data-pkid="' + RecID + '" data-status="'+item.PKID+'" class="dropdown-item linkChangeStatus" id="linkChangeStatus' + RecID + '_' + item.PKID + '" >' + item.StatusTitle + '</a>';

            }

        });


    }
    str += '</div>';
    return str;
}
function FunBlank() {
    PKID = 0;

    $('#divAddNew').find('.form-control').val('');
    $('#txtFKProjectID').GenexAutoCompleteBlank();
   
    $('#txtFKClientID').GenexAutoCompleteBlank();

    var id ='divFKEmpID';
   
    $('#divFKEmpID').children().remove();
    var containerid = id + '_container';
    $("#" + containerid).find("ul").find('input').prop("checked", false);





    $('#popupTitle').find('span').html("New Schedule");

}



function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtStartDate").val() == "") {
        fail = true;
        $("#txtStartDate").css("border-color", ColorE);
        strError += "<li>Enter From Date</li>";
    }
    else {
        $("#txtStartDate").css("border-color", ColorN);
    }
    if ($("#txtEndDate").val() == "") {
        fail = true;
        $("#txtEndDate").css("border-color", ColorE);
        strError += "<li>Enter To Date</li>";
    }
    else {
        $("#txtEndDate").css("border-color", ColorN);
    }
    if ($("#dropFKWorkTypeID").ValZero() == "0") {
        fail = true;
        $("#dropFKWorkTypeID").css("border-color", ColorE);
        strError += "<li>Select Work Type</li>";
    }
    else {
        $("#dropFKWorkTypeID").css("border-color", ColorN);
    }
    if ($("#txtFKClientID").GenexAutoCompleteGet('0') == "0") {
        fail = true;
        $("#txtFKClientID").css("border-color", ColorE);
        strError += "<li>Select Client</li>";
    }
    else {
        $("#txtFKClientID").css("border-color", ColorN);
    }
    if ($("#txtFKProjectID").GenexAutoCompleteGet('0') == "0") {
        fail = true;
        $("#txtFKProjectID").css("border-color", ColorE);
        strError += "<li>Select Project</li>";
    }
    else {
        $("#txtFKProjectID").css("border-color", ColorN);
    }
    if ($("#divFKEmpID").GenexMultiSelectGet() == "") {
        fail = true;
        $("#divFKEmpID").css("border-color", ColorE);
        strError += "<li>Select Employee</li>";
    }
    else {
        $("#divFKEmpID").css("border-color", ColorN);
    }
    if ($("#dropFKStatusID").ValZero() == "0") {
        fail = true;
        $("#dropFKStatusID").css("border-color", ColorE);
        strError += "<li>Select Default Status</li>";
    }
    else {
        $("#dropFKStatusID").css("border-color", ColorN);
    }
    if (!fail) {
        $("#divValidateSummary").hide();
        FunSave();

    } else {
        $("#divValidateSummary").show();
        $("#divValidateSummary").find(".validate-box ul").empty();
        $("#divValidateSummary").find(".validate-box ul").html(fail_log + strError);
        $('html, body').animate({
            scrollTop: $("#divValidateSummary").offset().top
        }, 500);
        return false;
    }
}

function FunSave() {



    var args = {
        PKID: PKID, FKProjectID: $("#txtFKProjectID").GenexAutoCompleteGet('0'), FromDate: $("#txtStartDate").val(), ToDate: $("#txtEndDate").val(),
        FromTime: $("#txtTime").val(), FKWorkTypeID: $("#dropFKWorkTypeID").ValZero(), FKStatusID: $("#dropFKStatusID").ValZero(),
        Remarks: $("#txtRemarks").val(), StrEmp: $("#divFKEmpID").GenexMultiSelectGet()
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
                        closediv();

                        HideLoader();
                        FunBlank();
                        OpenAlert('Saved Successfully!');

                        IsColCreated = false;
                        RCount = 0;
                        $("#tbldata").GenexTableDestroy();
                        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "D", "");

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

function FunUpdateScheduleStatus(RecID,FKStatusID) {
    if (confirm("Do you want to update the status?")) {
        var args = { PKID: RecID, FKStatusID: FKStatusID };
        ShowLoader();
        $.ajax({

            type: "POST",
            url: pagename + "/UpdateScheduleStatus",
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
                            OpenAlert("Record updated successfully!");

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

function FunSendScheduleEmail(RecID) {
    if (confirm("Do you want to send email?")) {
        var args = { PKID: RecID };
        ShowLoader();
        $.ajax({

            type: "POST",
            url: pagename + "/SendEmail",
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
                           
                            OpenAlert("Your request submitted successfully");

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
            opendiv("divAddNew");
        }
    });

    $("#btnSearch").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });
    $("#btnSearch1").click(function () {
        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });

}
function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    if (LoadEntity == 0) {
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    }
}
function PageLoadFun() {
    InitilizeEvents();
    FunSetTabKey();
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
    SetDatePicker("txtfromdate");
    SetDatePicker("txttodate");

    SetDatePicker("txtStartDate");
    SetDatePicker("txtEndDate");

    SetTimePicker('txtTime');




    LoadEntity = 5;

   
    FunGetClientForAutoComplete(FunClientCallBack, 0, '');
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, 'Active');
    FunFillWorkTypeMaster();
    FunFillScheduleStatusMaster();




}
function FunFillWorkTypeMaster() {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetWorkTypeMaster",
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
                        str = str + '<option value="' + item.PKID + '">' + item.WorkType + '</option>';
                    });


                }
                $('#dropFKWorkTypeIDSrch').append('<option value="0">Select One</option>' + str);
                $('#dropFKWorkTypeID').append('<option value="0">Select One</option>' + str);
                PageLoadComplete();
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

function FunFillScheduleStatusMaster() {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetScheduleStatusMaster",
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
                        str = str + '<option value="' + item.PKID + '">' + item.StatusTitle + '</option>';
                    });


                }
                $('#dropFKStatusIDSrch').append('<option value="0">Select One</option>' + str);
                $('#dropFKStatusID').append('<option value="0">Select One</option>' + str);
                JsonSchedueStatus = jsonarr;
                PageLoadComplete();
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

function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}



function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}
function FunSetClientDetail(item, inputid) {

    var FKClientID = $("#" + inputid).GenexAutoCompleteGet(0);
    if (inputid == 'txtFKClientID') {
        $('#txtFKProjectID').GenexAutoCompleteBlank();
        FunGetProjectForAutoComplete(FunProjectCallBackFromClient, FKClientID, 'Active', 0);
    }
    else {
        $('#txtFKProjectIDSrch').GenexAutoCompleteBlank();
        FunGetProjectForAutoComplete(FunProjectCallBackFromClientSrch, FKClientID, 'Active', 0);


    }
}

function FunEmpCallBack(JsonArr) {
    $("#txtFKEmpIDSrch").GenexAutoComplete(JsonArr, "EmpID,Name,Status");
    $("#divFKEmpID").GenexMultiSelect(JsonArr);
    PageLoadComplete();
}
function FunProjectCallBack(JsonArr) {
    $("#txtFKProjectIDSrch").GenexAutoComplete(JsonArr, "ProjectID,Project,ClientID");
    $("#txtFKProjectID").GenexAutoComplete(JsonArr, "ProjectID,Project,ClientID");
    PageLoadComplete();
}
function FunProjectCallBackFromClient(JsonArr) {

    $("#txtFKProjectID").GenexAutoComplete(JsonArr, "ProjectID,Project,ClientID");

}
function FunProjectCallBackFromClientSrch(JsonArr) {

    $("#txtFKProjectIDSrch").GenexAutoComplete(JsonArr, "ProjectID,Project,ClientID");

}
function FunClientCallBack(JsonArr) {
    $("#txtFKClientID").GenexAutoCompleteWithCallBack(JsonArr, FunSetClientDetail, 0, "ClientID,Name,Status");
    $("#txtFKClientIDSrch").GenexAutoCompleteWithCallBack(JsonArr, FunSetClientDetail, 0, "ClientID,Name,Status");

    PageLoadComplete();
}

$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});