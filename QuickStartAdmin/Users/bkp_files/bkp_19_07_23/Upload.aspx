<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Upload.aspx.cs" Inherits="QuickStartAdmin.Users.Upload" %>

<!DOCTYPE html>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <script src="assets/libs/jquery/jquery.min.js"></script>
    <script src="assets/libs/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
        function selectfile() {

            $("#FileUpload1").trigger("click");
        }
        function onupload() {
            var value = $("#FileUpload1").val();

            if (value != '') {
                window.parent.ShowFileLoader($("#hidBtnID").val());
                $("#form1").submit();

            }


        }
        function readURL(input) {
            var Extension = input.value.substring(input.value.lastIndexOf('.') + 1).toLowerCase();
            var array = ['jpg', 'png', 'jpeg', 'bmp'];
           
            if ($("#hidFileType").val() == "CSV") {
                array = ['csv'];
            }
            else if ($("#hidFileType").val() == "Excel") {
                array['xlsx', 'xls', 'xlsm']
            }
            if (array.indexOf(Extension) <= -1) {

                if ($("#hidFileType").val() == "CSV") {
                    alert("Only CSV File Allowed!");
                }
                else if ($("#hidFileType").val() == "Excel") {
                    alert("Only XLSX, XLS Or XLSM files are allowed!");
                }
                else {
                    alert("Only JPG,JPEG,BMP or PNG files are allowed!");
                   
                }
               

              
               

            }
            else {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();

                    reader.onload = function (e) {

                        document.getElementById("divpreview").style.backgroundImage = "url(" + e.target.result + ")";
                    }

                    reader.readAsDataURL(input.files[0]);
                }
               
            }
        }


        function callFileClientFunction(id, filesize, filename, filext, Result, Msg) {
          
            window.parent.AttachClientFileCall(Result, Msg, $("#hidTRID").val(),id, filesize, filename, filext);
        }

        window.selectAttachment = function (args) {
            $("#hidUploadType").val(args[0]);
            $("#hidFileType").val(args[1]);
            $("#hidTRID").val(args[2]);
            $("#hidBtnID").val(args[3]);
          
            selectfile();
        }
        function LogoutParent() {
            window.parent.location.href = "Logout.aspx";
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
         <asp:HiddenField ID="hidUploadType" runat="server" ClientIDMode="Static" Value="" />
        <asp:HiddenField ID="hidFileType" runat="server" ClientIDMode="Static" Value="" />
        <asp:HiddenField ID="hidTRID" runat="server" ClientIDMode="Static" Value="" />
         <asp:HiddenField ID="hidBtnID" runat="server" ClientIDMode="Static" Value="" />
        
        <div style="display: none">
          
            <asp:FileUpload ID="FileUpload1" runat="server" Width="200px" CssClass="fileupload" onchange="onupload();" />

        </div>
        <div id="divErrormsg" runat="server" style="display:none;"></div>
    </form>
</body>
</html>
