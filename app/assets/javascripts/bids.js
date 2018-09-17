$(document).on("turbolinks:load", function () {
  if ($(".bids, .request_for_tenders.show").length === 0) return;

  $('input[type=radio][name="score"]').change(function() {
    $(this).parent().parent().parent().submit()
  });
});


$(document).ready(function () {
  if ($(".bids, .request_for_tenders.show").length === 0) return;

  $('input[type=radio][name="score"]').change(function() {
    $(this).parent().parent().parent().submit()
  });
})
