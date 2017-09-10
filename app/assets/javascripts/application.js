// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require autosize
//= require moment
//= require cocoon
//= require handsontable.full
//= require Chart
//= require_tree .


function sectionRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.setAttribute('style', 'height: 2em !important; font-size: 1.1em; font-weight: bold; vertical-align: bottom; text-align: center');
}

function labelRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.style.fontWeight = "bold";
}

function buildSheetData(page, sectionHeaders, data) {
    page.items.forEach(function  (item) {
        if (item.item_type === 'header') {
            sectionHeaders.push({row: data.length, col: 2, rowspan: 1, colspan: 1, renderer: sectionRenderer});
            sectionHeaders.push({row: data.length, col: 0, rowspan: 1, colspan: 1, readOnly: true});
            sectionHeaders.push({row: data.length, col: 1, rowspan: 1, colspan: 1, readOnly: true});
            sectionHeaders.push({row: data.length, col: 3, rowspan: 1, colspan: 1, readOnly: true});
            sectionHeaders.push({row: data.length, col: 4, rowspan: 1, colspan: 1, readOnly: true});
            data.push(item);
        } else {
            data.push(item);
        }
    });
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
