<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="SchedulingEmailReceivers.aspx.cs" Inherits="QuickStartAdmin.Users.SchedulingEmailReceivers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Scheduling Email</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Company Settings</a></li>
                        <li class="breadcrumb-item active">Scheduling Email</li>
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
                        <div class="font-size-16">
                            Select Receivers for Scheduling Emails :<br>
                            <br>
                        </div>
                        <div class="col-sm-3">
                            <div class="mb-3">
                                <select size="4" id="listcode1" multiple="multiple" class="nobackimage form-control" style="height: 200px;">
                                </select>

                            </div>


                        </div>
                        <div class="col-sm-2">
                            <div class="btn-pd">

                                <input type="button" id="btnMoveRight" class="btnadd" value=">>" title="Move Right"><br>
                                <br>
                                <input type="button" class="btnadd" value="<<" id="btnMoveLeft" title="Move Left">
                            </div>

                        </div>
                        <div class="col-sm-3">
                            <div class="mb-3">
                                <select size="4" id="listcode2" multiple="multiple" class="form-control" style="height: 200px;">
                                </select>

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
                        <div class="col-md-4">
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

    <script src="UserJs/CompanySettings/SchedulingEmailReceivers.js"></script>
</asp:Content>
