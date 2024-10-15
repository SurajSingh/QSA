<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="Employees.aspx.cs" Inherits="QuickStartAdmin.Users.Employees" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />
    <div id="otherdiv_inftype" class="otherdiv" style="z-index: 1045;"></div>
    <div class="modal-dialog modal-sm divpopup" id="divaddInformation" style="width: 800px; display: none; z-index: 1050;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Role Group Settings</h4>
                <button type="button" class="close" onclick="closerolergoup();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <div class="row ctrl">
                    <label class="col-sm-3 col-xs-12 lbl">Role Group Title:</label>
                    <div class="col-sm-4 col-xs-12 w2">
                        <select id="dropmasterrole" class="form-control custom-select"></select>
                    </div>

                    <div class="col-sm-5 col-xs-12 w2">
                        <input type="text" id="txtmasterrolename" placeholder="Role Name" class="form-control" />
                    </div>
                </div>
                <div class="row ctrl">

                    <div class="col-sm-12 col-xs-12">
                        <div class="dataTables_wrapper" style="max-height: 300px; margin: 10px 0px; overflow: auto; width: 100%;">


                            <div class="clearfix"></div>

                            <table id="tblrole" class="tblrole table table-striped table-bordered table-quicklist">
                                <thead>
                                    <tr>
                                        <th width="50" style="border: none;"></th>
                                        <th style="border: none;"></th>
                                        <th width="70" style="border-top: solid 1px #e0e0e0; border-right: solid 1px #e0e0e0; border-left: solid 1px #e0e0e0">View
                                        </th>
                                        <th width="70" style="border-top: solid 1px #e0e0e0; border-right: solid 1px #e0e0e0">Add
                                        </th>
                                        <th width="70" style="border-top: solid 1px #e0e0e0; border-right: solid 1px #e0e0e0">Edit
                                        </th>
                                        <th width="70" style="border-top: solid 1px #e0e0e0; border-right: solid 1px #e0e0e0">Delete
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <div class="clearfix"></div>
                        </div>
                    </div>


                </div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">

                <input type="button" class="btn btn-warning hvr-glow" value="Save" id="btnSaveRole" />
                <input type="button" class="btn btn-secondary hvr-glow" value="Delete" id="btnDeleteRole" style="display: none;" />
                <input type="button" class="btn btn-secondary hvr-glow" value="Close" id="btnCloseRole" onclick="closerolergoup();" />
            </div>
        </div>
    </div>

    <div class="modal-dialog modal-sm divpopup" id="divAddDepartment" style="width: 700px; display: none; z-index: 1050;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Departments</h4>
                <button type="button" class="close" onclick="CloseDepartment();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner" style="margin: 0px;">
                <iframe id="ifAddDepartment" src="Departments.aspx?HotLink=1&HasParent=1" style="width: 100%; height: 600px; overflow: auto; border: none;"></iframe>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton" style="margin: 0px; border: none;">

                <input type="button" class="btn btn-secondary hvr-glow" value="Close" id="btnCloseDepartment" onclick="CloseDepartment();" />
            </div>
        </div>
    </div>


    <div class="modal-dialog modal-sm divpopup" id="divAddDesignation" style="width: 700px; display: none; z-index: 1050;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Departments</h4>
                <button type="button" class="close" onclick="CloseDesignation();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner" style="margin: 0px;">
                <iframe id="ifAddDesignation" src="Designations.aspx?HotLink=1&HasParent=1" style="width: 100%; height: 600px; overflow: auto; border: none;"></iframe>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton" style="margin: 0px; border: none;">

                <input type="button" class="btn btn-secondary hvr-glow" value="Close" id="btnCloseDesignation" onclick="CloseDesignation();" />
            </div>
        </div>
    </div>


    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-user-plus font-size-18"></i><span>Add New Employee</span></h4>
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
                            <span class="d-none d-sm-block">Contact</span>
                        </a>
                    </li>
                    <li class="nav-item waves-effect waves-light">
                        <a class="nav-link" data-bs-toggle="tab" href="#navpills2-messages" role="tab" aria-selected="false">
                            <span class="d-block d-sm-none"><i class="far fa-envelope"></i></span>
                            <span class="d-none d-sm-block">Cost</span>
                        </a>
                    </li>
                    <li class="nav-item waves-effect waves-light">
                        <a class="nav-link" data-bs-toggle="tab" href="#navpills2-groups" role="tab" aria-selected="false">
                            <span class="d-block d-sm-none"><i class="far fa-envelope"></i></span>
                            <span class="d-none d-sm-block">Employee Groups</span>
                        </a>
                    </li>

                </ul>

                <!-- Tab panes -->
                <div class="tab-content">
                    <div class="tab-pane active" id="navpills2-home" role="tabpanel">
                        <div class="row">

                            <div class="col-sm-4 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Login ID: * 
                                    </label>
                                    <input id="txtLoginID" type="text" class="form-control" maxlength="10" />
                                </div>

                            </div>

                            <div class="col-sm-4 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Password: *                       
                                    </label>
                                    <input id="txtPWD" type="password" class="form-control" maxlength="15" />
                                </div>
                            </div>

                        </div>
                        <div class="clearfix"></div>
                        <div class="row">

                            <div class="col-sm-4 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        First Name: *                       
                                    </label>
                                    <input type="text" id="txtFName" class="form-control" maxlength="50" />
                                </div>
                            </div>
                            <div class="col-sm-4 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Last Name: *                       
                                    </label>
                                    <input type="text" id="txtLName" class="form-control" maxlength="50" />
                                </div>
                            </div>
                            <div class="col-sm-4 col-xs-12">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Date of Birth:                        
                                    </label>
                                    <input id="txtDOB" type="text" class="form-control" />
                                </div>
                            </div>
                        </div>
                        <div class="clearfix"></div>


                        <div class="row">

                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Department: *   <a id="linkAddPepartment" class="addnewtype">
                                            <i class="fa fa-plus-circle"></i></a>
                                    </label>
                                    <select id="dropFKDeptID" class="form-select"></select>
                                </div>
                            </div>

                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Designation:*   <a id="linkAddDesignation" class="addnewtype">
                                            <i class="fa fa-plus-circle"></i></a>
                                    </label>
                                    <select id="dropFKDesigID" class="form-select"></select>
                                </div>
                            </div>

                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Manager: 
                       
                                    </label>
                                    <input type="text" id="txtFKManagerID" class="form-control" />

                                </div>
                            </div>
                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Submit to:                        
                                    </label>
                                    <input type="text" id="txtFKSubmitToID" class="form-control" />

                                </div>
                            </div>

                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Email:  *
                       
                                    </label>
                                    <input id="txtEmailID" type="email" class="form-control" maxlength="50" />
                                </div>
                            </div>

                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Join Date:  *                                                          
                       
                                    </label>
                                    <input id="txtJoinDate" type="text" class="form-control" />
                                </div>
                            </div>


                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Active Status:  *
                       
                                    </label>
                                    <select id="dropActiveStatus" onchange="empstatus(this)" class="form-select">
                                        <option value="Active">Active</option>
                                        <option value="Released">Released</option>
                                        <option value="Block">Block</option>

                                    </select>
                                </div>

                            </div>
                            <div class="col-sm-3 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Release Date: 
                                    </label>
                                    <input id="txtReleasedDate" type="text" class="form-control" />
                                </div>

                            </div>
                        </div>
                        <div class="clearfix"></div>


                        <div class="row">


                            <div class="col-sm-4 col-xs-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Login Type:* 

                                    </label>
                                    <select id="dropRoleType" class="form-select">
                                        <option value="User">User</option>
                                        <option value="Admin">Admin</option>

                                    </select>
                                </div>

                            </div>
                            <div class="col-sm-4 col-xs-4">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Role Group:* <a onclick="openrolegroup()" class="addnewtype">
                                            <i class="fa fa-plus-circle"></i></a>

                                    </label>
                                    <select id="dropFKRoleGroupID" class="form-select">
                                    </select>
                                </div>

                            </div>
                            <div class="col-sm-3 col-xs-4">
                                <div class="mb-3">
                                    <label class="form-label">Project:</label>
                                    <div id="divFKProjectIDSrch"></div>
                                </div>
                            </div>
                        </div>


                        <div class="clearfix"></div>


                        <div class="clearfix"></div>
                        <div class="form-check">
                            <input id="chkAppointment" type="checkbox" class="form-check-input">
                            <label class="form-check-label" for="chkAppointment">Available For Appointment</label>
                        </div>



                        <div class="clearfix"></div>
                    </div>
                    <div class="tab-pane" id="navpills2-profile" role="tabpanel">
                        <div class="row">

                            <div class="col-sm-12 col-xs-12">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Title: 
                       
                                    </label>
                                    <input id="txtAddressTitle" type="text" class="form-control" maxlength="50" />
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

                            <div class="col-sm-4 col-xs-12">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Cell Phone:                       
                                    </label>
                                    <input type="text" id="txtMobNo" class="form-control" maxlength="15" />
                                </div>
                            </div>
                            <div class="col-sm-4 col-xs-12">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Home Phone:                       
                                    </label>
                                    <input type="text" id="txtPhone1" class="form-control" maxlength="15" />
                                </div>
                            </div>
                            <div class="col-sm-4 col-xs-12">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Fax:                       
                                    </label>
                                    <input type="text" id="txtPhone2" class="form-control" maxlength="15" />
                                </div>
                            </div>
                        </div>

                        <div class="clearfix"></div>
                        <div class="row">

                            <div class="col-sm-12 col-xs-12">
                                <div class="mb-3">
                                    <label class="form-label">
                                        Notes:                        
                                    </label>
                                    <textarea id="txtRemark" class="form-control" style="height: 40px;" maxlength="500">
                                    </textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane" id="navpills2-messages" role="tabpanel">
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label">Billing Rate: </label>
                                    <input id="txtBillRate" type="text" class="form-control" placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label">Pay Rate:  </label>
                                    <input id="txtPayRate" type="text" class="form-control" placeholder="0.00" />
                                </div>
                            </div>
                            <div class="col-lg-4" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">Overtime Billing Rate: </label>
                                    <input id="txtOverTimeBillRate" type="text" class="form-control" placeholder="0.00">
                                </div>
                            </div>
                        </div>

                        <div class="row">

                            <div class="col-lg-4" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">Overtime Pay Rate: </label>
                                    <input id="txtOverTimePayrate" type="text" class="form-control" placeholder="0.00">
                                </div>
                            </div>
                            <div class="col-lg-4" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">Overhead Multiplier: </label>
                                    <input id="txtOverheadMulti" type="text" class="form-control" placeholder="0.00">
                                </div>
                            </div>
                            <div class="col-lg-4" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">Amount:</label>
                                    <input id="txtSalaryAmount" type="text" class="form-control" placeholder="0.00">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label">Currency: </label>
                                    <select id="dropFKCurrencyID" class="form-select">
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane" id="navpills2-groups" role="tabpanel">
                        <div class="row">
                            <div class="col-lg-12">
                                <table id="tblGroup" class="table table-striped table-bordered dt-responsive nowrap">
                                    <thead>
                                        <tr>
                                            <th style="width: 200px;">Group Name</th>
                                            <th>Description</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
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
                <h4 class="mb-0" id="pagetitle">Employees</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Employees</a></li>
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
                                        <label>Emp ID/Name :</label>
                                        <input type="text" class="form-control" id="txtEmpIDSrch" />
                                    </div>

                                    <div class="col-sm-3 mar">
                                        <label>Department:</label>
                                        <select class="form-select" id="dropFKDeptIDSrch">
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Status:</label>
                                        <select class="form-select" id="dropActiveStatusSrch">
                                            <option value="">-All-</option>
                                            <option value="Active">Active</option>
                                            <option value="Released">Released</option>
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
                                    <th style="width: 20px; min-width: 20px"></th>
                                    <th style="width: 20px; min-width: 20px"></th>
                                    <th data-column="LoginID" class="sorting tdLoginID">Login ID</th>
                                    <th data-column="EnrollNo" class="sorting tdEnrollNo">Enroll No.</th>
                                    <th data-column="FName" class="sorting tdFName">First Name</th>
                                    <th data-column="LName" class="sorting tdLName">Last Name</th>
                                    <th data-column="JoinDate" class="sorting tdJoinDate">Join Date</th>
                                    <th data-column="DeptName" class="sorting tdDeptName">Department</th>
                                    <th data-column="DesigName" class="sorting tdDesigName">Designation</th>
                                    <th data-column="ManagerName" class="sorting tdManagerName">Manager</th>
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
    <script src="UserJs/Manage/Employees.js?version=<%=PageVersion%>"></script>

    <%--<script src="UserJs/Reports/BillingReport/RptInvoiceRegister.js"></script>--%>
</asp:Content>
