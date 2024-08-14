<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="TransactionStatements.aspx.cs" Inherits="QuickStartAdmin.Users.TransactionStatements" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />




    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Transaction Statement</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Transaction Statement</a></li>
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
                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="row ">
                                            <div class="col-md-3">
                                                <label>Client :</label>
                                            </div>
                                            <div class="col-md-9">
                                                <input type="text" id="txtFKClientIDSrch" class="form-control" />
                                            </div>
                                        </div>
                                    </div>
                                </div>

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
                                        <label>Date:</label>
                                        <select id="dropaterange" class="form-select" onchange="sowCustomDate(this.id);">
                                            <option value="All" selected="selected">All</option>
                                            <option value="This Calendar Year">This Calendar Year</option>
                                            <option value="Last Calendar Year">Last Calendar Year</option>
                                            <option value="Current Month">This Month</option>
                                            <option value="Last Month">Last Month</option>
                                            <option value="Current Week">This Week</option>
                                            <option value="Today">Today</option>
                                            <option value="Custom">Custom</option>
                                        </select>
                                    </div>
                                    <div class="col-sm-6 divdaterange" id="divcustomdate">
                                        <div class="row">
                                            <div class="col-sm-6 mar">
                                                <label>From Date:</label>
                                                <input type="text" class="form-control" id="txtfromdate" />
                                            </div>
                                            <div class="col-sm-6 mar">
                                                <label>To Date:</label>
                                                <input type="text" class="form-control" id="txttodate" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Transaction Type:</label>
                                        <select id="dropTranTypeSrch" class="form-select">
                                            <option value="">All</option>
                                            <option value="Invoice">Invoice</option>
                                            <option value="Payment">Payment</option>
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Project:</label>
                                        <input type="text" class="form-control" id="txtProjectNameSrch" />
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-sm-3 mar">
                                        <label>Invoice#:</label>
                                        <input type="text" id="txtInvoiceIDSrch" class="form-control" />
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Payment ID:</label>
                                        <input type="text" id="txtPayIDSrch" class="form-control" />
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

                                    <th data-column="TranDate" class="sorting tdTranDate">Date</th>
                                    <th data-column="ClientName" class="sorting tdClientName">Client</th>
                                    <th data-column="ProjectCode" class="sorting tdProjectCode">Project ID</th>
                                    <th data-column="ProjectName" class="sorting tdProjectName">Project Name</th>
                                    <th data-column="TranType" class="sorting tdTranType">Tran Type</th>
                                    <th data-column="TranDesc" class="sorting tdTranDesc">Description</th>
                                    <th data-column="InvoiceID" class="sorting tdInvoiceID">Invoice#</th>
                                    <th data-column="PayID" class="sorting tdPayID">PaymentID</th>
                                    <th data-column="DrAmt" class="sorting tdDrAmt tdclscurrency bold tdclsnum">Dr.Amt.</th>
                                    <th data-column="CrAmt" class="sorting tdCrAmt tdclscurrency bold tdclsnum">Cr.Amt.</th>
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

    <script src="UserJs/Billing/TransactionStatements.js?version=<%=PageVersion%>"></script>
</asp:Content>

