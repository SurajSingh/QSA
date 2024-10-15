var json;
var pagename = "Employees.aspx";
var PKID = 0;
var PKRoleGroupID = 0;
var IsValidLogin = 0;
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
        PKUserID: 0, Name: $('#txtEmpIDSrch').val(), ActiveStatus: $('#dropActiveStatusSrch').val(), FKDeptID: $('#dropFKDeptIDSrch').ValZero()

    };

    $.ajax({
        type: "POST",
        url: pagename + "/GetData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
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
                                var id = "trdata" + this.PKUserID;
                                var strtrClass = "even";
                                if (i % 2 == 0) {
                                    strtrClass = "odd";
                                }
                                str = str + '<tr id="' + id + '" class="' + strtrClass + '">';
                                if (IsEdit == 1) {
                                    str = str + '<td>  <a class="linkEditRec px-3 text-primary" id="linkEditRec' + this.PKUserID + '"  title="Edit Record"> <i class="uil uil-pen font-size-18t"></i></a></td>';

                                }
                                else {
                                    str += "<td></td>";
                                }
                                if (IsDelete == 1) {
                                    str = str + '<td style="text-align:center">  <a class="linkDeleteRec px-3 text-danger" id="linkDeleteRec' + this.PKUserID + '"  title="Delete Record"><i class="uil uil-trash-alt font-size-18"></i></a></td>';
                                }
                                else {
                                    str += "<td></td>";
                                }

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

                                            strval = item[attr];
                                            if ($(th).hasClass('tdclscurrency')) {
                                                strclass = strclass + ' tdclscurrency';
                                                var TranCurrency = CurrencyName;
                                                strval = TranCurrency + ' ' + strval;
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
                            $('#tbldata').on('click', '.linkEditRec', function (event) {
                                event.stopImmediatePropagation();
                                var newid = $(this).attr("id");
                                newid = newid.replace("linkEditRec", "");
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
        PageSize: 0, OffSet: 0, SortBy: '', SortDir: '',
        PKUserID: PKID, Name: '', ActiveStatus: '', FKDeptID: 0

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
                        FunBlank();
                        $('#popupTitle').find('span').html("Modify Employee");
                        PKID = jsonarr.data.Table[0].PKUserID;

                        $("#txtLoginID").val(jsonarr.data.Table[0].LoginID);
                        $("#txtEmailID").val(jsonarr.data.Table[0].EmailID);
                        $("#txtPWD").val(jsonarr.data.Table[0].PWD);
                        $("#txtFName").val(jsonarr.data.Table[0].FName);
                        $("#txtLName").val(jsonarr.data.Table[0].LName);
                        //$("#txtEnrollNo").val(jsonarr.data.Table[0].EnrollNo);
                        $("#txtDOB").val(jsonarr.data.Table[0].DOB);

                        $("#txtMobNo").val(jsonarr.data.Table[0].MobNo);
                        $("#txtPhone1").val(jsonarr.data.Table[0].Phone1);
                        $("#txtPhone2").val(jsonarr.data.Table[0].Phone2);
                        $("#txtAddressTitle").val(jsonarr.data.Table[0].AddressTitle);
                        $("#txtAddress1").val(jsonarr.data.Table[0].Address1);
                        $("#txtAddress2").val(jsonarr.data.Table[0].Address2);

                        $("#dropFKCountryID").val(jsonarr.data.Table[0].FKCountryID);
                        FunFillState("dropFKCountryID", "dropFKStateID", "dropFKCityID", "dropFKTahsilID");
                        $("#dropFKStateID").val(jsonarr.data.Table[0].FKStateID);
                        FunFillCity("dropFKStateID", "dropFKCityID", "dropFKTahsilID");

                        $("#dropFKCityID").val(jsonarr.data.Table[0].FKCityID);
                        FunFillTahsil("dropFKCityID", "dropFKTahsilID");
                        $("#dropFKTahsilID").val(jsonarr.data.Table[0].FKTahsilID);


                        $("#txtZIP").val(jsonarr.data.Table[0].ZIP);
                        $("#txtJoinDate").val(jsonarr.data.Table[0].JoinDate);
                        $("#txtReleasedDate").val(jsonarr.data.Table[0].ReleasedDate);
                        $("#txtFKManagerID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKManagerID, jsonarr.data.Table[0].ManagerName);
                        $("#txtFKSubmitToID").GenexAutoCompleteSet(jsonarr.data.Table[0].FKSubmitToID, jsonarr.data.Table[0].SubmitToName);

                        $("#dropRoleType").val(jsonarr.data.Table[0].RoleType);
                        $("#dropFKRoleGroupID").val(jsonarr.data.Table[0].FKRoleGroupID);

                        $("#dropFKDeptID").val(jsonarr.data.Table[0].FKDeptID);
                        $("#dropFKDesigID").val(jsonarr.data.Table[0].FKDesigID);

                        $("#txtRemark").val(jsonarr.data.Table[0].Remark);
                        $("#chkAppointment").prop("checked", jsonarr.data.Table[0].IsAppointment);
                        $("#dropActiveStatus").val(jsonarr.data.Table[0].ActiveStatus);
                        if (jsonarr.data.Table1.length > 0) {
                            $("#txtBillRate").val(jsonarr.data.Table1[0].BillRate.toFixed(2));
                            $("#txtPayRate").val(jsonarr.data.Table1[0].PayRate.toFixed(2));
                            $("#txtOverTimeBillRate").val(jsonarr.data.Table1[0].OverTimeBillRate.toFixed(2));
                            $("#txtOverTimePayrate").val(jsonarr.data.Table1[0].OverTimePayrate.toFixed(2));
                            $("#txtOverheadMulti").val(jsonarr.data.Table1[0].OverheadMulti.toFixed(2));
                            $("#dropFKCurrencyID").val(jsonarr.data.Table1[0].FKCurrencyID);

                            $("#txtSalaryAmount").val(jsonarr.data.Table1[0].SalaryAmount.toFixed(2));
                        }

                        if (jsonarr.data.Table2.length > 0) {
                            var str = '';
                            $.each(jsonarr.data.Table2, function (i, item) {


                                str = str + '<tr>';
                                str = str + '<td><i class="fa fa-angle-right"></i>&nbsp;' + item.GroupName + '</td>';
                                str = str + '<td>' + item.Description + '</td>';
                                str += '</tr>';
                            });
                            $('#tblGroup tbody').append(str);
                        }

                        IsValidLogin = 1;
                        FunActiveRoleGroup();

                        opendiv('divAddNew');
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
function FunBlank() {
    PKID = 0;
    IsValidLogin = 0;
    $('#divAddNew').find('.form-control').val('');
    $("#dropRoleType").val('User');
    $("#dropFKRoleGroupID").val('0');
    $("#dropActiveStatus").val('Active');
    $("#dropFKDeptID").val('0');
    $("#dropFKDesigID").val('0');

    $("#tblGroup tbody").empty();

    $('#txtFKManagerID').GenexAutoCompleteBlank();
    $('#txtFKSubmitToID').GenexAutoCompleteBlank();

    /*FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);*/

    FunActiveRoleGroup();
    $('#popupTitle').find('span').html("New Employee");

}
function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";
    if ($("#txtLoginID").val() == "") {
        fail = true;
        $("#txtLoginID").css("border-color", ColorE);
        strError += "<li>Enter Employee ID</li>";
    }
    else {
        $("#txtLoginID").css("border-color", ColorN);
    }
    if ($("#txtPWD").val() == "") {
        fail = true;
        $("#txtPWD").css("border-color", ColorE);
        strError += "<li>Enter Password</li>";
    }
    else {
        $("#txtPWD").css("border-color", ColorN);
    }
    //if ($("#txtEnrollNo").val() == "") {
    //    fail = true;
    //    $("#txtEnrollNo").css("border-color", ColorE);
    //    strError += "<li>Enter Enroll No.</li>";
    //}
    //else {
    //    $("#txtEnrollNo").css("border-color", ColorN);
    //}
    if ($("#txtFName").val() == "") {
        fail = true;
        $("#txtFName").css("border-color", ColorE);
        strError += "<li>Enter First Name</li>";
    }
    else {
        $("#txtFName").css("border-color", ColorN);
    }
    if ($("#txtLName").val() == "") {
        fail = true;
        $("#txtLName").css("border-color", ColorE);
        strError += "<li>Enter Last Name</li>";
    }
    else {
        $("#txtLName").css("border-color", ColorN);
    }


    if ($("#dropFKDeptID").ValZero() == "0") {
        fail = true;
        $("#dropFKDeptID").css("border-color", ColorE);
        strError += "<li>Select Department</li>";
    }
    else {
        $("#dropFKDeptID").css("border-color", ColorN);
    }
    if ($("#dropFKDesigID").ValZero() == "0") {
        fail = true;
        $("#dropFKDesigID").css("border-color", ColorE);
        strError += "<li>Select Designation</li>";
    }
    else {
        $("#dropFKDesigID").css("border-color", ColorN);
    }


    if ($("#txtEmailID").val() == "") {
        fail = true;
        $("#txtEmailID").css("border-color", ColorE);
        strError += "<li>Enter Email ID</li>";
    }
    else {
        $("#txtEmailID").css("border-color", ColorN);
    }
    if ($("#txtJoinDate").val() == "") {
        fail = true;
        $("#txtJoinDate").css("border-color", ColorE);
        strError += "<li>Enter Join Date</li>";
    }
    else {
        $("#txtJoinDate").css("border-color", ColorN);
    }

    if ($("#dropRoleType").val() == "User") {

        if ($("#dropFKRoleGroupID").ValZero() == "0") {
            fail = true;
            $("#dropFKRoleGroupID").css("border-color", ColorE);
            strError += "<li>Select User Roles</li>";
        }
        else {
            $("#dropFKRoleGroupID").css("border-color", ColorN);
        }
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

    var projectids = $('#divFKProjectIDSrch').GenexMultiSelectGet();

    var args = {
        PKUserID: PKID, LoginID: $("#txtLoginID").val(), EmailID: $("#txtEmailID").val(), PWD: $("#txtPWD").val(), FName: $("#txtFName").val(), MName: '', LName: $("#txtLName").val(), EnrollNo: '', DOB: $("#txtDOB").val(), Gender: '', MobNo: $("#txtMobNo").val(), Phone1: $("#txtPhone1").val(), Phone2: $("#txtPhone2").val(), AddressTitle: $("#txtAddressTitle").val(), Address1: $("#txtAddress1").val(), Address2: $("#txtAddress2").val(), FKTahsilID: $("#dropFKTahsilID").ValZero(), FKCityID: $("#dropFKCityID").ValZero(), FKStateID: $("#dropFKStateID").ValZero(), FKCountryID: $("#dropFKCountryID").ValZero(), ZIP: $("#txtZIP").val(),
        JoinDate: $("#txtJoinDate").val(), ReleasedDate: $("#txtReleasedDate").val(), FKManagerID: $("#txtFKManagerID").GenexAutoCompleteGet('0'), FKSubmitToID: $("#txtFKSubmitToID").GenexAutoCompleteGet('0'), RoleType: $("#dropRoleType").val(), FKRoleGroupID: $("#dropFKRoleGroupID").ValZero(), FKDeptID: $("#dropFKDeptID").ValZero(), FKDesigID: $("#dropFKDesigID").ValZero(), FKTimeZoneID: 0, Remark: $("#txtRemark").val(), IsAppointment: $("#chkAppointment").is(':checked'), FKDashboardID: 0, ActiveStatus: $("#dropActiveStatus").val(), BillRate: $("#txtBillRate").ValZero(), PayRate: $("#txtPayRate").ValZero(), OverTimeBillRate: $("#txtOverTimeBillRate").ValZero(), OverTimePayrate: $("#txtOverTimePayrate").ValZero(),
        OverheadMulti: $("#txtOverheadMulti").ValZero(), FKCurrencyID: $("#dropFKCurrencyID").ValZero(), PayPeriod: '', SalaryAmount: $("#txtSalaryAmount").ValZero(), ProjectIds: projectids
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
                        PKID = 0;
                        IsColCreated = false;
                        RCount = 0;
                        $("#tbldata").GenexTableDestroy();
                        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");

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
        var args = { PKUserID: RecID };
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
function FunFillDepartment() {
    var str = "";
    var args = {
    };
    $("#dropFKDeptID").empty();
    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetDepartment",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    if (jsonarr[0].Result == "1") {
                        $.each(jsonarr, function (i, item) {
                            str = str + '<option value="' + item.PKDeptID + '">' + item.DeptName + '</option>';
                        });

                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                    }
                }
                $("#dropFKDeptID").append('<option value="0">Select One</option>' + str);
                $("#dropFKDeptIDSrch").append('<option value="0">--All--</option>' + str);
                PageLoadComplete();
            }
            else {
                OpenAlert("Session Timeout!");
                window.location.href = "Logout.aspx";
            }
        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}
function FunFillDesignation() {
    var str = "";
    var args = {
    };
    $("#dropFKDesigID").empty();
    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetDesignation",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            if (data.d != "failure" && data.d != "Invalid Request") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    if (jsonarr[0].Result == "1") {
                        $.each(jsonarr, function (i, item) {
                            str = str + '<option value="' + item.PKDesigID + '">' + item.DesigName + '</option>';
                        });

                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                    }
                }
                $("#dropFKDesigID").append('<option value="0">Select One</option>' + str);
                PageLoadComplete();
            }
            else {
                OpenAlert("Session Timeout!");
                window.location.href = "Logout.aspx";
            }
        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
}
function FunValidateLoginID() {
    IsValidLogin = 0;
    $("#divCheckLogin").html("");

    if ($("#txtLoginID").val() != "") {
        $("#divCheckLogin").html('<img src="images/smallLoader.gif" />');
        var args = {
            LoginID: $("#txtLoginID").val(), PKUserID: PKID
        };

        $.ajax({
            type: "POST",
            url: pagename + "/ValidateLoginID",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {
                if (data.d != "failure" && data.d != "Invalid Request") {
                    var jsonarr = $.parseJSON(data.d);
                    HideLoader();
                    if (jsonarr.length > 0) {
                        if (jsonarr[0].Result == "1") {
                            $("#divCheckLogin").html('<img src="images/green-right-icon.png" />');
                            IsValidLogin = 1;
                        }
                        else if (jsonarr[0].Result == "9") {
                            location.href = "Logout.aspx";
                        }
                        else {
                            $("#divCheckLogin").html('<img src="images/warning.png" /> ' + jsonarr[0].Msg);
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

                return;
            }

        });
    }

}
function closerolergoup() {
    PKRoleGroupID = 0;
    $('#divaddInformation').hide();
    $('#otherdiv_inftype').hide();
}
function openrolegroup() {
    $("#tblrole").find(".checkcustom input").prop('checked', false);
    $("#tblrole").find(".checkcustom span").removeClass("checked");

    $("#txtmasterrolename").val("");
    $("#dropmasterrole").val('0');
    $('#btnDeleteRole').hide();
    $("#tblrole").find(".chkiteminner span").css("border-color", "#e0e0e0");
    $("#tblrole").find(".chkiteminner input").prop('disabled', true);
    FunSetPosition('divaddInformation');
    $('#divaddInformation').show();
    $('#otherdiv_inftype').show();


    $("#dropmasterrole").change(function (event) {
        event.stopImmediatePropagation();
        $("#tblrole").find(".checkcustom input").prop('checked', false);
        $("#tblrole").find(".checkcustom span").removeClass("checked");
        $("#tblrole").find(".chkiteminner span").css("border-color", "#e0e0e0");
        $("#tblrole").find(".chkiteminner input").prop('disabled', true);

        if ($("#dropmasterrole").val() == "0") {
            $("#txtmasterrolename").val("");
            PKRoleGroupID = 0;
            $('#btnDeleteRole').hide();
        }
        else {
            $("#txtmasterrolename").val($("#dropmasterrole option:selected").text());
            PKRoleGroupID = $("#dropmasterrole").val();
            $('#btnDeleteRole').show();
            FunFillRoleGroup(false);
        }


    });


    $("#tblrole .headcheck input").click(function () {
        if ($(this).is(':checked')) {
            $(this).parent().addClass("checked");

        }
        else {
            $(this).parent().removeClass("checked");

        }
        var status = this.checked; // "select all" checked status
        $('#tblrole .chkitem input').each(function () { //iterate all listed checkbox items
            this.checked = status; //change ".checkbox" checked status
            if (status) { $(this).parent().addClass("checked"); }

            else {
                $(this).parent().removeClass("checked");
            }

        });

        if (status) {
            $("#tblrole").find(".chkiteminner span").css("border-color", "#2594db");
            $("#tblrole").find(".chkiteminner input").prop('disabled', false);
        }
        else {
            $("#tblrole").find(".chkiteminner span").css("border-color", "#e0e0e0");
            $("#tblrole").find(".chkiteminner input").prop('disabled', true);
            $("#tblrole").find(".chkiteminner input").prop('checked', false);
            $("#tblrole").find(".chkiteminner span").removeClass("checked");
        }


    });
}
function FunDeleteRoleGroup() {
    if (confirm("Do you want to delete this record?")) {
        var args = { PKRoleGroupID: $('#dropmasterrole').ValZero() };
        ShowLoader();
        $.ajax({

            type: "POST",
            url: pagename + "/DeleteRoleGroup",
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
                            PKRoleGroupID = 0;
                            FunFillRoleGroup(false);
                            openrolegroup();


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
function FunActiveRoleGroup() {


    if ($("#dropRoleType").val() == "User" || $("#dropRoleType").val() == "Vendor") {
        $('#dropFKRoleGroupID').attr('disabled', false);

    }
    else {
        $('#dropFKRoleGroupID').attr('disabled', true);

    }
}
function MasterGetAllRoleHTML() {
    var args = {};
    ShowLoader();
    $.ajax({

        type: "POST",
        url: pagename + "/getAllRoleText",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure") {
                $("#tblrole tbody").append(data.d);

                $(".chkiteminner input").change(function () {

                    if ($(this).is(':checked')) {
                        $(this).parent().addClass("checked");


                    }
                    else {
                        $(this).parent().removeClass("checked");

                    }



                });
                $(".chkitem input").change(function () {
                    var newid = $(this).attr("id");
                    id = newid.replace("chkrecord", "");

                    if ($(this).is(':checked')) {
                        $(this).parent().addClass("checked");

                        $('#trinv_' + id).find(".chkiteminner span").css("border-color", "#2594db");
                        $('#trinv_' + id).find(".chkiteminner input").prop('checked', true);
                        $('#trinv_' + id).find(".chkiteminner input").prop('disabled', false);
                        $('#trinv_' + id).find(".chkiteminner span").addClass("checked");

                    }
                    else {
                        $(this).parent().removeClass("checked");
                        $('#trinv_' + id).find(".chkiteminner span").css("border-color", "#e0e0e0");
                        $('#trinv_' + id).find(".chkiteminner input").prop('checked', false);
                        $('#trinv_' + id).find(".chkiteminner input").prop('disabled', true);
                        $('#trinv_' + id).find(".chkiteminner span").removeClass("checked");

                    }



                });

                var $table = $("#tblrole");
                $table.floatThead({
                    scrollContainer: function ($table) {
                        return $table.closest('.dataTables_wrapper');
                    }
                });
                HideLoader();

            }
        }
    });

}
function FunFillRoleGroup(IsPageLoad) {
    var str = "";
    var args = {
        PKRoleGroupID: PKRoleGroupID
    };
    if (PKRoleGroupID == 0) {

        $("#dropFKRoleGroupID").empty();
        $("#dropmasterrole").empty();
    }
    ShowLoader();
    $.ajax({
        type: "POST",
        url: pagename + "/GetRoleGroupData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        cache: false,
        success: function (data) {

            if (data.d != "failure" && data.d != "Invalid Request") {
                var jsonarr = $.parseJSON(data.d);
                HideLoader();
                if (jsonarr.length > 0) {
                    if (jsonarr[0].Result == "1") {
                        if (PKRoleGroupID == 0) {
                            $.each(jsonarr, function (i, item) {

                                str = str + '<option value="' + item.PKRoleGroupID + '">' + item.GroupName + '</option>';

                            });

                            $("#dropSrchRoles").append('<option value="0">All</option>' + str);
                            $("#dropFKRoleGroupID").append('<option value="0">Select One</option>' + str);
                            $("#dropmasterrole").append('<option value="0">--Add New--</option>' + str);

                        }
                        else {
                            FunFillRoleDetail(jsonarr);
                        }
                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert("RoleGroup:" + jsonarr[0].Msg);
                    }
                }
                else {

                    $("#dropFKRoleGroupID").append('<option value="0">Select One</option>' + str);
                    $("#dropmasterrole").append('<option value="0">--Add New--</option>' + str);
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
function FunFillRoleDetail(jsonarr) {


    var table1 = $("#tblrole tbody");

    $("#tblrole").find(".checkcustom input").prop('checked', false);
    $("#tblrole").find(".checkcustom span").removeClass("checked");
    $("#tblrole").find(".chkiteminner span").css("border-color", "#e0e0e0");
    $("#tblrole").find(".chkiteminner input").prop('disabled', true);
    $.each(jsonarr, function (i, item) {

        table1.find('tr').each(function (j, el) {
            if (!$(this).hasClass("trrolegroup")) {
                var id = $(this).attr('id');
                id = id.replace("trinv_", "");

                $("#hidrolegrouoid" + id).val("");


                if (item.FKRoleID == $("#chkrecord" + id).val()) {

                    $(this).find(".chkitem input").prop('checked', true);
                    $(this).find('.chkitem span').addClass("checked");
                    $("#hidrolegrouoid" + id).val(item.FKRoleID);
                    $(this).find('.chkiteminner input').prop('disabled', false);
                    if (item.IsView) {
                        $("#chkview" + id).prop('checked', true);
                        $("#chkview" + id).parent().addClass("checked");
                    }

                    if (item.IsAdd) {
                        $("#chkadd" + id).prop('checked', true);
                        $("#chkadd" + id).parent().addClass("checked");
                    }

                    if (item.IsEdit) {
                        $("#chkedit" + id).prop('checked', true);
                        $("#chkedit" + id).parent().addClass("checked");
                    }

                    if (item.IsDelete) {
                        $("#chkdelete" + id).prop('checked', true);
                        $("#chkdelete" + id).parent().addClass("checked");
                    }



                }



            }

        });
    });

}
function FumSaveMasterRoleGroup() {
    var status = 1, roleid = "", nid = "", rolenid = "", isadd = "", isedit = "", isdelete = "", isview = "";
    var table1 = $("#tblrole tbody");
    if (document.getElementById('txtmasterrolename').value == '') {
        document.getElementById('txtmasterrolename').style.borderColor = "red";
        status = 0;
    }
    else {
        document.getElementById('txtmasterrolename').style.borderColor = "#dadada";
    }
    if (status == 1) {
        table1.find('tr').each(function (i, el) {

            if (!$(this).hasClass("trrolegroup")) {
                var id = $(this).attr('id');
                id = id.replace("trinv_", "");
                if ($("#chkrecord" + id).is(':checked')) {

                    roleid = roleid + $("#chkrecord" + id).val() + "#";
                    rolenid = rolenid + $("#hidrolegrouoid" + id).val() + "#";
                    if ($("#chkview" + id).is(':checked')) {
                        isview = isview + "1#";
                    }
                    else {
                        isview = isview + "0#";
                    }

                    if ($("#chkadd" + id).is(':checked')) {
                        isadd = isadd + "1#";
                    }
                    else {
                        isadd = isadd + "0#";
                    }

                    if ($("#chkedit" + id).is(':checked')) {
                        isedit = isedit + "1#";
                    }
                    else {
                        isedit = isedit + "0#";
                    }
                    if ($("#chkdelete" + id).is(':checked')) {
                        isdelete = isdelete + "1#";
                    }
                    else {
                        isdelete = isdelete + "0#";
                    }


                }



            }

        });

        var args = { PKRoleGroupID: $('#dropmasterrole').val(), rolename: $('#txtmasterrolename').val(), roleid: roleid, rolenid: rolenid, isview: isview, isadd: isadd, isedit: isedit, isdelete: isdelete };
        ShowLoader();
        $.ajax({

            type: "POST",
            url: pagename + "/SaveRoleGroup",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {

                if (data.d != "failure") {

                    var jsonarr = $.parseJSON(data.d);
                    HideLoader();
                    if (jsonarr.length > 0) {

                        if (jsonarr[0].Result == "1") {
                            PKRoleGroupID = 0;
                            FunFillRoleGroup(false);
                            closerolergoup();

                        }
                        else if (jsonarr[0].Result == "9") {
                            location.href = "Logout.aspx";
                        }
                        else {
                            OpenAlert(jsonarr[0].Msg);

                        }
                    }
                    else {
                        OpenAlert("The call to the server side failed. ");

                    }
                }


            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                HideLoader();
                return;
            }

        });


    }



}
function CloseDepartment() {
    $('#divAddDepartment').hide();
    $('#otherdiv_inftype').hide();

}
function CloseDesignation() {
    $('#divAddDesignation').hide();
    $('#otherdiv_inftype').hide();

}
function FunDepartmentCallFromChild() {
    CloseDepartment();
    $("#dropFKDeptID").empty();

    FunFillDepartment();

}
function FunDesigCallFromChild() {
    CloseDesignation();
    $("#dropFKDesigID").empty();

    FunFillDesignation();

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
    $("#txtLoginID").change(function () {
        FunValidateLoginID();
    });
    $("#dropRoleType").change(function () {
        FunActiveRoleGroup();
    });
    $("#btnSaveRole").click(function () {
        FumSaveMasterRoleGroup();
    });
    $("#btnCloseRole").click(function () {
        closerolergoup();
    });
    $("#btnSearch").click(function () {

        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });
    $("#btnRefresh").click(function () {

        PKID = 0;
        IsColCreated = false;
        RCount = 0;
        $("#tbldata").GenexTableDestroy();
        FunFillData($("#tbldata").GenexTableGetPageSize(), 0, "", "A", "");
    });
    $("#linkAddPepartment").click(function () {
        FunSetPosition('divAddDepartment');
        $('#divAddDepartment').show();
        $('#otherdiv_inftype').show();

    });
    $("#linkAddDesignation").click(function () {
        FunSetPosition('divAddDesignation');
        $('#divAddDesignation').show();
        $('#otherdiv_inftype').show();

    });
    $("#btnDeleteRole").click(function () {
        FunDeleteRoleGroup();

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
    SetDatePicker('txtJoinDate');
    SetDatePicker('txtReleasedDate');
    SetDatePicker('txtDOB');
    SetAmountBox("txtBillRate", 2, false, "");
    SetAmountBox("txtPayRate", 2, false, "");
    SetAmountBox("txtOverTimeBillRate", 2, false, "");
    SetAmountBox("txtOverTimePayrate", 2, false, "");
    SetAmountBox("txtOverheadMulti", 2, false, "");
    SetAmountBox("txtSalaryAmount", 2, false, "");
    SetEmailBox("txtEmailID");
    SetMobileBox('txtMobNo');
    SetMobileBox('txtPhone1');
    SetMobileBox('txtPhone2');
    if (IsAdd == 0) {
        $("#btnAddNew").remove();
    }
    FunFillCountry("dropFKCountryID", "dropFKStateID", "dropFKCityID", "dropFKTahsilID");
    MasterGetAllRoleHTML();
    FunFillRoleGroup(true);
    LoadEntity = 5;
    FunGetTableLayout(FKPageID, "tbldata", FunGridLayoutCallback);
    FunFillDepartment();
    FunFillDesignation();
    FunFillCurrency(FunFillCurrencyCallBack);
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, 'Active');
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);



}

function FunProjectCallBack(JsonArr) {
    $("#divFKProjectIDSrch").GenexMultiSelect(JsonArr);
    /*PageLoadComplete();*/
}
function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}
function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}
function FunEmpCallBack(JsonArr) {
    $("#txtFKManagerID").GenexAutoComplete(JsonArr, "EmpID,Name,Status");
    $("#txtFKSubmitToID").GenexAutoComplete(JsonArr, "EmpID,Name,Status");
    PageLoadComplete();
}
function FunFillCurrencyCallBack(str) {
    $('#dropFKCurrencyID').append(str);
    PageLoadComplete();
}

$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});