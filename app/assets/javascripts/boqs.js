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
                    data: "tag",
                    type: 'autocomplete',
                    source: function(query, process) {
                        let tagsSoFar = page.items
                            .filter(function (item) {
                                return item.tag;
                            })
                            .sort()
                            .map(function (item) {
                                return item.tag;
                            })
                            .filter(function(item, pos, array) {
                                return !pos || item !== array[pos - 1];
                            });
                        console.log('tagsSoFar', tagsSoFar);
                        process(tagsSoFar);
                    },
                    strict: false
                },
                {
                    data: 'name',
                    renderer: labelRenderer
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
            dataSchema: {
                "id": null,
                "item_type": "item",
                "name": null,
                "description": null,
                "quantity": null,
                "unit": null,
                "page_id": page.id,
                "boq_id": gon.id,
                "priority": null,
                "tag": null
            },
            colWidths: [80, 50, 300, 42, 42, 50, 50],
            rowHeaders: true,
            stretchH: 'all',
            manualColumnResize: true,
            manualRowResize: true,
            // persistentState: true,
            // manualColumnMove: true,
            manualRowMove: true,
            // minSpareRows: 1,
            contextMenu: ['row_above', 'row_below', 'remove_row', 'undo', 'redo', 'cut', 'copy'],
            beforeRemoveRow: function(index, amount, visualRows) {
                visualRows.forEach(function (visualIndex) {
                    let item = data[visualIndex];
                    console.log("Deleting", item);
                    deleteItem(item)
                        .done(function (response) {
                            console.log("Deleted", item);
                        });
                });
            },
            afterCreateRow: function(index, amount, source) {
                for (row = index; row < index + amount; row++) {
                    let item = data[row];
                    let previous_priority = data[row-1].priority;
                    let next_priority = data[row+1].priority;
                    let current_priority = (previous_priority + next_priority) / 2;
                    console.log("p", previous_priority, "n", next_priority, "c",  current_priority)
                    item.priority = current_priority;
                    console.log(item);
                    createItem(item)
                        .done(function (createdItem) {
                            console.log("Created", createdItem);
                            data[row] = createdItem;
                            hot.render();
                        })
                }
            },
            afterChange: function (changes, source) {
                console.log("Saving...");
                $.each(changes, function (index, change) {
                    let row = change[0];
                    let col = change[1];
                    let oldVal = change[2];
                    let newVal = change[3];
                    let item = data[row];
                    if (item.id) {
                        console.log(item);
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