$(document).on("turbolinks:load", function () {
    if ($(".request_for_tenders.show, .bids.boq").length === 0) return;


  // When the user scrolls down 20px from the top of the document, show the button
  window.onscroll = function() {scrollFunction()};

  function scrollFunction() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
      document.querySelector("[data-back-to-top]").style.display = "block";
    } else {
      document.querySelector("[data-back-to-top]").style.display = "none";
    }
  }

  $("[data-back-to-top]").click(function () {
    document.body.scrollTop = 0; // For Safari
    document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
  })
});