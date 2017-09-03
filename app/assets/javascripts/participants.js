function sectionRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.style.fontWeight = "bold";
    td.style.fontSize = "1.1em";
    td.style.textAlign = 'left';
}

function saveFilledItem(filledItem) {
    let url = '/filled_items.json';
    let method = 'POST';

    if (filledItem.id) {
        url = '/filled_items/' + filledItem.id + '.json';
        method = 'PUT';
    }

    return $.ajax({
        url: url,
        method: method,
        data: { filled_item:  filledItem }
        })
        .done(function (data) {
            console.log("Saved filledItem", data);
        }).fail(function (error) {
            console.error('Error saving filledItem', error);
        });
}

$(document).on("turbolinks:load", function () {
    if ($(".participants.show_boq").length === 0) return;

    gon.boq.pages.forEach(function (page) {

        let data = [];
        let sectionHeaders = [];
        page.sections.forEach(function (section) {
            sectionHeaders.push({row: data.length, col: 0, rowspan: 1, colspan: 6, renderer: sectionRenderer});
            data.push(section);
            section.items.forEach(function (item) {
                data.push(item);
            });
        });


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
                    data: 'filled_item.amount',
                    readOnly: true
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
            afterRemoveRow: function (index, amount) {
                console.log('index', index);
                console.log('amount', amount);
                let endpoint = index + amount;
                for (index; index < endpoint; index++) {
                    console.log(data[index]);
                }
            },
            afterChange: function (changes, source) {
                console.log("Saving...");
                $.each(changes, function (index, change) {
                    let row = change[0];
                    let col = change[1];
                    let oldVal = change[2];
                    let newVal = change[3];
                    let filledItem = data[row].filled_item;
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