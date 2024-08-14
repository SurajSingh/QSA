<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="Clients.aspx.cs" Inherits="QuickStartAdmin.Users.Clients" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />
    <div id="otherdiv_inftype" class="otherdiv" style="z-index: 1045;"></div>

    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>Add New Client</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <div class="row" id="divValidateSummary" style="display: none;">
                    <div class="col-md-12 col-xs-12">
                        <div class="validate-box">
                            <ul></ul>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Client ID: *</label>
                            <input class="form-control" id="txtCode" maxlength="50" />
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="mb-3">
                            <label class="form-label">Client Name: *</label>
                            <input class="form-control" id="txtCompany" maxlength="50" />
                        </div>
                    </div>

                </div>
                <div class="row">
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Contact Person:</label>
                            <input class="form-control" id="txtCPerson" maxlength="50" />
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Designation:</label>
                            <input class="form-control" id="txtCPersonTitle" maxlength="50" />
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Email:</label>
                            <input class="form-control" id="txtEMailID" />
                        </div>
                    </div>

                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Website:</label>
                            <input class="form-control" id="txtWebsite" />
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Work Phone:</label>
                            <input class="form-control" id="txtPhone1" maxlength="15" />
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Home Phone:</label>
                            <input class="form-control" id="txtPhone2" maxlength="15" />
                        </div>
                    </div>

                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Cell:</label>
                            <input class="form-control" id="txtMobile" maxlength="15" />
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Fax:</label>
                            <input class="form-control" id="txtFax" />
                        </div>
                    </div>
                </div>

                <div class="row">

                    <div class="col-md-4">
                        <div class="mb-3">
                            <label class="form-label">Address: </label>
                            <input id="txtAddress1" type="text" class="form-control" placeholder="Building No./Unit" maxlength="100" />
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label class="form-label">&nbsp;</label><input id="txtAddress2" type="text" class="form-control" placeholder="Street" maxlength="100" />
                        </div>
                    </div>

                </div>
                <div class="row">

                    <div class="col-md-3">
                        <div class="mb-3">
                            <select class="form-select" id="dropFKCountryID"></select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="mb-3">
                            <select class="form-select" id="dropFKStateID"></select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="mb-3">
                            <select class="form-select" id="dropFKCityID"></select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="mb-3">
                            <select class="form-select" id="dropFKTahsilID"></select>
                        </div>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3">
                        <div class="mb-3">
                            <input id="txtZIP" type="text" class="form-control" maxlength="6" placeholder="ZIP" />
                        </div>

                    </div>
                </div>

                <div class="clearfix"></div>
                <div class="row">
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Manger:</label>
                            <input type="text" id="txtFKManagerID" class="form-control" />
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Active Status:</label>
                            <select id="dropActiveStatus" onchange="empstatus(this)" class="form-select">
                                <option value="Active">Active</option>
                                <option value="Released">Released</option>
                                <option value="Block">Block</option>

                            </select>
                        </div>
                    </div>

                </div>

                <div class="clearfix"></div>

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
                <h4 class="mb-0" id="pagetitle">Clients</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Clients</a></li>
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
                    <div id="tbldata_divfilter" class="hidetd divFilter">

                        <div class="divFilter-inner">
                            <div class="col-md-12">

                                <div class="row">
                                    <div class="col-sm-3 mar">
                                        <label>Client ID/Name:</label>
                                        <input type="text" class="form-control" id="txtClientNameSrch" />
                                    </div>


                                    <div class="col-sm-3 mar">
                                        <label>Status:</label>
                                        <select class="form-select" id="dropActiveStatusSrch">
                                            <option value="">-All-</option>
                                            <option value="Active">Active</option>
                                            <option value="Block">Block</option>
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">

                                        <a id="btnSearch" class="btn btn-primary bg-green mr-b-20 mr-t-50"><i class="uil-search me-1"></i>Search</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="divreport">
                        <table id="tbldata" class="dataTable  genexcustomtable">
                            <colgroup>
                            </colgroup>
                            <thead>
                                <tr class="headmain">
                                    <th style="width: 20px;"></th>
                                    <th style="width: 20px;"></th>
                                    <th data-column="Code" class="sorting tdCode">ClientID</th>
                                    <th data-column="Company" class="sorting tdCompany">Client</th>
                                    <th data-column="CPerson" class="sorting tdCPerson">Contact Person</th>
                                    <th data-column="CPersonTitle" class="sorting tdCPersonTitle">Designation</th>
                                    <th data-column="ManagerName" class="sorting tdManagerName">Manager</th>
                                    <th data-column="EMailID" class="sorting tdEMailID">Email</th>
                                    <th data-column="Phone1" class="sorting tdPhone1">Work Phone</th>
                                    <th data-column="Phone2" class="sorting tdPhone2">Home Phone</th>
                                    <th data-column="Mobile" class="sorting tdMobile">Cell</th>
                                    <th data-column="StateName" class="sorting tdStateName">State</th>
                                    <th data-column="CityName" class="sorting tdCityName">City</th>
                                    <th data-column="ActiveStatus" class="sorting tdActiveStatus">Status</th>
                                    <th data-column="CreatedByName" class="sorting tdCreatedByName">Created By</th>
                                    <th data-column="CreationDate" class="sorting tdCreationDate">Creation Date</th>
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
    <script src="MasterJs/AddressJs.js"></script>
    <script src="UserJs/Manage/Clients.js?version=<%=PageVersion%>"></script>
</asp:Content>
