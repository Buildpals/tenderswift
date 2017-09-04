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
    td.innerHTML = '<div class="col-md-10 mx-auto">' + value + '</div>';
    td.style.fontWeight = "bold";
    td.style.fontSize = "1.1em";
    td.style.textAlign = 'left';
}

function labelRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.style.fontWeight = "bold";
    td.style.textAlign = 'center';
}

function buildSheetData(page, sectionHeaders, data) {
    page.sections.forEach(function (section) {
        sectionHeaders.push({row: data.length, col: 0, rowspan: 1, colspan: 6, renderer: sectionRenderer});
        data.push({id: section.id, name: section.name});
        data.push({readOnly: true});
        section.items.forEach(function (item) {
            data.push(item);
            data.push({readOnly: true});
        });
    });
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

