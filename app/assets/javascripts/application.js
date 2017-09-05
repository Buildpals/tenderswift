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
    // td.innerHTML = '<div class="col-md-10 mx-auto">' + value + '</div>';
    td.style.fontWeight = "bold";
    td.style.fontSize = "1.1em";
    td.style.textAlign = 'left';
}


function tagRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.style.textAlign = 'center';
    let tags = value;
    td.innerHTML = tags.map(function (tag) {
        return tag.name;
    }).join(',');
}

function labelRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.style.fontWeight = "bold";
    td.style.textAlign = 'center';
}

function buildSheetData(page, sectionHeaders, data) {
    page.items.forEach(function  (item) {
        if (item.item_type === 'header') {
            data.push({ readOnly: true });
            sectionHeaders.push({row: data.length, col: 2, rowspan: 1, colspan: 1, renderer: sectionRenderer});
            data.push({ description: item.name });
        } else {
            data.push(item);
        }
    });
}

function saveItem(item, row, page, boq) {
    let url = '/items.json';
    let method = 'POST';

    if (item.id) {
        url = '/items/' + item.id + '.json';
        method = 'PUT';
    } else {
        item.item_type = 'item';
        item.page_id = page.id;
        item.boq_id = boq.id;
    }

    return $.ajax({
        url: url,
        method: method,
        data: { item: item, tags_string: item.tags }
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
