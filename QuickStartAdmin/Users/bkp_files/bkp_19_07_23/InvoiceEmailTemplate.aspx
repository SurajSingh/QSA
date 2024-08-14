<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="InvoiceEmailTemplate.aspx.cs" Inherits="QuickStartAdmin.Users.InvoiceEmailTemplate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Invoice Email Template</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Company Settings</a></li>
                        <li class="breadcrumb-item active">Invoice Email Template</li>
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

                        <div class="col-md-12">
                            <div class="mb-3">
                                <label>Subject: *</label>
                                <input type="text" class="form-control" id="txtSubject" required />
                            </div>
                        </div>
                        
                    </div>
                    <div class="row mr-t-50">

                        <div class="col-lg-12">
                            <div class="mb-3">
                                <textarea id="txtEmailHTML" name="area"></textarea>
                            </div>
                        </div>

                    </div>



                    <div class="row">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <div class="form-check">
                                    <input id="chkEnableEmail" type="checkbox" class="form-check-input">
                                    <label class="form-check-label" for="chkEnableEmail">Enable Email</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
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
    <script src="assets/libs/tinymce/tinymce.min.js"></script>
    <script src="UserJs/CompanySettings/InvoiceEmailTemplate.js"></script>
</asp:Content>
