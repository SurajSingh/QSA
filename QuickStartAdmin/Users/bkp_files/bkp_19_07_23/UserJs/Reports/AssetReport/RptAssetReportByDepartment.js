

var pagename = "RptAssetReportByDepartment.aspx";
var PKID = 0;
var FKPageID = 0;




function InitilizeEvents() {



    $("#btnSearch").click(function () {
        var iframe = document.getElementById("ifReport");
        var args = [];

        args[0] = $('#txtAssetNameSrch').val();
        args[1] = $("#dropFKCategoryIDSrch").ValZero();
        args[2] = $('#dropFKConditionIDSrch').ValZero();
        args[3] = $('#dropFKLocationIDSrch').ValZero();
        args[4] = $('#dropFKDeptIDSrch').ValZero();
        args[5] = $('#dropFKEmpIDSrch').ValZero();
        args[6] = FKPageID;
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


    LoadEntity = 5;

    FunFillLocationMaster(FunLocationCallback);
    FunFillAssetConditionMaster(FunAssetConditionCallback);
    FunFillAssetCategory(FunAssetCategoryCallback);
    FunGetEmpForAutoComplate(FunEmpCallBack, 0, '');
    FunFillDept(FunDeptCallback);

}
function FunLocationCallback(str) {

    $('#dropFKLocationIDSrch').append(str);
    PageLoadComplete();
}
function FunAssetConditionCallback(str) {

    $('#dropFKConditionIDSrch').append(str);
    PageLoadComplete();
}
function FunAssetCategoryCallback(str) {

    $('#dropFKCategoryIDSrch').append(str);
    PageLoadComplete();
}
function FunDeptCallback(str) {

    $('#dropFKDeptIDSrch').append(str);
    PageLoadComplete();
}
function FunEmpCallBack(JsonArr) {

    var str = '';
    if (JsonArr.length > 0) {
        $.each(JsonArr, function (i, item) {
            str = str + '<option value="' + item.PKID + '">' + item.label1 + '</option>';
        });
    }

    $('#dropFKEmpIDSrch').append('<option value="0">All</option>' + str);

    PageLoadComplete();
}
$(document).ready(function () {
    FKPageID = parseInt($("#HidPageID").val());
    SetUserRoles(PageLoadFun);
});