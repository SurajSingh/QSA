

var pagename = "RptInvoiceRegister.aspx";
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
        args[5] = '';
        args[6] ='';
        args[7] ='';
        args[8] = 0;
        args[9] = '';
        args[10] = $('#txtInviceNoSrch').val();
        args[11] = FKPageID;
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
   
    LoadEntity = 2;
   
    FunGetClientForAutoComplete(FunClientCallBack, 0, '');
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
    //FunGetEmpForAutoComplate(FunEmpCallBack, 0, '');
   
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


$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});