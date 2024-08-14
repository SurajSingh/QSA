<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="InvoiceTemplate.aspx.cs" Inherits="QuickStartAdmin.Users.InvoiceTemplate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <div id="divShowImage" class="imagemodal">
        <span class="close" onclick="closediv();">&times;</span>
        <img class="imagemodal-content" id="imgItem" />
        <div id="caption"></div>
    </div>


    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Invoice Template</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Company Settings</a></li>
                        <li class="breadcrumb-item active">Invoice Template</li>
                    </ol>
                </div>

            </div>
        </div>
    </div>






    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    
                    <div class="row mr-t-50 divinvtemplate">

                        <div class="col-lg-4">
                            <div class="imgbox" id="divTemp1" data-id="1" data-img="assets/images/invoice/template1.png" style="background-image:url(assets/images/invoice/template1.png);">
                                <span><i class="fa fa-search"></i></span>
                            </div>
                        </div>
                        <div class="col-lg-4">
                             <div class="imgbox" id="divTemp2" data-id="2" data-img="assets/images/invoice/template2.png" style="background-image:url(assets/images/invoice/template2.png);">
                                  <span><i class="fa fa-search"></i></span>
                            </div>
                        </div>
                        <div class="col-lg-4">
                             <div class="imgbox" id="divTemp3" data-id="3" data-img="assets/images/invoice/template3.png" style="background-image:url(assets/images/invoice/template3.png);">
                                  <span><i class="fa fa-search"></i></span>
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

    <script src="UserJs/CompanySettings/InvoiceTemplate.js?version=13092022"></script>
</asp:Content>
