$(document).on("turbolinks:load", function () {
  if ($(".build.show").length === 0) return;
  $("#surveyModal").modal("show");

  $(".vote").click( function (e) {
    $("#surveyModal").modal("hide");
  });
})
