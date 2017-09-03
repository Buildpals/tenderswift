function sectionRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.style.fontWeight = "bold";
    td.style.fontSize = "1.1em";
    td.style.textAlign = 'left';
}


function saveItem(item) {
    let url = '/items.json';
    let method = 'POST';

    if (item.id) {
        url = '/items/' + item.id + '.json';
        method = 'PUT';
    }

    return $.ajax({
        url: url,
        method: method,
        data: { item: item }
    })
    .done(function (data) {
        console.log("Saved item", data);
    }).fail(function (error) {
        console.error('Error saving item', error);
    });
}

$(document).on("turbolinks:load", function () {
    if ($(".boqs.show").length === 0) return;


    gon.pages.forEach(function (page) {

        // let sectionHeaders = page.sections.map(function (section, index) {
        //     return {row: index, col: 1, renderer: greenRenderer}
        // });

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
                    data: 'rate',
                    readOnly: true
                },
                {
                    data: 'amount',
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
            afterRemoveRow: function(index, amount) {
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
                    let item = data[row];
                    console.log('section_id', data[row-1].section_id);
                    console.log('section_id', data[row+1].section_id);
                    if (data[row-1].section_id) {
                        item.section_id = data[row-1].section_id;
                    } else {
                        item.section_id = data[row+2].section_id;
                    }
                    console.log(item);
                    saveItem(item);
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