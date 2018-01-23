function to_json(workbook) {
    XLSX.SSF.load_table(workbook.SSF);
    var result = {};
    workbook.SheetNames.forEach(function (sheetName) {
        var roa = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName], {header: 1});
        if (roa.length > 0) result[sheetName] = roa;
    });
    return result;
}

function process_wb(wb, sheetidx) {
    last_wb = wb;
    var sheet = wb.SheetNames[sheetidx || 0];
    var json = to_json(wb)[sheet];
    return json;
}

function make_buttons(data, sheetnames) {
    var $buttons = $('.buttons');
    $buttons.html("");
    sheetnames.forEach(function (s, idx) {
        var button = $('<button/>').attr({type: 'button', name: 'btn' + idx, text: s});
        button.append('<h5>' + s + '</h5>');
        button.addClass("col-md-2 btn btn-light excel-nav");
        button.click(function () {
            $('.sheet-name').text("");
            $('.sheet-name').text(s);
            display(data, idx);
        });
        $buttons.each(function (index, element) {
            $(this).append(button);
            $(this).append('<br/>');
        });
    });
};

function remove(array, element) {
    const index = array.indexOf(element);
    if (index !== -1) {
        array.splice(index, 1);
    }
}

function differenceValueRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    var quantitySurveyorRate = instance.getData()[row][rateColumn - 1];
    quantitySurveyorRate = parseFloat(quantitySurveyorRate);
    if (!isNaN(quantitySurveyorRate) && quantitySurveyorRate != null) {
        var fivePercentagePlus = (0.05 * quantitySurveyorRate) + quantitySurveyorRate;
        var fivePercentageMinus = parseFloat(quantitySurveyorRate - (0.05 * quantitySurveyorRate));
        var fifteenPercentagePlus = parseFloat(quantitySurveyorRate + (0.15 * quantitySurveyorRate));
        var fifteenPercentageMinus = parseFloat(quantitySurveyorRate - (0.15 * quantitySurveyorRate));
    }
    if (parseFloat(value) >= quantitySurveyorRate && parseFloat(value) < fivePercentagePlus) {
        td.style.fontStyle = 'italic';
        td.className = 'make-me-green';
    } else if (parseFloat(value) >= fivePercentagePlus && parseFloat(value) <= fifteenPercentagePlus) {
        td.style.fontStyle = 'bold';
        td.className = 'make-me-orange';
    } else if (parseFloat(value) > fifteenPercentagePlus) {
        td.style.fontStyle = 'bold';
        td.className = 'make-me-red';
    } else if (parseFloat(value) <= quantitySurveyorRate && parseFloat(value) > fivePercentageMinus) {
        td.style.fontStyle = 'italic';
        td.className = 'make-me-green';
    } else if (parseFloat(value) >= fivePercentageMinus && parseFloat(value) >= fifteenPercentageMinus) {
        td.style.fontStyle = 'bold';
        td.className = 'make-me-orange';
    } else if (parseFloat(value) < fifteenPercentageMinus) {
        td.style.fontStyle = 'bold';
        td.className = 'make-me-red';
    }

}

function rateRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.style.textAlign = "center";
    td.setAttribute('style', 'font-size: 1.1em; font-weight: bold; vertical-align: bottom; text-align: center');
}

function display(data, sheetidx) {
    json = process_wb(data, sheetidx);
    if (!json) json = [];
    json.forEach(function (r) {
        if (json[0].length < r.length) json[0].length = r.length;
    });

    var unitColumn = parseInt($('.unit_column').text())
    var amountColumn = parseInt($('.amount_column').text());
    var quantityColumn = parseInt($('.quantity_column').text());
    var itemColumn = parseInt($('.item_column').text());
    var displayRatesColumn = parseInt($('.rate_column').text() - 1);


    if (sheetidx == 0) {
        $('.sheet-name').text(data.SheetNames[0]);
    }

    json.forEach(function (row, index) {
        remove(row, row[amountColumn - 1]);
        var participantCompanyName;
        if (index == 0) { //if the row has a item header
            row[itemColumn] = "";
            row[quantityColumn] = "";
            row[quantityColumn - 1] = "";
            row[row.length - 1] = "";
        }
        if (row.length > 3) {
            for (var [key, value] of participantRates.entries()) {
                if (value.length == 0) { //contractor has not submitted anything
                    participantPostion = listOfParticipants.indexOf(key);
                    if (participantPostion == 0) {
                        row[row.length] = "N/A";
                    } else {
                        row[(row.length - 1) + participantPostion] = "N/A";
                    }
                }
                else {
                    for (i = 0; i < value.length; i++) {
                        if (value[i].className == $('.sheet-name').text()) {
                            rowNumber = parseInt(value[i].getAttribute('row')); //get row Number
                            sheetRowNumber = index + 1 //get the actually row number on the excel (we add two becasue the sheet number is behind our row number by one and remember we delete the item row from the excel)
                            if (sheetRowNumber == rowNumber) { //check row number
                                participantPostion = listOfParticipants.indexOf(key);
                                if (participantPostion == 0) {
                                    row[row.length] = value[i].innerHTML;
                                } else {
                                    row[(row.length - 1) + participantPostion] = value[i].innerHTML;
                                }
                            }
                        }
                    }
                }
            }
        }

    });
    console.log(participantRates);
    json[0][itemColumn] = "Item";
    json[0][2] = "Description";
    json[0][quantityColumn] = "Unit";
    json[0][quantityColumn - 1] = "Qty";
    json[0][displayRatesColumn] = "RATES";
    json[1][displayRatesColumn] = $('.qs-company-name').text() + "\n GHC " + $('.boq-contract-sum').text().trim();
    listOfParticipants.forEach(function (participantName, index) {
        json[1][displayRatesColumn + (index + 1)] = "\n " + participantName + " \n " + " \n GHC " + participantTotalBids[index] + " ";
    });

    excelTable = new Handsontable(document.getElementById('boq-excel'), {
        data: json,
        startRows: 5,
        startCols: 3,
        // stretchH: 'all',
        rowHeaders: true,
        colHeaders: true,
        fixedColumnsLeft: 3,
        fixedRowsTop: 2,
        // colWidths: [60, 20, 550, 60, 60],
        colWidths: function (index) {
            if (index === 0) {
                return 60
            } else if (index == 1) {
                return 550
            } else if (index == 2) {
                return 60
            } else if (index == 3) {
                return 60
            } else {
                return 100
            }
        },
        // width: function () { return calculateScreenWidth(); },
        width: function () {
            // return document.documentElement.clientWidth;
            return window.innerWidth - 200;
            // return window.offsetWidth;
        },
        preventOverflow: 'vertical',
        // height: function () { return calculateScreenHeight(); },
        mergeCells: [{
            row: 0,
            col: parseInt($('.rate_column').text() - 1),
            rowspan: 1,
            colspan: listOfParticipants.length + 1
        }],
        cells: function (row, col, prop) {
            var cellProperties = {};
            rateColumn = parseInt($('.rate_column').text());
            if (col !== rateColumn) {
                cellProperties.readOnly = 'true';
                cellProperties.contextMenu = 'true';
            }
            if (col >= rateColumn) {
                cellProperties.renderer = "differenceValueRenderer";
            }
            if (row == 0) {
                cellProperties.renderer = "rateRenderer";
            }
            return cellProperties;
        },
        afterInit: function () {
        }
    });
    make_buttons(data, data.SheetNames);
}


var container = $('#boq-excel');
var excelData = JSON.parse($('.content-boq').text());

var listOfParticipants = [];
var participantTotalBids = [];
var participantRates = new Map();

$('.request_for_tender_participants').children().each(function (i, e) {
    participantCompanyName = $(this).attr('class');
    listOfParticipants.push(participantCompanyName);
    firstPartOfCompanyName = participantCompanyName.split(' ')[0];
    participantTotalBids.push($('.' + firstPartOfCompanyName + '').children()[1].innerHTML);
    participantRates.set(participantCompanyName, $('.' + firstPartOfCompanyName + '').children().children());
});

Handsontable.renderers.registerRenderer('differenceValueRenderer', differenceValueRenderer);
Handsontable.renderers.registerRenderer('rateRenderer', rateRenderer);

console.log(listOfParticipants);

display(excelData, 0);