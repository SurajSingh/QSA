

var pagename = "RptClientMasterFileList.aspx";
var PKID = 0;
var FKPageID = 0;




function InitilizeEvents() {

   
   
    $("#btnSearch").click(function () {
        var iframe = document.getElementById("ifReport");
        var args = [];
        args[0] = $('#txtClientNameSrch').val();
        args[1] = $('#dropActiveStatusSrch').val();
      
        args[2] = FKPageID;
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
    LoadEntity = 0;
   
   
   
}



$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});