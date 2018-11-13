$(document).on('turbolinks:load', function () {
  if ($('.build.show').length === 0) return
  console.log('Welcome to dashboard');
  $('#surveyModal').modal('show')

  $('.vote').click( function (e) {
    $('#surveyModal').modal('hide');
  });
})
