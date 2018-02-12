$(document).on('turbolinks:load', function () {
  if ($('.create_tender.edit_tender_boq').length === 0) return

  let boqElement = document.getElementById('boq-excel')
  displayBoq(boqElement)





  var rABS = true; // true: readAsBinaryString ; false: readAsArrayBuffer
  function handleFile(e) {
    var files = e.target.files, f = files[0];
    var reader = new FileReader();
    reader.onload = function(e) {
      var data = e.target.result;
      if(!rABS) data = new Uint8Array(data);
      var workbook = XLSX.read(data, {cellFormula: true, cellStyles: true, type: rABS ? 'binary' : 'array'}); //read workbook
      console.log(data);
      var parsedJson = JSON.stringify(workbook);
      $('#workbook-data').val(parsedJson);
      parsedJson = JSON.parse(parsedJson);
      $('#request-form').submit(); //submit form to save json data in DB;
    };
    if(rABS) reader.readAsBinaryString(f); else reader.readAsArrayBuffer(f);
  }
  var uploadBoqButton = document.getElementById('upload-boq');
  uploadBoqButton.addEventListener('change', handleFile, false);
})