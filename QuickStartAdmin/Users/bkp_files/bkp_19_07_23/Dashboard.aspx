<%@ Page Title="" Language="C#" MasterPageFile="~/Users/UserMaster.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="QuickStartAdmin.Users.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="assets/css/dashboard.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- start page title -->
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="mb-0">Dashboard</h4>

                <div class="page-title-right">
                    <ol class="breadcrumb m-0">
                        <li class="breadcrumb-item"><a href="javascript: void(0);">QuickstartAdmin</a></li>
                        <li class="breadcrumb-item active">Dashboard</li>
                    </ol>
                </div>

            </div>
        </div>
    </div>
    <!-- end page title -->

    <div class="row">

        <%=StrLinks %>

        <%--<div class="col-md-6 col-xl-3">
                                <div class="card">
                                    <div class="card-body dashboardlinks">
                                        <div class="float-end mt-2">
                                          <i class="uil-user-circle"></i>
                                        </div>
                                        <div>
                                            <h4 class="mb-1 mt-1"><span data-plugin="counterup">Employee</span></h4>
                                            <p class="linkdesc"><a href="Employees.aspx">
Add, Modify, Role Settings</a></p>
                                        </div>
                                      
                                    </div>
                                </div>
                            </div> <!-- end col-->

                            <div class="col-md-6 col-xl-3">
                                <div class="card">
                                    <div class="card-body dashboardlinks">
                                        <div class="float-end mt-2">
                                            <i class="uil-clock-three"></i>
                                        </div>
                                        <div>
                                            <h4 class="mb-1 mt-1"><span data-plugin="counterup">Timesheet</span></h4>
                                            <p class="linkdesc"><a href="#">Enter, Approve, Reject</a></p>
                                        </div>
                                       
                                    </div>
                                </div>
                            </div> <!-- end col-->

                            <div class="col-md-6 col-xl-3">
                                <div class="card">
                                    <div class="card-body dashboardlinks">
                                        <div class="float-end mt-2">
                                              <i class="uil-enter"></i>
                                        </div>
                                        <div>
                                            <h4 class="mb-1 mt-1"><span data-plugin="counterup">Expenses</span></h4>
                                            <p class="linkdesc"><a href="#">Enter, Approve, Reimburse</a></p>
                                        </div>
                                       
                                    </div>
                                </div>
                            </div> <!-- end col-->

                            <div class="col-md-6 col-xl-3">

                                <div class="card">
                                    <div class="card-body dashboardlinks">
                                        <div class="float-end mt-2">
                                              <i class="uil-exchange"></i>
                                        </div>
                                        <div>
                                            <h4 class="mb-1 mt-1"><span data-plugin="counterup">Billing</span></h4>
											<p class="linkdesc"><a href="#">Invoice, Payments, Transactions</a></p>
                                        </div>
                                      
                                    </div>
                                </div>
                            </div> <!-- end col-->--%>
    </div>
    <!-- end row-->



    <div class="row">
        <div class="col-xl-6">
            <div class="card">
                <div class="card-body">

                    <h4 class="card-title mb-4">Top Ten Employees</h4>
                    <div id="LChartTop10Emp" class="chartloader">
                    </div>
                    <canvas id="ChartTop10Emp" height="200"></canvas>

                </div>
            </div>
        </div>
        <div class="col-xl-6">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title mb-4">Billing & Timesheet Analysis</h4>
                    <div id="LChartBillingTimeSheet" class="chartloader">
                    </div>
                    <div id="ChartBillingTimeSheet" class="apex-charts" dir="ltr"></div>
                </div>
            </div>
            <!--end card-->
        </div>


    </div>







    <div class="row">
        <div class="col-xl-8">
            <div class="card">
                <div class="card-body">
                    <div class="float-end">
                        <div class="dropdown">
                            <a class="dropdown-toggle text-reset" href="#" id="dropdownMenuButton5"
                                data-bs-toggle="dropdown" aria-haspopup="true"
                                aria-expanded="false">
                                <span class="fw-semibold">Filter By:</span> <span class="text-muted"><span id="spanTaskFilterBy">Current Month</span><i class="mdi mdi-chevron-down ms-1"></i></span>
                            </a>

                            <div id="divFilterTask" class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton5">
                                <a class="dropdown-item" data-date="Current Month">Current Month</a>
                                <a class="dropdown-item" data-date="This Calendar Year">Current Year</a>
                                <a class="dropdown-item" data-date="Current Week">Currect Week</a>
                            </div>
                        </div>
                    </div>
                    <h4 class="card-title mb-4">Top Ten Activites</h4>

                    <div class="mt-1">
                        <div id="LChartTop10Activity" class="chartloader">
                        </div>
                        <ul class="list-inline main-chart mb-0">
                            <li class="list-inline-item chart-border-left me-0 border-0">
                                <h3 class="text-primary"><%=StrCurrency %><span data-plugin="counterup" id="spanbillableamount">0</span><span class="text-muted d-inline-block font-size-15 ms-3">Billable Amount</span></h3>
                            </li>
                            <li class="list-inline-item chart-border-left me-0">
                                <h3><span data-plugin="counterup" id="spanTotalHours">0</span><span class="text-muted d-inline-block font-size-15 ms-3">Total Hours</span>
                                </h3>
                            </li>
                            <li class="list-inline-item chart-border-left me-0">
                                <h3><span data-plugin="counterup" id="spanBillableHours">0</span><span class="text-muted d-inline-block font-size-15 ms-3">Billable Hours</span></h3>
                            </li>

                        </ul>
                    </div>

                    <div class="mt-3" id="divTaskChart">
                        <div id="ChartTop10Activity" class="apex-charts" dir="ltr"></div>
                    </div>
                </div>
                <!-- end card-body-->
            </div>
            <!-- end card-->
        </div>
        <!-- end col-->
        <div class="col-xl-4">
            <div class="row">
                <div class="col-xl-12">
                    <div class="card">
                        <div class="card-body" id="divScheduleAndAppointment" style="min-height:390px;">


                            <h4 class="card-title mb-4">Client Schedule & Appointments</h4>
                            <div id="LScheduleAndAppointment" class="chartloader">
                            </div>




                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                
                
            </div>
        </div>

        <!-- end Col -->
    </div>
    <!-- end row-->

    <div class="row">

        <div class="col-xl-8">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title mb-4">Monthly Time</h4>
                            <div id="LChartMonthly" class="chartloader">
                            </div>
                            <div id="ChartMonthly" class="apex-charts" dir="ltr"></div>
                        </div>
                    </div>
                    <!--end card-->
                </div>
        <div class="col-xl-4">
            <div class="card">
                <div class="card-body">
                   

                    <h4 class="card-title mb-4">Recent Activity</h4>
                     <div id="LlistActivity" class="chartloader">
                            </div>
                    <ol id="listActivity" class="activity-feed mb-0 ps-2" data-simplebar style="max-height: 350px;overflow:auto">
                        <%--<li class="feed-item">
                            <div class="feed-item-list">
                                <p class="text-muted mb-1 font-size-13">Today<small class="d-inline-block ms-1">12:20 pm</small></p>
                                <p class="mb-0">
                                    Andrei Coman magna sed porta finibus, risus
                                                        posted a new article: <span class="text-primary">Forget UX
                                                            Rowland</span>
                                </p>
                            </div>
                        </li>
                        <li class="feed-item">
                            <p class="text-muted mb-1 font-size-13">22 Jul, 2020 <small class="d-inline-block ms-1">12:36 pm</small></p>
                            <p class="mb-0">
                                Andrei Coman posted a new article: <span
                                    class="text-primary">Designer Alex</span>
                            </p>
                        </li>
                        <li class="feed-item">
                            <p class="text-muted mb-1 font-size-13">18 Jul, 2020 <small class="d-inline-block ms-1">07:56 am</small></p>
                            <p class="mb-0">
                                Zack Wetass, sed porta finibus, risus Chris Wallace
                                                    Commented <span class="text-primary">Developer Moreno</span>
                            </p>
                        </li>
                        <li class="feed-item">
                            <p class="text-muted mb-1 font-size-13">10 Jul, 2020 <small class="d-inline-block ms-1">08:42 pm</small></p>
                            <p class="mb-0">
                                Zack Wetass, Chris combined Commented <span
                                    class="text-primary">UX Murphy</span>
                            </p>
                        </li>

                        <li class="feed-item">
                            <p class="text-muted mb-1 font-size-13">23 Jun, 2020 <small class="d-inline-block ms-1">12:22 am</small></p>
                            <p class="mb-0">
                                Zack Wetass, sed porta finibus, risus Chris Wallace
                                                    Commented <span class="text-primary">Developer Moreno</span>
                            </p>
                        </li>
                        <li class="feed-item pb-1">
                            <p class="text-muted mb-1 font-size-13">20 Jun, 2020 <small class="d-inline-block ms-1">09:48 pm</small></p>
                            <p class="mb-0">
                                Zack Wetass, Chris combined Commented <span
                                    class="text-primary">UX Murphy</span>
                            </p>
                        </li>
                            --%>
                    </ol>

                </div>
            </div>
        </div>

      
    </div>
    <div class="row">
          <div class="col-xl-12">
            <div class="card">
                <div class="card-body">
                    <h4 class="card-title mb-4">Latest Invoices</h4>
                    <div class="table-responsive">
                         <div id="LLatestInvoice" class="chartloader">
                            </div>
                        <table id="tblRecentInvLog" class="table table-centered table-nowrap mb-0">
                            <thead class="table-light">
                                <tr>

                                    <th>Invoice ID</th>
                                    <th>Project</th>
                                    <th>Date</th>
                                    <th>Total</th>
                                    <th>Payment Status</th>
                                    <th>View Details</th>
                                </tr>
                            </thead>
                            <tbody>
                                

                            </tbody>
                        </table>
                    </div>
                    <!-- end table-responsive -->
                </div>
            </div>
        </div>
    </div>
    <!-- end row -->


    <!-- end row -->

    <script src="assets/libs/apexcharts/apexcharts.min.js"></script>

    <!-- apexcharts init -->
    <%-- <script src="assets/js/pages/apexcharts.init.js"></script>--%>

    <script src="assets/js/pages/dashboard.init.js"></script>


    <script src="assets/libs/chart.js/Chart.bundle.min.js"></script>
    <%--<script src="assets/js/pages/chartjs.init.js"></script> --%>
    <script src="UserJs/Dashboard/DashboardCompany.js"></script>

</asp:Content>
