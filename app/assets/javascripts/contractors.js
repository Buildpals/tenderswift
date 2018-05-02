$(document).on('turbolinks:load', function () {
  if ($('.contractors.dashboard').length === 0) return

  $('.card').each(function (i, e) {
    if (parseInt($(this).css('height')) >= 700) {
      $(this).css('height', '700px')
      $(this).css('overflow-y', 'scroll')
    }
  })
})
