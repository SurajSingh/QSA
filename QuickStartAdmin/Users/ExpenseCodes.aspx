<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ExpenseCodes.aspx.cs" Inherits="QuickStartAdmin.Users.ExpenseCodes" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />
    <div id="otherdiv_inftype" class="otherdiv" style="z-index: 1045;"></div>

    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>Add Expense Code</span></h4>
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
                            <label class="form-label" for="name">Expense Type: *</label>
                            <input id="txtTaskCode" type="text" class="form-control" maxlength="40" />
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label" for="email">Expense Name: *</label>
                            <input id="txtTaskName" type="text" class="form-control" maxlength="40" />
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Active Status: *</label>
                            <select id="dropActiveStatus" class="form-select">
                                <option>Active</option>
                                <option>Block</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Cost Rate:(<%=StrCurrency %>)</label>
                            <input id="txtCostRate" type="text" class="form-control" />
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">MU %:</label>
                            <input id="txtMuRate" type="text" class="form-control" />
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="mb-3">
                            <label class="form-label">Tax %:</label>
                            <input id="txtTax" class="form-control" />
                        </div>
                    </div>
                    <div class="col-lg-2">
                        <div class="mb-3">

                            <div class="form-check">
                                <input id="chkIsBillable" type="checkbox" class="form-check-input">
                                <label class="form-check-label" for="chkIsBillable">Billable</label>
                            </div>
                        </div>
                    </div>
                     <div class="col-lg-2">
                        <div class="mb-3">

                            <div class="form-check">
                                <input id="chkisReimb" type="checkbox" class="form-check-input">
                                <label class="form-check-label" for="chkisReimb">Reimb</label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Description:</label>
                            <textarea id="txtDescription" class="form-control" style="height: 100px;" maxlength="500"></textarea>
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
                <h4 class="mb-0" id="pagetitle">Expense Codes</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Expense Codes</a></li>
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
                                        <label>Exp. Type/Name :</label>
                                        <input type="text" class="form-control" id="txtTaskCodeSrch" />
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
                                    <th data-column="TaskCode" class="sorting tdTaskCode">Expense  Type</th>
                                    <th data-column="TaskName" class="sorting tdTaskName">Expense  Name</th>
                                    <th data-column="Description" class="sorting tdDescription">Description</th>
                                    <th data-column="CostRate" class="sorting tdCostRate tdclscurrency">Cost Rate</th>
                                    <th data-column="MuRate" class="sorting tdMuRate">MU%</th>
                                    <th data-column="isReimb" class="sorting tdisReimb">Reimb</th>
                                    <th data-column="IsBillable" class="sorting tdIsBillable">Billable</th>
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

    <script src="UserJs/Manage/ExpenseCodes.js?version=<%=PageVersion%>"></script>
</asp:Content>
