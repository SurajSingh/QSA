<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="TaxMaster.aspx.cs" Inherits="QuickStartAdmin.Users.TaxMaster" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />

    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="bx bx-money font-size-18"></i>&nbsp;<span>Add New Tax</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label" for="name">Tax Name : *</label>
                            <input type="text" class="form-control" id="txtTaxName" required/>
                        </div>
                    </div>                 

                </div>
                <div class="row">
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Tax % : *</label>
                             <input type="text" class="form-control" id="txtTaxPercentage" required/>
                           
                        </div>
                    </div>
                </div>
            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Save" id="btnSave" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose" onclick="closediv();" />

            </div>
        </div>
    </div>


    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Tax Master</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Tax Master</a></li>
                        <li class="breadcrumb-item active">QuickstartAdmin</li>
                    </ol>
                </div>

            </div>
        </div>
    </div>






    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="col-sm-12 pull-right">
                        <a class="popup-form btn btn-primary bg-green mr-b-20" id="btnAddNew"><i class="mdi mdi-plus me-1"></i>Add New</a>
                    </div>

                    <table id="tbldata" class="table table-striped table-bordered dt-responsive nowrap" style="border-collapse: collapse; border-spacing: 0; width: 100%;">
                        <thead>
                            <tr>
                                <th>Tax Name</th>
                                <th>Tax %</th>                              
                                <th style="max-width:30px;">Edit</th>
                                <th style="max-width:40px;">Delete</th>
                            </tr>
                        </thead>

                        <tbody>
                        </tbody>
                    </table>
                    <div id="divDataloader" style="text-align: center;">
                        <img src="images/smallLoader.gif" />
                    </div>
                </div>
            </div>
        </div>
        <!-- end col -->
    </div>

    <!-- end row -->
    <script src="UserJs/Manage/TaxMaster.js?version=<%=PageVersion%>""></script>
</asp:Content>
