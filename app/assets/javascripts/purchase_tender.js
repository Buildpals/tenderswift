$(document).on('turbolinks:load', function () {
  $('#purchase-form').on('ajax:success', function (event) {
    disablePurchaseButton(event.target)
  }).on('ajax:error', function (event) {
    [data, status, xhr] = event.detail
    console.log(event)
    $('#purchase-form').append('<p>ERROR<p>')
  })

  function disablePurchaseButton (target) {
    // Use setTimeout to prevent race-condition when Rails re-enables the button
    setTimeout(function () {
      Rails.disableElement(target)

      $('#make_purchase_button')
        .html('<i class=\'fa fa-spinner fa-spin\'></i> Please confirm' +
          ' the purchase on your phone...')
    }, 0)
  }
})