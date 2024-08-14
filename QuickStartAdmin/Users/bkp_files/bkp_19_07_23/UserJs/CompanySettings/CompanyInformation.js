
var json;
var pagename = "/Users/CompanyInformation.aspx";
var PKID = 0;


function FunBlank() {
    PKID = 0;

    $('#divAddForm').find('.form-control').val('');

}


function FunValidate() {

    var fail = false;
    var fail_log = "<li>Please fill required fields marked as *</li>";
    var strError = "";

    $('#divAddForm').find('textarea, input').each(function () {
        if (!$(this).prop('required')) {

        } else {
            if (!$(this).val()) {

                fail = true;
                $(this).css("border-color", ColorE);
                var id = $(this).attr("id");
                if (id == "txtCompanyName") {
                    strError += "<li>Fill Company Name</li>";
                }
                else if (id == "txtAddress1") {
                    strError += "<li>Fill Address</li>";
                }
                else if (id == "txtCPerson") {
                    strError += "<li>Fill Contact Person Name</li>";
                }
                else if (id == "txtEmail") {
                    strError += "<li>Fill Contact Email</li>";
                }
                


            }
            else {
                $(this).css("border-color", ColorN);
            }

        }


    });

    var phone = $('#txtPhone').val();
    phone = phone.replace('(', '');
    phone = phone.replace(')', '');
    phone = phone.replace('-', '');
    phone = phone.replace(' ', '');
    if (phone != '') {
        if (phone.length != 10) {

            strError += "<li>Invalid Phone Number</li>";
            fail = true;
            $('#txtPhone').css("border-color", ColorE);
        }
        else {
            $('#txtPhone').css("border-color", ColorN);
        }
    }
    else {
        $('#txtPhone').css("border-color", ColorN);
    }


    phone = $('#txtMobile').val();
    phone = phone.replace('(', '');
    phone = phone.replace(')', '');
    phone = phone.replace('-', '');
    phone = phone.replace(' ', '');
    if (phone != '') {
        if (phone.length != 10) {

            strError += "<li>Invalid Cell Number</li>";
            fail = true;
            $('#txtMobile').css("border-color", ColorE);
        }
        else {
            $('#txtMobile').css("border-color", ColorN);
        }
    }
    else {
        $('#txtMobile').css("border-color", ColorN);
    }


    $('#divAddForm').find('select').each(function () {
        if (!$(this).prop('required')) {

        } else {
            if (!$(this).val() || $(this).val() == "0" || $(this).val() == "") {

                fail = true;
                $(this).css("border-color", ColorE);
                var id = $(this).attr("id");
                if (id == "dropFKCountryID") {
                    strError += "<li>Select Country</li>";
                }
                else if (id == "dropFKStateID") {
                    strError += "<li>Select State</li>";
                }
                else if (id == "dropFKCityID") {
                    strError += "<li>Select City</li>";
                }
                else if (id == "dropFKTahsilID") {
                    strError += "<li>Select County</li>";
                }
              
                else if (id == "dropFKTimezoneID") {
                    strError += "<li>Select Timezone</li>";
                }
                else if (id == "dropFKCurrencyID") {
                    strError += "<li>Select Currency</li>";
                }
            }
            else {
                $(this).css("border-color", ColorN);
            }

        }


    });



    if (!fail) {
        $("#divValidateSummary").hide();
        FunSave();

    } else {
        $("#divValidateSummary").show();
        $("#divValidateSummary").find(".validate-box ul").empty();
        $("#divValidateSummary").find(".validate-box ul").html(fail_log + strError);
        $('html, body').animate({
            scrollTop: (0)
        }, 500);
    }
}

function FunSave() {


    var args = {
        CompanyID: '', CompanyName: $("#txtCompanyName").val(), Address1: $("#txtAddress1").val(), Address2: $("#txtAddress2").val(),
        FKTahsilID: $("#dropFKTahsilID").val(), FKCityID: $("#dropFKCityID").val(), FKStateID: $("#dropFKStateID").val(), FKCountryID: $("#dropFKCountryID").val(),
        ZIP: $("#txtZIP").val(), Mobile: $("#txtMobile").val(), Phone: $("#txtPhone").val(),
        Email: $("#txtEmail").val(), CPerson: $("#txtCPerson").val(), CPersonTitle: '', GSTNo: '',
        PANNo:'', LogoURL: '', Website: $("#txtWebsite").val(), FKTimezoneID: $("#dropFKTimezoneID").val(), FKCurrencyID: $("#dropFKCurrencyID").val(), DateForStr: $("#txtDateForStr").val()
        
    }
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
                        if (PKID == 0) {
                            FunBlank();
                        }
                        OpenAlert('Saved Successfully!');

                    }
                    else if (jsonarr[0].Result == "9") {
                        location.href = "Logout.aspx";
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                        HideLoader();
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



function FunFillData() {
    var str = "";
    ShowLoader();
    var args = {
       
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
                        FunFillDetail(jsonarr);
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
            return;
        }

    });



}
function FunFillDetail(jsonarr) {
    FunBlank();

    $.each(jsonarr.data.Table, function () {

        PKID = this.PKCompanyID;
       
        $("#txtPKCompanyID").val(this.PKCompanyID);
      
        $("#txtCompanyName").val(this.CompanyName);
        $("#txtAddress1").val(this.Address1);
        $("#txtAddress2").val(this.Address2);
      
        $("#dropFKCountryID").val(this.FKCountryID);
        if (this.FKCountryID != 0) {
            FunFillState("dropFKCountryID", "dropFKStateID", "dropFKCityID", "dropFKTahsilID");
            $("#dropFKStateID").val(this.FKStateID);
        }
        if (this.FKStateID != 0) {
            FunFillCity("dropFKStateID", "dropFKCityID", "dropFKTahsilID");
            $("#dropFKCityID").val(this.FKCityID);
        }
        if (this.FKCityID != 0) {
            FunFillTahsil("dropFKCityID", "dropFKTahsilID");
            $("#dropFKTahsilID").val(this.FKTahsilID);
        }
      

        $("#txtZIP").val(this.ZIP);
        $("#txtMobile").val(this.Mobile);
        $("#txtPhone").val(this.Phone);
        $("#txtEmail").val(this.Email);
        $("#txtCPerson").val(this.CPerson);

        
        
        $("#txtWebsite").val(this.Website);
      
        $("#dropFKTimezoneID").val(this.FKTimezoneID);
        $("#dropFKCurrencyID").val(this.FKCurrencyID);
        $("#txtDateForStr").val(this.DateForStr);

    });
    HideLoader();

}



function InitilizeEvents() {
   
    $("#btnsave").click(function () {
        FunValidate();
    });

}
function FunFillCurrencyCallBack(str) {
    $('#dropFKCurrencyID').append(str);
    PageLoadComplete();
}
function FunFillTimezoneCallBack(str) {
    $('#dropFKTimezoneID').append(str);
    PageLoadComplete();
}
function PageLoadComplete() {
    LoadEntity = LoadEntity - 1;
    if (LoadEntity == 0) {
        FunFillData();
    }
}
function PageLoadFun() {
  
    PKID = parseInt($("#HidID").val());
    InitilizeEvents();

    SetEmailBox("txtEmail");
    SetMobileBox('txtMobile');
    SetMobileBox('txtPhone');
    FunSetTabKey();
    if (IsEdit == 0 && PKID != 0) {

        $("#btnsave").remove();
    }

    FunFillCountry("dropFKCountryID", "dropFKStateID", "dropFKCityID", "dropFKTahsilID");
    LoadEntity = 2;
    FunFillTimezone(FunFillTimezoneCallBack);
    FunFillCurrency(FunFillCurrencyCallBack);
  
   
   
   
}
$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});