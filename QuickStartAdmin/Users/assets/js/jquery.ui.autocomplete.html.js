/*
 * jQuery UI Autocomplete HTML Extension
 *
 * Copyright 2010, Scott González (http://scottgonzalez.com)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 *
 * http://github.com/scottgonzalez/jquery-ui-extensions
 */
(function( $ ) {

var proto = $.ui.autocomplete.prototype,
	initSource = proto._initSource;

function filter( array, term ) {
	var matcher = new RegExp( $.ui.autocomplete.escapeRegex(term), "i" );
	return $.grep( array, function(value) {
		return matcher.test( $( "<div>" ).html( value.label || value.value || value ).text() );
	});
}


$.extend( proto, {
	_initSource: function() {
		if ( this.options.html && $.isArray(this.options.source) ) {
			this.source = function( request, response ) {
				response( filter( this.options.source, request.term ) );
			};
		} else {
			initSource.call( this );
		}
	},

    _renderItem: function (ul, item) {
       
       
		return $( "<li></li>" )
			.data( "item.autocomplete", item )
			.append( $( "<a></a>" )[ this.options.html ? "html" : "text" ]( item.label ) )
            .appendTo(ul);

    },
    _renderMenu: function (ul, items) {
        var that = this;
        var DivID = that.menu.element.parent().attr("id");
        DivID = DivID.replace("_divid", "");
        var strheader = $("#" + DivID + "_hidHeader").val();
        $.each(items, function (index, item) {
            that._renderItemData(ul, item);
            if (index == 0) {
                if (strheader != "") {
                    ul.prepend('<li class="header-auto">' + strheader + '</li>')
                }
            }
        });
       
    },   
    _resizeMenu: function () {
        var ul = this.menu.element;

        var BodyWidth = $(document).width() - 30;
        if ($(".main-content").length) {
            BodyWidth = $(".main-content").width();
        }
        var DivID = ul.parent().attr("id");     

        DivID = DivID.replace("_divid", "");
       
       
        var InputCtrl = $("#" + DivID);       

        var InputX = $(InputCtrl).position().left;
        var InputY = $(InputCtrl).position().top + $(InputCtrl).height();
        InputY = InputY + 2;

        var InputW = $(InputCtrl).width();
        var RemainingWidth = BodyWidth - InputX;

        if (RemainingWidth < 400) {
            RemainingWidth = (InputX) + InputW;
            InputX = BodyWidth-(InputX + InputW);
        }
        

        if ((BodyWidth - InputX) < 400) {
            ul.css("left", InputX);
            ul.css("top", InputY);
        }
        else {
            ul.css("left", InputX);
            ul.css("top", InputY);
        }
        ul.outerWidth(RemainingWidth);

        
    }
});

})( jQuery );
