<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="TransferAsset.aspx.cs" Inherits="QuickStartAdmin.Users.TransferAsset" %>

<%@ Register Src="~/Users/usercontrol/ucReportLayout.ascx" TagPrefix="uc1" TagName="ucReportLayout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ucReportLayout runat="server" ID="ucReportLayout" />
    <div id="divShowImage" class="imagemodal">
        <span class="close" onclick="closediv();">&times;</span>
        <img class="imagemodal-content" id="imgItem" />
        <div id="caption"></div>
    </div>

    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 500px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>Transfer Asset</span></h4>
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
                <div class="col-lg-12">
                    <div class="mb-3">
                        <label class="form-label">Transfer Date: *</label>
                        <input class="form-control" id="txtPurchaseDate" maxlength="15" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Asset: *</label>
                            <input class="form-control" id="txtAssetCode" maxlength="50" />
                        </div>
                    </div>

                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Location: *</label>
                            <select class="form-select" id="dropFKLocationID"></select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="row">
                        <div class="col-lg-12" id="divFKDeptID" style="display: none;">
                            <div class="mb-3">
                                <label class="form-label">Department: *</label>
                                <select class="form-select" id="dropFKDeptID"></select>
                            </div>
                        </div>
                        <div class="col-lg-12" id="divFKEmpID" style="display: none;">
                            <div class="mb-3">
                                <label class="form-label">Employee: *</label>

                                <select class="form-select" id="dropFKEmpID"></select>
                            </div>
                        </div>
                        <div class="col-lg-12" id="divFKRepairPartyID" style="display: none;">
                            <div class="mb-3">
                                <label class="form-label">Vendor: *</label>
                                <select class="form-select" id="dropFKRepairPartyID"></select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Remarks: </label>
                            <textarea class="form-control" id="txtRemarks" maxlength="500" style="height: 40px;"></textarea>
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
                <h4 class="mb-0" id="pagetitle">Transfer Asset</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Transfer Asset</a></li>
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

                                </div>
                                <div class="row">
                                    <div class="col-sm-3 mar">
                                        <label>Asset Code/Name:</label>
                                        <input type="text" class="form-control" id="txtAssetNameSrch" />
                                    </div>

                                    <div class="col-sm-3 mar">
                                        <label>Asset Category:</label>
                                        <select class="form-select" id="dropFKCategoryIDSrch">
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Condition:</label>
                                        <select class="form-select" id="dropFKConditionIDSrch">
                                        </select>
                                    </div>
                                    <div class="col-sm-3 mar">
                                        <label>Location:</label>
                                        <select class="form-select" id="dropFKLocationIDSrch">
                                        </select>
                                    </div>


                                    <div class="col-sm-3 mar">

                                        <a id="btnSearch" class="btn btn-primary bg-green mr-b-20 mr-t-50"><i class="uil-search me-1"></i>Search</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <i class="fa fa-repai"></i>
                    </div>
                    <div class="divreport">
                        <table id="tbldata" class="dataTable  genexcustomtable">
                            <colgroup>
                            </colgroup>
                            <thead>
                                <tr class="headmain">
                                    <th style="width: 20px;"></th>                                   
                                   
                                    <th data-column="TranDate" class="sorting tdTranDate">Date</th>
                                    <th data-column="EntryID" class="sorting tdEntryID">EntryID</th>
                                    <th data-column="AssetCode" class="sorting tdAssetCode">Asset Code</th>
                                    <th data-column="AssetName" class="sorting tdAssetName">Asset Name</th>
                                    <th data-column="CategCode" class="sorting tdCategCode">Category Code</th>
                                    <th data-column="LocationName" class="sorting tdLocationName">Location</th>
                                    <th data-column="AssetLocation" class="sorting tdAssetLocation">Location Detail</th>
                                    <th data-column="PLocationName" class="sorting tdPLocationName">Previous Location</th>
                                    <th data-column="PAssetLocation" class="sorting tdPAssetLocation">Previous Location Detail</th>
                                    <th data-column="PurchaseRate" class="sorting tdPurchaseRate tdclscurrency">Cost</th>
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
   
    <script src="MasterJs/AssetAPI.js"></script>

    <script src="UserJs/AssetManagement/TransferAsset.js?version=<%=PageVersion%>"></script>
</asp:Content>
