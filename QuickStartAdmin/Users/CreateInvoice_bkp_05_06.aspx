<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="CreateInvoice.aspx.cs" Inherits="QuickStartAdmin.Users.CreateInvoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets/css/invoice.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="HidID" runat="server" ClientIDMode="Static" Value="0" />
    <div class="modal-dialog modal-sm divpopup" id="divMemo" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-file-edit-alt font-size-18"></i>&nbsp;<span>Enter Memo</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner" style="margin: 0px;">
                <div class="row">
                    <div class="col-lg-12">
                        <textarea id="txtMemo" name="area"></textarea>
                    </div>

                </div>

                <div class="clearfix"></div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton" style="border: 0px;">
                <input type="button" class="btn btn-success waves-effect waves-light" value="OK" id="btnSaveMemo" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnCloseMemo" onclick="closediv();" />

            </div>
        </div>
    </div>


    <div class="modal-dialog modal-sm divpopup" id="divSuccessMsg" style="width: 400px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="uil-file-edit-alt font-size-18"></i>&nbsp;<span>Success</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner" style="margin: 0px;">
                <div class="row">
                    <div class="col-lg-12 text-center">
                        <label>Invoice Generated Successfully</label>
                    </div>

                </div>
                <div class="row">
                    <div class="col-lg-12 text-center">
                        <div style="margin-top: 20px; margin-bottom: 20px;">
                            <input type="button" class="btn btn-success waves-effect waves-light" value="Print Invoice" id="btnPrintInvoice" />
                            <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" onclick="closediv();" />
                        </div>

                    </div>
                </div>

                <div class="clearfix"></div>

            </div>
            <div class="clearfix"></div>

        </div>
    </div>

    <!--Added by nilesh to show the unbilled task and expenses on the popup - Start - 23/04/24 -->
        <div class="modal-dialog modal-sm divpopup" id="divUnbilledTask" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divPopupTitle"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>Ubilled Tasks</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <!--<div class="row" id="divValidateSummary" style="display: none;">
                    <div class="col-md-12 col-xs-12">
                        <div class="validate-box">
                            <ul></ul>
                        </div>
                    </div>
                </div>-->                
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-6">
                            <label class="form-label">Select unbilled task to be included in the invoice:</label>

                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="mb-6">
                            <input type="checkbox" id="chkShowAllTask" class="form-check-input" value="allTask"/>
                            <label >Show All Tasks</label>

                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <table id="tblTimeSheet" class="tableInput table-bordered" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="tdApprove" style="width: 30px; text-align: center;">
                                        <input type="checkbox" class="form-check-input" id="chkAll" /></th>
                                    <th class="tdEmpID" style="width: 130px;">Employee</th>
                                    <th class="tdTaskDate" style="width: 130px;">Date</th>
                                    <th class="tdFKTaskID">Task</th>
                                    <th class="tdHrs" style="width: 70px; text-align: right;">Hours</th>
                                    <th class="tdDescription">Description</th>
                                    <th class="tdTBillRate" style="width: 80px; text-align: right;">Bill Rate</th>
                                    <th class="tdAmount" style="width: 80px; text-align: right;">Amount</th>
                                </tr>
                            </thead>

                            <tbody>
                            </tbody>

                        </table>



                    </div>

                </div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Save" id="btnTask" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose" onclick="closediv();" />

            </div>
        </div>
    </div>

    <div class="modal-dialog modal-sm divpopup" id="divUnbilledExpenses" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divPopupTitleExpense"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>Ubilled Expensed</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner">
                <!--<div class="row" id="divValidateSummary" style="display: none;">
                    <div class="col-md-12 col-xs-12">
                        <div class="validate-box">
                            <ul></ul>
                        </div>
                    </div>
                </div>-->                
                <div class="row">
                    <div class="col-lg-6">
                        <div class="mb-6">
                            <label class="form-label">Select unbilled expenses to be included in the invoice:</label>

                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="mb-6">
                            <input type="checkbox" id="chkShowAllExpenses" class="form-check-input" value="allTask"/>
                            <label >Show All Expenses</label>

                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <table id="tblExpenseLog" class="tableInput table-bordered" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="tdApprove" style="width: 30px; text-align: center;">
                                        <input type="checkbox" class="form-check-input" id="chkAllExpense" /></th>
                                    <th class="tdEmpID" style="width: 130px;">Employee</th>
                                    <th class="tdExpenseDate" style="width: 130px;">Date</th>
                                    <th class="tdFKExpenseID">Expense</th>
                                    <th class="tdHrs" style="width: 70px; text-align: right;">Unit</th>
                                    <th class="tdDescription">Description</th>
                                    <th class="tdECostRate" style="width: 80px; text-align: right;">Cost Rate</th>
                                    <th class="tdMU" style="width: 80px; text-align: right;">MU %</th>
                                    <th class="tdAmount" style="width: 80px; text-align: right;">Amount</th>
                                </tr>
                            </thead>

                            <tbody>
                            </tbody>

                        </table>



                    </div>

                </div>

            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Save" id="btnExpense" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose" onclick="closediv();" />

            </div>
        </div>
    </div>
    <!--Added by nilesh to show the unbilled task and expenses on the popup - End - 23/04/24 -->

     <div class="modal-dialog modal-sm divpopup" id="divSubmit" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="bx bx-user font-size-18"></i>&nbsp;<span>Submit your timesheet</span></h4>
                <button type="button" class="close" onclick="closediv();"><span aria-hidden="true">×</span></button>
            </div>
            <div class="divpopup-inner" style="margin-top: 15px;">
                <div class="row">
                    <div class="col-3 col-lg-3">
                        <div class="mb-3">
                            <label class="form-label" for="name">Submit To : *</label>
                        </div>
                    </div>
                    <div class="col-9 col-lg-9">
                        <div class="row">
                            <div class="col-12 col-lg-12">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input name="rbtnSubmitTo" id="chkClientManager" type="radio" class="form-check-input" checked="checked">
                                        <label class="form-check-label" for="chkClientManager">Client Manager</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12 col-lg-12">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input name="rbtnSubmitTo" id="chkProjectManager" type="radio" class="form-check-input">
                                        <label class="form-check-label" for="chkClientManager">Project Manager</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12 col-lg-12">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input name="rbtnSubmitTo" id="chkYourManager" type="radio" class="form-check-input">
                                        <label class="form-check-label" for="chkYourManager">Your Manager</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-5 col-lg-5">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input name="rbtnSubmitTo" id="chkSpecific" type="radio" class="form-check-input">
                                        <label class="form-check-label" for="chkSpecific">Specific</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-7 col-lg-7">
                                <div class="mb-3">
                                    <div class="form-check">
                                        <select id="dropSubmitToSpecific" class="form-select" style="display: none;"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clearfix"></div>
            <div class="divpopbutton">
                <input type="button" class="btn btn-success waves-effect waves-light" value="Submit" id="btnSubmit" />
                <input type="button" class="btn btn-secondary  waves-effect waves-light" value="Close" id="btnClose" onclick="closediv();" />

            </div>
        </div>
    </div>


    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0">Create Invoice</h4>
                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Create Invoice</a></li>
                        <li class="breadcrumb-item active">QuickstartAdmin</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>

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
                <div class="col-xl-3">
                    <div class="leftsummarybox" id="divSummary">

                        <h4 class="card-title">Project Billing Summary</h4>
                        <div class="leftsummarybox-inner">
                            <h5 id="projectname" class="project-title"></h5>
                            <div class="clearfix"></div>
                            <div class="accordion" id="accordionExample">
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingOne">
                                        <a class="accordion-button" data-bs-toggle="collapse"
                                            data-bs-target="#collapseOne" aria-expanded="true"
                                            aria-controls="collapseOne">Work-in-Progress<span>&nbsp;(*billable only)</span>
                                        </a>
                                    </h2>
                                    <div id="collapseOne" class="accordion-collapse collapse show"
                                        aria-labelledby="headingOne" data-bs-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <div class="invoice-txtbox clearfix">
                                                <ul id="ulProjectTime">
                                                    <li>Time : <span id="spantime">-</span></li>
                                                    <li>Service Amt. : <span id="spanserviceamt">-</span></li>
                                                    <li>Expenses Amt. : <span id="spanexpamt">-</span></li>
                                                    <li>Pre-Billed : <span id="spanpreebilled">-</span></li>

                                                </ul>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingTwo">
                                        <a class="accordion-button collapsed"
                                            data-bs-toggle="collapse" data-bs-target="#collapseTwo"
                                            aria-expanded="false" aria-controls="collapseTwo">Project Summary
                                        </a>
                                    </h2>
                                    <div id="collapseTwo" class="accordion-collapse collapse"
                                        aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <div class="invoice-txtbox clearfix">
                                                <div class="invc-lft-txt">
                                                    <ul id="ulProjectContract">
                                                        <li>Client Name: <span id="spanclientname">-</span></li>
                                                        <li>Project Name: <span id="spanprojectname">-</span></li>
                                                        <li>Contract Type : <span id="spancontracttype">-</span></li>
                                                        <li>Contract Amt. : <span id="spancontractamt">-</span></li>
                                                        <li>Service Amt. : <span id="spanserviceamt1">-</span></li>
                                                        <li>Expenses Amt. : <span id="spanexpamt1">-</span></li>
                                                        <li>% Complete : <span id="spanpercomplete">-</span></li>

                                                    </ul>
                                                </div>


                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingThree">
                                        <a class="accordion-button collapsed"
                                            data-bs-toggle="collapse" data-bs-target="#collapseThree"
                                            aria-expanded="false" aria-controls="collapseThree">Last Invoice
                                        </a>
                                    </h2>
                                    <div id="collapseThree" class="accordion-collapse collapse"
                                        aria-labelledby="headingThree" data-bs-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <div class="invoice-txtbox clearfix">

                                                <div class="invc-lft-txt">
                                                    <ul id="ulLastInv">
                                                        <li>Date :  <span id="spanDate">-</span></li>
                                                        <li>Invoice No.  :  <span id="spanLastInvNo">-</span></li>
                                                        <li>Amount :  <span id="spanLastInvAmt">-</span></li>

                                                    </ul>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                            <div class="text-end mr-t-50">
                                <input type="button" class="btn btn-light waves-effect waves-light" value="Clear" id="btnClear" />
                            </div>
                        </div>


                    </div>

                    <!--Added by Nilesh To show the current bill summary start-->
                   <div id="divtotalsummary" style="">
	                    <div class="invoice-txtbox clearfix">
		                    <div class="invc-lft-txt">
			                    <ul>
				                    <li>Service Amt. :</li>
				                    <li>Expense Amt. :</li>
				                    <li>Sub Total :</li>

			                    </ul>
		                    </div>
		                    <div class="invc-rht-txt">
			                    <ul>
				                    <li><span>
					                    $</span>
					                    <input name="txtServiceAmount" type="text" id="txtServiceAmount" readonly="readonly"></li>
				                    <li><span>
					                    $</span>
					                    <input name="txtExpenseAmount" type="text" id="txtExpenseAmount" readonly="readonly"></li>
				                    <li><span>$</span><input name="FTotalSubAmt" type="text" id="FTotalSubAmt" value="0"  readonly="readonly"></li>

			                    </ul>
		                    </div>

	                    </div>
	                    <div class="invoice-txtbox clearfix">
		                    <div class="invc-lft-txt">
			                    <ul>
				                    <li>Tax : </li>
				                    <li>Tax % :</li>
				                    <li>Tax Amount :</li>

			                    </ul>
		                    </div>
		                    <div class="invc-rht-txt">
			                    <ul>
				                    <li>
					                    <select name="dropFKTaxID" id="dropFKTaxID" class="form-select"></select>
				                    </li>
				                    <li>
					                    <input name="txtTaxPer" type="text" id="txtTaxPer" class="form-control"></li>
				                    <li><span>$</span><input name="FTotalTax" type="text" id="FTotalTax" readonly="readonly" ></li>

			                    </ul>
		                    </div>

	                    </div>
	                    <div class="invoice-txtbox clearfix">
		                    <div class="invc-lft-txt">
			                    <ul>
				                    <li>Discount : </li>
				                    <li>Retainer (C) :</li>
				                    <li>Total :</li>


			                    </ul>
		                    </div>
		                    <div class="invc-rht-txt">
			                    <ul>
				                    <li>
					                    <span>
						                    $</span>
					                    <input name="txtDiscount" type="text" id="txtDiscount" value="0">
				                    </li>
				                    <li><span>
					                    $</span>
					                    <input name="FReceived" type="text" id="FReceived" value="0" readonly="readonly"></li>
				                    <li><span>$</span>
					                    <input name="FNetAmt" type="text" id="FNetDueAmt" value="0" readonly="readonly"></li>

			                    </ul>
		                    </div>

	                    </div>

	                    <div class="invoice-txtbox clearfix">
		                    <div class="invc-lft-txt">
			                    <ul>
				                    <li>Paid<span id="spanpaidamount">*</span>: </li>
				                    <li>Amount Due :</li>
				                    <li>Retainage :</li>


			                    </ul>
		                    </div>
		                    <div class="invc-rht-txt">
			                    <ul>
				                    <li>
					                    <span>
						                    $</span>
					                    <input name="txtpaidamount" type="text" id="txtpaidamount" value="0" >
				                    </li>
				                    <li><span>
					                    $</span>
					                    <input name="FNetDueAmt" type="text" id="FNetDueAmt" value="0"  readonly="readonly"></li>
				                    <li><span>$</span>
					                    <input name="txtretainage" type="text" id="txtretainage" value="0" ></li>

			                    </ul>
		                    </div>

	                    </div>
                    </div>
                    <!--End-->


                </div>

                <div class="col-xl-9">
                    <div class="nrwizard">

                        <div id="tabsinvoice">
                            <!-- Seller Details -->
                            <h3>Choose Project</h3>
                            <section>                              
                                <div class="row">
                                    <div class="col-lg-4">
                                        <div class="mb-3">
                                            <label for="basicpill-firstname-input">Project : *</label>
                                            <input type="text" class="form-control" id="txtFKProjectID" />
                                        </div>
                                    </div>

                                </div>

                                
                                    <div id="invoiceDateRange" class="row" style ="display:none;">
                                        <div class="col-lg-4">
                                            <div class="mb-3">
                                                <label class="form-label">Billing From Date : *</label>
                                                <input type="text" class="form-control"  id="txtInvFromDate" hidden/>
                                            </div>
                                         </div>
                                    
                                        <div  class="col-lg-4">
                                            <div class="mb-3">
                                                <label class="form-label">Billing To Date : *</label>
                                                <input type="text" class="form-control"  id="txtInvEndDate" hidden/>
                                            </div>
                                        </div>
                                    </div>
                                     

                                

                                <div class="row">
                                    <div class="col-lg-4">
                                        <div class="mb-3">
                                            <label class="form-label">Invoice Date : *</label>
                                            <input type="text" class="form-control" id="txtInvDate" />
                                        </div>
                                    </div>
                               </div>

                                
                                <div class="row">
                                    <div class="col-lg-4">
                                        <div class="mb-3">
                                            <label for="basicpill-address-input">Invoice Number : *</label>
                                            <input type="text" class="form-control" placeholder="Prefix :" id="txtPrefix" readonly="readonly" /><br>
                                            <input type="text" class="form-control" placeholder="Serial No. :" id="txtSNo" /><br>
                                            <input type="text" class="form-control" placeholder="Suffix : " id="txtSuffix" readonly="readonly" />
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <!-- Company Document -->
                            <h3>Address</h3>
                            <section>
                                <div class="row">
                                    <div class="col-lg-8">
                                        <div class="mb-3">
                                            <label class="form-label">Contact Person: *</label>
                                            <input class="form-control" id="txtCPerson" maxlength="50" />
                                        </div>
                                    </div>
                                    <div class="col-lg-4">
                                        <div class="mb-3">
                                            <label class="form-label">Designation:</label>
                                            <input class="form-control" id="txtCPersonTitle" maxlength="50" />
                                        </div>
                                    </div>
                                </div>
                                <div class="row">

                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label class="form-label">Address: *</label>
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
                                            <div class="clearfix"></div>
                                        </div>

                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <select class="form-select" id="dropFKStateID"></select>
                                            <div class="clearfix"></div>
                                        </div>

                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <select class="form-select" id="dropFKCityID"></select>
                                            <div class="clearfix"></div>
                                        </div>

                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <select class="form-select" id="dropFKTahsilID"></select>
                                            <div class="clearfix"></div>
                                        </div>

                                    </div>

                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <input id="txtZIP" type="text" class="form-control" maxlength="6" placeholder="ZIP" />
                                            <div class="clearfix"></div>
                                        </div>

                                    </div>
                                </div>

                            </section>


                            <!-- Bank Details -->
                            <h3>Invoice Items</h3>
                            <section>

                                <div class="DetailPart">
                                    <div class="tablePart topRadius">
                                        <span class="title">Item Details</span>
                                        <div class="RightLink" id="divDetailButtons">

                                            <a id="linkMemo">
                                                <i class="fa fa-notes-medical"></i>&nbsp;<span>Add Memo</span>
                                            </a>

                                        </div>

                                    </div>
                                    <div class="clearfix"></div>
                                    <div class="detail-container">
                                        <table id="tblDetail" class="tableInput tableInput-select xpad table-bordered table-hover">
                                            <thead>
                                                <tr>
                                                    <th style="width: 30px;"></th>
                                                    <th>Description
                                                    </th>
                                                    <th style="width: 100px; text-align: right;">Rate
                                                    </th>
                                                    <th style="width: 80px; text-align: right;">Qty
                                                    </th>
                                                    <th style="width: 120px; text-align: right;">Amount
                                                    </th>
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
                                                <li>Total Amt.: <span id="FTotalSubAmt">0</span></li>
                                                <li>Tax Amt.(+): <span id="FTotalTax">0</span></li>
                                                <li>Discount (-): <span id="FTotalDisc">0</span></li>
                                                <li>Net Amt.: <span id="FNetAmt">0</span></li>
                                                <li>Applied Retainer: <span id="FReceived">0</span></li>
                                                <li>Due Amt : <span id="FNetDueAmt">0</span></li>
                                            </ul>
                                        </div>
                                        <div class="RightLink addmore">
                                            <div class="row">
                                                 <a id="btnAddUnbilledTask">
                                                    <i class="fa fa-fw fa-plus topicon"></i> Task&nbsp;&nbsp;
                                                 </a>
                                            </div>
                                            <div class="row">
                                            <a id="btnAddUnbilledExpenses">                                              
                                                <i class="fa fa-fw fa-plus topicon"></i>  Expenses&nbsp;&nbsp;</a> </div>
                                        </div>
                                    </div>

                                    <div class="clearfix"></div>
                                </div>

                                <div class="row">
                                    <div class="col-lg-3">
                                        <div class="mb-3">
                                            <label class="form-label">Tax :</label>
                                            <select id="dropFKTaxID" class="form-select"></select>
                                        </div>
                                    </div>
                                    <div class="col-lg-3">
                                        <div class="mb-3">
                                            <label class="form-label">Tax %:</label>
                                            <input id="txtTaxPer" type="text" class="form-control" />
                                        </div>
                                    </div>

                                    <div class="col-lg-3">
                                        <div class="mb-3">
                                            <label class="form-label">Discount (<span id="spandiscCurrency"></span>):</label>
                                            <input id="txtDiscount" type="text" class="form-control" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-lg-3">
                                        <div class="mb-3">
                                            <label class="form-label">Client Retainer:</label>
                                            <input id="txtClientRetainer" type="text" class="form-control" readonly="readonly" />
                                        </div>
                                    </div>
                                </div>
                            </section>
                         
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- jquery step -->
    <script src="assets/libs/jquery-steps/build/jquery.steps.min.js"></script>
    <script src="assets/libs/tinymce/tinymce.min.js"></script>
    <script src="MasterJs/AddressJs.js"></script>
    <script src="UserJs/Billing/CreateInvoice.js?v=1"></script>
    <!-- form wizard init -->

</asp:Content>
