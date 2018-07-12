$(document).on('turbolinks:load', function () {
  $('#network_code')
    .change(function () {
      console.log($(this).val() === 'VOD')
      if ($(this).val() === 'VOD') {
        showVoucherCode()
      } else {
        hideVoucherCode()
      }
    })

  $('#purchase-form')
    .on('ajax:before', function () {
      showPurchaseInProgress('Sending purchase request...')
    })
    .on('ajax:error', function (event) {
      // Network error making the request
      // Or Internal Server error on ds02_server
      showPurchaseError('Sorry, something went wrong')
    })
})

function showVoucherCode () {
  $('#voucher-field-group').removeClass('d-none')
}

function hideVoucherCode () {
  $('#voucher-field-group').addClass('d-none')
}

function showPurchaseInProgress (loadingMessage) {
  console.log('showPurchaseInProgress', loadingMessage)

  $('#purchase-errors').html('').addClass('d-none')
  $('#purchaseFormClose').hide()

  let purchaseButton = document.getElementById('make_purchase_button')

  // Use setTimeout to prevent race-condition when Rails re-enables the button
  setTimeout(function () {
    purchaseButton.dataset.disableWith
        = '<i class=\'fa fa-spinner fa-spin\'></i> &nbsp;' + loadingMessage
    window.Rails.disableElement(purchaseButton)
  }, 10)
}

function showPurchaseError (errorMessage) {

  $('#purchase-errors').html(errorMessage).removeClass('d-none')
  $('#purchaseFormClose').show()

  let purchaseButton = document.getElementById('make_purchase_button')

  // Use setTimeout to prevent race-condition when Rails disables the button
  setTimeout(function () {
    window.Rails.enableElement(purchaseButton)
  }, 50)
}
