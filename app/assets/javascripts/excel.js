
function calculateScreenHeight (){
    return window.innerHeight;
}

function calculateScreenWidth (){
    return window.innerWidth * 2/3;
}

function to_json(workbook) {
    XLSX.SSF.load_table(workbook.SSF);
    var result = {};
    workbook.SheetNames.forEach(function(sheetName) {
        var roa = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName], {header:1});
        if(roa.length > 0) result[sheetName] = roa;
    });
    return result;
}


function process_wb(wb, sheetidx) {
    last_wb = wb;
    var sheet = wb.SheetNames[sheetidx||0];
    var json = to_json(wb)[sheet];
    return json;
}

function make_buttons (data, sheetnames) {
    var $buttons = $('.buttons');
    $buttons.html("");
    sheetnames.forEach(function(s,idx) {
        var button= $('<button/>').attr({ type:'button', name:'btn' +idx, text:s });
        button.append('<h5>' + s + '</h5>');
        button.addClass("col-md-2 btn btn-light excel-nav");
        button.click(function() { displaySheet(data, idx); });
        $buttons.each(function(index, element) {
            $(this).append(button);
            $(this).append('<br/>');
        });
    });
};

function displaySheet (data, sheetidx){
    json = process_wb(data, sheetidx);
    if(!json) json = [];
        json.forEach(function(r) { if(json[0].length < r.length) json[0].length = r.length; });

    excelTable = new Handsontable(document.getElementById('boq-excel'), {
        data: json,
        startRows: 5,
        startCols: 3,
        stretchH: 'all',
        rowHeaders: true,
        colHeaders: true,
        width: function () { return calculateScreenWidth(); },
        height: function () { return calculateScreenHeight(); },
        cells: function(row, col, prop){
            var cellProperties = {};
            if(col !== 5){
              cellProperties.readOnly = 'true'
          }
          return cellProperties;
        }
    });
    make_buttons(data, data.SheetNames);
}

/* 
1. Ask QS for the rate column
*/