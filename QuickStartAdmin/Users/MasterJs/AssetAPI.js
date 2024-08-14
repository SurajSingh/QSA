function FunFillAssetConditionMaster(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetAssetConditionMaster",
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
                        str = str + '<option value="' + item.PKID + '">' + item.Condition + '</option>';
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

function FunFillLocationMaster(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetLocationMaster",
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
                        str = str + '<option value="' + item.PKID + '">' + item.LocationName + '</option>';
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

function FunFillAssetCategory(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetAssetCategory",
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
                        str = str + '<option value="' + item.PKID + '">' + item.CategName + '</option>';
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

function FunFillParty(callback) {
    var str = "";
    var args = {
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetParty",
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
                        str = str + '<option value="' + item.PKID + '">' + item.Company + '</option>';
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

function FunGetAssetForAutoComplete(callback) {

    var jsonarr = [];
    var args = {
       
    };

    ShowLoader();
    $.ajax({
        type: "POST",
        url: MasterAPIURL + "/GetAssetForAutoComplete",
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