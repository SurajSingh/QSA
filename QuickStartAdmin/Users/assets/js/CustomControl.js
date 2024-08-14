function GenexFilerTree(array, id) {
    var passedTest = [];
    for (var i = 0; i < array.length; i++) {
        if (array[i].ParentID == id)
            passedTest.push(array[i]);
    }

    return passedTest;
}

function FunChildRecersive(jsontreedata, ParentID, str, IsCheck) {
    var newArray = GenexFilerTree(jsontreedata, ParentID);

    if (newArray.length > 0) {

        str += '<ul class="nested">';
        for (var i = 0; i < newArray.length; i++) {
            var StrNodeName = '';
            var newArrayChild = GenexFilerTree(jsontreedata, newArray[i].ID);
            if (IsCheck == false) {
                StrNodeName = '<span class="tree-content">' + newArray[i].Name + '</span>'
                if (newArrayChild.length > 0) {
                    StrNodeName = '<span class="tree-node-nochild tree-node"></span>' + StrNodeName + '';
                }
                else {
                    StrNodeName = '<span class="tree-node-nochild"></span>' + StrNodeName + '';
                }
            }
            else {
                if (newArrayChild.length > 0) {
                    StrNodeName = '<label class="checkbox haschild">' + newArray[i].Name + '<input data-name="' + newArray[i].Name + '" type="checkbox" value="' + newArray[i].ID + '" /> <span class="checkmark"></span></label> ';
                }
                else {
                    StrNodeName = '<label class="checkbox">' + newArray[i].Name + '<input data-name="' + newArray[i].Name + '" type="checkbox" value="' + newArray[i].ID + '" /> <span class="checkmark"></span></label> ';

                }

            }


            str += '<li data-columns="' + newArray[i].ID + '" data-parentid="' + newArray[i].ParentID + '">' + StrNodeName;
            str = FunChildRecersive(jsontreedata, newArray[i].ID, str, IsCheck);
        }
        str += '</ul>';
        return str;
    }
    else {
        return str;
    }
}

$.fn.ComboTree = function (jsontreedata, IsCombo, IsCheck) {

    try {
        var str = '';
        var IsTextBox = false;
        var id = this.attr("id");
        var treedivid = this;
        if (IsCheck == null) {
            IsCheck = false;
        }
        if (IsCheck) {
            this.addClass('genex-checkboxcombo');

        }
        this.children().remove();

        if (jsontreedata.length > 0) {

            var newArray = GenexFilerTree(jsontreedata, 0);

            for (var i = 0; i < newArray.length; i++) {
                var StrNodeName = '';
                var newArrayChild = GenexFilerTree(jsontreedata, newArray[i].ID);
                if (IsCheck == false) {
                    StrNodeName = '<span class="tree-content">' + newArray[i].Name + '</span>';
                    if (newArrayChild.length > 0) {
                        StrNodeName = '<span class="tree-node-nochild tree-node"></span>' + StrNodeName + '';
                    }
                    else {
                        StrNodeName = '<span class="tree-node-nochild"></span>' + StrNodeName + '';
                    }
                }
                else {
                    if (newArrayChild.length > 0) {

                        StrNodeName = '<label class="checkbox haschild">' + newArray[i].Name + '<input data-name="' + newArray[i].Name + '" type="checkbox" value="' + newArray[i].ID + '" /> <span class="checkmark"></span></label> ';
                    }
                    else {
                        StrNodeName = '<label class="checkbox">' + newArray[i].Name + '<input data-name="' + newArray[i].Name + '" type="checkbox" value="' + newArray[i].ID + '" /> <span class="checkmark"></span></label> ';

                    }

                }

                str += '<li data-columns="' + newArray[i].ID + '" data-parentid="' + newArray[i].ParentID + '" >' + StrNodeName;
                str = FunChildRecersive(jsontreedata, newArray[i].ID, str, IsCheck);
                str += '</li>';
            }

            str = '<ul class="rootul">' + str + '</ul>';
            this.append(str);
        }
        if (IsCombo) {

            if ($("#" + id + "_search").length == 0) {
                var strtext = '<input type="text" id="' + id + '_search" placeholder="Select One" class="form-control treeSearchCtrl dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" />'
                $(strtext).insertBefore(this);
                $('body').on('click', "#" + id, function (e) {
                    e.stopPropagation()
                });
                $("#" + id + "_search").on("keydown", function (e) {
                    var NewID = $(this).attr("id");
                    NewID = NewID.replace("_search", "");

                    if (!($("#" + NewID).hasClass("show"))) {
                        $(this).click();
                    }


                });
                $("#" + id + "_search").on("change", function (e) {

                    var NewID = $(this).attr("id");
                    NewID = NewID.replace("_search", "");

                    var val = $("#" + NewID).ComboTreeGet();
                    if (val == null) {
                        $(this).val("");
                    }
                    else {
                        var obj = $("#" + NewID).find(".selectednode").parent();
                        $(this).val(obj.text());
                    }



                });
                $("#" + id + "_search").on("keyup", function (e) {
                    var NewID = $(this).attr("id");
                    NewID = NewID.replace("_search", "");

                    var textval = $(this).val();
                    if (textval == "") {
                        $("#" + NewID).find("li").show();
                    }
                    else {
                        $("#" + NewID).find('.tree-content').each(function () {

                            var strtext = $(this).text().toUpperCase();
                            if (strtext.indexOf(textval.toUpperCase()) < 0) {
                                $(this).parent().hide();
                            }
                        });
                    }

                });
                this.addClass("dropdown-menu treecombo-select");
                this.attr("aria-labelledby", id);
            }




            //this.css("width", $("#" + id + "_search").width);
        }

        var toggler = document.getElementById(id).getElementsByClassName("tree-node");
        var i;

        for (i = 0; i < toggler.length; i++) {
            toggler[i].addEventListener("click", function () {
                this.parentElement.querySelector(".nested").classList.toggle("active");
                this.classList.toggle("tree-node-down");
            });
        }
        this.on('click', '.tree-content', function (event) {
            event.stopImmediatePropagation();
            var NewDivID = $(this).parent().closest('div');
            var NewID = $(NewDivID).attr("id");
            var IsShow = true;
            if ($(this).hasClass("selectednode")) {
                IsShow = false;
            }
            $(NewDivID).find(".tree-content").removeClass("selectednode");
            if (IsShow) {
                $(this).addClass("selectednode");
            }

            if (IsCombo) {
                if ($(this).hasClass("selectednode")) {

                    $("#" + NewID + "_search").addClass("showclildname");
                    $("#" + NewID + "_search").val($(this).text());
                }
                else {
                    $("#" + NewID + "_search").val("");
                    $("#" + NewID + "_search").removeClass("showclildname");
                }
            }
        });
        this.on('click', '.haschild input', function (event) {
            event.stopImmediatePropagation();
            var ischecked = $(this).is(":checked");
            $(this).parent().parent().find('input').prop('checked', ischecked);           
        });
        return this;
    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return this;
}
$.fn.ComboTreeSelect = function (id) {

    try {
        var treedivid = this;
        var treeid = this.attr("id");
        this.find(".tree-content").removeClass("selectednode");
        this.find('li').each(function () {
            var newid = $(this).attr("data-columns");
            if (newid == id) {
                var SelectedNode = $(this).find('.tree-content').first();
                $(SelectedNode).addClass("selectednode");

                if (treedivid.hasClass("treecombo-select")) {
                    $("#" + treeid + "_search").val($(SelectedNode).text());
                    $("#" + treeid + "_search").addClass("showclildname");
                }

            }
        });
        var newid = this.find('.selectednode');
        $(newid).parents(".nested")
            .addClass("active");

        $(newid).parents(".nested")
            .parent().find(".tree-node").addClass("tree-node-down");



        this.scrollTop($('.selectednode').position().top);

    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return this;
}
$.fn.ComboTreeGet = function () {
    var value = null;
    try {
        var obj = this.find(".selectednode").parent();
        value = $(obj).attr("data-columns");

    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return value;
}

$.fn.ComboTreeClearSelection = function (id) {

    try {
        this.find(".tree-content").removeClass("selectednode");
        this.find(".nested").removeClass("active");
        if (this.hasClass("treecombo-select")) {
            var id = this.attr("id");
            $("#" + id + "_search").val("");
            $("#" + id + "_search").removeClass("showclildname");

        }

    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return this;
}