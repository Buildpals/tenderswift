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
        button.click(function() {
            $('.sheet-name').text("");
            $('.sheet-name').text(s);
            displaySheet(data, idx); 
        });
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

    var rateColumn;
    var amountColumn = parseInt($('.amount_column').text());

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
            rateColumn = parseInt($('.rate_column').text());
            if(col !== rateColumn){
              cellProperties.readOnly = 'true';
              cellProperties.contextMenu = 'true';
              //cellProperties.type = 'numeric';
          }
          return cellProperties;
        },
        afterChange: function(changes, source) {
            $.each(changes, function (index, change) {
                let row = change[0];
                let col = change[1];
                let oldVal = change[2];
                let newVal = change[3];
                if($('.sheet-name').text() == ""){ //if there is nothing here then it's on the first sheet
                    $('.sheet-name').text(data.SheetNames[0]);   
                }
                $.ajax({
                    url: "/rates/",
                    type: "POST",
                    data: { 
                        rate: {
                                boq_id: parseInt($('.boq_id').text()),
                                sheet_name: $('.sheet-name').text(),
                                row_number: parseInt(row) + 1,
                                participant_id: parseInt($('.participant_id').text()),
                                value: newVal
                                }
                        },
                    success: function(response){ 
                        //console.log(response);
                        var quantityColumn = parseInt($('.quantity_column').text());
                        //myData[row][col+1]=parseInt(myData[row][col+1])+parseInt(newVal);
                        //json[row][]
                        quantity = json[row][quantityColumn];
                        rate = json[row][rateColumn];
                        json[row][amountColumn] = quantity * rate;
                        //console.log(json[row][amountColumn]);
                        excelTable.loadData(json);
                    },
                    error: function(response){
                        console.log(response);
                    }
                });
            });
        },
    });
    make_buttons(data, data.SheetNames);
}

/* 
1. Ask QS for the rate column
*/