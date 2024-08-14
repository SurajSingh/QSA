

var pagename = "RptProjectAnalysisReport.aspx";
var PKID = 0;
var FKPageID = 0;




function InitilizeEvents() {

   
   
    $("#btnSearch").click(function () {
        var iframe = document.getElementById("ifReport");
        var args = [];

        args[0] = '';
        args[1] = $("#txtFKClientIDSrch").GenexAutoCompleteGet('0');
        args[2] = $('#dropActiveStatusSrch').val();
        args[3] = $('#dropFKContractTypeSrch').val();
        args[4] = $("#txtFKProjectID").GenexAutoCompleteGet('0');
        args[5] = FKPageID;
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
    FunFillContractType(FunFillContractTypeCallBack);
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);

   
}

function FunClientCallBack(JsonArr) {
   
    $("#txtFKClientIDSrch").GenexAutoComplete(JsonArr, "ClientID,Name,Status");
    PageLoadComplete();
}

function FunFillContractTypeCallBack(str) {
    $('#dropFKContractTypeSrch').append(str);
   
    PageLoadComplete();
}
function FunProjectCallBack(JsonArr) {
    $("#txtFKProjectID").GenexAutoComplete(JsonArr, "ProjectID,Project,ClientID");

    PageLoadComplete();
}
$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});