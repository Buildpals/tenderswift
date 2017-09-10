$(document).on("turbolinks:load", function () {
    if ($(".boqs.show").length === 0) return;


    let ctx = document.getElementById('myChart').getContext('2d');
    var chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'doughnut',

        // The data for our dataset
        data: {
            labels: Object.keys(getBreakDown()),
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
                data: Object.values(getBreakDown()),
            }]
        },

        // Configuration options go here
        options: {}
    });

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
                console.log(getBreakDown());

                clearChartData(chart);

                let tagsHash = getBreakDown();
                Object.keys(tagsHash).forEach(function (tag) {
                    addData(chart, tag, tagsHash[tag]);
                });

                console.log(chart.data);
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