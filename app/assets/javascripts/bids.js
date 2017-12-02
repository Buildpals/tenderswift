$(document).on("turbolinks:load", function () {
    if ($(".bids.boq").length === 0) return;

    let boq;
    boq = new App.Boq(gon.boq);
    return boq.render('tag_editing');
});