<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="PaymentReview.aspx.cs" Inherits="QuickStartAdmin.Users.PaymentReview" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />

    <div class="modal-dialog modal-sm divpopup" id="divViewDetail" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-file-edit-alt font-size-18"></i>&nbsp;<span>Payment Detail</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <div class="row">
                    <div class="col-lg-12">
                        <table class="tblReport">
                            <tr>
                                <td colspan="2">
                                    <span class="tdcolhead">
                                        Client:
                                    </span>
                                    <span id="spanClientName" class="tdcolval"></span>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 50%;">
                                    <span class="tdcolhead">
                                        Date:
                                    </span>
                                    <span id="txtTranDate" class="tdcolval"></span>
                                </td>
                                <td>
                                    <span class="tdcolhead">
                                        Payment ID:
                                    </span>
                                    <span id="txtPayID" class="tdcolval"></span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="tdcolhead">
                                        Payment Type:
                                    </span>
                                    <span id="dropFKPaymentTypeID" class="tdcolval"></span>
                                </td>
                                <td>
                                    <span class="tdcolhead">
                                        Payment Mode:
                                    </span>
                                    <span id="dropFKPaymodeID" class="tdcolval"></span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="tdcolhead">
                                        Amount:
                                    </span>
                                    <span id="txtAmount" class="tdcolval"></span>
                                </td>
                                <td>
                                    <span class="tdcolhead">
                                        Check/Tran ID:
                                    </span>
                                    <span id="txtTranID" class="tdcolval"></span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <span class="tdcolhead">
                                        Apply As Retainer?:
                                    </span>
                                    <span id="chkIsRetainer" class="tdcolval"></span>
                                </td>

                            </tr>
                        </table>

                    </div>

                </div>
                <div class="row" id="divInvoice">
                    <div class="col-lg-12">
                        <label>List of Adjusted Invoices:</label>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-lg-12">
                        <table id="tblAdjustList" class="tableInput tableInput-select xpad table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 100px;">Invoice #</th>
                                    <th>Project</th>
                                    <th style="width: 80px;">Date</th>
                                    <th style="width: 80px; text-align: right;">Net Amount</th>
                                    <th style="width: 80px; text-align: right;">Due Amount</th>
                                    <th style="width: 80px; text-align: right;">Amt. Applied(<%=StrCurrency%>)</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12 text-center">
                        <div style="margin-top: 20px; margin-bottom: 20px;">

                            <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" onclick="closediv();" />
                        </div>

                    </div>
                </div>

                <div class="clearfix"></div>

            </div>
            <div class="clearfix"></div>

        </div>
    </div>


    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Payment Review</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Payment Review</a></li>
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
                                <a class="popup-form btn btn-primary bg-green" href="ReceivePayment.aspx" id="btnAddNew"><i class="mdi mdi-plus me-1"></i>Add New</a>
                            </div>
                            <div class="col-md-2 divtopcontrol">
                                <ul class="ulpaging">
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
                                        <label>Client:</label>
                                        <input type="text" id="txtFKClientIDSrch" class="form-control" />
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Payment Type:</label>
                                        <select class="form-select" id="dropFKPaymentTypeIDSrch">
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Payment Mode:</label>
                                        <select class="form-select" id="dropFKPaymodeIDSrch">
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Payment ID:</label>
                                        <input type="text" id="txtInvoiceIDSrch" class="form-control" />
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
                                    <th style="width: 20px;"></th>
                                    <th data-column="TranDate" class="sorting tdTranDate">Date</th>
                                    <th data-column="PayID" class="sorting tdPayID">Payment ID</th>
                                    <th data-column="ClientCode" class="sorting tdClientCode">Client ID</th>
                                    <th data-column="ClientName" class="sorting tdClientName">Client</th>
                                    <th data-column="PaymentType" class="sorting tdPaymentType">Payment Type</th>
                                    <th data-column="PaymentMode" class="sorting tdPaymentMode">Payment Mode</th>
                                    <th data-column="TranID" class="sorting tdTranID">Check/Tran ID</th>
                                    <th data-column="Amount" class="sorting tdAmount tdclscurrency tdclsnum">Amount</th>
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

    <script src="UserJs/Billing/PaymentReview.js?version=<%=PageVersion%>"></script>
</asp:Content>

