<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="ReceivePayment.aspx.cs" Inherits="QuickStartAdmin.Users.ReceivePayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="HidID" runat="server" ClientIDMode="Static" Value="0" />
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Receive Payment</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Receive Payment</a></li>
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
                    <div class="row" id="divValidateSummary" style="display: none;">
                        <div class="col-md-12 col-xs-12">
                            <div class="validate-box">
                                <ul></ul>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="col-md-2 mb-3">
                                   <label class="form-label">Date : *</label>
                                        <input type="text" class="form-control" id="txtTranDate" />
                                </div>
                                <div class="col-md-2 mb-3">
                                  <label class="form-label">Client : *</label>
                                        <input type="text" class="form-control" id="txtFKClientID" />
                                </div>
                                <div class="col-md-2 mb-3">
                                             <label class="form-label">Client Retainer(<%=StrCurrency%>):</label>
                                        <input type="text" class="form-control" id="txtClientBalance" value="0.00" readonly="readonly" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2 mb-3">
                                    <label class="form-label">Payment Type : *</label>
                                        <select class="form-select" id="dropFKPaymentTypeID">
                                        </select>
                                </div>
                                <div class="col-md-2 mb-3" id="divPaymentMode">
                                    <label class="form-label">Payment Mode : *</label>
                                        <select class="form-select" id="dropFKPaymodeID">
                                        </select>
                                </div>
                                 <div class="col-md-2 mb-3">
                                   <label class="form-label">Transaction/Check ID : </label>
                                        <input type="text" class="form-control" id="txtTranID" />
                                </div>
                            </div>
                            <div class="row">
                              
                                <div class="col-md-2 mb-3">
                                    <label class="form-label">Amount(<%=StrCurrency%>) : *</label>
                                        <input type="text" class="form-control" id="txtAmount" />
                                </div>
                                <div class="col-md-2 mb-3">
                                     <label class="form-label">&nbsp;</label>
                                   <input type="checkbox" id="chkIsRetainer">&nbsp;&nbsp;<label>Apply as Retainer</label>
                                </div>
                            </div>

                        </div>


                    </div>

                    <div class="row">
                        <div class="col-md-12">

                            <div class="DetailPart" id="divInvoice">
                                <div class="tablePart topRadius">
                                    <span class="title">List of Invoices For Adjustment</span>
                                    <div class="RightLink" id="divDetailButtons">
                                    </div>

                                </div>
                                <div class="clearfix"></div>
                                <div class="detail-container">
                                    <table id="tblAdjustList" class="tableInput tableInput-select xpad table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th class="tdApprove" style="width: 30px; text-align: center;">
                                                    <input type="checkbox" class="form-check-input" id="chkAll" /></th>
                                                <th style="width: 100px;">Invoice #</th>
                                                 <th>Project</th>
                                                <th style="width: 100px;">Date</th>
                                                <th style="width: 80px; text-align: right;">Net Amount</th>
                                                <th style="width: 80px; text-align: right;">Due Amount</th>
                                                <th style="width: 100px; text-align: right;">Amt. Applied(<%=StrCurrency%>)</th>

                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="clearfix"></div>
                                <div class="tablePart BottomRadius">
                                    <div class="summary">
                                        <ul>
                                            <li>Total Amt.: <span id="FTotalAamount">0</span></li>
                                            <li>Adjustment Amt.: <span id="FTotalAdjAmt">0</span></li>
                                            <li>Remaning Amt.: <span id="FTotalRemaning">0</span></li>
                                        </ul>
                                    </div>

                                </div>

                                <div class="clearfix"></div>
                            </div>






                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-12">
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

    <script src="UserJs/Billing/ReceivePayment.js?version=<%=PageVersion%>"></script>
</asp:Content>

