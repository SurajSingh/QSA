var OriginalFileName = "", SavedFileName = "";
var UploadType = "Item";
var UploadBtnID = "btnFileSelectInner";
var UploadPath = "/Users/UserFiles/Item/";
var FileType = ".PNG,.JPG,.JPEG";
function FunUploadAttachment(uploadtype,btnid,uploadpath) {
    SavedFileName = "";
    OriginalFileName = "";
    UploadType = uploadtype;
    UploadBtnID = btnid;
    UploadPath = uploadpath;
    var status = 1;
  
    if (status == 1) {
        var iframe = document.getElementById("ifuploadfile");
        var args = [];
       
        args[0] = UploadType;
        args[1] = FileType;
        args[2] = "";
        args[3] = UploadBtnID;
        
        iframe.contentWindow.selectAttachment(args);
    }
}
function AttachClientFileCall(Result, Msg, trID, id, filesize, filename, filext) {

    if (Result == 1) {
        HideFileLoader(UploadBtnID);
        OriginalFileName = filename;
        SavedFileName = id;
        $("#btnfileselect").css("background-image", "url(" +UploadPath+ SavedFileName + ")");
    }
    else {

        HideFileLoader(UploadBtnID);
        OpenAlert(Msg);
    }
}