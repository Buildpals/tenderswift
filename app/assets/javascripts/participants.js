$(document).on("turbolinks:load", function () {
    if ($(".participants.show_boq, .participants.show").length === 0) return;

    let boq;
    boq = new App.Boq(gon.boq);
    return boq.render('rate_filling');
});