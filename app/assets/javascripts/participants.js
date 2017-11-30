$(document).on("turbolinks:load", function () {
    if ($(".participants.boq").length === 0) return;

    let boq;
    boq = new App.Boq(gon.boq);
    return boq.render('rate_filling');
});

$(document).on("turbolinks:load", function () {
    if ($(".participants.show_boq").length === 0) return;

    let boq;
    boq = new App.Boq(gon.boq);
    return boq.render('tag_editing');
});