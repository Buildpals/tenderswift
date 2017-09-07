$(document).on("turbolinks:load", function () {
    if ($(".participants.show_boq").length === 0) return;

    gon.boq.pages.forEach(function (page) {

        let data = [];
        let sectionHeaders = [];
        buildSheetData(page, sectionHeaders, data);

        let container = document.getElementById('sheet-' + page.id);

        let hot = new Handsontable(container, {
            data: data,
            cell: sectionHeaders,
            mergeCells: sectionHeaders,
            colHeaders: ['Item', 'Description', 'Quantity', 'Unit', 'Rate', 'Amount'],
            className: "htCenter",
            columns: [
                {
                    data: 'name',
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
                    data: 'filled_item.amount'
                }
            ],
            colWidths: [60, 412, 80, 42, 80, 80],
            rowHeaders: true,
            // colHeaders: true,
            stretchH: 'all',
            manualColumnResize: true,
            manualRowResize: true,
            // persistentState: true,
            // manualColumnMove: true,
            manualRowMove: true,
            minSpareRows: 1,
            // contextMenu: ['row_above', 'row_below', 'remove_row', 'undo', 'redo', 'cut', 'copy'],
            afterChange: function (changes, source) {
                console.log("Saving...");
                $.each(changes, function (index, change) {
                    let row = change[0];
                    let col = change[1];
                    let oldVal = change[2];
                    let newVal = change[3];
                    let filledItem = data[row].filled_item;
                    filledItem.amount = data[row].quantity * filledItem.rate;
                    hot.render();
                    console.log(filledItem);
                    saveFilledItem(filledItem);
                });
            }
        });

        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            e.target // newly activated tab
            e.relatedTarget // previous active tab
            hot.render();
        });

    });


});