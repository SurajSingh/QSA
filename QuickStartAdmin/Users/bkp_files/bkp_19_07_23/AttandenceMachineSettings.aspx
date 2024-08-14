<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="AttandenceMachineSettings.aspx.cs" Inherits="QuickStartAdmin.Users.AttandenceMachineSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Attandence Machine Settings</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Company Settings</a></li>
                        <li class="breadcrumb-item active">Attandence Machine Settings</li>
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

                        <div class="col-lg-2">
                            <div class="mb-3">
                                <label>Username: *</label>
                                <input type="text" class="form-control" id="txtAttenUserName"  />
                            </div>
                        </div>                       
                    </div>                  

                    <div class="row">
                        <div class="col-lg-2">
                            <div class="mb-3">
                                <label>Password: *</label>
                                <input type="password" class="form-control" id="txtAttenPWD" />
                            </div>
                        </div>
                        
                    </div>                  
                    <div class="row">
                        <div class="col-lg-2">
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

    <script src="UserJs/CompanySettings/AttandenceMachineSettings.js"></script>
</asp:Content>