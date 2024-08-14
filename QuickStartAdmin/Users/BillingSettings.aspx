<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="BillingSettings.aspx.cs" Inherits="QuickStartAdmin.Users.BillingSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Billing Settings</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Company Settings</a></li>
                        <li class="breadcrumb-item active">Billing Settings</li>
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

                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label>Invoice Prefix: </label>
                                <input type="text" class="form-control" id="txtInvoicePrefix" maxlength="10"  />
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label>Invoice Suffix: </label>
                                <input type="text" class="form-control" id="txtInvoiceSuffix" maxlength="10" />
                            </div>
                        </div>
                    </div>
                   

                    <div class="row">
                        <div class="col-lg-2 col-md-12">
                            <div class="mb-3">
                                <label>Next Invoice No: </label>
                                <input type="text" class="form-control" id="txtInvoiceSNo" maxlength="8"/>
                            </div>
                        </div>
                        
                    </div>                  
                    <div class="row">
                        <div class="col-lg-6">
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

    <script src="UserJs/CompanySettings/BillingSettings.js"></script>
</asp:Content>