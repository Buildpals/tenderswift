$(document).on("turbolinks:load", function () {
    if ($(".bids.boq").length === 0) return;

    let boq = new App.Boq();
    let bidReviewSettings = {
        contextMenu: ['undo', 'redo', 'cut', 'copy'],
        columns: [
            {
                data: 'name',
                renderer: boq.labelRenderer,
                readOnly: true
            },
            {
                data: 'description',
                className: 'htLeft',
                readOnly: true
            },
            {
                data: 'quantity',
                readOnly: true
            },
            {
                data: 'unit',
                readOnly: true
            },
            {
                data: 'filled_item.rate',
                readOnly: true
            },
            {
                data: 'amount',
                readOnly: true
            }
        ]
    };
    boq.render(gon.boq, bidReviewSettings);
});