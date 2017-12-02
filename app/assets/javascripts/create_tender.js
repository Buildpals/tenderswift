function showLoadingIndicator() {
    $('.loading-indicator').removeClass('hidden')
    $('.saved-indicator').addClass('hidden')
    $('.next-button').addClass('disabled')
}

function hideLoadingIndicator() {
    $('.loading-indicator').addClass('hidden')
    $('.saved-indicator').removeClass('hidden')
    $('.next-button').removeClass('disabled')
}

$(document).on("turbolinks:load", function () {
    if ($(".create_tender").length === 0) return;

    autosize($('textarea'));

    $('[data-save-on-change]').change(function () {
        showLoadingIndicator();
        $('#request-form').trigger('submit.rails');
    });

    $('[data-save-on-click]').click(function () {
        showLoadingIndicator();

        setTimeout( function(){
            $('#request-form').trigger('submit.rails');
        }, 500 );
    });

    $('.nested-forms').on('cocoon:before-insert', function(e, insertedItem) {
        console.log("item inserted");

        $(insertedItem).find('[data-save-on-change]').change(function () {
            showLoadingIndicator();
            $('#request-form').trigger('submit.rails');
        });
    });
});



$(document).on("turbolinks:load", function () {
    if ($(".create_tender.edit_tender_boq").length === 0) return;

    let boq = new App.Boq();
    let itemsEditingSettings = {
        contextMenu: ['row_above', 'row_below', 'remove_row', 'undo', 'redo', 'cut', 'copy'],
        columns: [
            {
                data: 'name',
                renderer: boq.labelRenderer
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
        ],
        editRates: true
    };
    boq.render(gon.boq, itemsEditingSettings);
});