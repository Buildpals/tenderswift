$(document).on('turbolinks:load', function () {
  if ($('.create_tender').length === 0) return

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
    $(this).find('input[type="submit"]').attr({ 'disabled': true });
  })

  $('.nested-forms').on('cocoon:after-insert', function (e, insertedItem) {
    $('#request-form').trigger('rescan.areYouSure');
  })

  $('.nested-forms').on('cocoon:after-remove', function (e, insertedItem) {
    $('#request-form').trigger('rescan.areYouSure');
  })
})

// $(document).on('turbolinks:load', function () {
//   if ($('.create_tender.edit_tender_boq').length === 0) return
//
//   let boq = new App.Boq()
//   let itemsEditingSettings = {
//     contextMenu: ['row_above', 'row_below', 'remove_row', 'undo', 'redo', 'cut', 'copy'],
//     columns: [
//       {
//         data: 'name',
//         renderer: boq.labelRenderer
//       },
//       {
//         data: 'description',
//         className: 'htLeft'
//       },
//       {
//         data: 'quantity',
//       },
//       {
//         data: 'unit'
//       },
//       {
//         data: 'rate'
//       },
//       {
//         data: 'amount',
//         readOnly: true
//       }
//     ],
//     editRates: true
//   }
//   boq.render(gon.boq, itemsEditingSettings)
// })