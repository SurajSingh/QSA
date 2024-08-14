

function GenexFilterModuleTree(array, id) {
    var passedTest = [];
    for (var i = 0; i < array.length; i++) {
        if (array[i].FKParentID == id)
            passedTest.push(array[i]);
    }

    return passedTest;
}

function FunChildModuleRecersive(jsontreedata, ParentID, str, IsCheck) {
    var newArray = GenexFilterModuleTree(jsontreedata, ParentID);

    if (newArray.length > 0) {

        str += '<ul class="nested">';
        for (var i = 0; i < newArray.length; i++) {
            var StrNodeName = '';
            var newArrayChild = GenexFilterModuleTree(jsontreedata, newArray[i].PKID);
            if (IsCheck == false) {
                StrNodeName = '<span class="tree-content">' + newArray[i].ModuleName + '</span>'
                if (newArrayChild.length > 0) {
                    StrNodeName = '<span class="tree-node-nochild tree-node"></span>' + StrNodeName + '';
                }
                else {
                    if (newArray[i].RecType == 'Task') {
                        StrNodeName = '<span class="tree-node-nochild tree-node-task "></span>' + StrNodeName + '';
                    }
                    else {
                        StrNodeName = '<span class="tree-node-nochild"></span>' + StrNodeName + '';
                    }
                }
            }
            else {
                if (newArrayChild.length > 0) {
                    StrNodeName = '<label class="checkbox haschild">' + newArray[i].ModuleName + '<input data-name="' + newArray[i].ModuleName + '" type="checkbox" value="' + newArray[i].PKID + '" /> <span class="checkmark"></span></label> ';
                }
                else {
                    StrNodeName = '<label class="checkbox">' + newArray[i].ModuleName + '<input data-name="' + newArray[i].ModuleName + '" type="checkbox" value="' + newArray[i].PKID + '" /> <span class="checkmark"></span></label> ';

                }

            }


            str += '<li data-columns="' + newArray[i].PKID + '" data-parentid="' + newArray[i].FKParentID + '" data-rectype="' + newArray[i].RecType + '" data-NoOfTask="' + newArray[i].NoOfTask + '" data-NoOfModule="' + newArray[i].NoOfModule + '">' + StrNodeName;
            
            str = FunChildModuleRecersive(jsontreedata, newArray[i].PKID, str, IsCheck);
        }
        str += '</ul>';
        return str;
    }
    else {
        return str;
    }
}

$.fn.ProjectModuleTree = function (jsonArr, IsCombo, IsCheck) {

    try {
        var jsontreedata = jsonArr.data.Table;
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
        this.empty();
        

        if (jsontreedata.length > 0) {
            StrNodeName = '<span class="tree-node-nochild tree-node"></span><span class="tree-content">' + "<b>" + strProjectName+"</b>" + '</span>';
        }
        else {
            StrNodeName = '<span class="tree-node-nochild"></span><span class="tree-content">' + strProjectName + '</span>';
        }
        str = '<li data-columns="0" data-rectype="project" data-FKParentID="0" data-NoOfTask="0" data-NoOfModule="0">' + StrNodeName;
        var newArray = GenexFilterModuleTree(jsontreedata, 0);
        if (newArray.length > 0) {
            str += '<ul class="nested">';
           

            for (var i = 0; i < newArray.length; i++) {
                var StrNodeName = '';
                var newArrayChild = GenexFilterModuleTree(jsontreedata, newArray[i].PKID);
                StrNodeName = '<span class="tree-content">' + newArray[i].ModuleName + '</span>';
                if (newArrayChild.length > 0) {
                    StrNodeName = '<span class="tree-node-nochild tree-node"></span>' + StrNodeName + '';
                }
                else {
                    if (newArray[i].RecType == 'Task') {
                        StrNodeName = '<span class="tree-node-nochild tree-node-task "></span>' + StrNodeName + '';
                    }
                    else {
                        StrNodeName = '<span class="tree-node-nochild"></span>' + StrNodeName + '';
                    }
                  
                }

                str += '<li data-columns="' + newArray[i].PKID + '" data-parentid="' + newArray[i].FKParentID + '" data-rectype="' + newArray[i].RecType + '" data-NoOfTask="' + newArray[i].NoOfTask + '" data-NoOfModule="' + newArray[i].NoOfModule + '">' + StrNodeName;
  
                str = FunChildModuleRecersive(jsontreedata, newArray[i].PKID, str, IsCheck);
                str += '</li>';
            }
            str += '</ul>';
            
        }
        str += '</li>';
        str = '<ul class="rootul">' + str + '</ul>';
        this.append(str);

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
            if (!$(this).hasClass("selectednode")) {
                FKParentID = 0;
                FunBlankModule();
                FunBlankTask();
                $('#divAddTask').hide();
                $('#divAddModule').hide();

                $('#btnAddNew').hide();
                $('#btnAddNew1').hide();

                var NewDivID = $(this).parent().closest('div');
                var NewID = $(NewDivID).attr("id");
                var RecType = $(this).parent().attr('data-rectype');
                PKID = $(this).parent().attr('data-columns');
                FKParentID = 0;
                var NoOfTask = $(this).parent().attr('data-NoOfTask');
                var NoOfModule = $(this).parent().attr('data-NoOfModule');

                var IsShow = true;
                if ($(this).hasClass("selectednode")) {
                    IsShow = false;
                }
                $(NewDivID).find(".tree-content").removeClass("selectednode");
                if (IsShow) {
                    $(this).addClass("selectednode");
                    if (RecType == 'project') {
                        $('#divAddModule').show();

                    }
                    else if (RecType == 'Module') {
                        FKParentID = $(this).parent().attr('data-parentid');
                        $('#divAddModule').show();
                        $('#divAddTask').hide();
                        if (parseInt(NoOfModule) == 0) {
                           
                            $('#btnAddNew1').show();

                        }
                        if (parseInt(NoOfTask) == 0) {
                           
                            $('#btnAddNew').show();
                        }
                        FunFillDetail();
                    }
                    else if (RecType == 'Task') {
                        FKParentID = $(this).parent().attr('data-parentid');
                        $('#divAddModule').hide();
                        $('#divAddTask').show();
                        $('#btnAddNew').hide();
                        $('#btnAddNew1').hide();
                       
                        FunFillDetail();
                    }

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

        if ($(newid).parent().find('.nested').length) {
            if ($(newid).parent().find('.nested').hasClass('active')) {
                $(newid).parent().find(".tree-node:first").addClass("tree-node-down");
            }
        }
       



        $(newid).parents(".nested")
            .parent().find(".tree-node:first").addClass("tree-node-down");

        
       

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