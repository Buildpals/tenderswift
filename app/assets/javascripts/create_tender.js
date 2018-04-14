$(document).on('turbolinks:load', function () {
  if ($('.create_tender').length === 0) return

  autosize($('textarea'))

  $('#request-form').areYouSure({
    'softPageUnloadEvent': 'turbolinks:before-visit',
    'addRemoveFieldsMarksDirty': true
  })

  // Enable save button only if the form is dirty - using events.
  $('#request-form').bind('dirty.areYouSure', function () {
    $(this).find('input[type="submit"]').attr({ 'disabled': false });
  })
  $('#request-form').bind('clean.areYouSure', function () {
    //$(this).find('input[type="submit"]').attr({ 'disabled': true });
  })

  $('.nested-forms').on('cocoon:after-insert', function (e, insertedItem) {
    $('#request-form').trigger('rescan.areYouSure');
  })

  $('.nested-forms').on('cocoon:after-remove', function (e, insertedItem) {
    $('#request-form').trigger('rescan.areYouSure');
  })
})


$(document).on('turbolinks:load', function () {
  if ($('.create_tender.edit_tender_boq').length === 0) return

  var rABS = true // true: readAsBinaryString ; false: readAsArrayBuffer
  function handleFile (e) {
    var files = e.target.files, f = files[0]
    var reader = new FileReader()
    reader.onload = function (e) {
      var data = e.target.result
      if (!rABS) data = new Uint8Array(data)
      var workbook = XLSX.read(data, {cellFormula: true, cellStyles: true, type: rABS ? 'binary' : 'array'}) //read workbook
      console.log(data)
      var parsedJson = JSON.stringify(workbook)
      $('#workbook-data').val(parsedJson)
      $('#request-form').submit() //submit form to save json data in DB;
    }
    if (rABS) {
      reader.readAsBinaryString(f)
    } else  {
      reader.readAsArrayBuffer(f)
    }
  }

  var uploadBoqButton = document.getElementById('upload-boq')
  uploadBoqButton.addEventListener('change', handleFile, false)
})

$(document).on('turbolinks:load', function () {
  if ($('.create_tender.edit_tender_contractors, .request_for_tender.show').length === 0) return

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
})

