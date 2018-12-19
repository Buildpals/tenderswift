$(document).on('turbolinks:load', function () {
  if ($('.build').length === 0) return

  autosize($('textarea'))

  $('#request-form').areYouSure({
    'softPageUnloadEvent': 'turbolinks:before-visit',
    'addRemoveFieldsMarksDirty': true
  })

  // Enable save button only if the form is dirty - using events.
  $('#request-form').bind('dirty.areYouSure', function () {
    $(this).find('input[type="submit"]').attr({ 'disabled': false });
  })
  $('#request-form').bind('clean.areYouSure', function () {
    //$(this).find('input[type="submit"]').attr({ 'disabled': true });
  })

  $('.nested-forms').on('cocoon:after-insert', function (e, insertedItem) {
    $('#request-form').trigger('rescan.areYouSure');
  })

  $('.nested-forms').on('cocoon:after-remove', function (e, insertedItem) {
    $('#request-form').trigger('rescan.areYouSure');
  })

  if ($('.sample').text() == 'true') {
    introJs().setOptions({
      exitOnOverlayClick: false
    }).start()
  }
})