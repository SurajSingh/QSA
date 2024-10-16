! function (l) {
    "use strict";

    function r() { }
    r.prototype.respChart = function (r, o, e, a) {
        Chart.defaults.global.defaultFontColor = "#9295a4", Chart.defaults.scale.gridLines.color = "rgba(166, 176, 207, 0.1)";
        var t = r.get(0).getContext("2d"),
            n = l(r).parent();

        function i() {
            r.attr("width", l(n).width());
            switch (o) {
                case "Line":
                    new Chart(t, {
                        type: "line",
                        data: e,
                        options: a
                    });
                    break;
                case "Doughnut":
                    new Chart(t, {
                        type: "doughnut",
                        data: e,
                        options: a
                    });
                    break;
                case "Pie":
                    new Chart(t, {
                        type: "pie",
                        data: e,
                        options: a
                    });
                    break;
                case "Bar":
                    new Chart(t, {
                        type: "bar",
                        data: e,
                        options: a
                    });
                    break;
                case "Radar":
                    new Chart(t, {
                        type: "radar",
                        data: e,
                        options: a
                    });
                    break;
                case "PolarArea":
                    new Chart(t, {
                        data: e,
                        type: "polarArea",
                        options: a
                    })
            }
        }
        l(window).resize(i), i()
    }, r.prototype.init = function () {
        this.respChart(l("#lineChart"), "Line", {
            labels: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October"],
            datasets: [{
                label: "Sales Analytics",
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
                data: [65, 59, 80, 81, 56, 55, 40, 55, 30, 80]
            }, {
                label: "Monthly Earnings",
                fill: !0,
                lineTension: .5,
                backgroundColor: "rgba(235, 239, 242, 0.2)",
                borderColor: "#ebeff2",
                borderCapStyle: "butt",
                borderDash: [],
                borderDashOffset: 0,
                borderJoinStyle: "miter",
                pointBorderColor: "#ebeff2",
                pointBackgroundColor: "#fff",
                pointBorderWidth: 1,
                pointHoverRadius: 5,
                pointHoverBackgroundColor: "#ebeff2",
                pointHoverBorderColor: "#eef0f2",
                pointHoverBorderWidth: 2,
                pointRadius: 1,
                pointHitRadius: 10,
                data: [80, 23, 56, 65, 23, 35, 85, 25, 92, 36]
            }]
        }, {
            scales: {
                yAxes: [{
                    ticks: {
                        max: 100,
                        min: 20,
                        stepSize: 10
                    }
                }]
            }
        });
        this.respChart(l("#doughnut"), "Doughnut", {
            labels: ["Desktops", "Tablets"],
            datasets: [{
                data: [300, 210],
                backgroundColor: ["#5b73e8", "#ebeff2"],
                hoverBackgroundColor: ["#5b73e8", "#ebeff2"],
                hoverBorderColor: "#fff"
            }]
        });
        this.respChart(l("#pie"), "Pie", {
            labels: ["Desktops", "Tablets"],
            datasets: [{
                data: [300, 180],
                backgroundColor: ["#34c38f", "#ebeff2"],
                hoverBackgroundColor: ["#34c38f", "#ebeff2"],
                hoverBorderColor: "#fff"
            }]
        });
        this.respChart(l("#bar"), "Bar", {
            labels: ["January", "February", "March", "April", "May", "June", "July"],
            datasets: [{
                label: "Sales Analytics",
                backgroundColor: "rgba(52, 195, 143, 0.8)",
                borderColor: "rgba(52, 195, 143, 0.8)",
                borderWidth: 1,
                hoverBackgroundColor: "rgba(52, 195, 143, 0.9)",
                hoverBorderColor: "rgba(52, 195, 143, 0.9)",
                data: [65, 59, 81, 45, 56, 80, 50, 20]
            }]
        }, {
            scales: {
                xAxes: [{
                    barPercentage: .4
                }]
            }
        });
        this.respChart(l("#radar"), "Radar", {
            labels: ["Eating", "Drinking", "Sleeping", "Designing", "Coding", "Cycling", "Running"],
            datasets: [{
                label: "Desktops",
                backgroundColor: "rgba(241, 180, 76 , 0.2)",
                borderColor: "#f1b44c",
                pointBackgroundColor: "#f1b44c",
                pointBorderColor: "#fff",
                pointHoverBackgroundColor: "#fff",
                pointHoverBorderColor: "#f1b44c",
                data: [65, 59, 90, 81, 56, 55, 40]
            }, {
                label: "Tablets",
                backgroundColor: "rgba(91, 140, 232, 0.2)",
                borderColor: "#5b73e8",
                pointBackgroundColor: "#5b73e8",
                pointBorderColor: "#fff",
                pointHoverBackgroundColor: "#fff",
                pointHoverBorderColor: "#5b73e8",
                data: [28, 48, 40, 19, 96, 27, 100]
            }]
        });
        this.respChart(l("#polarArea"), "PolarArea", {
            datasets: [{
                data: [11, 16, 7, 18],
                backgroundColor: ["#50a5f1", "#34c38f", "#f1b44c", "#5b73e8"],
                label: "My dataset",
                hoverBorderColor: "#fff"
            }],
            labels: ["Series 1", "Series 2", "Series 3", "Series 4"]
        })
    }, l.ChartJs = new r, l.ChartJs.Constructor = r
}(window.jQuery),
    function () {
        "use strict";
        window.jQuery.ChartJs.init()
    }();