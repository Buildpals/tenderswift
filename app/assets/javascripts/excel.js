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

function remove(array, element) {
    const index = array.indexOf(element);    
    if (index !== -1) {
        array.splice(index, 1);
    }
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

var contractSum = 0.0;
var contractorRates = [];
var isRatesLoaded = false;

function displaySheet (data, sheetidx){
    json = process_wb(data, sheetidx);
    if(!json) json = [];
        json.forEach(function(r) { if(json[0].length < r.length) json[0].length = r.length; });

    var rateColumn = parseInt($('.rate_column').text());
    var amountColumn = parseInt($('.amount_column').text());
    var itemColumn = parseInt($('.item_column').text());
    var quantityColumn = parseInt($('.quantity_column').text());

    if(sheetidx == 0){
        $('.sheet-name').text(data.SheetNames[0]);
    }

    json.forEach(function(row){
        remove(row, row[amountColumn]);
        remove(row, row[rateColumn]);
        if(row[itemColumn] == 'Item' || row[itemColumn] == 'item'){
            row.push('Rate');
            row.push('Amount');
        }
    });

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
          }
          return cellProperties;
        },
        afterInit: function(){
            $.ajax({
                url: "/rates/",
                type: "GET",
                data: { 
                    rate: {
                            boq_id: parseInt($('.boq_id').text()),
                            participant_id: parseInt($('.participant_id').text())
                            //sheet_name: data.SheetNames[sheetidx]
                            }
                    },
                success: function(response){ 
                    //console.log(response);
                    if (response.length > 0){
                        for(i=0; i < response.length; i++){
                            result = response[i];
                            const contractorRate = new Object();
                            contractorRate.quantity = result.quantity;
                            contractorRate.value = result.value;
                            contractorRate.sheetName = result.sheet_name;
                            contractorRate.rowNumber = result.row_number;
                            contractorRate.participantId = result.participant_id;
                            contractorRates.push(contractorRate);
                            if(contractorRate.sheetName == $('.sheet-name').text()){
                                row_number = parseInt(response[i].row_number) - 1;
                                quantity = json[row_number][quantityColumn];
                                rate = parseFloat(response[i].value);
                                json[row_number][rateColumn] = rate;
                                json[row_number][amountColumn] = parseInt(quantity) * parseFloat(rate);
                                excelTable.loadData(json);
                            }

                        }

                        if(!isRatesLoaded){
                            for(i=0; i < contractorRates.length; i++){
                                isRatesLoaded = true;
                                contractSum = contractSum + ( contractorRates[i].value * contractorRates[i].quantity );
                            }
                        }
                        $('.contract-sum').text(contractSum);

                    }
                    console.log(response);
                },
                error: function(response){
                    console.log(response);
                }
            });
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
                if(newVal != "" && typeof json[row][quantityColumn] != 'undefined'){ //make sure user has typed something and there is a value in a quantity column
                    $.ajax({
                        url: "/rates/",
                        type: "POST",
                        data: { 
                            rate: {
                                    boq_id: parseInt($('.boq_id').text()),
                                    sheet_name: $('.sheet-name').text(),
                                    row_number: parseInt(row) + 1,
                                    participant_id: parseInt($('.participant_id').text()),
                                    quantity: parseFloat(json[row][quantityColumn]),
                                    value: newVal
                                    }
                            },
                        success: function(response){ 
                            quantity = json[row][quantityColumn];
                            rate = json[row][rateColumn];
                            json[row][amountColumn] = quantity * rate;

                            contractSum = contractSum + json[row][amountColumn];
                            //console.log(json[row][amountColumn]);
                            excelTable.loadData(json);

                            $('.contract-sum').text(contractSum);
                        },
                        error: function(response){
                            console.log(response);
                        }
                    });
                }
            });
        },
    });
    make_buttons(data, data.SheetNames);
}

/* 
1. Ask QS for the rate column
*/

$('.submit-your-bid').click( function(e){
    $.ajax({
        url: "/participants/contract_sum/"+$('.participant_auth').text()+"/",
        type: "PATCH",
        data: { 
            participants: {
                    contract_sum: parseFloat($('.contract-sum').text())
                }
            },
        success: function(response){
            console.log(response);
        },
        error: function(response){
            console.log(response);
        }
    });
});


/* 
 New way off doing the contract sum.
 ===================================
 1. Load all rates of the contractor oninit from DB
 2. Read through sheetJS (json) and do the calculation for the amount then add it up
 to get the contract sum.
 3. Do this Sunday Evening! 
*/