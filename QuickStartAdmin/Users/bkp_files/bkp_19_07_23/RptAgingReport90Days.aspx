<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="RptAgingReport90Days.aspx.cs" Inherits="QuickStartAdmin.Users.RptAgingReport90Days" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0" id="pagetitle">Aging Report 90 Days</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">Aging Report 90 Days</a></li>
                        <li class="breadcrumb-item active">Aging Report</li>
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
                    <div class="col-12">
                        <div class="row">
                            <div class="col-sm-3 mar">
                                <label>Date Range:</label>
                                <select id="dropaterange" class="form-select" onchange="sowCustomDate(this.id);">
                                    <option value="All">All Dates</option>
                                    <option value="Today">Today's Date</option>
                                    <option selected="selected" value="AsOf">As Of</option>
                                    <option value="AsOfLastMonth">As of Last Month</option>
                                    <option value="AsOfLastYear">As of Last Year</option>
                                    <option value="ThisWeektoDate">This Week to Date</option>
                                    <option value="ThisMonthtoDate">This Month to Date</option>
                                    <option value="ThisYeartoDate">This Year to Date</option>
                                    <option value="LastYeartoDate">Last Year to Date</option>
                                    <option value="Custom">Custom</option>
                                </select>
                            </div>
                            <div class="col-sm-6 divdaterange" id="divcustomdate">
                                <div class="row">
                                    <div class="col-sm-6 mar" id="divFromDateSrch">
                                        <label>From Date:</label>
                                        <input type="text" class="form-control" id="txtfromdate" />
                                    </div>
                                    <div class="col-sm-6 mar" id="divToDateSrch">
                                        <label>To Date:</label>
                                        <input type="text" class="form-control" id="txttodate" />
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-sm-3 mar">
                                <label>Project:</label>
                                <div id="divFKProjectIDSrch"></div>

                            </div>
                            <div class="col-sm-3 mar">
                                <label>Client:</label>
                                <div id="divFKClientIDSrch"></div>
                            </div>

                            <div class="col-sm-3 mar">

                                <a id="btnSearch" class="btn btn-primary bg-green mr-b-20 mr-t-50"><i class="uil-search me-1"></i>Search</a>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>
        <!-- end col -->
    </div>
    <div class="row">


        <div class="col-sm-12">
            <div>
                <div class="divreport">
                    <iframe id="ifReport" src="Reports/AgingReport.aspx" class="ifReport" style="margin: 0px; padding: 0px; height: 800px;"></iframe>


                </div>
            </div>
        </div>
    </div>
    <script src="UserJs/Reports/AgingReport/RptAgingReport90Days.js"></script>
</asp:Content>
