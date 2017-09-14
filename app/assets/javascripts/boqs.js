App.Boq = (function() {
    function Boq(boqData) {
        this.boqData = boqData;
    }

    let chart;
    let tagsHash =  {};
    let viewType;

    Boq.prototype.render = function(_viewType) {
        viewType = _viewType;
        renderChart();
        renderSpreadSheet(this.boqData, viewType);
    };

    Boq.prototype.renderSpreadSheet = renderSpreadSheet;

    Boq.prototype.renderChart = renderChart;

    function renderChart() {
        let chartDiv = document.getElementById('myChart');
        if (chartDiv) {
            let ctx = chartDiv.getContext('2d');

            let tagsHash = getBreakDown();
            chart = new Chart(ctx, {
                // The type of chart we want to create
                type: 'doughnut',

                // The data for our dataset
                data: {
                    labels: Object.keys(tagsHash),
                    datasets: [{
                        label: "My First dataset",
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',
                            'rgba(54, 162, 235, 0.2)',
                            'rgba(255, 206, 86, 0.2)',
                            'rgba(75, 192, 192, 0.2)',
                            'rgba(153, 102, 255, 0.2)',
                            'rgba(255, 159, 64, 0.2)'
                        ],
                        borderColor: [
                            'rgba(255,99,132,1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)'
                        ],
                        borderWidth: 1,
                        data: Object.values(tagsHash),
                    }]
                },

                // Configuration options go here
                options: {}
            });
        }
    }



    function renderSpreadSheet(boqData, viewType) {
        boqData.pages.forEach(function (page) {

            let data = [];
            let sectionHeaders = [];
            buildSheetData(page, sectionHeaders, data);

            let container = document.getElementById('sheet-' + page.id);

            let colHeaders, columns, colWidths;
            if (viewType === 'tag_editing') {
                colHeaders = ['Tag', 'Item', 'Description', 'Quantity', 'Unit', 'Rate', 'Amount'];
                columns = [
                    {
                        data: "tag",
                        // type: 'autocomplete',
                        // source: function(query, process) {
                        //     process(Object.keys(getBreakDown()));
                        // },
                        // strict: false
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
                        type: 'numeric',
                        readOnly: true
                    },
                    {
                        data: 'amount',
                        type: 'numeric',
                        readOnly: true
                    }
                ];
                colWidths = [80, 50, 300, 42, 42, 50, 50];
            } else if (viewType === 'rate_filling') {
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
                        type: 'numeric',
                        readOnly: true
                    },
                    {
                        data: 'unit',
                        readOnly: true
                    },
                    {
                        data: 'filled_item.rate',
                        type: 'numeric'
                    },
                    {
                        data: 'filled_item.amount',
                        type: 'numeric'
                    }
                ];
                colWidths = [50, 300, 42, 42, 50, 50];
            } else {
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
                        type: 'numeric'
                    },
                    {
                        data: 'unit'
                    },
                    {
                        data: 'rate',
                        type: 'numeric',
                        readOnly: true
                    },
                    {
                        data: 'amount',
                        type: 'numeric',
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
                    "priority": null,
                    "tag": null
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

                        if (chart) {
                            clearChartData(chart);

                            let tagsHash = getBreakDown();
                            Object.keys(tagsHash).forEach(function (tag) {
                                addData(chart, tag, tagsHash[tag]);
                            });
                        }

                        if (viewType === 'rate_filling') {
                            if (item.filled_item.rate) {
                                item.filled_item.amount = item.quantity * item.filled_item.rate;
                            }
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



    function getBreakDown(){
        gon.boq.pages.forEach(function (page) {
            page.items.forEach(function (item) {
                if (item.item_type === 'item') {
                    if (item.tag) {
                        tagsHash[item.tag] = tagsHash[item.tag] === undefined ? item.quantity : tagsHash[item.tag] + item.quantity;
                    } else {
                        let quantity = item.quantity;
                        if (!quantity) quantity = 0;
                        tagsHash["Others"] = tagsHash["Others"] === undefined ? quantity : tagsHash["Others"] + quantity;
                    }
                }
            })
        });
        return tagsHash;
    }

    function addData(chart, label, data) {
        chart.data.labels.push(label);
        chart.data.datasets.forEach((dataset) => {
            dataset.data.push(data);
        });
        chart.update(0);
    }

    function clearChartData(chart) {
        chart.data.labels.length = 0;
        chart.data.datasets.forEach((dataset) => {
            dataset.data.length = 0;
        });
        chart.update(0);
    }



    function buildSheetData(page, customCells, data) {
        page.items.forEach(function  (item) {
            if (item.item_type === 'header') {
                customCells.push({row: data.length, col: 1, rowspan: 1, colspan: 1, renderer: sectionRenderer});
                customCells.push({row: data.length, col: 0, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 2, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 3, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 4, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 5, rowspan: 1, colspan: 1, readOnly: true});
                data.push(item);
            } else {
                data.push(item);
            }
        });
    }

    function buildSheetDataWithTagging(page, customCells, data) {
        page.items.forEach(function  (item) {
            if (item.item_type === 'header') {
                customCells.push({row: data.length, col: 2, rowspan: 1, colspan: 1, renderer: sectionRenderer});
                customCells.push({row: data.length, col: 0, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 1, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 3, rowspan: 1, colspan: 1, readOnly: true});
                customCells.push({row: data.length, col: 4, rowspan: 1, colspan: 1, readOnly: true});
                data.push(item);
            } else {
                customCells.push({
                    row: data.length, col: 0,
                    type: 'autocomplete',
                    source: function(query, process) {
                        process(Object.keys(getBreakDown()));
                    },
                    strict: false
                });
                data.push(item);
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
    if ($(".request_for_tenders.edit").length === 0) return;

    let boq;
    boq = new App.Boq(gon.boq);
    return boq.render();
});

$(document).on("turbolinks:load", function () {
    if ($(".request_for_tenders.show").length === 0) return;

    let boq;
    boq = new App.Boq(gon.boq);
    return boq.renderChart();
});