<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ProfilePicture.aspx.cs" Inherits="QuickStartAdmin.Users.ProfilePicture" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Profile Picture</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Company Settings</a></li>
                        <li class="breadcrumb-item active">Profile Picture</li>
                    </ol>
                </div>

            </div>
        </div>
    </div>






    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="profile-logo">
                        <div class="profilehding">Company Logo <span style="font-weight:normal;font-size:12px;">(.jpg/.jpeg/.png/.bmp)</span><br />
                             <span style="font-weight:normal;font-size:12px;">Max Size: 245 KB</span>
                        </div>
                        <div class="fileupload" id="btnfileselect">
                            
                        </div>
                        <div class="editbtn">
                            
                            <a  class="btn btn-primary bg-green" id="btnUpload1"><i class="uil-edit me-1"></i>&nbsp;Edit</a>
                             &nbsp;<a  class="btn  bg-light" id="btnRest1"><i class="uil-trash me-1"></i>&nbsp;Reset</a>
                        </div>
                    </div>


                    <div class="profile-logo">
                        <div class="profilehding">Small Icon <span style="font-weight:normal;font-size:12px;">(.jpg/.jpeg/.png/.bmp)</span><br />
                             <span style="font-weight:normal;font-size:12px;">Max Size: 245 KB</span>
                        </div>
                        <div class="fileupload smallicon" id="btnfileselect1">
                            
                        </div>
                        <div class="editbtn">
                            <a  class="btn btn-primary bg-green" id="btnUpload2"><i class="uil-edit me-1"></i>&nbsp;Edit</a>&nbsp;<a  class="btn  bg-light" id="btnRest2"><i class="uil-trash me-1"></i>&nbsp;Reset</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- end col -->
    </div>

    <!-- end row -->
   <iframe src="Upload.aspx" id="ifuploadfile" style="display: none;"></iframe> 
    <script src="UserJs/CompanySettings/ProfilePicture.js?version=14082022"></script>
</asp:Content>
