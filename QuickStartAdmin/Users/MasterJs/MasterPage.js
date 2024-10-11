var opendivid = '';
var opendivdetailid = '';
var tableData;
var tableData1;
var DateFormat = "mm/dd/yy";
var CurrencyName = "$";
var FKCurrencyID = 1;
var MaskDateFormat = "00/00/0000";
var MaskDatePlaceHolder = "__/__/____";
var IsLoadingRole = false;
var ProgCount = 0;
var ColorE = "#FF723D";
var ColorN = "#dadada";
var popupWin = [];
var LoadEntity = 0;
function FunOpenHotLink(PageURL, QueryString, w, h) {
    var NewPageURL = PageURL;
    if (QueryString == "") {
        QueryString = "HotLink=1";
    }
    else {
        QueryString = QueryString + "&HotLink=1";
    }
    NewPageURL = NewPageURL + "?" + QueryString;
    if (w == 0) {
        w = screen.width;
    }
    if (h == 0) {
        h = screen.height;
    }

    var NWin = window.open("/Users/" + NewPageURL, '', 'height=' + h + ',width=' + w + ',location=no,toolbar=no,menubar=no');
    popupWin.push(NWin);
    if (window.focus) {
        NWin.focus();
    }

}
function ShowDetailLoader(id) {
    $("#divloader").css("width", "50%");
    $("#divloader").css("left", "50%");
    ShowLoader(id);
}
function ShowLoader(id) {
    if (id != null && id == "1") {
        $("#divloader").css("background-color", "#ffffff");
    }
    else {
        $("#divloader").css("background-color", "none");
    }
    ProgCount = ProgCount + 1;
    $("#divloader").show();
}
function HideLoader() {
    ProgCount = ProgCount - 1;
    if (ProgCount <= 0) {
        $("#divloader").css("width", "100%");
        $("#divloader").css("left", "0");
        $("#divloader").hide();
        ProgCount = 0;
    }
}
function ShowFileLoader(btnID) {
    var str = '<img id="loader' + btnID + '" src="images/smallLoader.gif" />';
    $("#" + btnID).parent().append(str);
    $("#" + btnID).hide();
}
function HideFileLoader(btnID) {
    $("#loader" + btnID).remove();
    $("#" + btnID).show();
}
function ShowDataLoader(id) {
    if (id == null || id== "") {
        $("#divDataloader").show();
    }
    else {
        $("#"+id).show();
    }
   
}
function HideDataLoader(id) {
    if (id == null || id == "") {
        $("#divDataloader").hide();
    }
    else {
        $("#" + id).hide();
    }
}
function OpenAlert(msg) {
    $('#alerttext').html(msg);
    //  setposition("divalert");
    $('#divalert').show();
    $('#divalertback').show();
    $("#btnAlertOK").focus();
}
function CloseAlert() {
    $('#divalert').hide();
    $('#divalertback').hide();
}
function ActiveDataTable(id, arr) {


    var FileName = "Data";
    if ($("#pagetitle").length) {
        FileName = $("#pagetitle").html();
    }

    tableData = $("#" + id).DataTable({
        dom: 'RflBrtip',
        "destroy": true,
        "pageLength": 50,
        scrollY: 500,
        scrollX: true,
        scrollCollapse: true,
        fixedColumns: false,
        colReorder: true,
        language: {
            "emptyTable": "No data found"
        },
        'aoColumnDefs': [{
            'bSortable': false,
            'aTargets': arr /* 1st one, start by the right */
        }]
       
    });

    SetExportButton("");


}
function ActiveDataTableWithTotal(id, arr, arrTotal) {

    $(document).ready(function () {
        $("#" + id).DataTable(), $("#"+id).DataTable({
            lengthChange: !1
            
        })
    });




    //var FileName = "Report";
    //if ($(".card-title").html() != null && $(".card-title").html() != "") {
    //    FileName = $("#pagetitle").html();
    //}

    //tableData = $("#" + id).DataTable({
    //    dom: 'RflBrtip',
    //    "destroy": true,
    //    "pageLength": 50,
    //    scrollY: 300,
    //    scrollX: true,
    //    scrollCollapse: true,
    //    fixedColumns: false,
    //    colReorder: true,
    //    language: {
    //        "emptyTable": "No data found"
    //    },
    //    'aoColumnDefs': [{
    //        'bSortable': false,
    //        'aTargets': arr /* 1st one, start by the right */
    //    }],
    //    buttons: [{
    //        extend: 'pdf',
    //        title: FileName,
    //        filename: FileName
    //    }, {
    //        extend: 'excel',
    //        title: FileName,
    //        filename: FileName
    //    }, {
    //        extend: 'csv',
    //        filename: FileName
    //    }],
    //    "footerCallback": function (row, data, start, end, display) {
    //        var api = this.api(), data;

    //        // Remove the formatting to get integer data for summation
    //        var intVal = function (i) {
    //            return typeof i == 'string' ?
    //                i.replace(/[\$,]/g, '') * 1 :
    //                typeof i == 'number' ?
    //                    i : 0;
    //        };

    //        if (arrTotal.length > 0) {
    //            for (var i = 0; i < arrTotal.length; i++) {
    //                // Total over all pages
    //                total = api
    //                    .column(arrTotal[i])
    //                    .data()
    //                    .reduce(function (a, b) {
    //                        return intVal(a) + intVal(b);
    //                    }, 0);



    //                // Update footer
    //                $(api.column(arrTotal[i]).footer()).html(
    //                    FormatMoney(total, 2, ".", ",")
    //                );

    //            }
    //        }
    //    }

    //});

    //SetExportButton("");


}


function SetExportButton(Title) {
    $("#dropExport option").click(function () {
        if ($(this).val() == "CSV") {
            tableData.button('.buttons-csv').trigger();
        }


    });
}
function FunExport2Word(element, filename = '') {
    var preHtml = "<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'><head><meta charset='utf-8'><title>Word Report</title></head><body style='margin:0px;padding:0px;'>";
    var postHtml = "</body></html>";
    var html = preHtml + element + postHtml;

    var blob = new Blob(['\ufeff', html], {
        type: 'application/msword'
    });

    // Specify link url
    var url = 'data:application/vnd.ms-word;charset=utf-8,' + encodeURIComponent(html);

    // Specify file name
    filename = filename ? filename + '.doc' : 'document.doc';

    // Create download link element
    var downloadLink = document.createElement("a");

    document.body.appendChild(downloadLink);

    if (navigator.msSaveOrOpenBlob) {
        navigator.msSaveOrOpenBlob(blob, filename);
    } else {
        // Create a link to the file
        downloadLink.href = url;

        // Setting the file name
        downloadLink.download = filename;

        //triggering the function
        downloadLink.click();
    }

    document.body.removeChild(downloadLink);
}
function SetLeftRightListBox(LBtnID, RBtnID, ListID1, ListID2) {
    $("#" + RBtnID).click(function () {
        MoveListItem(false, ListID1, ListID2)
    });
    $("#" + LBtnID).click(function () {
        MoveListItem(false, ListID2, ListID1)
    });
}
function MoveListItem(isMoveAll, leftListBoxID, rightListBoxID) {

    if (isMoveAll == true) {

        $('#' + leftListBoxID + ' option').remove().appendTo('#' + rightListBoxID).removeAttr('selected');

    }
    else {

        $('#' + leftListBoxID + ' option:selected').remove().appendTo('#' + rightListBoxID).prop('selected', false);
        $('#' + leftListBoxID+' :nth-child(1)').prop('selected', true);
    }

}
function FunGetNextChar(c) {
    return String.fromCharCode(c.charCodeAt(0) + 1);
}

function sowCustomDate(id) {
    $('#divFromDateSrch').hide();
    $('#divToDateSrch').hide();
    if (id == "dropaterange") {
        if (document.getElementById(id).value == "Custom") {
            $('#divcustomdate').show();
            $('#divFromDateSrch').show();
            $('#divToDateSrch').show();
        }
        else {
            if (document.getElementById(id).value == "AsOf") {

                $('#divcustomdate').show();
                $('#divToDateSrch').show();
                $('#divToDateSrch').find('input').val(GetTodayDate());

            }
            else {
                $('#divcustomdate').hide();

            }
           
        }


    }
    else {
        if (document.getElementById(id).value == "Custom") {
            $('#'+id+"custom").show();
        }
        else {
            $('#' + id + "custom").hide();
        }
    }
    
}

function opendivdetail(id) {
    opendivdetailid = id;
    $('#' + id).removeClass('zoomout');
    $('#' + id).css("width", "80%");
    $('#' + id).css("left", "101%");
    $('#' + id).css("display", "block");   
    $('#' + id).css("left", "auto");
    $('#' + id).css("right", "0");
   
}

function zoondetaildiv() {

    $('#' + opendivdetailid).toggleClass("zoomout");
}
function closedetaildiv() {

    $('#' + opendivdetailid).removeClass('zoomout');   
    $('#' + opendivdetailid).css("display", "none");   
    opendivdetailid = "";
}


function opendiv(id) {
    opendivid = id;
    FunSetPosition(id);
    $('#otherdiv').fadeIn("slow");
    $('#' + id).fadeIn("slow");
    $('#' + id).draggable({ cursor: "move", handle: '.modal-header' });


}
function closediv(parentdivID) {
    if ($('#' + opendivid).length) {
        $('#' + opendivid).hide();
        $('#otherdiv').hide();

        if (parentdivID != undefined && parentdivID != '' && parentdivID != null) {
            opendivid = parentdivID;
        }

    }
}

function FunSetAddress(Address1, Address2, Country, State, City, Tahsil, Zip) {
    var strAddr = Address1;
    if (Address2 != "") {
        if (strAddr == "") {
            strAddr = Address2;
        }
        else {
            strAddr = strAddr + ", " + Address2;
        }
    }
    if (Tahsil != "") {
        if (strAddr != "") {
            strAddr = strAddr + "<br/>";
        }
        strAddr = strAddr + Tahsil;
    }
    if (City != "") {
        if (Tahsil == "") {
            strAddr = strAddr + "<br/>";
        }
        else {
            strAddr = strAddr + ", ";
        }
        strAddr = strAddr + City;
    }
    if (State != "") {
        if (City != "" || Tahsil != "") {
            strAddr = strAddr + ", ";
        }
        else if (strAddr != "") {
            strAddr = strAddr + "<br/>";
        }
        strAddr = strAddr + State;
    }
    if (Country != "") {
        if (State != "" || City != "") {
            strAddr = strAddr + ", ";
        }
        else if (strAddr != "") {
            strAddr = strAddr + "<br/>";
        }
        strAddr = strAddr + Country;
    }
    if (Zip != "") {
        if (State != "" || City != "" || Country != "") {
            strAddr = strAddr + " - ";
        }
        else if (strAddr != "") {
            strAddr = strAddr + "<br/>";
        }
        strAddr = strAddr + Zip;
    }
    return strAddr;
}
function FunSetAutoCompante(JsonData, inputID, HidID) {

    $("#" + inputID).autocomplete({
        selectFirst: true,
        delay: 0,
        mustMatch: true,
        autoFocus: true,
        source: JsonData,
        select: function (event, ui) {
            $("#" + HidID).val(ui.item.PKID);
            $("#" + inputID).val(ui.item.ColName);

            return false;
        },
        change: function (event, ui) {

            $(this).val((ui.item ? ui.item.ColName : ""));
            $("#" + inputID).val((ui.item ? ui.item.PKID : ""));

        },
        focus: function (event, ui) { event.preventDefault(); }
    });
}
function FunSetPosition(id) {

    $(function () {
        $.getScript("js/jquery-ui.js", function () {

            $('#' + id).draggable({ cursor: "move", handle: '.modal-header' });
        });
    });

    $('#' + id).css("top", Math.max(0, (($(window).height() - $('#' + id).outerHeight()) / 2) +
        $(window).scrollTop()) + "px");

    if ($(window).width() < 481) {
        $('#' + id).css("left", "1px");
    }
    else {
        $('#' + id).css("left", Math.max(0, (($(window).width() - $('#' + id).outerWidth()) / 2) +
            $(window).scrollLeft()) + "px");
    }

}
function SetZipCode(id) {
    $('#' + id).mask('00000-0000', { placeholder: "_____-____" });
}
function SetDatePickerMax(id, MaxDate) {

    $('#' + id).datepicker({
        dateFormat: DateFormat,
        startDate: '-3d',
        maxDate: MaxDate
    });
    $('#' + id).mask(MaskDateFormat, { placeholder: MaskDatePlaceHolder });
    $('#' + id).change(function () {
        ValidateMaxDate($(this).val(), id, MaxDate, "max");
    });
}
function SetDatePickerMin(id, MinDate) {
    $('#' + id).mask(MaskDateFormat, { placeholder: MaskDatePlaceHolder });
    $('#' + id).datepicker("option", "minDate", MinDate);


    $('#' + id).change(function () {
        ValidateMaxDate($(this).val(), id, MinDate, "min");
    });
}
function SetDatePicker(id) {

    $('#' + id).datepicker({
        dateFormat: DateFormat

    });
    $('#' + id).mask(MaskDateFormat, { placeholder: MaskDatePlaceHolder });
    $('#' + id).change(function () {
        ValidateDate($(this).val(), id);
    });
}
function SetDatePickerDOB(id) {

    var startdate = new Date();
    startdate.setFullYear(startdate.getFullYear() - 18);

    $('#' + id).datepicker({
        dateFormat: DateFormat,
        maxDate: startdate,
        setDate: startdate
    });
    $('#' + id).mask(MaskDateFormat, { placeholder: MaskDatePlaceHolder });
    $('#' + id).change(function () {
        ValidateDate($(this).val(), id);
    });
}
function SetTimePicker(id) {

    $('#' + id).timepicker({
        timeFormat: 'h:mm p',
        interval: 60,
        minTime: '8',
        maxTime: '5:00pm',
        defaultTime: '9',
        startTime: '8:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
    });

}
function SetGSTBox(id) {
    $('#' + id).change(function (event) {
        var str = $(this).val();

        if (str != "") {
            if (!ValidateGST(str)) {

                $(this).css("border-color", ColorE);
                $(this).focus();
                $(this).val("");
                OpenAlert('Invalid GST No!');
                event.preventDefault();
            }
            else {
                $(this).css("border-color", ColorN);
            }

        }
        else {
            $(this).css("border-color", ColorN);
        }

    });
}
function SetPANBox(id) {
    $('#' + id).change(function (event) {
        var str = $(this).val();

        if (str != "") {
            if (!ValidatePAN(str)) {

                $(this).css("border-color", ColorE);
                $(this).focus();
                $(this).val("");
                OpenAlert('Invalid PAN No!');
                event.preventDefault();
            }
            else {
                $(this).css("border-color", ColorN);
            }

        }
        else {
            $(this).css("border-color", ColorN);
        }

    });
}
function Trim(str) {
    while (str.charAt(0) == (" ")) {
        str = str.substring(1);
    }
    while (str.charAt(str.length - 1) == " ") {
        str = str.substring(0, str.length - 1);
    }
    return str;

}

function SetEmailBox(id) {
    $('#' + id).change(function (event) {
        var str = $(this).val();

        if (str != "") {
            if (!ValidateEmail(str)) {

                $(this).css("border-color", ColorE);
                $(this).focus();
                $(this).val("");
                OpenAlert('Invalid Email ID!');
                event.preventDefault();
            }
            else {
                $(this).css("border-color", ColorN);
            }

        }
        else {
            $(this).css("border-color", ColorN);
        }

    });
}


function ValidateDate(val, id) {

    if (val != "" && val != MaskDatePlaceHolder) {
        if (!isDate(val)) {
            alert('Invalid date format, date must be in ' + DateFormat.toUpperCase() + 'YY format');

            document.getElementById(id).value = "";
            $("#" + id).focus();
        }

    }
}
function ValidateMaxDate(val, id, MaxDate, type) {

    if (val != "" && val != MaskDatePlaceHolder) {
        if (!isDate(val)) {
            alert('Invalid date format, date must be in ' + DateFormat.toUpperCase() + 'YY format');

            document.getElementById(id).value = "";
            $("#" + id).focus();

        }
        else {
            var startdate = new Date(document.getElementById(id).value);
            if (type == "max") {
                if (Date.parse(startdate) > Date.parse(MaxDate)) {
                    alert('Date does not allowed');

                    document.getElementById(id).value = "";
                    $("#" + id).focus();
                }
            }
            else {
                if (Date.parse(startdate) < Date.parse(MaxDate)) {
                    alert('Date does not allowed');

                    document.getElementById(id).value = "";
                    $("#" + id).focus();
                }
            }

        }
    }

}

function SetMobileBox(id) {
    $('#' + id).mask('(000) 000-0000', { placeholder: "(___) ___-____" });
}


function SetAmountBox(id, decimalPlaces, allowNegative, defval) {

    if ($('#' + id).val() == "") {
        $('#' + id).val(defval);

    }

    $('#' + id).addClass("amount");
   /* $('#' + id).after("<span class='currency'>" + CurrencyName + "</span>");*/

    $('#' + id).keypress(function () {
        var temp = $(this).val();
        if (temp == "") {
            $(this).val(defval);
        }
        else {
            extractNumber(this, decimalPlaces, allowNegative);
        }

    });
    $('#' + id).keyup(function () {
        var temp = $(this).val();
        if (temp == "") {
            $(this).val(defval);
        }
        else {
            extractNumber(this, decimalPlaces, allowNegative);
        }

    });

    $('#' + id).change(function () {
        var temp = $(this).val();
        if (temp != "") {
            var newval = parseFloat(temp);

            $(this).val(newval.toFixed(decimalPlaces));
        }


    });


}
function SetNumberBox(id, decimalPlaces, allowNegative, defval) {
    if ($('#' + id).val() == "") {
        $('#' + id).val(defval);

    }
   // $('#' + id).css("text-align", "right");
    $('#' + id).keypress(function () {
        var temp = $(this).val();
        if (temp == "") {
            $(this).val(defval);
        }
        else {
            extractNumber(this, decimalPlaces, allowNegative);
        }

    });
    if ($('#' + id).hasClass("custom-select")) {
        $('#' + id).css("padding-right", "24px");
    }
    $('#' + id).keyup(function (event) {
        event.stopImmediatePropagation();
        var temp = $(this).val();
        if (temp == "") {
            $(this).val(defval);
        }
        else {
            extractNumber(this, decimalPlaces, allowNegative);
        }

    });


}
function FunSetDecimalAmt(id, decimalPlaces) {
    $('#' + id).change(function (event) {
        event.stopImmediatePropagation();
        var temp = $(this).val();
        if (temp != "") {
            $(this).val(parseFloat(temp).toFixed(decimalPlaces));
        }
       

    });

}
function SetDefaultVal(obj, decimalPlaces, allowNegative, defval) {
    var temp = obj.value;
    if (temp == "") {
        obj.value = "0";
    }
    else {
        extractNumber(obj, decimalPlaces, allowNegative);
    }
}
function TS_blockNonNumbers(obj, e, allowDecimal, allowNegative, id) {
    if (e.keyCode == 13) {
        var hoursid = 'txtdesc' + id;

        $('#' + hoursid).focus();
        e.preventDefault();
    }

    var key;
    var isCtrl = false;
    var keychar;
    var reg;

    if (window.event) {
        key = e.keyCode;
        isCtrl = window.event.ctrlKey
    }
    else if (e.which) {
        key = e.which;
        isCtrl = e.ctrlKey;
    }

    if (isNaN(key)) return true;

    keychar = String.fromCharCode(key);

    // check for backspace or delete, or if Ctrl was pressed
    if (key == 8 || isCtrl) {
        return true;
    }

    reg = /\d/;
    var isFirstN = allowNegative ? keychar == '-' && obj.value.indexOf('-') == -1 : false;
    var isFirstD = allowDecimal ? keychar == '.' && obj.value.indexOf('.') == -1 : false;




    return isFirstN || isFirstD || reg.test(keychar);
}
function Convert2Decimal(num, digit) {

    var n = num.toFixed(digit);
    return n;
}
function FormatMoney(number, decPlaces, decSep, thouSep) {
    decPlaces = isNaN(decPlaces = Math.abs(decPlaces)) ? 2 : decPlaces,
        decSep = typeof decSep == "undefined" ? "." : decSep;
    thouSep = typeof thouSep == "undefined" ? "," : thouSep;
    var sign = number < 0 ? "-" : "";
    var i = String(parseInt(number = Math.abs(Number(number) || 0).toFixed(decPlaces)));
    var j = (j = i.length) > 3 ? j % 3 : 0;

    return sign +
        (j ? i.substr(0, j) + thouSep : "") +
        i.substr(j).replace(/(\decSep{3})(?=\decSep)/g, "$1" + thouSep) +
        (decPlaces ? decSep + Math.abs(number - i).toFixed(decPlaces).slice(2) : "");
}
function RoundNumber(num, scale) {
    if (!("" + num).includes("e")) {
        return +(Math.round(num + "e+" + scale) + "e-" + scale);
    } else {
        var arr = ("" + num).split("e");
        var sig = ""
        if (+arr[1] + scale > 0) {
            sig = "+";
        }
        return +(Math.round(+arr[0] + "e" + sig + (+arr[1] + scale)) + "e-" + scale);
    }
}

function SetDateFormat(datestr) {
    var date = new Date(datestr);
    return ((date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear());
}
function GetTodayDate() {
    var strDate = "";
    var date = new Date();

    var DSplitChar = '/';
    if (DateFormat.indexOf('-') > -1) {
        DSplitChar = '-';
    }
    var month = ""; day = "";
    if ((date.getMonth() + 1) < 10) {
        month = "0" + (date.getMonth() + 1);
    }
    else {
        month = (date.getMonth() + 1);
    }
    if (date.getDate() < 10) {
        day = "0" + date.getDate();
    }
    else {
        day = date.getDate();
    }
    if (DateFormat.charAt(0) == 'm') {
       

        strDate = month + DSplitChar + day + DSplitChar + date.getFullYear();
    }
    else {
        strDate = day + DSplitChar + month + DSplitChar + date.getFullYear();
    }

    return strDate;
}


//Validate Functions
function isDate(date) {
    var objDate,  // date object initialized from the ExpiryDate string 
        mSeconds, // ExpiryDate in milliseconds 
        day,      // day 
        month,    // month 
        year;     // year 
    // date length should be 10 characters (no more no less) 
    if (date.length != 10) {
        return false;
    }
    // third and sixth character should be '/' 
    var DSplitChar = '/';
    if (DateFormat.indexOf('-') > -1) {
        DSplitChar = '-';
    }
    if (date.substring(2, 3) != DSplitChar || date.substring(5, 6) != DSplitChar) {
        return false;
    }
    // extract month, day and year from the ExpiryDate (expected format is mm/dd/yyyy) 
    // subtraction will cast variables to integer implicitly (needed 
    // for != comparing) 

    if (DateFormat.charAt(0) == 'm') {
        month = date.substring(0, 2) - 1; // because months in JS start from 0 
        day = date.substring(3, 5) - 0;
    }
    else {
        day = date.substring(0, 2) - 0; // because months in JS start from 0 
        month = date.substring(3, 5) - 1;
    }


    year = date.substring(6, 10) - 0;

    // test year range 
    if (year < 1000 || year > 3000) {
        return false;
    }
    // convert ExpiryDate to milliseconds 
    mSeconds = (new Date(year, month, day)).getTime();
    // initialize Date() object from calculated milliseconds 
    objDate = new Date();
    objDate.setTime(mSeconds);
    // compare input date and parts from Date() object 
    // if difference exists then date isn't valid 
    if (objDate.getFullYear() != year ||
        objDate.getMonth() != month ||
        objDate.getDate() != day) {
        return false;
    }
    // otherwise return true 
    return true;
}
function IsMobile(val, len) {
    var isvalid = true;
    val = val.replace("(", "");
    val = val.replace(")", "");
    val = val.replace("-", "");
    val = val.replace(" ", "");
    if (isNaN(val)) {
        isvalid = false;
    }
    else {
        if (val.length != len) {
            isvalid = false;
        }
    }
    return isvalid;
}
function extractNumber(obj, decimalPlaces, allowNegative) {
    var temp = obj.value;

    // avoid changing things if already formatted correctly
    var reg0Str = '[0-9]*';
    if (decimalPlaces > 0) {
        reg0Str += '\\.?[0-9]{0,' + decimalPlaces + '}';
    } else if (decimalPlaces < 0) {
        reg0Str += '\\.?[0-9]*';
    }
    reg0Str = allowNegative ? '^-?' + reg0Str : '^' + reg0Str;
    reg0Str = reg0Str + '$';
    var reg0 = new RegExp(reg0Str);
    if (reg0.test(temp)) return true;

    // first replace all non numbers
    var reg1Str = '[^0-9' + (decimalPlaces != 0 ? '.' : '') + (allowNegative ? '-' : '') + ']';
    var reg1 = new RegExp(reg1Str, 'g');
    temp = temp.replace(reg1, '');

    if (allowNegative) {
        // replace extra negative
        var hasNegative = temp.length > 0 && temp.charAt(0) == '-';
        var reg2 = /-/g;
        temp = temp.replace(reg2, '');
        if (hasNegative) temp = '-' + temp;
    }

    if (decimalPlaces != 0) {
        var reg3 = /\./g;
        var reg3Array = reg3.exec(temp);
        if (reg3Array != null) {
            // keep only first occurrence of .
            //  and the number of places specified by decimalPlaces or the entire string if decimalPlaces < 0
            var reg3Right = temp.substring(reg3Array.index + reg3Array[0].length);
            reg3Right = reg3Right.replace(reg3, '');
            reg3Right = decimalPlaces > 0 ? reg3Right.substring(0, decimalPlaces) : reg3Right;
            temp = temp.substring(0, reg3Array.index) + '.' + reg3Right;
        }
    }


    obj.value = temp;
}
function ValidateEmail(str) {
    if (str != '') {
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(str);
    }
}
function ValidateGST(val) {
   
    var gstinformat = new RegExp('^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    if (gstinformat.test(val)) {
        return true;
    }
    else {
        return false;
    }
}
function ValidatePAN(val) {
    var regex = /[A-Z]{5}[0-9]{4}[A-Z]{1}$/;
    return regex.test(val);
}
$.fn.ValZero = function () {
    var val = 0;
    try {

        if (this.val() && this.val() != "") {
            val = this.val();
        }

    }
    catch (e) {
        console.log(e);
    }

    return val;
}
$.fn.RoundVal = function (val) {
    var NewVal = "";
    try {

        if (val != "") {
            NewVal = RoundNumber(val, 2);
        }
        this.val(NewVal);
    }
    catch (e) {
        console.log(e);
    }


}
function ConvertToDecimal(val) {
    var newval = parseFloat(val);
    if (newval % 1 == 0) {
        newval = newval + '.' + '00';
    }
    return newval;
}
function FunSetTabKey() {
    $(document).on('keydown', ':tabbable', function (e) {

        if (e.key == "Enter") {
           

            var $canfocus = $(':tabbable:visible');
            var strtype = document.activeElement.getAttribute("type");
            var strtagname = document.activeElement.tagName;
            
            if (strtype == "button" || strtagname =="TEXTAREA") {
                //yes it an input type = 'radio' element.
            }
            else {
                e.preventDefault();
                var index = $canfocus.index(document.activeElement);
                if (!$canfocus.eq(index).hasClass("stopfocus")) {
                    index = index + 1;
                    if (index >= $canfocus.length) index = 0;                   
                    $canfocus.eq(index).focus();
                    $canfocus.eq(index).select();
                  
                }

               
            }
          
        }

    });
}

function JSONToCSVConvertor(JSONData, ReportTitle, ShowLabel) {
    //If JSONData is not an object then JSON.parse will parse the JSON string in an Object
    var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;

    var CSV = '';
    //Set Report title in first row or line

    CSV += ReportTitle + '\r\n\n';

    //This condition will generate the Label/Header
    if (ShowLabel) {
        var row = "";

        //This loop will extract the label from 1st index of on array
        for (var index in arrData[0]) {

            //Now convert each value to string and comma-seprated
            row += index + ',';
        }

        row = row.slice(0, -1);

        //append Label row with line break
        CSV += row + '\r\n';
    }

    //1st loop is to extract each row
    for (var i = 0; i < arrData.length; i++) {
        var row = "";

        //2nd loop will extract each column and convert it in string comma-seprated
        for (var index in arrData[i]) {
            row += '"' + arrData[i][index] + '",';
        }

        row.slice(0, row.length - 1);

        //add a line break after each row
        CSV += row + '\r\n';
    }

    if (CSV == '') {
        alert("Invalid data");
        return;
    }

    //Generate a file name
    var fileName = "MyReport_";
    //this will remove the blank-spaces from the title and replace it with an underscore
    fileName += ReportTitle.replace(/ /g, "_");

    //Initialize file format you want csv or xls
    var uri = 'data:text/csv;charset=utf-8,' + escape(CSV);

    // Now the little tricky part.
    // you can use either>> window.open(uri);
    // but this will not work in some browsers
    // or you will not get the correct file extension    

    //this trick will generate a temp <a /> tag
    var link = document.createElement("a");
    link.href = uri;

    //set the visibility hidden so it will not effect on your web-layout
    link.style = "visibility:hidden";
    link.download = fileName + ".csv";

    //this part will append the anchor tag and remove it after automatic click
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}