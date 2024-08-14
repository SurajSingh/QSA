$.fn.GenexAutoComplete = function (jsonData, HeaderCol) {

    try {
        var ctrlid = this;
        var divid = this.attr("id") + "_divid";
        var inputid = this.attr("id") + "_hidid";
        var headerid = this.attr("id") + "_hidHeader";
        if ($("#" + inputid).length == 0) {
            this.parent().append('<input id="' + inputid + '" type="hidden" value="" />');
        }
        if ($("#" + headerid).length == 0) {
            this.parent().append('<input id="' + headerid + '" type="hidden" value="" />');
        }
        if ($("#" + divid).length == 0) {
            $('<div id="' + divid + '" class="parentautocomplete" />').insertAfter(this);
        }
        if (HeaderCol != null) {
            if (jsonData.length > 0) {
                var newdiv = jsonData[0].label;
                var divid1 = $(newdiv);
                var arrcol = HeaderCol.split(',');
                $(divid1).each(function (i, div) {
                    if (i < arrcol.length) {
                        $(div).html(arrcol[i]);
                    }
                    else {
                        $(div).html("Column" + i);
                    }
                });
                var newli = $("<li></li>");
                $(newli).append($(divid1));
                $("#" + headerid).val(newli.html());
            }


        }
        this.attr("placeholder", "Select One");
        this.autocomplete({

            selectFirst: true,
            delay: 0,
            mustMatch: true,
            autoFocus: true,
            minLength: 0,
            html: true,
            appendTo: "#" + divid,
            source: jsonData,
            select: function (event, ui) {
                $("#" + inputid).val(ui.item.PKID);
                ctrlid.val(ui.item.label1);


                return false;
            },
            change: function (event, ui) {

                $(this).val((ui.item ? ui.item.label1 : ""));
                $("#" + inputid).val((ui.item ? ui.item.PKID : ""));

            },
            focus: function (event, ui) { event.preventDefault(); },
            open: function () {

                if (HeaderCol != null) {

                    $('ul.ui-autocomplete').prepend(HeaderCol);
                }

            }
        }).on('focus', function () { $(this).keydown(); });


    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return this;
};
$.fn.GenexAutoCompleteWithCallBack = function (jsonData,callback,MustFound,HeaderCol) {

    try {
      
        var ctrlid = this;
        var ctrlID1 = this.attr("id");
       
        var divid = this.attr("id") + "_divid";
        var inputid = this.attr("id") + "_hidid";
        var headerid = this.attr("id") + "_hidHeader";
        if ($("#" + inputid).length == 0) {
            this.parent().append('<input id="' + inputid + '" type="hidden" value="" />');
        }
        if ($("#" + headerid).length == 0) {
            this.parent().append('<input id="' + headerid + '" type="hidden" value="" />');
        }
        if ($("#" + divid).length == 0) {
            $('<div id="' + divid + '" class="parentautocomplete" />').insertAfter(this);
        }
        if (HeaderCol != null) {
            if (jsonData.length > 0) {
                var newdiv = jsonData[0].label;
                var divid1 = $(newdiv);
                var arrcol = HeaderCol.split(',');
                $(divid1).each(function (i, div) {
                    if (i < arrcol.length) {
                        $(div).html(arrcol[i]);
                    }
                    else {
                        $(div).html("Column" + i);
                    }
                });
                var newli = $("<li></li>");
                $(newli).append($(divid1));
                $("#" + headerid).val(newli.html());
            }


        }
        this.attr("placeholder", "Select One");
        this.autocomplete({

            selectFirst: true,
            delay: 0,
            mustMatch: false,
            autoFocus: true,
            minLength: 0,
            html: true,
            appendTo: "#" + divid,
            source: jsonData,            
            select: function (event, ui) {
                $("#" + inputid).val(ui.item.PKID);
                ctrlid.val(ui.item.label1);
                //callback(ui.item, ctrlID1);

                return false;
            },
            change: function (event, ui) {
                if (MustFound == null || MustFound == 0) {

                }
                else {
                    $(this).val((ui.item ? ui.item.label1 : ""));
                }              

                $("#" + inputid).val((ui.item ? ui.item.PKID : ""));

                callback(ui.item, ctrlID1);

            },
            
            focus: function (event, ui) { event.preventDefault(); }
        }).on('focus', function () { $(this).keydown(); });

       
    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return this;
}

$.fn.GenexAutoCompleteBlank = function () {

    try {
        var ctrlid = this;      
        var inputid = this.attr("id") + "_hidid";
        this.val("");
        if ($("#" + inputid).length > 0) {
            $("#" + inputid).val("");
        }
       

    }
    catch (e) {
        console.log(e);
    }
  
    return this;
}

$.fn.GenexAutoCompleteSet = function (id,val) {

    try {
        var ctrlid = this;
        var inputid = this.attr("id") + "_hidid";
        this.val(val);
        $("#" + inputid).val(id);

    }
    catch (e) {
        console.log(e);
    }

    return this;
}
$.fn.GenexAutoCompleteSetByVal = function (id,jsonarr) {

    try {
        var ctrlid = this;
        var val = "";
        var inputid = this.attr("id") + "_hidid";
        $("#" + inputid).val(id);
        for (var i = 0; i < jsonarr.length; i++) {
            if (jsonarr[i].PKID == id) {
                val = jsonarr[i].label1;
                this.val(val);
                return;
            }
        }      

    }
    catch (e) {
        console.log(e);
    }

    return this;
}
$.fn.GenexAutoCompleteGet = function (defval) {
    
    try {
       
        var inputid = this.attr("id") + "_hidid";
        if ($("#" + inputid).length > 0) {
            if ($("#" + inputid).val() != "") {
                defval = $("#" + inputid).val();
            }
        }
       

    }
    catch (e) {
        console.log(e);
    }

    return defval;
}
$.fn.GenexMultiSelect = function (jsonData) {

    try {
        var str = '';
       
        var id = this.attr("id");
        var thisctrl = this;
        var containerid = id + '_container';
        var searchid = id + '_search';
        this.children().remove();      
        if (jsonData.length > 0) {           

            for (var i = 0; i < jsonData.length; i++) {

                //str += '<li><label class="checkbox">' + jsonData[i].label1 + '<input data-name="' + jsonData[i].label1 +'" type="checkbox" value="' + jsonData[i].PKID + '" /> <span class="checkmark"></span></label> ';   
                //str += '</li>';

                str += '<li><div class="form-check"><input id="' + containerid + 'chk' + jsonData[i].PKID + '" data-name="' + jsonData[i].label1 + '" type="checkbox" value="' + jsonData[i].PKID + '" class="form-check-input"><label class="form-check-label checkbox" for="' + containerid + 'chk' + jsonData[i].PKID + '">' + jsonData[i].label1 + '</label></div></li>';
            }

            
        }
        if ($("#" + containerid).length == 0) {
            var strcontainer = '<div id="' + containerid + '" class="dropdown-menu genex-multiselect-container" aria-labelledby="' + id + '"><input type="text" class="form-control" id="' + searchid + '" placeholder="Find in list"/></div>';
            $(strcontainer).insertAfter(this);
            str = '<ul>' + str + '</ul>';  
            $("#" + containerid).append(str);
        }
        else {
            $("#" + containerid).find("ul").empty();
            $("#" + containerid).find("ul").append(str);
        }

       
        this.attr("data-bs-toggle", "dropdown");
        this.attr("aria-haspopup", "true");
        this.attr("aria-expanded", "false");
        this.addClass("form-control");  
        this.addClass("genex-multiselect-box");   
        $('body').on('click', "#" + containerid, function (e) {
            e.stopPropagation();
           

        }); 
        $('body').on('click', "#" + containerid + " ul input", function (e) {
          
            e.stopImmediatePropagation();
            var val = $(this).val();
            var name = $(this).attr("data-name");            
            var IsChecked = $(this).is(':checked');
            if (!IsChecked) {
                thisctrl.find('span').each(function () {

                    var strtext = $(this).attr("data-val");
                    if (strtext == val) {
                        $(this).remove();
                    }
                });
            }
            else {
                var elespan = '<span data-val="' + val + '"><label>' + name + '</label><i class="fa  fa-trash"></i></span>';
                thisctrl.append(elespan);
               
            }

        }); 
        thisctrl.on('click', "i", function (e) {
            e.stopImmediatePropagation();
            var strtext = $(this).parent().attr("data-val");
            $(this).parent().remove();
            $("#" + containerid).find('input').each(function () {
                var val = $(this).val();
               
                if (strtext == val) {

                    $(this).prop('checked', false);
                }
            });
           
        }); 

        $("#" + searchid).on("keyup", function (e) {
            e.stopImmediatePropagation();
            var textval = $(this).val();
            if (textval == "") {
                $("#" + containerid).find("li").show();
            }
            else {
                textval = textval.toUpperCase();
                $("#" + containerid).find("li").each(function () {

                    var strtext = $(this).text().toUpperCase();
                    if (strtext.indexOf(textval) < 0) {
                        $(this).hide();
                    }
                });
            }

        });
       
        return this;
    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return this;
}
$.fn.GenexMultiSelectGet = function () {
    var str = '';
    try {
        this.find('span').each(function () {

            var strtext = $(this).attr("data-val");
            str = str + strtext + ',';
        });

        if (str.length > 0) {
            str = str.replace(/,\s*$/, "");
        }

    }
    catch (e) {
        console.log(e);
    }

    return str;
}
$.fn.GenexMultiSelectSetStr = function (SelectedStr) {

    try {
       
        var id = this.attr("id");
        var thisctrl = this;
        this.children().remove();
        var containerid = id + '_container';
        $("#" + containerid).find("ul").find('input').prop("checked", false);
        var arr = SelectedStr.split(',');
        if (arr.length > 0) {
            for (var i = 0; i < arr.length; i++) {
                if ($("#" + containerid).find("input[value='" + arr[i] + "'][type='checkbox']").length) {
                    var ctrl = $("#" + containerid).find("input[value='" + arr[i] + "'][type='checkbox']")
                    var val = ctrl.val();
                    var name = ctrl.attr["data-name"];
                    $("#" + containerid).find("input[value='" + arr[i] + "'][type='checkbox']").prop("checked", true);
                    //var elespan = '<span data-val="' + val + '"><label>' + name + '</label><i class="fa  fa-trash"></i></span>';
                    //thisctrl.append(elespan);
                }
               
            }


            $("#" + containerid).find("ul").find('input').each(function () {
                var val = $(this).val();
                var name = $(this).attr("data-name");
                var IsChecked = $(this).is(':checked');
                if (IsChecked) {
                    var elespan = '<span data-val="' + val + '"><label>' + name + '</label><i class="fa  fa-trash"></i></span>';
                    thisctrl.append(elespan);
                }
               
            });

           
        }
      
    }
    catch (e) {
        console.log(e);
    }
    // return value   

    return this;
}