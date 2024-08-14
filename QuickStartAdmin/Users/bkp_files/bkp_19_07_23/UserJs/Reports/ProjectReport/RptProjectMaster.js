

var pagename = "RptProjectMaster.aspx";
var PKID = 0;
var FKPageID = 0;


function FunFillContractTypeCallBack(str) {
    $('#dropFKContractTypeSrch').append(str);   
    PageLoadComplete();
}
function FunClientCallBack(JsonArr) {
    $("#txtFKClientIDSrch").GenexAutoComplete(JsonArr, "ClientID,Name,Status");
   
    PageLoadComplete();
}

function InitilizeEvents() {

   
   
    $("#btnSearch").click(function () {
        var iframe = document.getElementById("ifReport");
        var args = [];
        args[0] = $('#txtClientNameSrch').val();
        args[1] = $("#txtFKClientIDSrch").GenexAutoCompleteGet('0');
        args[2] = $('#dropActiveStatusSrch').val();
        args[3] = $('#dropFKContractTypeSrch').ValZero();
        args[4] = FKPageID;
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
    LoadEntity = 2;
   
    FunGetClientForAutoComplete(FunClientCallBack, 0, '');   
    FunFillContractType(FunFillContractTypeCallBack);
   
   
}



$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});