$(document).on("turbolinks:load", function () {
    if ($(".participants.boq").length === 0) return;

    let boq = new App.Boq();
    let rateFillingSettings = {
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
                data: 'filled_item.rate'
            },
            {
                data: 'amount',
                readOnly: true
            }
        ],
        editRates: true
    };
    boq.render(gon.boq, rateFillingSettings);
});