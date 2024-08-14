$(document).ready(function () {




    $('#linkLogout').on('click', function () {
        closePopups();
        location.href = "Logout.aspx";

    });

  
  
   


    FunFillPageForAutoAcomplete();
    FunFillNotification();
    DateFormat = $("#HidDateFormat").val();
    DateFormat = DateFormat.toLowerCase();
    DateFormat = DateFormat.substr(0, 8);
    if (DateFormat.indexOf('-') > 0) {
        MaskDateFormat = MaskDateFormat.replace('/', '-');
        MaskDateFormat = MaskDateFormat.replace('/', '-');
        MaskDatePlaceHolder = MaskDatePlaceHolder.replace('/', '-');
        MaskDatePlaceHolder = MaskDatePlaceHolder.replace('/', '-');
    }
    CurrencyName = $("#HidCurrencyName").val();
    FKCurrencyID = $("#hidCurrencyID").val();
});

