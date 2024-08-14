<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="CompanyInformation.aspx.cs" Inherits="QuickStartAdmin.Users.CompanyInformation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Company Information</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Company Settings</a></li>
                        <li class="breadcrumb-item active">Company Information</li>
                    </ol>
                </div>

            </div>
        </div>
    </div>



    <div class="row" id="divValidateSummary" style="display: none;">
        <div class="col-md-12 col-xs-12">
            <div class="validate-box">
                <ul></ul>
            </div>
        </div>
    </div>


    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body" id="divAddForm">
                    <div class="row mr-t-50">

                        <div class="col-lg-4 mar">
                            <div class="mb-3">
                                <label>Company Name: *</label>
                                <input type="text" class="form-control" id="txtCompanyName" required />
                            </div>
                        </div>
                        <div class="col-lg-4 mar">
                            <div class="mb-3">
                                <label>Contact Person: *</label>
                                <input type="text" class="form-control" id="txtCPerson" required />
                            </div>
                        </div>
                    </div>
                    <div class="row">

                        <div class="col-md-4">
                            <div class="mb-3">
                                <label class="form-label">Address: *</label>
                                <input id="txtAddress1" type="text" class="form-control" placeholder="Building No./Unit" maxlength="100" required/>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label class="form-label">&nbsp;</label><input id="txtAddress2" type="text" class="form-control" placeholder="Street" maxlength="100" />
                            </div>
                        </div>

                    </div>
                    <div class="row">

                        <div class="col-md-2">
                            <div class="mb-3">
                                <select class="form-select" id="dropFKCountryID" required></select>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="mb-3">
                                <select class="form-select" id="dropFKStateID"></select>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="mb-3">
                                <select class="form-select" id="dropFKCityID"></select>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="mb-3">
                                <select class="form-select" id="dropFKTahsilID"></select>
                            </div>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <div class="mb-3">
                                <input id="txtZIP" type="text" class="form-control" maxlength="6" placeholder="ZIP" />
                            </div>

                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-2 col-md-12">
                            <div class="mb-3">
                                <label>Phone:</label>
                                <input type="text" class="form-control" id="txtPhone" />
                            </div>
                        </div>
                        <div class="col-lg-2 col-md-12">
                            <div class="mb-3">
                                <label>Cell:</label>
                                <input type="text" class="form-control" id="txtMobile" />
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-12">
                            <div class="mb-3">
                                <label>Email: *</label>
                                <input type="text" class="form-control" id="txtEmail" required />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4 col-md-12">
                            <div class="mb-3">
                                <label>Website:</label>
                                <input type="text" class="form-control" id="txtWebsite" />
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-12">
                            <div class="mb-3">
                                <label>Currency: *</label>
                                <select id="dropFKCurrencyID" class="form-select" required>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">


                        <div class="col-lg-4 col-md-12">
                            <div class="mb-3">
                                <label>Timezone: *</label>
                                <select id="dropFKTimezoneID" class="form-select" required>
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-12">
                            <div class="mb-3">
                                <label>Date Format: *</label>
                                <select id="txtDateForStr" class="form-select">
                                    <option value="MM/dd/yyyy">MM/DD/YYYY</option>
                                    <option value="dd-MM-yyyy">DD-MM-YYYY</option>
                                    <option value="MM-dd-yyyy">MM-DD-YYYY</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-8">
                            <div class="text-end" style="margin-top:20px;">

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
    <script src="UserJs/CompanySettings/CompanyInformation.js?version=25092022"></script>
</asp:Content>
