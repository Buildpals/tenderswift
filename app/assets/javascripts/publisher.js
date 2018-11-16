$(document).on("turbolinks:load", function () {
  if ($(".build.show").length === 0){
    return;
  } else{
    $("#surveyModal").modal("show");
  }

  $(".vote").click( function (e) {
    $("#surveyModal").modal("hide");
  });
});
