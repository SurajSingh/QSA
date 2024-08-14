
var OpenedGridName = "";


$.fn.GenexTable = function (TotalRecord, JsonGridLayout, callback, IsLayout, IsFixHeader, IsFilter) {
    var PageSize = 100;
    var colstr = "";
    if (IsLayout == null) {
        IsLayout = true;
    }
    if (IsFixHeader == null) {
        IsFixHeader = false;
    }
    try {

        var id = this.attr('id');
        var IsControlGenerated = false;

        if (!$("#" + id + "_wrapper").length) {
            this.before('<div id="' + id + '_wrapper" class="dataTables_wrapper no-footer"></div>');
            this.appendTo("#" + id + "_wrapper");

            if ($('#divDataloader').length) {
                $('#divDataloader').appendTo("#" + id + "_wrapper");
            }

            if ($("#" + id + "_loader").length) {
                $("#" + id + "_loader").appendTo("#" + id + "_wrapper");
                $("#" + id + "_loader").hide();
            }
            this.addClass("genexcustomtable");
            if (!IsLayout) {
                this.addClass("nolayout");
            }
            if (!IsFixHeader) {
                this.addClass("nofixheader");
            }

            $("#" + id + " tbody").on('click', 'tr', function (event) {
                $('.genexcustomtable-dropdown').hide();
                if ($(this).hasClass('SelectedRow')) {
                    $(this).removeClass("SelectedRow");
                }
                else {
                    $(this).parent().find('.SelectedRow').removeClass('SelectedRow');
                    $(this).addClass("SelectedRow");
                }
            });
        }


        var CurrentPage = 1;

        if ($("#" + id + "_txtPageNo").length) {
            CurrentPage = parseInt($("#" + id + "_txtPageNo").val());
        }



        if (!$("#" + id + "_control").find('.ulpaging').length) {
            var str = '<div class="row">';
            str += '<div class="col-md-12 col-lg-7"><ul class="ulpaging">';
            str += ' <li> <label>Page Size:</label><input type="text" id="' + id + '_txtPageSize" class="form-control PageSize" /></li>';
            str += '<li id="' + id + '_lipaging"> <a id="' + id + '_btnPagePrev" class="btnPagePrev">Previous</a><input type="text" id="' + id + '_txtPageNo" class="form-control" /><span id="' + id + '_PageNoOfPage" class="PageNoOfPage">/100</span><a id="' + id + '_btnPageNext" class="btnPageNext">Next</a> </li>';
            if (IsFilter) {
                str += ' <li><a title="Filter Data" id="' + id + 'btnFilter" class="buttons-filter"><i class="fa fa-filter"></i> <span>Show Filters</span> </a></li>';
            }
            str += '</ul></div>';

            var strexport = '<a class="dt-button buttons-export  btn  waves-effect" id="' + id + "_export" + '" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-file"></i>&nbsp;Export As  <i class="uil-angle-down d-none d-xl-inline-block font-size-15"></i></a><div  class="dropdown-menu dropdown-menu-end" aria-labelledby="' + id + "_export" + '"><a class="dt-button buttons-pdf buttons-html5"><span>PDF</span></a><a class="dt-button buttons-excel buttons-html5"><span>Excel</span></a><a class="dt-button buttons-word buttons-html5"><span>Word</span></a></div>';
            if (!IsLayout) {
                str += ' <div class="col-md-12 col-lg-5 dt-buttons"  id="' + id + '_buttons">' + strexport + '</div>';
            }
            else {
                str += ' <div class="col-9 col-md-10 col-lg-4 dt-buttons dt-buttons-export"  id="' + id + '_buttons">' + strexport + '</div>';
                str += '<div class="col-3 col-md-2 col-lg-1 dt-buttons"><a class="btnlayout" id="' + id + '_customize"> <i class="fa fa-list"></i></a></div>';
            }



            $("#" + id + "_control").append(str);
            SetNumberBox(id + "_txtPageNo", 0, false, "");
            SetNumberBox(id + "_txtPageSize", 0, false, "");

            colstr = $(this).find("thead").html();

            $("#btnSaveLayout").click(function (event) {
                event.stopImmediatePropagation();
                $("#" + id).GenexTableSaveLayout(colstr);
            });
            $("#btnResetLayout").click(function (event) {
                event.stopImmediatePropagation();
                $("#" + id).GenexTableResetLayout();
            });
        }
        else {
            IsControlGenerated = true;
        }

        if ($("#" + id + "_txtPageSize").val() == "") {
            $("#" + id + "_txtPageSize").val(PageSize);
        }
        else {
            PageSize = parseInt($("#" + id + "_txtPageSize").val());
        }

        var noofpage = parseInt(TotalRecord / PageSize);
        var StartIndex = CurrentPage * PageSize;
        if ((noofpage * PageSize) < TotalRecord) {
            noofpage = noofpage + 1;
        }
        if (noofpage == 0 && TotalRecord > 0) {
            noofpage = 1;
        }

        StartIndex = (StartIndex - PageSize) + 1;
        var EndIndex = StartIndex + PageSize - 1;
        if (EndIndex > TotalRecord) {
            EndIndex = TotalRecord;
        }
        $("#" + id + "_PageNoOfPage").html("/" + noofpage);

        if ($("#" + id + "_txtPageNo").val() == "") {
            if (TotalRecord > 0) {
                $("#" + id + "_txtPageNo").val("1");
            }
            else {
                $("#" + id + "_txtPageNo").val("0");

            }
        }

        if (IsControlGenerated == false) {


            $("#" + id + "_txtPageSize").val(PageSize);

            $("#" + id + "_txtPageSize").change(function () {
                $("#" + id).GenexTableDestroy();
                PageSize = parseInt($(this).ValZero());

                noofpage = parseInt(TotalRecord / PageSize);
                StartIndex = CurrentPage * PageSize;
                if ((noofpage * PageSize) < TotalRecord) {
                    noofpage = noofpage + 1;
                }
                if (noofpage == 0 && TotalRecord > 0) {
                    noofpage = 1;
                }

                callback($(this).ValZero(), 0, "", "A", "");
            });


            $("#" + id + " thead").on('click', 'th', function (event) {
                event.stopImmediatePropagation();
                var datacol = $(this).attr('data-column');
                if ($(this).hasClass("sorting") && typeof datacol != typeof undefined && datacol != false) {
                    var SortDir = "D";
                    var strclassName = "";
                    if ($(this).hasClass("sorting_asc")) {
                        SortDir = "D";
                        strclassName = "sorting_desc";
                    }
                    else {
                        SortDir = "A";
                        strclassName = "sorting_asc";

                    }
                    $("#" + id + ' thead').find('th').removeClass('sorting_asc');
                    $("#" + id + ' thead').find('th').removeClass('sorting_desc');
                    $(this).parent().find('th').removeClass('sorting_asc');
                    $(this).parent().find('th').removeClass('sorting_desc');

                    $("#" + id + ' thead').find('[data-column=' + datacol + ']').addClass(strclassName);
                    $(this).addClass(strclassName);
                    callback(PageSize, 0, datacol, SortDir, "");
                }
            });


            if (IsLayout) {
                $("#" + id + "_customize").click(function (event) {
                    event.stopImmediatePropagation();
                    var strCol = "";

                    var tblid = $("#" + id);

                    if (tblid.parent().parent().find('.floatThead-table').length) {
                        tblid = tblid.parent().parent().find('.floatThead-table');
                    }
                    $("#tblTableLayout tbody").empty();
                    if (JsonGridLayout == null || JsonGridLayout.length == 0) {
                        tblid.find('thead .headmain th').each(function (row, th) {
                            var attr = $(th).attr('data-column');
                            if (typeof attr != typeof undefined && attr != false) {
                                var selectedstr = "";
                                var strclass = "";
                                var strcolwidth = "";


                                if (!$(th).hasClass('hidetd')) {
                                    selectedstr = 'checked="checked"';
                                }
                                if ($(th).hasClass('tdnoedit')) {

                                    strclass = 'class="tdnoedit"';
                                }

                                strCol += '<tr id="trlayout' + attr + '" ' + strclass + '><td><input type="checkbox" id="chkgrid' + attr + '" value="' + attr + '" ' + selectedstr + ' /></td><td class="colheadername">' + $(th).html() + '</td><td><input type="text" id="txtDisplayName' + attr + '" class="form-control" max-width="50" value="' + $(th).html() + '" /></td>';

                                strCol += '</tr>';
                            }

                        });
                    }
                    else {
                        $.each(JsonGridLayout, function (i, item) {
                            var selectedstr = "";
                            var strclass = "";
                            var attr = item.FieldName;
                            if (item.Visibility) {
                                selectedstr = 'checked="checked"';
                            }
                            if (item.IsEditable) {

                                strclass = 'class="tdnoedit"';
                            }
                            strCol += '<tr id="trlayout' + attr + '" ' + strclass + '><td><input type="checkbox" id="chkgrid' + attr + '" value="' + attr + '" ' + selectedstr + ' /></td><td class="colheadername">' + item.HeaderName + '</td><td><input type="text" id="txtDisplayName' + attr + '" class="form-control" max-width="50" value="' + item.DisplayName + '" /></td>';
                            strCol += '</tr>';


                        });

                    }
                    $("#tblTableLayout tbody").append(strCol);
                    $("#tblTableLayout tbody").find('.tdnoedit').find('input').prop('disabled', true);

                    OpenedGridName = id;
                    opendiv("divTableLayout");
                });
            }


            $("#" + id + "_buttons").on('click', '.buttons-word', function (event) {
                event.stopImmediatePropagation();
                callback(0, 0, "", "A", "Word");
            });
            $("#" + id + "_buttons").on('click', '.buttons-excel', function (event) {
                event.stopImmediatePropagation();
                callback(0, 0, "", "A", "Excel");
            });
            $("#" + id + "_buttons").on('click', '.buttons-pdf', function (event) {
                event.stopImmediatePropagation();
                callback(0, 0, "", "A", "PDF");
            });
            $("#" + id + "_buttons").on('click', '.buttons-print', function (event) {
                event.stopImmediatePropagation();
                window.print();
            });

            $("#" + id + "_btnPagePrev").click(function (event) {
                event.stopImmediatePropagation();
                if (!$(this).hasClass('disabled')) {
                    PageSize = parseInt($("#" + id + "_txtPageSize").ValZero());
                    var ArrPaging = $("#" + id).GenexTablGetSortingCol();
                    CurrentPage = parseInt($("#" + id + "_txtPageNo").val());
                    CurrentPage = CurrentPage - 1;
                    StartIndex = ((CurrentPage * PageSize) - PageSize) + 1;
                    $("#" + id + "_txtPageNo").val(CurrentPage);
                    var EndIndex1 = StartIndex + PageSize - 1;
                    if (EndIndex1 > TotalRecord) {
                        EndIndex1 = TotalRecord;
                    }
                    $("#" + id + "_info").html('Showing ' + StartIndex + ' to ' + EndIndex1 + ' of ' + TotalRecord + ' entries');

                    callback(PageSize, StartIndex - 1, ArrPaging[0].SortCol, ArrPaging[0].SortDir, "");
                }

            });

            $("#" + id + "_btnPageNext").click(function (event) {
                event.stopImmediatePropagation();
                if (!$(this).hasClass('disabled')) {
                    PageSize = parseInt($("#" + id + "_txtPageSize").ValZero());
                    var ArrPaging = $("#" + id).GenexTablGetSortingCol();
                    CurrentPage = parseInt($("#" + id + "_txtPageNo").val());
                    CurrentPage = CurrentPage + 1;
                    StartIndex = ((CurrentPage * PageSize) - PageSize) + 1;
                    $("#" + id + "_txtPageNo").val(CurrentPage);
                    var EndIndex1 = StartIndex + PageSize - 1;
                    if (EndIndex1 > TotalRecord) {
                        EndIndex1 = TotalRecord;
                    }
                    $("#" + id + "_info").html('Showing ' + StartIndex + ' to ' + EndIndex1 + ' of ' + TotalRecord + ' entries');

                    callback(PageSize, StartIndex - 1, ArrPaging[0].SortCol, ArrPaging[0].SortDir, "");
                }
            });


            $("#" + id + "_txtPageNo").change(function (event) {
                event.stopImmediatePropagation();
                PageSize = parseInt($("#" + id + "_txtPageSize").ValZero());
                if ($("#" + id + "_txtPageNo").val() == "") {
                    $("#" + id + "_txtPageNo").val("1");
                }
                if (parseInt($("#" + id + "_txtPageNo").val()) <= 0) {
                    if (TotalRecord > 0) {
                        $("#" + id + "_txtPageNo").val("1");
                    }
                    else {
                        $("#" + id + "_txtPageNo").val("0");
                    }
                }
                var NewPage = parseInt($("#" + id + "_txtPageNo").val());
                if (NewPage > noofpage) {
                    $("#" + id + "_txtPageNo").val(noofpage);
                }

                if (TotalRecord > 0) {
                    var ArrPaging = $("#" + id).GenexTablGetSortingCol();

                    CurrentPage = parseInt($("#" + id + "_txtPageNo").val());
                    StartIndex = ((CurrentPage * PageSize) - PageSize) + 1;
                    $("#" + id + "_txtPageNo").val(CurrentPage);
                    var EndIndex1 = StartIndex + PageSize - 1;
                    if (EndIndex1 > TotalRecord) {
                        EndIndex1 = TotalRecord;
                    }
                    $("#" + id + "_info").html('Showing ' + StartIndex + ' to ' + EndIndex1 + ' of ' + TotalRecord + ' entries');

                    callback(PageSize, StartIndex - 1, ArrPaging[0].SortCol, ArrPaging[0].SortDir, "");
                }

            });

            if (IsFilter) {
                $("#" + id + "btnFilter").click(function (event) {
                    event.stopImmediatePropagation();
                    $("#" + id + "_divfilter").toggleClass('hidetd');
                    if ($("#" + id + "_divfilter").hasClass('hidetd')) {
                        $("#" + id + "btnFilter").find('span').html('Show Filters');

                    }
                    else {
                        $("#" + id + "btnFilter").find('span').html('Hide Filter');
                    }
                    $("#" + id).GenexTableFixHeader(true);



                });
                if ($("#" + id + "_divfilter_cancel").length) {
                    $("#" + id + "_divfilter_cancel").click(function (event) {
                        event.stopImmediatePropagation();
                        $("#" + id + "_divfilter").toggleClass('hidetd');
                        $("#" + id).GenexTableFixHeader(true);
                    });
                }

            }

        }


        if (!$("#" + id + "FooterInfo").length) {
            var strPage = '<div id="' + id + 'FooterInfo"><div class="dataTables_info" id="' + id + '_info" role="status" aria-live="polite">Showing ' + StartIndex + ' to ' + EndIndex + ' of ' + TotalRecord + ' entries</div>';

            this.after(strPage);
        }

        //Active Inactive Next and Previous Page 
        if (CurrentPage == 1 || noofpage == 0) {
            $("#" + id + "_btnPagePrev").addClass("disabled");
        }
        else {
            $("#" + id + "_btnPagePrev").removeClass("disabled");
        }
        if (CurrentPage == noofpage || noofpage == 0) {
            $("#" + id + "_btnPageNext").addClass("disabled");
        }
        else {
            $("#" + id + "_btnPageNext").removeClass("disabled");
        }
        if (IsLayout) {
            if (JsonGridLayout != null) {
                if (JsonGridLayout.length > 0) {
                    $("#" + id).GenexTableSetLayout(JsonGridLayout, colstr);
                    if (IsFixHeader) {
                        $("#" + id).GenexTableFixHeader(IsControlGenerated);
                    }
                }
                else {
                    if (IsFixHeader) {
                        $("#" + id).GenexTableFixHeader(IsControlGenerated);
                    }

                }
            }
            else {
                if (IsFixHeader) {
                    $("#" + id).GenexTableFixHeader(IsControlGenerated);
                }
            }

        }
        else {
            if (IsFixHeader) {
                $("#" + id).GenexTableFixHeader(IsControlGenerated);
            }
        }

        return this;
    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return this;
};

$.fn.GenexTablGetSortingCol = function () {
    var id = this.attr('id');
    var SortDir = "D";
    var SortCol = "";
    var TableData = new Array();
    if ($("#" + id + ' thead').find('.sorting_asc').length > 0) {
        SortDir = "A";
        SortCol = $("#" + id + ' thead').find('.sorting_asc').attr('data-column');
    }
    else if ($("#" + id + ' thead').find('.sorting_desc').length > 0) {
        SortDir = "D";
        SortCol = $("#" + id + ' thead').find('.sorting_desc').attr('data-column');

    }
    TableData[0] = {
        "SortDir": SortDir
        , "SortCol": SortCol

    };
    return TableData;
};
$.fn.GenexTableDestroy = function () {
    var id = this.attr('id');
    var StrPageSize = "";

    if ($("#" + id + "FooterInfo").length) {
        $("#" + id + "FooterInfo").remove();
    }
    if ($("#" + id + "_PageNoOfPage").length) {
        $("#" + id + "_PageNoOfPage").val("/0");
        $("#" + id + "_txtPageNo").val("1");

    }

    return this;
};
$.fn.GenexTableGetPageSize = function () {
    var id = this.attr('id');
    var PageSize = 100;

    if ($("#" + id + "_txtPageSize").length) {
        PageSize = parseInt($("#" + id + "_txtPageSize").ValZero());
    }

    return PageSize;
};
$.fn.GenexTableFixHeader = function (IsControlGenerated) {
    var id = this.attr('id');
    var str = '';
    if (IsControlGenerated == false) {
        $("#" + id + ' colgroup').empty();
    }
    $("#" + id + ' thead .headmain th').each(function (row, th) {

        var colw = $(th).width();
        if (!$(th).hasClass("hidetd")) {

            $(th).css("width", colw);
            $("#" + id + " tbody").find("tr:first").find('td:eq(' + row + ')').css("width", colw);
            if (IsControlGenerated == false) {
                str = '<col style="width: ' + colw + 'px;">';
                $("#" + id + ' colgroup').append(str);
            }

        }

    });

    var frameH = $(window).height();
    var lessheight = 10;

    if ($("#" + id + "_control").length) {
        lessheight = lessheight + $("#" + id + "_control").height() + 20;
    }
    if ($("#" + id + "_divSaveCtrl").length) {
        lessheight = lessheight + $("#" + id + "_divSaveCtrl").height() + 20;
    }
    if ($("#page-topbar").length) {
        lessheight = lessheight + $("#page-topbar").height() + 20;
    }
    if ($("#divnavbar").length) {
        lessheight = lessheight + $("#divnavbar").height() + 20;
    }
    if ($(".page-title-box").length) {
        lessheight = lessheight + $(".page-title-box").height() + 20;
    }
    if ($(".divrptfilter").length) {
        lessheight = lessheight + $(".divrptfilter").height() + 20;
    }
    if ($("#" + id + "_divfilter").length) {
        if (!$("#" + id + "_divfilter").hasClass('hidetd')) {
            lessheight = lessheight + $("#" + id + "_divfilter").height() + 20;
        }
    }

    if (this.hasClass("genexpopuptable")) {
        lessheight = lessheight + this.closest(".divpopup").position().top;
        if (this.closest(".divpopup").find('.divpopbutton').length) {
            lessheight = lessheight + this.closest(".divpopup").find('.divpopbutton').height();
        }

    }

    $("#" + id + "_wrapper").css("height", frameH - lessheight);
    $("#" + id + "_wrapper").css("overflow", "auto");

    var x = $("#" + id).outerWidth();
    $("#" + id + "_wrapper").css("width", "100%");
    var $table = $("#" + id);

    if (IsControlGenerated) {
        if ($("#" + id).hasClass('nofixheader')) {
            $("#" + id).GenexTableRemoveHeader();
        }
    }

    $table.floatThead({
        scrollContainer: function ($table) {
            return $table.closest('.dataTables_wrapper');
        }
    });
};

$.fn.GenexTableRemoveHeader = function () {
    var id = this.attr('id');
    var reinit = this.floatThead('destroy');

};
$.fn.GenexTableGetSelectedCol = function () {
    var id = this.attr('id');
    var id1 = this;

    if ($("#" + id).parent().parent().find('.floatThead-table').length) {
        id1 = $("#" + id).parent().parent().find('.floatThead-table');
    }
    var strCol = "";
    id1.find('thead .headmain th').each(function (row, th) {
        var attr = $(th).attr('data-column');
        if (typeof attr != typeof undefined && attr != false) {
            var selectedstr = "";
            if (!$(th).hasClass('hidetd')) {
                if (strCol != "") {
                    strCol += ',';
                }
                strCol += attr;
            }
        }

    });
    return strCol;
};
$.fn.GenexTableSetLayout = function (JsonTableLayout, headerstr) {
    var id = this.attr('id');
    if (!this.hasClass('nofixheader')) {
        $("#" + id).GenexTableRemoveHeader();
    }

    $.each(JsonTableLayout, function (i, item) {
        if (item.Visibility) {
            $("#" + id).find('.td' + item.FieldName).removeClass("hidetd");
        }
        else {
            $("#" + id).find('.td' + item.FieldName).addClass("hidetd");
        }
        $("#" + id + ' thead').find('.td' + item.FieldName).html(item.DisplayName);

    });


};
$.fn.GenexTableSaveLayout = function (headerstr) {
    var id = this.attr('id');
    var StrData;
    var TableData = new Array();
    var sno = 0;

    $('#tblTableLayout tbody tr').each(function (row, tr) {
        var trid = $(this).attr('id');
        trid = trid.replace('trlayout', '');
        var IsEditable = true;
        if ($(tr).hasClass('tdnoedit')) {
            IsEditable = false;
        }
        TableData[sno] = {
            "SNo": sno
            , "FieldName": $('#chkgrid' + trid).val()
            , "HeaderName": $(tr).find(".colheadername").html()
            , "DisplayName": $('#txtDisplayName' + trid).val()
            , "Visibility": $('#chkgrid' + trid).is(':checked')
            , "IsPrint": $('#chkgrid' + trid).is(':checked')
            , "ColWidth": "100px"
            , "IsEditable": IsEditable


        };
        sno = sno + 1;
    });
    StrData = JSON.stringify(TableData);

    var args = {
        FKPageID: FKPageID,
        GridName: OpenedGridName,
        XMLDef: StrData,
        ForAllUser: $('#chkForAllUsersLayout').is(':checked')

    };

    ShowLoader();
    $.ajax({

        type: "POST",
        url: "/Users/SetTableLayout.aspx" + "/SaveData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {

                    if (jsonarr[0].Result == "1") {
                        HideLoader();
                        closediv();
                        FunGridLayoutSetArray(TableData, OpenedGridName);
                        $("#" + OpenedGridName).GenexTableSetLayout(TableData, headerstr);

                        PKID = 0;
                        IsColCreated = false;
                        RCount = 0;
                        $("#" + id).GenexTableDestroy();
                        FunFillData($("#" + id).GenexTableGetPageSize(), 0, "", "A", "");
                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                        HideLoader();
                    }
                }
                else {
                    OpenAlert("The call to the server side failed. ");

                }


            }
            else {
                OpenAlert(data.d);
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
};
$.fn.GenexTableResetLayout = function () {
    var id = this.attr('id');


    var args = {
        FKPageID: FKPageID,
        GridName: OpenedGridName, ForAllUser: $('#chkForAllUsersLayout').is(':checked')


    };

    ShowLoader();
    $.ajax({

        type: "POST",
        url: "/Users/SetTableLayout.aspx" + "/ResetData",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data) {

            if (data.d != "failure") {
                var jsonarr = $.parseJSON(data.d);

                if (jsonarr.length > 0) {

                    if (jsonarr[0].Result == "1") {
                        HideLoader();
                        closediv();
                        //$("#" + OpenedGridName).GenexTableSetLayout([], "");
                        //LoadEntity = 1;
                        //FunGetTableLayout(FKPageID, OpenedGridName, FunGridLayoutCallback);

                        opendiv('divRefreshLayout');


                    }
                    else {
                        OpenAlert(jsonarr[0].Msg);
                        HideLoader();
                    }
                }
                else {
                    OpenAlert("The call to the server side failed. ");

                }


            }
            else {
                OpenAlert(data.d);
            }

        },
        error: function (x, e) {
            OpenAlert("The call to the server side failed. " + x.responseText);
            HideLoader();
            return;
        }

    });
};

$.fn.GenexList = function (TotalRecord, callback, IsFilter) {
    var PageSize = 100;
    var colstr = "";
    
    try {

        var id = this.attr('id');
        var IsControlGenerated = false;

        if (!$("#" + id + "_wrapper").length) {
            this.before('<div id="' + id + '_wrapper" class="dataTables_wrapper no-footer"></div>');
            this.appendTo("#" + id + "_wrapper");

            if ($('#divDataloader').length) {
                $('#divDataloader').appendTo("#" + id + "_wrapper");
            }

            if ($("#" + id + "_loader").length) {
                $("#" + id + "_loader").appendTo("#" + id + "_wrapper");
                $("#" + id + "_loader").hide();
            }
          
            
        }


        var CurrentPage = 1;

        if ($("#" + id + "_txtPageNo").length) {
            CurrentPage = parseInt($("#" + id + "_txtPageNo").val());
        }



        if (!$("#" + id + "_control").find('.ulpaging').length) {
            var str = '<div class="row">';
            str += '<div class="col-md-12 col-lg-12"><div style="background:#ffffff;padding:15px;float: left;width:100%;"><ul class="ulpaging" style="margin:0px;" >';
            str += ' <li> <label>Page Size:</label><input type="text" id="' + id + '_txtPageSize" class="form-control PageSize" /></li>';
            str += '<li id="' + id + '_lipaging"> <a id="' + id + '_btnPagePrev" class="btnPagePrev">Previous</a><input type="text" id="' + id + '_txtPageNo" class="form-control" /><span id="' + id + '_PageNoOfPage" class="PageNoOfPage">/100</span><a id="' + id + '_btnPageNext" class="btnPageNext">Next</a> </li>';
            if (IsFilter) {
                str += ' <li><a title="Filter Data" id="' + id + 'btnFilter" class="buttons-filter"><i class="fa fa-filter"></i> <span>Show Filters</span> </a></li>';
            }
            str += '</ul></div></div>';

            //var strexport = '<a class="dt-button buttons-export  btn  waves-effect" id="' + id + "_export" + '" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-file"></i>&nbsp;Export As  <i class="uil-angle-down d-none d-xl-inline-block font-size-15"></i></a><div  class="dropdown-menu dropdown-menu-end" aria-labelledby="' + id + "_export" + '"><a class="dt-button buttons-pdf buttons-html5"><span>PDF</span></a><a class="dt-button buttons-excel buttons-html5"><span>Excel</span></a><a class="dt-button buttons-word buttons-html5"><span>Word</span></a></div>';
            //str += ' <div class="col-md-12 col-lg-5 dt-buttons"  id="' + id + '_buttons">' + strexport + '</div>';



            $("#" + id + "_control").append(str);
            SetNumberBox(id + "_txtPageNo", 0, false, "");
            SetNumberBox(id + "_txtPageSize", 0, false, "");

            
        }
        else {
            IsControlGenerated = true;
        }

        if ($("#" + id + "_txtPageSize").val() == "") {
            $("#" + id + "_txtPageSize").val(PageSize);
        }
        else {
            PageSize = parseInt($("#" + id + "_txtPageSize").val());
        }

        var noofpage = parseInt(TotalRecord / PageSize);
        var StartIndex = CurrentPage * PageSize;
        if ((noofpage * PageSize) < TotalRecord) {
            noofpage = noofpage + 1;
        }
        if (noofpage == 0 && TotalRecord > 0) {
            noofpage = 1;
        }

        StartIndex = (StartIndex - PageSize) + 1;
        var EndIndex = StartIndex + PageSize - 1;
        if (EndIndex > TotalRecord) {
            EndIndex = TotalRecord;
        }
        $("#" + id + "_PageNoOfPage").html("/" + noofpage);

        if ($("#" + id + "_txtPageNo").val() == "") {
            if (TotalRecord > 0) {
                $("#" + id + "_txtPageNo").val("1");
            }
            else {
                $("#" + id + "_txtPageNo").val("0");

            }
        }

        if (IsControlGenerated == false) {


            $("#" + id + "_txtPageSize").val(PageSize);

            $("#" + id + "_txtPageSize").change(function () {
                $("#" + id).GenexTableDestroy();
                PageSize = parseInt($(this).ValZero());
                noofpage = parseInt(TotalRecord / PageSize);
                StartIndex = CurrentPage * PageSize;
                if ((noofpage * PageSize) < TotalRecord) {
                    noofpage = noofpage + 1;
                }
                if (noofpage == 0 && TotalRecord > 0) {
                    noofpage = 1;
                }
                if (PageSize == 0) {
                    PageSize = 100;
                    $(this).val(PageSize);
                }
                callback($(this).val(), 0, "", "A", "");
            });



            $("#" + id + "_buttons").on('click', '.buttons-word', function (event) {
                event.stopImmediatePropagation();
                callback(0, 0, "", "A", "Word");
            });
            $("#" + id + "_buttons").on('click', '.buttons-excel', function (event) {
                event.stopImmediatePropagation();
                callback(0, 0, "", "A", "Excel");
            });
            $("#" + id + "_buttons").on('click', '.buttons-pdf', function (event) {
                event.stopImmediatePropagation();
                callback(0, 0, "", "A", "PDF");
            });
            $("#" + id + "_buttons").on('click', '.buttons-print', function (event) {
                event.stopImmediatePropagation();
                window.print();
            });

            $("#" + id + "_btnPagePrev").click(function (event) {
                event.stopImmediatePropagation();
                if (!$(this).hasClass('disabled')) {
                    PageSize = parseInt($("#" + id + "_txtPageSize").ValZero());
                    var ArrPaging = $("#" + id).GenexTablGetSortingCol();
                    CurrentPage = parseInt($("#" + id + "_txtPageNo").val());
                    CurrentPage = CurrentPage - 1;
                    StartIndex = ((CurrentPage * PageSize) - PageSize) + 1;
                    $("#" + id + "_txtPageNo").val(CurrentPage);
                    var EndIndex1 = StartIndex + PageSize - 1;
                    if (EndIndex1 > TotalRecord) {
                        EndIndex1 = TotalRecord;
                    }
                    $("#" + id + "_info").html('Showing ' + StartIndex + ' to ' + EndIndex1 + ' of ' + TotalRecord + ' entries');

                    callback(PageSize, StartIndex - 1, ArrPaging[0].SortCol, ArrPaging[0].SortDir, "");
                }

            });

            $("#" + id + "_btnPageNext").click(function (event) {
                event.stopImmediatePropagation();
                if (!$(this).hasClass('disabled')) {
                    PageSize = parseInt($("#" + id + "_txtPageSize").ValZero());
                    var ArrPaging = $("#" + id).GenexTablGetSortingCol();
                    CurrentPage = parseInt($("#" + id + "_txtPageNo").val());
                    CurrentPage = CurrentPage + 1;
                    StartIndex = ((CurrentPage * PageSize) - PageSize) + 1;
                    $("#" + id + "_txtPageNo").val(CurrentPage);
                    var EndIndex1 = StartIndex + PageSize - 1;
                    if (EndIndex1 > TotalRecord) {
                        EndIndex1 = TotalRecord;
                    }
                    $("#" + id + "_info").html('Showing ' + StartIndex + ' to ' + EndIndex1 + ' of ' + TotalRecord + ' entries');

                    callback(PageSize, StartIndex - 1, ArrPaging[0].SortCol, ArrPaging[0].SortDir, "");
                }
            });


            $("#" + id + "_txtPageNo").change(function (event) {
                event.stopImmediatePropagation();
                PageSize = parseInt($("#" + id + "_txtPageSize").ValZero());
                if ($("#" + id + "_txtPageNo").val() == "") {
                    $("#" + id + "_txtPageNo").val("1");
                }
                if (parseInt($("#" + id + "_txtPageNo").val()) <= 0) {
                    if (TotalRecord > 0) {
                        $("#" + id + "_txtPageNo").val("1");
                    }
                    else {
                        $("#" + id + "_txtPageNo").val("0");
                    }
                }
                var NewPage = parseInt($("#" + id + "_txtPageNo").val());
                if (NewPage > noofpage) {
                    $("#" + id + "_txtPageNo").val(noofpage);
                }

                if (TotalRecord > 0) {
                    var ArrPaging = $("#" + id).GenexTablGetSortingCol();

                    CurrentPage = parseInt($("#" + id + "_txtPageNo").val());
                    StartIndex = ((CurrentPage * PageSize) - PageSize) + 1;
                    $("#" + id + "_txtPageNo").val(CurrentPage);
                    var EndIndex1 = StartIndex + PageSize - 1;
                    if (EndIndex1 > TotalRecord) {
                        EndIndex1 = TotalRecord;
                    }
                    $("#" + id + "_info").html('Showing ' + StartIndex + ' to ' + EndIndex1 + ' of ' + TotalRecord + ' entries');

                    callback(PageSize, StartIndex - 1, ArrPaging[0].SortCol, ArrPaging[0].SortDir, "");
                }

            });

            if (IsFilter) {
                $("#" + id + "btnFilter").click(function (event) {
                    event.stopImmediatePropagation();
                    $("#" + id + "_divfilter").toggleClass('hidetd');
                    if ($("#" + id + "_divfilter").hasClass('hidetd')) {
                        $("#" + id + "btnFilter").find('span').html('Show Filters');

                    }
                    else {
                        $("#" + id + "btnFilter").find('span').html('Hide Filter');
                    }
                    $("#" + id).GenexTableFixHeader(true);



                });
                if ($("#" + id + "_divfilter_cancel").length) {
                    $("#" + id + "_divfilter_cancel").click(function (event) {
                        event.stopImmediatePropagation();
                        $("#" + id + "_divfilter").toggleClass('hidetd');
                        $("#" + id).GenexTableFixHeader(true);
                    });
                }

            }

        }


        if (!$("#" + id + "FooterInfo").length) {
            var strPage = '<div id="' + id + 'FooterInfo"><div class="dataTables_info" id="' + id + '_info" role="status" aria-live="polite">Showing ' + StartIndex + ' to ' + EndIndex + ' of ' + TotalRecord + ' entries</div>';

            this.after(strPage);
        }

        //Active Inactive Next and Previous Page 
        if (CurrentPage == 1 || noofpage == 0) {
            $("#" + id + "_btnPagePrev").addClass("disabled");
        }
        else {
            $("#" + id + "_btnPagePrev").removeClass("disabled");
        }
        if (CurrentPage == noofpage || noofpage == 0) {
            $("#" + id + "_btnPageNext").addClass("disabled");
        }
        else {
            $("#" + id + "_btnPageNext").removeClass("disabled");
        }
       

        return this;
    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return this;
};




$.fn.GenexTableExport = function (JsonTableLayout, JsonData, ExportType) {
    var id = this.attr('id');
    var strhead = '', strdata = '', strtophead = '';
    var sno = 0;
    var colspan = 0;
    var tblid = $("#" + id);
    if (tblid.parent().parent().find('.floatThead-table').length) {
        tblid = tblid.parent().parent().find('.floatThead-table');
    }

    tblid.find('thead .headmain th').each(function (row, th) {
        var attr = $(th).attr('data-column');
        if (typeof attr != typeof undefined && attr != false) {

            var Visibility = true;
            if (!$(th).hasClass('hidetd')) {
                var strwidth = '';
                if ($(th).attr('data-column') == 'ImageURL') {
                    if (ExportType == 'Excel') {
                        strwidth = 'width="200"';
                    }
                    else {
                        strwidth = 'width="160"';
                    }
                }
                strhead += '<th style="border-left:1px solid #e0e0e0;border-top:1px solid #e0e0e0;" ' + strwidth + '>' + $(th).html() + '</th>';
                colspan = colspan + 1;
            }
            sno++;
        }

    });



    $.each(JsonData, function (i, item) {
        strdata += '<tr>';

        tblid.find('thead .headmain th').each(function (row, th) {
            var attr = $(th).attr('data-column');
            if (typeof attr != typeof undefined && attr != false) {

                if (!$(th).hasClass('hidetd')) {
                    var keyval = JsonData[i][attr];

                    if (attr == "ImageURL") {
                        if (keyval == "") {
                            keyval = $('#HidWebURL').val() + 'Users/Images/NoImage.jpg';
                        }
                        else {
                            keyval = $('#HidWebURL').val() + '/webfiles/itemimg/' + keyval;
                        }
                        var strwidth = '';
                        if (ExportType == 'Excel') {
                            strwidth = 'width="200"';
                        }
                        else {
                            strwidth = 'width="160"';
                        }
                        strdata += '<td style="border-left:1px solid #e0e0e0;border-top:1px solid #e0e0e0;text-align:center;vertical-align:middle;" height="150" ' + strwidth + '>';
                        if (ExportType == 'Word') {

                            strdata += '<img src="' + keyval + '"  width="150" height="150" />';
                        }
                        else if (ExportType == 'Excel') {

                            strdata += '<img src="' + keyval + '"   height="140" />';
                        }
                        else {
                            strdata += '<img src="' + keyval + '" style="width:120px;" width="120" />';
                        }
                        strdata += '</td>';
                    }
                    else {
                        strdata += '<td style="border-left:1px solid #e0e0e0;border-top:1px solid #e0e0e0;">' + keyval + '</td>';
                    }
                }

            }

        });

        strdata += '</tr>';
    });
    var filename = "ExportData";
    if ($("#" + id + "_title").find('h1').length) {
        filename = $("#" + id + "_title").find('h1').html();
    }
    else if ($("#pagetitle").length) {
        filename = $("#pagetitle").html();
    }

    var tblborder = '0';
    if (ExportType == 'PDF') {
        tblborder = '1';
    }
    var newid = Math.floor(1000 + Math.random() * 9000);
    var htmls = '<table id="tblExportData' + newid + '" cellpadding="4" cellspacing="0" border="' + tblborder + '" width="100%" style="width:100%;repeat-header: yes;border-right:1px solid #e0e0e0;border-bottom:1px solid #e0e0e0;font-family:Calibri;font-size:10pt;"><thead><tr><th style="color:#17a2b8;" colspan="' + colspan + '">' + filename + '</th></tr><tr bgcolor="#17a2b8" style="background-color:#17a2b8;color:#ffffff;">' + strhead + '</tr></thead><tbody>' + strdata + '</tbody></table>';
    filename = filename.replace(/[^A-Z0-9]/ig, "");
    filename = filename + '_' + Math.floor(1000 + Math.random() * 9000);
    if (ExportType == "Excel") {

        GenexExportExcel(htmls, filename, newid);
    }
    else if (ExportType == "PDF") {
        FunDownloadPDF(htmls, filename, FKPageID);
    }
    else if (ExportType == "Word") {
        FunExport2Word(htmls, filename);
    }
};

function GenexExportExcel(htmls, filename, newid) {

    var str = '<div style="display:none;" id="divexport' + newid + '">' + htmls + '</div>';
    $("body").append(str);
    ExportToExcel('xlsx', filename, 'tblExportData' + newid);
    $('#divexport' + newid).remove();
    //var uri = 'data:application/vnd.ms-excel;base64,';
    //var template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>';
    //var base64 = function (s) {
    //    return window.btoa(unescape(encodeURIComponent(s)));
    //};

    //var format = function (s, c) {
    //    return s.replace(/{(\w+)}/g, function (m, p) {
    //        return c[p];
    //    });
    //};

    //var ctx = {
    //    worksheet: 'Worksheet',
    //    table: htmls
    //};


    //var link = document.createElement("a");
    //link.download = filename;
    //link.href = uri + base64(format(template, ctx));
    //link.click();
}

function ExportToExcel(type, filename, tblid, fn, dl) {
    var elt = document.getElementById(tblid);
    var wb = XLSX.utils.table_to_book(elt, { sheet: "sheet1" });
    return dl ?
        XLSX.write(wb, { bookType: type, bookSST: true, type: 'base64' }) :
        XLSX.writeFile(wb, fn || (filename + '.' + (type || 'xlsx')));
}