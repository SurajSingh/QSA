<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="Designations.aspx.cs" Inherits="QuickStartAdmin.Users.Designations" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />
      <asp:HiddenField ID="HidHasParent" runat="server" ClientIDMode="Static" Value="0" />
    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="bx bx-money font-size-18"></i>&nbsp;<span>Add New Designation</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-3">
                            <label class="form-label" for="name">Designation : *</label>
                            <input type="text" class="form-control" id="txtDepartment" required/>
                        </div>
                    </div>                 

                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Description :</label>
                            <textarea class="form-control" style="height: 100px;" id="txtDesc" ></textarea>
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


   <%-- <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Designation</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Designation</a></li>
                        <li class="breadcrumb-item active">QuickstartAdmin</li>
                    </ol>
                </div>

            </div>
        </div>
    </div>--%>

     <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0">Designations</h4>
            
            </div>
        </div>
    </div>




    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <%--change upper div  ***************************************************************************--%>

                    <div class="col-sm-12 pull-right">
                        <div class="row">
                            <div class="col-md-2">
                                <a class="popup-form btn btn-primary bg-green" id="btnAddNew"><i class="mdi mdi-plus me-1"></i>Add New</a>
                            </div>
                            <div class="col-md-2 divtopcontrol">
                                <ul class="ulpaging">
                                    <li><a title="Refresh" id="btnRefresh" class="buttons-filter"><i class="uil-refresh"></i>&nbsp;Refresh</a></li>

                                </ul>
                            </div>
                            <div class="col-md-8 divtopcontrol" id="tbldata_control">
                            </div>
                        </div>

                    </div>

                    <%--change ends ***************************************************************************--%>

                    <%--change filter div  ***************************************************************************--%>
                
                    <div id="tbldata_divfilter" class="hidetd divFilter">
                        <div class="divFilter-inner">
                            <div class="col-md-12">

                                <div class="row">
            
                                    <div class="col-sm-3 mar">

                                        <label>Search:<input type="search" id="searchTxt" class="form-control form-control-sm" placeholder="" aria-controls="tbldata"></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
               
                    <%--change filer div ends ******************************************************--%>
                    <div class="divreport">
                    <table id="tbldata" class="dataTable  genexcustomtable" style="border-collapse: collapse; border-spacing: 0; width: 100%;">
                            <colgrou>
                            </colgroup>
                        <thead>
                            <tr class="headmain">
                                <th data-column="DesigName" class="sorting tdDesigName" >Designation</th>
                                <th data-column="DesigDesc" class="sorting tdDesigDesc" >Description</th>                              
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
        </div>
        <!-- end col -->
    </div>

    <!-- end row -->
    <script src="UserJs/Manage/Designations.js?version=23062022"></script>
</asp:Content>
