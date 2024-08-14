

var pagename = "RptTimeExpensesDetailbyClientProject.aspx";
var PKID = 0;
var FKPageID = 0;




function InitilizeEvents() {

   
   
    $("#btnSearch").click(function () {
        var iframe = document.getElementById("ifReport");
        var args = [];

        args[0] = $('#dropaterange').val();
        args[1] = $('#txtfromdate').val();
        args[2] = $('#txttodate').val();
        args[3] = $('#divFKProjectIDSrch').GenexMultiSelectGet();
        args[4] = $('#divFKClientIDSrch').GenexMultiSelectGet();
        args[5] = $('#divFKEmpIDSrch').GenexMultiSelectGet();
        args[6] = $('#dropBillableSrch').val();
        args[7] = $('#dropApproveStatusSrch').val();
        args[8] = $('#dropFKManagerIDSrch').ValZero();
        args[9] = $('#dropBilledSrch').val();
        args[10] = $('#dropTaskTypeSrch').val();

        var WithCost = "0";
        if ($('#chkShowCostSrch').is(':checked')) {
            WithCost = "1";
        }
        args[11] = WithCost;
        args[12] = FKPageID;
        iframe.contentWindow.SearchReport(args);
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
    
    SetDatePicker("txtfromdate");
    SetDatePicker("txttodate");
   
    LoadEntity = 3;
   
    FunGetClientForAutoComplete(FunClientCallBack, 0, '');
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, '');
   
}
function FunGridLayoutCallback(JsonArr) {

    JsonReportLayout = JsonArr;
    PageLoadComplete();
}



function FunGridLayoutSetArray(JsonArr, id) {
    JsonReportLayout = JsonArr;
}

function FunProjectCallBack(JsonArr) {   
    $("#divFKProjectIDSrch").GenexMultiSelect(JsonArr);
    PageLoadComplete();
}
function FunClientCallBack(JsonArr) {
    $("#divFKClientIDSrch").GenexMultiSelect(JsonArr);
    PageLoadComplete();
}

function FunEmpCallBack(JsonArr) {

    $("#divFKEmpIDSrch").GenexMultiSelect(JsonArr);
    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });
    }
    $('#dropFKManagerIDSrch').append('<option value="0">All</option>' + str);
    PageLoadComplete();
 
}
$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});