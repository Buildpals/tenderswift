App.Boq = (function() {
    function Boq(boqData) {
        this.boqData = boqData;
    }

    let viewType;

    Boq.prototype.render = function(_viewType) {
        viewType = _viewType;
        renderSpreadSheet(this.boqData, viewType);
    };

    Boq.prototype.renderSpreadSheet = renderSpreadSheet;

    function renderSpreadSheet(boqData, viewType) {
        boqData.pages.forEach(function (page) {

            let data = [];
            let sectionHeaders = [];
            buildSheetData(page, sectionHeaders, data);

            let container = document.getElementById('sheet-' + page.id);

            let colHeaders, columns, colWidths, contextMenu;
            if (viewType === 'tag_editing') {
                contextMenu = ['undo', 'redo', 'cut', 'copy'];
                colHeaders = ['Item', 'Description', 'Quantity', 'Unit', 'Rate', 'Amount'];
                columns = [
                    {
                        data: 'name',
                        renderer: labelRenderer,
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
                ];
                colWidths = [50, 300, 42, 42, 50, 50];
            } else if (viewType === 'rate_filling') {
                contextMenu = ['undo', 'redo', 'cut', 'copy'];
                colHeaders = ['Item', 'Description', 'Quantity', 'Unit', 'Rate', 'Amount'];
                columns = [
                    {
                        data: 'name',
                        renderer: labelRenderer,
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
                ];
                colWidths = [50, 300, 42, 42, 50, 50];
            } else {
                contextMenu = ['row_above', 'row_below', 'remove_row', 'undo', 'redo', 'cut', 'copy'];
                colHeaders = ['Item', 'Description', 'Quantity', 'Unit', 'Rate', 'Amount'];
                columns = [
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
                    },
                    {
                        data: 'unit'
                    },
                    {
                        data: 'rate'
                    },
                    {
                        data: 'amount',
                        readOnly: true
                    }
                ];
                colWidths = [50, 300, 42, 42, 50, 50];
            }

            let hot = new Handsontable(container, {
                data: data,
                cell: sectionHeaders,
                mergeCells: sectionHeaders,
                colHeaders: colHeaders,
                className: "htCenter",
                columns: columns,
                dataSchema: {
                    "id": null,
                    "item_type": "item",
                    "name": null,
                    "description": null,
                    "quantity": null,
                    "unit": null,
                    "page_id": page.id,
                    "boq_id": gon.boq.id,
                    "priority": null
                },
                colWidths: colWidths,
                // rowHeaders: true,
                stretchH: 'all',
                manualColumnResize: true,
                manualRowResize: true,
                // persistentState: true,
                // manualColumnMove: true,
                // manualRowMove: true,
                // minSpareRows: 1,
                formulas: true,
                contextMenu: contextMenu,
                beforeRemoveRow: function(index, numRowsToBeRemoved, visualRows) {
                    visualRows.forEach(function (visualIndex) {
                        let item = data[visualIndex];
                        console.log("Deleting", item);
                        deleteItem(item)
                            .done(function (response) {
                                console.log("Deleted", item);
                            });
                    });
                },
                afterCreateRow: function(index, numNewlyCreatedRows, source) {
                    for (row = index; row < index + numNewlyCreatedRows; row++) {
                        let item = data[row];
                        let previous_priority = data[row-1].priority;
                        let next_priority = data[row+1].priority;
                        let current_priority = (previous_priority + next_priority) / 2;
                        item.priority = current_priority;
                        console.log("Creating item", item);
                        createItem(item)
                            .done(function (createdItem) {
                                console.log("Created", createdItem);
                                data[row] = createdItem;
                                hot.render();
                            })
                    }
                },
                afterChange: function(changes, source) {
                    $.each(changes, function (index, change) {
                        let row = change[0];
                        let col = change[1];
                        let oldVal = change[2];
                        let newVal = change[3];
                        let item = data[row];

                        if (viewType === 'rate_filling') {
                            saveFilledItem(item.filled_item)
                                .done(function (updatedFilledItem) {
                                    console.log("Updated", updatedFilledItem);
                                    data[row].filled_item = updatedFilledItem;
                                    hot.render();
                                });
                        } else {
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
    }

    function buildSheetData(page, customCells, data) {
        page.items.forEach(function  (item, index) {
            if (item.item_type === 'header') {
                customCells.push({row: data.length, col: 1, rowspan: 1, colspan: 1, renderer: sectionRenderer});
                customCells.push({row: data.length, col: 0, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 2, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 3, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 4, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 5, rowspan: 1, colspan: 1, readOnly: true});
                data.push(item);
            } else {
                let rowNum = index + 1;
                let quantityCell = "C" + rowNum;
                let rateCell = "E" + rowNum;
                data.push(
                    {
                        boq_id: item.boq_id,
                        description: item.description,
                        filled_item: item.filled_item,
                        id: item.id,
                        item_type: item.item_type,
                        name: item.name,
                        page_id: item.page_id,
                        priority: item.priority,
                        quantity: item.quantity,
                        unit: item.unit,
                        amount: "=" + quantityCell + "*" + rateCell
                    }
                );
            }
        });
    }


    function sectionRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.setAttribute('style', 'height: 2em !important; font-size: 1.1em; font-weight: bold; vertical-align: bottom; text-align: center');
    }

    function labelRenderer(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.fontWeight = "bold";
    }


    function createItem(item) {
        let url = '/items.json';
        let method = 'POST';

        return $.ajax({
            url: url,
            method: method,
            data: { item: item }
        })
    }

    function updateItem(item) {
        let url = '/items/' + item.id + '.json';
        let method = 'PUT';

        return $.ajax({
            url: url,
            method: method,
            data: { item: item }
        });
    }

    function deleteItem(item) {
        let url = '/items/' + item.id + '.json';
        let method = 'DELETE';

        return $.ajax({
            url: url,
            method: method
        });
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
        });
    }

    return Boq;
})();


$(document).on("turbolinks:load", function () {
    if ($(".create_tender.edit_tender_boq, .request_for_tenders.preview").length === 0) return;

    let boq;
    boq = new App.Boq(gon.boq);
    return boq.render();
});

$(document).on("turbolinks:load", function () {
    if ($(".request_for_tenders.show").length === 0) return;

    let boq;
    boq = new App.Boq(gon.boq);
    return boq.render();
});