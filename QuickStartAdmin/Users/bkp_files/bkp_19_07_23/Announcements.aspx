<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="Announcements.aspx.cs" Inherits="QuickStartAdmin.Users.Announcements" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <asp:HiddenField ID="HidID" runat="server" ClientIDMode="Static" Value="0" />
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />
     <div class="modal-dialog modal-sm divpopup" id="divView" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="bx bx-notification font-size-18"></i>&nbsp;<span>Announcement</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                             <table id="tbldetail" class="table table-borderless table-centered table-nowrap table-announcement">
                                <tbody>
                                </tbody>
                            </table>

                        </div>
                    </div>
                  
                </div>
              

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
               
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" onclick="closediv();" />

            </div>
        </div>
    </div>
    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="bx bx-notification font-size-18"></i>&nbsp;<span>Add New Announcement</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Date : *</label>
                            <input type="text" class="form-control" id="txtDisplayDate" required />

                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label">Active Status : *</label>
                            <select class="form-select" id="dropActiveStatus">
                                <option value="Active">Active</option>
                                <option value="Inactive">Inactive</option>
                            </select>

                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label" for="txtTitle">Title : *</label>
                            <input type="text" class="form-control" id="txtTitle" maxlength="500" required />
                        </div>
                    </div>

                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label" for="txtAnnouncement">Description : *</label>
                            <textarea class="form-control" id="txtAnnouncement" style="height: 40px;" maxlength="1000" required>

                            </textarea>

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
        <div class="col-xl-12">
            <div class="card">
                <div class="card-body">
                    <div class="col-sm-12 pull-right">
                        <a class="popup-form btn btn-primary bg-green mr-b-20" id="btnAddNew"><i class="mdi mdi-plus me-1"></i>Add New</a>
                    </div>

                    <h4 class="card-title mb-4">Announcements</h4>

                    <div style="max-height: 339px;">
                        <div class="table-responsive">
                            <table id="tbldata" class="table table-borderless table-centered table-nowrap table-announcement">
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                        <!-- enbd table-responsive-->
                    </div>
                    <!-- data-sidebar-->
                </div>
                <!-- end card-body-->
            </div>
            <!-- end card-->
        </div>
        <!-- end col -->


    </div>

    <div id="divDataloader" style="text-align: center;">
        <img src="images/smallLoader.gif" />
    </div>

    <!-- end row -->
    <script src="UserJs/CompanySettings/Announcements.js?version=<%=PageVersion%>"></script>
</asp:Content>
