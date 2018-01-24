$(document).on('turbolinks:load', function () {
  if ($('.request_for_tenders.compare_bids').length === 0) return

  // Renderers
  function rowHeaderRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments)
    td.style.textAlign = 'center'
    td.setAttribute('style', 'font-weight: bold; vertical-align: top; text-align: center')
  }

  function differenceValueRenderer (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments)
    var quantitySurveyorRate = instance.getData()[row][4]
    quantitySurveyorRate = parseFloat(quantitySurveyorRate)
    if (!isNaN(quantitySurveyorRate) && quantitySurveyorRate != null) {
      var fivePercentagePlus = (0.05 * quantitySurveyorRate) + quantitySurveyorRate
      var fivePercentageMinus = parseFloat(quantitySurveyorRate - (0.05 * quantitySurveyorRate))
      var fifteenPercentagePlus = parseFloat(quantitySurveyorRate + (0.15 * quantitySurveyorRate))
      var fifteenPercentageMinus = parseFloat(quantitySurveyorRate - (0.15 * quantitySurveyorRate))
    }
    if (parseFloat(value) >= quantitySurveyorRate && parseFloat(value) < fivePercentagePlus) {
      td.style.fontStyle = 'italic'
      td.className = 'make-me-green'
    } else if (parseFloat(value) >= fivePercentagePlus && parseFloat(value) <= fifteenPercentagePlus) {
      td.style.fontStyle = 'bold'
      td.className = 'make-me-orange'
    } else if (parseFloat(value) > fifteenPercentagePlus) {
      td.style.fontStyle = 'bold'
      td.className = 'make-me-red'
    } else if (parseFloat(value) <= quantitySurveyorRate && parseFloat(value) > fivePercentageMinus) {
      td.style.fontStyle = 'italic'
      td.className = 'make-me-green'
    } else if (parseFloat(value) >= fivePercentageMinus && parseFloat(value) >= fifteenPercentageMinus) {
      td.style.fontStyle = 'bold'
      td.className = 'make-me-orange'
    } else if (parseFloat(value) < fifteenPercentageMinus) {
      td.style.fontStyle = 'bold'
      td.className = 'make-me-red'
    }

  }

  function companyHeaderRenderer (instance, td, row, col, prop, value, cellProperties) {
    var escaped = Handsontable.helper.stringify(value)
    escaped = strip_tags(escaped, '<div><br><strong><span>') //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
    td.innerHTML = escaped
    td.setAttribute('style', 'vertical-align: bottom; text-align: center')
    return td
  }

  function descriptionRenderer(instance, td, row, col, prop, value, cellProperties) {
    var escaped = Handsontable.helper.stringify(value)
    escaped = strip_tags(escaped, '<div><br><strong><span>') //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
    td.innerHTML = escaped
    return td
  }

  function sectionRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.setAttribute('style', 'height: 2em !important; font-size: 1.1em; font-weight: bold; vertical-align: bottom; text-align: center');
  }

  function labelRenderer(instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.TextRenderer.apply(this, arguments);
    td.style.fontWeight = "bold";
  }

  function strip_tags(input, allowed) {
    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
      commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;

    // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
    allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join('');

    return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
      return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
    });
  }

  function to_json (workbook) {
    XLSX.SSF.load_table(workbook.SSF)
    var result = {}
    workbook.SheetNames.forEach(function (sheetName) {
      var roa = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName], {header: 1})
      if (roa.length > 0) result[sheetName] = roa
    })
    return result
  }

  function process_wb (wb, sheetidx) {
    last_wb = wb
    var sheet = wb.SheetNames[sheetidx || 0]
    var json = to_json(wb)[sheet]
    return json
  }

  function make_buttons (data, sheetnames) {
    var $buttons = $('.buttons')
    $buttons.html('')
    sheetnames.forEach(function (s, idx) {
      var button = $('<button/>').attr({type: 'button', name: 'btn' + idx, text: s})
      button.append(s)
      button.addClass('btn btn-small btn-primary m-2')
      button.click(function () {
        display(data, idx)
      })
      $buttons.each(function (index, element) {
        $(this).append(button)
        $(this).append('<br/>')
      })
    })
  }

  function colWidths(index) {
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
  }

  function height () {
    return window.innerHeight - (42 + 85 + 175)
  }

  function mergeCells () {
    return [
      {row: 0, col: 0, rowspan: 2, colspan: 1},
      {row: 0, col: 1, rowspan: 2, colspan: 1},
      {row: 0, col: 2, rowspan: 2, colspan: 1},
      {row: 0, col: 3, rowspan: 2, colspan: 1},
      {row: 0, col: 4, rowspan: 1, colspan: participants.length + 1}
    ]
  }

  function isHeader (row) {
    if (row.length === 2 && row[0] === undefined && typeof row[1] === 'string') {
      return true
    } else {
      return false
    }
  }

  function data (workBookData, sheetidx) {
    let json = process_wb(workBookData, sheetidx)

    let objectData = [
      {
        'item': 'Item',
        'description': 'Description',
        'quantity': 'Qty',
        'unit': 'Unit',
        'rate': 'Rates'
      }
    ]

    let headerRow = {
      'rate': `<div>${boqElement.dataset.qsCompanyName} <br> <span class="small">(GHS ${1000})</span></div>`
    }

    participants.forEach(function (participant) {
      headerRow[participant.company_name] =
        `<div>${participant.company_name} <br> <span class="small">(GHS ${participant.total_bid})</span></div>`
    })

    objectData.push(headerRow)

    json.forEach(function (row, rowNumber) {
      // Skip the first row in the json because it is the header row
      // and we have appended our own custom headerRow to objectData
      if (rowNumber === 0) {
        return
      }

      let rowData = {
        'item': row[0],
        'description': isHeader(row) ? `<strong>${row[1]}<strong>` : row[1],
        'quantity': row[2],
        'unit': row[3],
        'rate': row[4]
      }

      participants.forEach(function (participant) {
        let rate = participant.rates.find(function (rate) {
          return (rate.row_number - 1) === rowNumber
        })

        if (rate) {
          rowData[participant.company_name] = rate.value
        }
      })
      objectData.push(rowData)
    })
    return objectData
  }

  function dataSchema () {
    let dataSchema = {
      'item': null,
      'description': null,
      'quantity': null,
      'unit': null,
      'rate': null
    }

    participants.forEach(function (participant) {
      dataSchema[participant.company_name] = null
    })

    dataSchema['last'] = null
    return dataSchema
  }

  function columns () {
    let columns = [
      {
        data: 'item'
      },
      {
        data: 'description',
        className: 'htLeft'
      },
      {
        data: 'quantity'
      },
      {
        data: 'unit'
      },
      {
        data: 'rate',
      }
    ]

    participants.forEach(function (participant) {
      columns.push({
        data: participant.company_name,
        renderer: differenceValueRenderer
      })
    })

    columns.push({
      data: 'last'
    })
    return columns
  }

  function cells (row, col, prop) {
    var cellProperties = {};
    var visualRowIndex = this.instance.toVisualRow(row);
    var visualColIndex = this.instance.toVisualColumn(col);

    if (row === 0) {
      cellProperties.renderer =  rowHeaderRenderer
    } else if (row === 1 && prop !== 'last') {
      cellProperties.renderer = companyHeaderRenderer
    } else if (row > 1 && col === 1) {
      cellProperties.renderer = descriptionRenderer
    }

    return cellProperties;
  }

  function display (workBookData, sheetidx) {
    excelTable = new Handsontable(document.getElementById('boq-excel'), {
      data: data(workBookData, sheetidx),
      dataSchema: dataSchema(),
      columns: columns(),
      cells: cells,
      mergeCells: mergeCells(),
      colHeaders: true,
      rowHeaders: true,
      minSpareRows: 1,
      height: height(),
      fixedRowsTop: 2,
      stretchH: 'last',
      colWidths: colWidths,
      readOnly: true
    })

    make_buttons(workBookData, workBookData.SheetNames)
  }

  let boqElement = document.getElementById('boq-excel')
  let participants = JSON.parse(boqElement.dataset.participants)
  let excelData = JSON.parse(boqElement.dataset.boq)

  display(excelData, 0)
})