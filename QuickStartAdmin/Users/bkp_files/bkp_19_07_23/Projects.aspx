<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="Projects.aspx.cs" Inherits="QuickStartAdmin.Users.Projects" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />
  

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
                <ul class="nav nav-pills nav-justified bg-light nr-nav-pill" role="tablist">
                    <li class="nav-item waves-effect waves-light">
                        <a class="nav-link active" data-bs-toggle="tab" href="#navpills2-home" role="tab" aria-selected="true">
                            <span class="d-block d-sm-none"><i class="fas fa-home"></i></span>
                            <span class="d-none d-sm-block">General</span>
                        </a>
                    </li>
                    <li class="nav-item waves-effect waves-light">
                        <a class="nav-link" data-bs-toggle="tab" href="#navpills2-profile" role="tab" aria-selected="false">
                            <span class="d-block d-sm-none"><i class="far fa-user"></i></span>
                            <span class="d-none d-sm-block">Billing Information</span>
                        </a>
                    </li>                   
                    <li class="nav-item waves-effect waves-light">
                        <a class="nav-link" data-bs-toggle="tab" href="#navpills2-settings" role="tab" aria-selected="false">
                            <span class="d-block d-sm-none"><i class="far fa-envelope"></i></span>
                            <span class="d-none d-sm-block">Settings</span>
                        </a>
                    </li>
                </ul>

                <!-- Tab panes -->
                <div class="tab-content">
                    <div class="tab-pane active" id="navpills2-home" role="tabpanel">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Project ID: *</label>
                                        <input type="text" class="form-control" id="txtProjectCode" />
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <div class="mb-3">
                                        <label class="form-label">Title: *</label>
                                        <input type="text" class="form-control" id="txtProjectName" />
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Client: *</label>
                                         <input type="text" id="txtFKClientID" class="form-control" />
                                       
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Manager:</label>
                                        <input type="text" id="txtFKManagerID" class="form-control" />
                                    </div>
                                </div>

                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Contract Type:</label>
                                        <select class="form-select" id="dropFKContractTypeID">
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Contract Amt.:(<%=StrCurrency %>) *</label>
                                        <input class="form-control" placeholder="0.00" id="txtContractAmt" />
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Service Amt.:(<%=StrCurrency %>)</label>
                                        <input class="form-control" placeholder="0.00" id="txtExpAmt" />
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Exp Amt:(<%=StrCurrency %>)</label>
                                        <input class="form-control" placeholder="0.00" id="txtServiceAmt" />
                                    </div>
                                </div>
                            </div>


                            <div class="row">
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">% Complete:</label>
                                        <input class="form-control" placeholder="0.00" id="txtCompletePercent" />
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Start Date:</label>
                                        <input type="text" class="form-control" id="txtStartdate" />
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Due Date:</label>
                                        <input type="text" class="form-control" id="txtDueDate" />
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Budgeted Hours: </label>
                                        <input class="form-control" placeholder="0.00" id="txtBudgetedHours" />
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">PO#:</label>
                                        <input class="form-control" id="txtPONo" />
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Status: </label>
                                        <select class="form-select" id="dropProjectStatus">
                                            <option value="Active">Active</option>
                                            <option value="Archived">Archived</option>
                                            <option value="Completed">Completed</option>
                                            <option value="Hold">Hold</option>
                                            <option value="Inactive">Inactive</option>
                                            <option value="Main">Main</option>
                                            <option value="Canceled">Canceled</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label class="form-label">Remark :</label>
                                        <textarea class="form-control" id="txtRemark" style="height: 100px;"></textarea>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="tab-pane" id="navpills2-profile" role="tabpanel">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Currency:</label>
                                        <select id="dropFKCurrencyID" class="form-select">
                                        </select>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Billing Frequency:</label>
                                        <select class="form-select" id="dropFKBillingFrequency">
                                            
                                        </select>
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Tax:</label>
                                        <select class="form-select" id="dropFKTaxID">
                                       
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="mb-3">
                                        <label class="form-label">Main Expense Tax(%):</label>
                                        <input type="text" class="form-control" id="txtExpenseTax" />
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="mb-3">
                                        <label class="form-label">Payment Term:</label>
                                        <select class="form-select" id="dropFKTermID" >                                         
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <input type="checkbox" id="chkISCustomInvoice">&nbsp;&nbsp;<label>Use Custom Invoice Number</label>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Prefix:</label>
                                        <input type="text" class="form-control" placeholder="Invoice Number Prefix" id="txtInvoicePrefix" />
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Next Number:</label>
                                        <input type="text"  class="form-control" placeholder="Last Invoice Number" id="txtInvoiceSNo">
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Suffix:</label>
                                        <input type="text"  class="form-control" placeholder="Invoice Suffix" id="txtInvoiceSuffix" />
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    
                    <div class="tab-pane" id="navpills2-settings" role="tabpanel">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-lg-12">
                                    <h4 class="card-title">Time Sheet Default Settings</h4>
                                    <div class="mb-3">
                                        <input  type="checkbox" id="chkTBillable" />&nbsp;&nbsp;<label>Default time entry is billable</label>
                                    </div>
                                    <div class="mb-3">
                                        <input type="checkbox" id="chkTMemoRequired" />&nbsp;&nbsp;<label>Memo is required for a time entry</label>
                                    </div>
                                    <div class="mb-3">
                                        <input type="checkbox"id="chkTDesReadonly" />&nbsp;&nbsp;<label>Disallow employee to edit task description</label>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <h4 class="card-title">Expenses Default Settings</h4>
                                    <div class="mb-3">
                                        <input type="checkbox"id="chkEBillable" />&nbsp;&nbsp;<label>Default expense entry is billable</label>
                                    </div>
                                    <div class="mb-3">
                                        <input type="checkbox"id="chkEMemoRequired" />&nbsp;&nbsp;<label>Memo is required for an expense entry</label>
                                    </div>
                                    <div class="mb-3">
                                        <input type="checkbox"id="chkEDesReadOnly" />&nbsp;&nbsp;<label>Disallow employee to edit expense description</label>
                                    </div>
                                </div>
                            </div>

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
                <h4 class="mb-0" id="pagetitle">Projects</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Projects</a></li>
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
                                        <label>Project ID/Name:</label>
                                        <input type="text" class="form-control" id="txtProjectNameSrch" />
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Contract Type:</label>
                                        <select class="form-select" id="dropFKContractTypeSrch">
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Client:</label>
                                        <input type="text" id="txtFKClientIDSrch" class="form-control" />
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Status:</label>
                                        <select class="form-select" id="dropActiveStatusSrch">
                                            <option value="">-All-</option>
                                           <option value="Active">Active</option>
                                            <option value="Archived">Archived</option>
                                            <option value="Completed">Completed</option>
                                            <option value="Hold">Hold</option>
                                            <option value="Inactive">Inactive</option>
                                            <option value="Main">Main</option>
                                            <option value="Canceled">Canceled</option>
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
                                    <th data-column="ProjectCode" class="sorting tdProjectCode">ProjectID</th>
                                    <th data-column="ProjectName" class="sorting tdProjectName">Title</th>
                                    <th data-column="ClientCompany" class="sorting tdClientCompany">Client</th>
                                    <th data-column="ContractAmt" class="sorting tdContractAmt tdclscurrency tdclsnum">Contract Amount</th>
                                    <th data-column="CompletePercent" class="sorting tdCompletePercent tdclsPer tdclsnum">% Complete</th>
                                    <th data-column="BudgetedHours" class="sorting tdBudgetedHours tdclsnum">Bud. Hours</th>
                                    <th data-column="DueDate" class="sorting tdDueDate">Due Date</th>
                                    <th data-column="ProjectStatus" class="sorting tdProjectStatus">Status</th>
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
    <script src="UserJs/Manage/Projects.js?version=<%=PageVersion%>"></script>
</asp:Content>
