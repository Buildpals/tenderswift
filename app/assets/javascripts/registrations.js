$(document).on('turbolinks:load', function () {
  let pagesToRunOn =
    $('.registrations.new, .publishers.edit, .contractors.edit, .after_signup.edit, .welcome.edit')
  if (pagesToRunOn.length === 0) return

  let input = $('#phone_number_input')
  input.intlTelInput({
    initialCountry: 'gh',
    utilsScript: '/assets/libphonenumber/utils.js'
  })

  $('#finish-welcome').click(function (e) {
    let intlNumber = input.intlTelInput('getNumber')
    $('#publisher_phone_number').val(intlNumber)
  });
  $('form').submit(function () {
    let intlNumber = input.intlTelInput('getNumber')
    $('#publisher_phone_number').val(intlNumber)
    $('#contractor_phone_number').val(intlNumber)
  })
})