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


  // Activate tooltips in the page
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })




  function storeBankDetailsInLocalStorage() {
    var company_name = $('.qs-company-name').text();
    localStorage.setItem(company_name+ '-bankname', $('#request_for_tender_bank_name').val());
    localStorage.setItem(company_name+ '-branch', $('#request_for_tender_bank_branch').val());
    localStorage.setItem(company_name+ '-account_name', $('#request_for_tender_account_name').val());
    localStorage.setItem(company_name+ '-account_number', $('#request_for_tender_account_nunber').val());
  }

  function pullBankDetailsFromLocalStorage() {
    var company_name = $('.qs-company-name').text();
    $('#request_for_tender_bank_name').val(localStorage.getItem(company_name+ '-bankname'));
    $('#request_for_tender_bank_branch').val(localStorage.getItem(company_name+ '-branch'));
    $('#request_for_tender_account_name').val(localStorage.getItem(company_name+ '-account_name'));
    $('#request_for_tender_account_nunber').val(localStorage.getItem(company_name+ '-account_number'));
  }

  $('.next-button').click( function (e) {
    storeBankDetailsInLocalStorage();
  });

  $(document).ready( function (e) {
    pullBankDetailsFromLocalStorage();
  });


  $('#participants-modal').on('show.bs.modal', function (e) {
    function ShowHideDiv (chkPassport) {
      var participantsDiv = document.querySelector("[data-participants-div]")
      var publicLinkDiv = document.querySelector("[data-public-link-container]")
      participantsDiv.style.display = chkPassport.checked ? 'block' : 'none'
      publicLinkDiv.style.display = chkPassport.checked ? 'none' : 'block'
    }


    var $privateSwitch = $("[data-private-switch]")
    console.log($privateSwitch)
    $privateSwitch.click(function () {
      console.log($privateSwitch)
      ShowHideDiv(this)
      console.log($privateSwitch)
    })

    ShowHideDiv($privateSwitch)
  })

});