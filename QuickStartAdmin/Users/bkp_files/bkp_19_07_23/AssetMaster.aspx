<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="AssetMaster.aspx.cs" Inherits="QuickStartAdmin.Users.AssetMaster" %>

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

    <div class="modal-dialog modal-sm divpopup" id="divAddNew" style="width: 800px; display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="popupTitle"><i class="uil-file-plus font-size-18"></i>&nbsp;<span>Add New Asset</span></h4>
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
                    <div class="col-lg-9">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-4">
                                    <div class="mb-3">
                                        <label class="form-label">Asset Code: *</label>
                                        <input class="form-control" id="txtAssetCode" maxlength="50" />
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <div class="mb-3">
                                        <label class="form-label">Asset Name: *</label>
                                        <input class="form-control" id="txtAssetName" maxlength="50" />
                                    </div>
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label class="form-label">Description: </label>
                                        <input class="form-control" id="txtAssetDesc" maxlength="500" />
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="col-lg-3">
                        <div class="mb-3" title="Upload Item Image" id="divImage">
                            <div id="btnfileselect" class="UploadPhoto normal" style="background-image: url(Images/NoImage.jpg); float: right;">
                                <div id="btnFileSelectInner"></div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Category: *</label>
                            <select class="form-select" id="dropFKCategoryID"></select>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Serial No.: </label>
                            <input class="form-control" id="txtSerialNo" maxlength="50" />
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Barcode: </label>
                            <input class="form-control" id="txtBarcode" maxlength="50" />
                        </div>
                    </div>

                    <div class="col-lg-3">
                        <div class="mb-3">
                            <label class="form-label">Manufacturer:</label>
                            <input class="form-control" id="txtManufacturer" maxlength="50" />
                        </div>
                    </div>
                </div>

                <fieldset class="fieldset">
                    <legend>Acquire  Detail

                    </legend>
                    <div class="innerbox">

                        <div class="row">
                            <div class="col-lg-3">
                                <div class="mb-3">
                                    <label class="form-label">Vendor: *</label>
                                    <select class="form-select" id="dropFKPartyID"></select>
                                </div>
                            </div>
                            <div class="col-lg-3">
                                <div class="mb-3">
                                    <label class="form-label">Acquire Date: *</label>
                                    <input class="form-control" id="txtPurchaseDate" maxlength="15" />
                                </div>
                            </div>

                            <div class="col-lg-2">
                                <div class="mb-3">
                                    <label class="form-label">Rate:</label>
                                    <input class="form-control" id="txtPurchaseRate" maxlength="15" />
                                </div>
                            </div>
                            <div class="col-lg-2">
                                <div class="mb-3">
                                    <label class="form-label">Invoice #:</label>
                                    <input class="form-control" id="txtInvoiceID" maxlength="50" />
                                </div>
                            </div>
                            <div class="col-lg-2">
                                <div class="mb-3">
                                    <label class="form-label">PO #:</label>
                                    <input class="form-control" id="txtPONo" maxlength="50" />
                                </div>
                            </div>
                        </div>
                    </div>
                </fieldset>




                <fieldset class="fieldset">
                    <legend>Current Status</legend>
                    <div class="innerbox">
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label">Condition: *</label>
                                    <select class="form-select" id="dropFKConditionID"></select>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label">Location: *</label>
                                    <select class="form-select" id="dropFKLocationID"></select>
                                </div>
                            </div>

                            <div class="col-lg-4" id="divFKDeptID" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">Department: *</label>
                                    <select class="form-select" id="dropFKDeptID"></select>
                                </div>
                            </div>
                            <div class="col-lg-4" id="divFKEmpID" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">Employee: *</label>

                                    <select class="form-select" id="dropFKEmpID"></select>
                                </div>
                            </div>
                            <div class="col-lg-4" id="divFKRepairPartyID" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">Vendor: *</label>
                                    <select class="form-select" id="dropFKRepairPartyID"></select>
                                </div>
                            </div>
                        </div>
                    </div>
                </fieldset>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="mb-3">
                            <label class="form-label">Notes: </label>
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
                <h4 class="mb-0" id="pagetitle">Asset Master</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Asset Master</a></li>
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
                                    <th style="width: 20px;"></th>
                                    <th data-column="ImgURL" class="tdImgURL">Image</th>
                                    <th data-column="AssetCode" class="sorting tdAssetCode">Asset Code</th>
                                    <th data-column="AssetName" class="sorting tdAssetName">Asset Name</th>
                                    <th data-column="CategCode" class="sorting tdCategCode">Category Code</th>
                                    <th data-column="CategName" class="sorting tdCategName">Category Name</th>
                                    <th data-column="Condition" class="sorting tdCondition">Condition</th>
                                    <th data-column="SerialNo" class="sorting tdSerialNo">Serial No.</th>
                                    <th data-column="Barcode" class="sorting tdBarcode">Barcode</th>
                                    <th data-column="LocationName" class="sorting tdLocationName">Location</th>
                                    <th data-column="AssetLocation" class="sorting tdAssetLocation">Location Detail</th>
                                    <th data-column="PurchaseDate" class="sorting tdPurchaseDate">Acquire Date</th>
                                    <th data-column="Manufacturer" class="sorting tdManufacturer">Manufacturer</th>
                                    <th data-column="Company" class="sorting tdCompany">Vendor</th>
                                    <th data-column="InvoiceID" class="sorting tdInvoiceID">Invoice#</th>
                                    <th data-column="PONo" class="sorting tdPONo">PO#</th>
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
    <iframe src="Upload.aspx" id="ifuploadfile" style="display: none;"></iframe>
    <script src="MasterJs/Attachment.js"></script>
    <script src="MasterJs/AssetAPI.js"></script>

    <script src="UserJs/AssetManagement/AssetMaster.js?version=30092022"></script>
</asp:Content>
