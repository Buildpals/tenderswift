window.App || (window.App = {});

App.init = function() {
    return $("a, span, i, div").tooltip();
};

$(document).on("turbolinks:load", function() {
    return App.init();
});