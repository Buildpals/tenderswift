$(document).on("turbolinks:load", function () {
    if ($(".boqs.show").length === 0) return;


    gon.pages.forEach(function (page) {

        let data = [];
        let sectionHeaders = [];
        buildSheetData(page, sectionHeaders, data);

        let container = document.getElementById('sheet-' + page.id);

        let hot = new Handsontable(container, {
            data: data,
            cell: sectionHeaders,
            mergeCells: sectionHeaders,
            colHeaders: ['Tag', 'Item', 'Description', 'Quantity', 'Unit', 'Rate', 'Amount'],
            className: "htCenter",
            columns: [
                {
                    data: "tag"
                },
                {
                    data: 'name',
                },
                {
                    data: 'description',
                    className: 'htLeft'
                },
                {
                    data: 'quantity',
                    type: 'numeric'
                },
                {
                    data: 'unit'
                },
                {
                    data: 'rate',
                    readOnly: true
                },
                {
                    data: 'amount',
                    readOnly: true
                }
            ],
            // dataSchema: {id: null, name: {first: null, last: null}, address: null},
            dataSchema: {
                "id": null,
                "item_type": "item",
                "name": null,
                "description": null,
                "quantity": null,
                "unit": null,
                "page_id": null,
                "tag": null
            },
            colWidths: [80, 50, 450, 80, 42, 42, 50],
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
            // afterRemoveRow: function(index, amount) {
            //     console.log('index', index);
            //     console.log('amount', amount);
            //     let endpoint = index + amount;
            //     for (index; index < endpoint; index++) {
            //         console.log(data[index]);
            //     }
            // },
            afterChange: function (changes, source) {
                console.log("Saving...");
                $.each(changes, function (index, change) {
                    let row = change[0];
                    let col = change[1];
                    let oldVal = change[2];
                    let newVal = change[3];
                    let item = data[row];
                    console.log(item);
                    if (item.id) {
                        updateItem(item)
                            .done(function (updatedItem) {
                                console.log("Updated", updatedItem);
                                data[row] = updatedItem;
                                hot.render();
                            });
                    }
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