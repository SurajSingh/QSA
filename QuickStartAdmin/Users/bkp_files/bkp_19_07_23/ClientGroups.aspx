<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ClientGroups.aspx.cs" Inherits="QuickStartAdmin.Users.ClientGroups" %>
<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="modal-dialog modal-sm divpopup" id="divView" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="bx bx-money font-size-18"></i>&nbsp;<span>Client Group Detail</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">

                <div class="row">

                    <div class="col-sm-12">
                        <div class="mb-3">
                            <table id="tblDetail" class="table table-striped table-bordered dt-responsive nowrap" style="border-collapse: collapse; border-spacing: 0; width: 100%;">
                                <thead>
                                    <tr>
                                        <th id="tdGroupName">

                                            
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>

                        </div>


                    </div>



                </div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">

                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnCloseView" onclick="closediv();" />

            </div>
        </div>
    </div>
    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="bx bx-money font-size-18"></i>&nbsp;<span>Add New Client Group</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label" for="name">Group Name : *</label>
                            <input type="text" class="form-control" id="txtGroupName" maxlength="50" required />
                        </div>
                    </div>


                </div>
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Description : </label>
                            <textarea class="form-control" id="txtDescription" style="height: 50px;" maxlength="200"></textarea>

                        </div>
                    </div>
                </div>
                <div class="row mr-t-50">
                    <div class="font-size-16">
                         <label class="form-label">Select Clients in the group : *</label>
                     
                       
                    </div>
                    <div class="col-sm-5">
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
                    <div class="col-sm-5">
                        <div class="mb-3">
                            <select size="4" id="listcode2" multiple="multiple" class="form-control" style="height: 200px;">
                            </select>

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
                <h4 class="mb-0" id="pagetitle">Client Group</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Client Group</a></li>
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
                                <th>Group Name</th>
                                  <th>Description</th>
                                 <th>No. of Clients</th>
                                <th>Created By</th>
                                <th>Creation Date</th>
                                <th style="max-width: 30px;">Edit</th>
                                <th style="max-width: 40px;">Delete</th>
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
    <script src="UserJs/Groups/ClientGroups.js?version=<%=PageVersion%>"></script>
</asp:Content>
