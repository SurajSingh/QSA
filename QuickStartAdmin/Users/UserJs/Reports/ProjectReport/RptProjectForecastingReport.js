

var pagename = "RptProjectForecastingReport.aspx";
var PKID = 0;
var FKPageID = 0;


function FunFillContractTypeCallBack(str) {
    $('#dropFKContractTypeSrch').append(str);   
    PageLoadComplete();
}
function FunProjectCallBack(JsonArr) {
    $("#txtFKProjectID").GenexAutoComplete(JsonArr, "ProjectID,Project,ClientID");
   
    PageLoadComplete();
}

function InitilizeEvents() {

   
   
    $("#btnSearch").click(function () {
        if ($("#txtFKProjectID").GenexAutoCompleteGet('0') == '0') {

            OpenAlert('Select Project');

        }
        else {
            var iframe = document.getElementById("ifReport");
            var args = [];
            args[0] = $("#txtFKProjectID").GenexAutoCompleteGet('0');
            args[1] = $('#HidRecType').val();
            args[2] = FKPageID;
            iframe.contentWindow.SearchReport(args);
        }


      

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
    LoadEntity = 1;
   
    FunGetProjectForAutoComplete(FunProjectCallBack, 0, 'Active', 0);
   
   
}



$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});