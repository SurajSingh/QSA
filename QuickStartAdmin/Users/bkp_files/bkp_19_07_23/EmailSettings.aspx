<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="EmailSettings.aspx.cs" Inherits="QuickStartAdmin.Users.EmailSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Email Settings</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Company Settings</a></li>
                        <li class="breadcrumb-item active">Email Settings</li>
                    </ol>
                </div>

            </div>
        </div>
    </div>






    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="row" id="divValidateSummary" style="display: none;">
                    <div class="col-md-12 col-xs-12">
                        <div class="validate-box">
                            <ul></ul>
                        </div>
                    </div>
                </div>
                    <div class="row mr-t-50">

                        <div class="col-lg-4">
                            <div class="mb-3">
                                <label>Sender Email: *</label>
                                <input type="text" class="form-control" id="txtSenderEmail"  required />
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="mb-3">
                                <label>Password: *</label>
                                <input type="password" class="form-control" id="txtSenderPWD" required  />
                            </div>
                        </div>
                    </div>
                   

                    <div class="row">
                        <div class="col-lg-4 col-md-12">
                            <div class="mb-3">
                                <label>SMTP Server: *</label>
                                <input type="text" class="form-control" id="txtSMTPServer" required />
                            </div>
                        </div>
                        <div class="col-lg-2 col-md-12">
                            <div class="mb-3">
                                <label>SMTP Port: *</label>
                                <input type="text" class="form-control" id="txtSMTPPort" required />
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-12">
                            <div class="mb-3">
                                 <label>&nbsp;</label>
                                <div class="clearfix"></div>
                        <div class="form-check">
                            <input id="chkEnableSSL" type="checkbox" class="form-check-input">
                            <label class="form-check-label" for="chkEnableSSL">Enable SSL</label>
                        </div>
                                
                               
                            </div>
                        </div>
                    </div>                  
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="text-end">

                                <input type="button" id="btnsave" class="btn btn-primary bg-green" value="Save" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- end col -->
    </div>

    <!-- end row -->
    <script src="MasterJs/AddressJs.js"></script>
    <script src="UserJs/CompanySettings/EmailSettings.js"></script>
</asp:Content>
