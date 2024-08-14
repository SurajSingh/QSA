var AddrURL = "/Users/MasterAPI/AreaAPI.aspx";
var strState = "";
var JSONCountry = "";
function FunFillCountry(DropCountry, DropState, DropCity,DropTahsil) {

    if (JSONCountry == "") {
        ShowLoader();
        var args = {};

        $.ajax({

            type: "POST",
            url: AddrURL + "/GetAllCountry",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            cache: false,
            success: function (data) {

                if (data.d != "failure" && data.d != "") {
                    JSONCountry = data.d;
                    HideLoader();
                    FillCountryDropDown(DropCountry, DropState, DropCity, DropTahsil);
                }

            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                HideLoader();
                return;
            }

        });
    }
    else {
        FillCountryDropDown(DropCountry, DropState, DropCity, DropTahsil);
    }


}
function FillCountryDropDown(DropCountry, DropState, DropCity, DropTahsil) {

    var str = "<option value='0'>Select Country</option>";
    $("#" + DropCountry).empty();
    $("#" + DropState).empty();
    $("#" + DropCity).empty();
    $("#" + DropState).append("<option value='0'>Select State</option>");
    $("#" + DropCity).append("<option value='0'>Select City</option>");
    $("#" + DropTahsil).append("<option value='0'>Select County</option>");

    var jsonarr = $.parseJSON(JSONCountry);

    if (jsonarr.length > 0) {

        $.each(jsonarr, function (i, item) {

            str = str + '<option value="' + item.PKCountryID + '">' + item.CountryName + '</option>';
        });


    }

    $("#" + DropCountry).append(str);


    $("#" + DropCountry).change(function (event) {
        event.stopImmediatePropagation();
        FunFillState(DropCountry, DropState, DropCity, DropTahsil);
    });

}

function FunFillState(DropCountry, DropState, DropCity, DropTahsil) {
   
    $("#" + DropState).empty();
    $("#" + DropCity).empty();
    $("#" + DropTahsil).empty();
    $("#" + DropCity).append("<option value='0'>Select City</option>");
    $("#" + DropTahsil).append("<option value='0'>Select County</option>");
   
    var str = "<option value='0'>Select State</option>";
   
    ShowLoader();
    var args = { FKCountryID: $("#" + DropCountry).val() };
   
    if ($("#" + DropCountry).val() != "0") {
        $.ajax({

            type: "POST",
            url: AddrURL + "/GetAllState",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            cache: false,
            success: function (data) {

                if (data.d != "failure" && data.d != "") {
                    var jsonarr = $.parseJSON(data.d);

                    if (jsonarr.length > 0) {

                        $.each(jsonarr, function (i, item) {

                            str = str + '<option value="' + item.PKStateID + '">' + item.StateName + '</option>';
                        });


                    }
                    $("#" + DropState).change(function (event) {
                        event.stopImmediatePropagation();
                        FunFillCity(DropState, DropCity, DropTahsil);
                    });

                   
                }
                $("#" + DropState).append(str);
                HideLoader();

            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                HideLoader();
                return;
            }

        });
    }
    else {
        $("#" + DropState).append(str);
        HideLoader();
    }
}
function FunFillCity(DropState, DropCity, DropTahsil) {

    $("#" + DropCity).empty(); 
    $("#" + DropTahsil).empty(); 
    $("#" + DropTahsil).append("<option value='0'>Select County</option>");
    var str = "<option value='0'>Select City</option>";


    ShowLoader();
    var args = { FKStateID: $("#" + DropState).val() };

    if ($("#" + DropState).val() != "0") {
        $.ajax({

            type: "POST",
            url: AddrURL + "/GetAllCity",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            cache: false,
            success: function (data) {

                if (data.d != "failure" && data.d != "") {
                    var jsonarr = $.parseJSON(data.d);

                    if (jsonarr.length > 0) {

                        $.each(jsonarr, function (i, item) {

                            str = str + '<option value="' + item.PKCityID + '">' + item.CityName + '</option>';
                        });


                    }                  


                }
                $("#" + DropCity).append(str);
                HideLoader();
                $("#" + DropCity).change(function (event) {
                    event.stopImmediatePropagation();
                    FunFillTahsil(DropCity, DropTahsil);
                });
            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                HideLoader();
                return;
            }

        });
    }
    else {
        $("#" + DropCity).append(str);
        HideLoader();
    }
}
function FunFillTahsil(DropCity, DropTahsil) {

    $("#" + DropTahsil).empty();

    var str = "<option value='0'>Select County</option>";
    var FKCityID=0;
    if ($("#" + DropCity).val()) {
        FKCityID = $("#" + DropCity).val();
    }
    ShowLoader();
    var args = { FKCityID: FKCityID};

    if (FKCityID != "0") {
        $.ajax({

            type: "POST",
            url: AddrURL + "/GetTahsil",
            data: JSON.stringify(args),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            cache: false,
            success: function (data) {

                if (data.d != "failure" && data.d != "") {
                    var jsonarr = $.parseJSON(data.d);

                    if (jsonarr.length > 0) {

                        $.each(jsonarr, function (i, item) {

                            str = str + '<option value="' + item.PKTahsilID + '">' + item.TahsilName + '</option>';
                        });
                    }

                }
                $("#" + DropTahsil).append(str);
                HideLoader();

            },
            error: function (x, e) {
                alert("The call to the server side failed. " + x.responseText);
                HideLoader();
                return;
            }

        });
    }
    else {
        $("#" + DropTahsil).append(str);
        HideLoader();
    }
}
