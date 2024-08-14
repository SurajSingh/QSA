(function ($) {

    $.fn.GenexTable = function (options) {

        // This is the easiest way to have default options.
        var settings = $.extend({
            TotalPage: 0,
            TotalRec: 0,
            PageSize: 50,
            PageNo:1
        }, options);

       
        return this;

    };

}(jQuery));