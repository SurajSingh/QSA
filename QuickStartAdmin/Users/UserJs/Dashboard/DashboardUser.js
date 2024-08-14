
var json;
var pagename = "DashboardUser.aspx";
var LoadEntity = 0;
var Analysischart = null;
function FunFillData() {
    var str = "";


    var args = {
    };

    $.ajax({
        type: "POST",
        url: pagename + "/GetData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {


                $("#LChartTodayInfo").hide();

                var jsonarr = $.parseJSON(data.d);
                FillMonthlyChart(jsonarr);
                FunFillScheduleAndApointment(jsonarr);

            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);

            return;
        }

    });



}
function FunDashboardGetTopTasks(daterange) {
    var str = "";


    var args = {
        daterange: daterange
    };

    $.ajax({
        type: "POST",
        url: pagename + "/DashboardGetTopTasks",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure" && data.d != "Invalid Request" && data.d != "") {


                $('#LChartTop10Activity').hide();
                $('#divTaskChart').show();

                var jsonarr = $.parseJSON(data.d);
                if (jsonarr.data.Table1.length > 0) {


                    $('#spanbillableamount').html(jsonarr.data.Table1[0].BillableAmount);
                    $('#spanTotalHours').html(jsonarr.data.Table1[0].TotalHours);
                    $('#spanBillableHours').html(jsonarr.data.Table1[0].BillableHours);

                    var labels = jsonarr.data.Table.map(function (e) {
                        return e.TaskCode;
                    });
                    var ChartData = jsonarr.data.Table.map(function (e) {
                        return e.Hrs;
                    });
                    var ChartData1 = jsonarr.data.Table.map(function (e) {
                        return e.BillAmount;
                    });
                    var ChartData2 = jsonarr.data.Table.map(function (e) {
                        return e.TCostRate;
                    });



                    var options = {
                        chart: {
                            height: 250,
                            type: "line",
                            stacked: !1,
                            toolbar: {
                                show: !1
                            }
                        },
                        stroke: {
                            width: [0, 2, 4],
                            curve: "smooth"
                        },
                        plotOptions: {
                            bar: {
                                columnWidth: "30%"
                            }
                        },
                        colors: ["#5b73e8", "#dfe2e6", "#f1b44c"],
                        series: [{
                            name: "Hours",
                            type: "column",
                            data: ChartData
                        }, {
                            name: "Pay Amount",
                            type: "area",
                            data: ChartData2
                        }, {
                            name: "Bill Amount",
                            type: "line",
                            data: ChartData1
                        }],
                        fill: {
                            opacity: [.85, .25, 1],
                            gradient: {
                                inverseColors: !1,
                                shade: "light",
                                type: "vertical",
                                opacityFrom: .85,
                                opacityTo: .55,
                                stops: [0, 100, 100, 100]
                            }
                        },
                        labels: labels,
                        markers: {
                            size: 0
                        },
                        xaxis: {

                        },
                        yaxis: {
                            title: {
                                text: "Hours"
                            }
                        },
                        tooltip: {
                            shared: !0,
                            intersect: !1,
                            y: {
                                formatter: function (e) {
                                    return void 0 !== e ? e.toFixed(0) + "" : e
                                }
                            }
                        },
                        grid: {
                            borderColor: "#f1f1f1"
                        }
                    };
                    
                    (Analysischart = new ApexCharts(document.querySelector("#ChartTop10Activity"), options)).render();

                }

            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);

            return;
        }

    });



}

function FillTopEmp(jsonarr) {
    $("#LChartTop10Emp").hide();


    Chart.defaults.global.defaultFontColor = "#9295a4", Chart.defaults.scale.gridLines.color = "rgba(166, 176, 207, 0.1)";
    //Today Items
    var labels = jsonarr.data.Table1.map(function (e) {
        return e.LoginID;
    });
    var ChartData = jsonarr.data.Table1.map(function (e) {
        return e.Amount;
    });
    var ChartData1 = jsonarr.data.Table1.map(function (e) {
        return e.Hrs;
    });


    var speedCanvas = document.getElementById("ChartTop10Emp");
    var dataFirst = [{
        data: ChartData,
        label: "Billing Amount",
        fill: !0,
        lineTension: .5,
        backgroundColor: "rgba(91, 140, 232, 0.2)",
        borderColor: "#5b73e8",
        borderCapStyle: "butt",
        borderDash: [],
        borderDashOffset: 0,
        borderJoinStyle: "miter",
        pointBorderColor: "#5b73e8",
        pointBackgroundColor: "#fff",
        pointBorderWidth: 1,
        pointHoverRadius: 5,
        pointHoverBackgroundColor: "#5b73e8",
        pointHoverBorderColor: "#fff",
        pointHoverBorderWidth: 2,
        pointRadius: 1,
        pointHitRadius: 10,
    }];

    var speedData = {
        labels: labels,
        datasets: dataFirst

    };
    var chartOptions = {
        legend: {
            display: true,
            position: 'top'
        },
        "scales": {
            "yAxes": [{
                "ticks": {
                    "beginAtZero": true,
                    callback: function (value, index, values) {
                        return value;
                    }
                }
            }]

        },
        stroke: {
            width: [0, 2, 4],
            curve: "smooth"
        },
    };

    var lineChart = new Chart(speedCanvas, {
        type: 'bar',
        hover: false,
        data: speedData,
        options: chartOptions
    });
}
function FillBillingAnalysis(jsonarr) {
    $("#LChartBillingTimeSheet").hide();


    //Today Items
    var labels = jsonarr.data.Table.map(function (e) {
        return e.Month;
    });
    var ChartData = jsonarr.data.Table.map(function (e) {
        return e.CostAmount;
    });
    var ChartData1 = jsonarr.data.Table.map(function (e) {
        return e.BillAmount;
    });
    var ChartData2 = jsonarr.data.Table.map(function (e) {
        return e.BilledAmount;
    });

    var options = {
        chart: {
            height: 350,
            type: "bar",
            toolbar: {
                show: !1
            }
        },
        plotOptions: {
            bar: {
                horizontal: !1,
                columnWidth: "45%",
                endingShape: "rounded"
            }
        },
        dataLabels: {
            enabled: !1
        },
        stroke: {
            show: !0,
            width: 2,
            colors: ["transparent"]
        },
        series: [{
            name: "Total Cost",
            data: ChartData
        }, {
            name: "Billable Amount",
            data: ChartData1
        }, {
            name: "Billed Amount",
            data: ChartData2
        }],
        colors: ["#f1b44c", "#5b73e8", "#34c38f"],
        xaxis: {
            categories: labels
        },
        yaxis: {
            title: {
                text: "$ (thousands)"
            }
        },
        grid: {
            borderColor: "#f1f1f1"
        },
        fill: {
            opacity: 1
        },
        tooltip: {
            y: {
                formatter: function (e) {
                    return "$ " + e + " thousands"
                }
            }
        }
    };
    (chart = new ApexCharts(document.querySelector("#ChartBillingTimeSheet"), options)).render();


}
function FillMonthlyChart(jsonarr) {
    $("#LChartMonthly").hide();


    //Today Items
    var labels = jsonarr.data.Table2.map(function (e) {
        return e.Month;
    });
    var ChartData = jsonarr.data.Table2.map(function (e) {
        return e.Hrs;
    });
  

    var options = {
        chart: {
            height: 350,
            type: "bar",
            toolbar: {
                show: !1
            }
        },
        plotOptions: {
            bar: {
                horizontal: !1,
                columnWidth: "45%",
                endingShape: "rounded"
            }
        },
        dataLabels: {
            enabled: !1
        },
        stroke: {
            show: !0,
            width: 2,
            colors: ["transparent"]
        },
        series: [{
            name: "Monthly Hours",
            data: ChartData
        }],
        colors: ["#f1b44c"],
        xaxis: {
            categories: labels
        },
        yaxis: {
            title: {
                text: "Hours"
            }
        },
        grid: {
            borderColor: "#f1f1f1"
        },
        fill: {
            opacity: 1
        },
        tooltip: {
            y: {
                formatter: function (e) {
                    return "" + e + " Hours"
                }
            }
        }
    };
    (chart = new ApexCharts(document.querySelector("#ChartMonthly"), options)).render();


}
function FunFillScheduleAndApointment(jsonarr) {
    $("#LScheduleAndAppointment").hide();
    var str = "";
    if (jsonarr.data.Table3.length > 0) {
        

        $.each(jsonarr.data.Table3, function () {
            str = str + '<div class="row events">';
            str += '  <div class="col-sm-1"><i class="uil-calender green"></i></div>';
            str += '<div class="col-sm-8"><strong>' + this.FromDate + '</strong> - ' + this.ProjectName + '<br>(' + this.RecType + ')</div>';
            if (this.FromTime != '') {
                str += '<div class="col-sm-3"><i class="uil-clock-three clock-icon"></i>&nbsp;' + this.FromTime + '</div>';
            }
            else {
                str += '<div class="col-sm-3"></div>';
            }
            str = str + '</div>';



        });


        $("#divScheduleAndAppointment").append(str);


    }
    else {
        str = str + '<div class="row events">';
        str += '  <div class="col-sm-12">No data exists</div>';
        str = str + '</div>';
        $("#divScheduleAndAppointment").append(str);
    }
}
var randomColorGenerator = function () {
    return '#' + (Math.random().toString(16) + '0000000').slice(2, 8);
};



function FunFillInvoices(jsonarr) {
    $("#LLatestInvoice").hide();

    if (jsonarr.data.Table4.length > 0) {
        str = "";

        $.each(jsonarr.data.Table4, function () {

          


            str = str + '<tr>';
            str += '<td>#' + this.InvoiceID + '</td>';
            str += '<td>' + this.InvDate + '</td>';
            str += '<td>' + this.ProjectCode + '</td>';
            str += '<td class="special">' + this.Symbol + FormatMoney(this.NetAmount, 2, ".", ",") + '</td>';
            if (this.NetAmount == this.NetDueAmount) {
                str += '<td> <span class="badge rounded-pill bg-soft-danger font-size-12">Unpaid</span></td>';
            }
            else if (this.NetDueAmount<=0) {
                str += '<td> <span class="badge rounded-pill bg-soft-success font-size-12">Paid</span></td>';
            }
            else  {
                str += '<td> <span class="badge rounded-pill bg-soft-warning font-size-12">Partial</span></td>';
            }
           
          
            str += '<td class="tdjobid"><a target="_blank" class="btn btn-primary btn-sm btn-rounded waves-effect waves-light" href="PrintInvoice.aspx?PKID=' + this.PKID + '">View Detail</a></td>';
           
          
            str = str + '</tr>';



        });

        $("#tblRecentInvLog tbody").empty();
        $("#tblRecentInvLog tbody").append(str);


    }
}
function FunFillRecentLogs() {
    var str = "";

    $("#listActivity").empty();

    var args = {


    };
    $.ajax({
        type: "POST",
        url: pagename + "/GetRecentLogs",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure" && data.d != "Invalid Request") {
                var jsonarr = $.parseJSON(data.d);
                $("#LlistActivity").hide();
                if (jsonarr.length > 0) {
                    $.each(jsonarr, function (i, item) {

                        str = str + '<li  class="feed-item">';
                        str += '<div class="feed-item-list">';
                        str += '<p class="text-muted mb-1 font-size-13">' + item.LogDate + '<small class="d-inline-block ms-1">' + item.LogTime+'</small></p>';
                        str += ' <p class="mb-0"><span class="text-primary">' + item.LoginID +'</span>&nbsp;' + item.Operation + '</p>';
                        str += ' </div>';

                       
                        str += '</li>';

                    });

                    $("#listActivity").append(str);
                   
                    
                }
                else {
                    $("#listActivity").append("<li>No activity found.</li>");
                }
            }
            else {
                OpenAlert("Session Timeout!");
                window.location.href = "Logout.aspx";
            }
        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);

            return;
        }

    });



}


function InitilizeEvents() {

    $('#divFilterTask').on('click', '.dropdown-item', function (event) {
        Analysischart.destroy();
        var newid = $(this).attr("data-date");
        var newid1 = $(this).html();
        $('#LChartTop10Activity').show();
        $('#divTaskChart').hide();
        $('#spanTaskFilterBy').html(newid1);
        FunDashboardGetTopTasks(newid);
    });

}

function PageLoadFun() {

    InitilizeEvents();



    FunFillData();
    FunDashboardGetTopTasks('Current Month');
    FunFillRecentLogs();




}

$(document).ready(function () {
    SetUserRoles(PageLoadFun);
});


//CallbakFunction






