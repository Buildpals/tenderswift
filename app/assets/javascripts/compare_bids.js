// Renderers
function rowHeaderRenderer (instance, td, row, col, prop, value, cellProperties) {
  Handsontable.renderers.TextRenderer.apply(this, arguments)
  td.style.textAlign = 'center'
  td.setAttribute('style', 'font-weight: bold; vertical-align: top; text-align: center')
}

function companyHeaderRenderer (instance, td, row, col, prop, value, cellProperties) {
  let escaped = Handsontable.helper.stringify(value)
  escaped = strip_tags(escaped, '<div><br><strong><span>') //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
  td.innerHTML = escaped
  td.setAttribute('style', 'vertical-align: bottom; text-align: center')
  return td
}

function descriptionRenderer (instance, td, row, col, prop, value, cellProperties) {
  let escaped = Handsontable.helper.stringify(value)
  escaped = strip_tags(escaped, '<div><br><strong><span>') //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
  td.innerHTML = escaped
  return td
}

function itemRenderer (instance, td, row, col, prop, value, cellProperties) {
  Handsontable.renderers.TextRenderer.apply(this, arguments)
  td.style.textAlign = 'center'
  td.setAttribute('style', 'text-align: center')
}

function differenceValueRenderer (instance, td, row, col, prop, value, cellProperties) {
  Handsontable.renderers.TextRenderer.apply(this, arguments)

  let quantitySurveyorRate = instance.getData()[row][4]
  let rate = parseFloat(value)

  if (isNaN(quantitySurveyorRate) || quantitySurveyorRate === null) {
    return
  }

  if (!rate) {
    return
  }

  quantitySurveyorRate = parseFloat(quantitySurveyorRate)
  let fifteenPercentageMinus = parseFloat(quantitySurveyorRate - (0.15 * quantitySurveyorRate))
  let fifteenPercentagePlus = parseFloat(quantitySurveyorRate + (0.15 * quantitySurveyorRate))
  let fivePercentageMinus = parseFloat(quantitySurveyorRate - (0.05 * quantitySurveyorRate))
  let fivePercentagePlus = (0.05 * quantitySurveyorRate) + quantitySurveyorRate

  td.innerHTML = rate.toFixed(2)

  if (rate >= quantitySurveyorRate && rate < fivePercentagePlus) {
    td.style.fontStyle = 'italic'
    td.className = 'make-me-green'
  } else if (rate >= fivePercentagePlus && rate <= fifteenPercentagePlus) {
    td.style.fontStyle = 'bold'
    td.className = 'make-me-orange'
  } else if (rate > fifteenPercentagePlus) {
    td.style.fontStyle = 'bold'
    td.className = 'make-me-red'
  } else if (rate <= quantitySurveyorRate && rate > fivePercentageMinus) {
    td.style.fontStyle = 'italic'
    td.className = 'make-me-green'
  } else if (rate >= fivePercentageMinus && rate >= fifteenPercentageMinus) {
    td.style.fontStyle = 'bold'
    td.className = 'make-me-orange'
  } else if (rate < fifteenPercentageMinus) {
    td.style.fontStyle = 'bold'
    td.className = 'make-me-red'
  }

  td.setAttribute('style', 'text-align: right')

  return td
}

function strip_tags (input, allowed) {
  const tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
    commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi

  // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
  allowed = (((allowed || '') + '').toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join('')

  return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
    return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : ''
  })
}

function to_json (workbook) {
  XLSX.SSF.load_table(workbook.SSF)
  const result = {}
  workbook.SheetNames.forEach(function (sheetName) {
    const roa = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName], {header: 1})
    if (roa.length > 0) result[sheetName] = roa
  })
  return result
}

function process_wb (wb, sheetidx) {
  last_wb = wb
  const sheet = wb.SheetNames[sheetidx || 0]
  return to_json(wb)[sheet]
}

function make_buttons (boqElement) {
  let data = JSON.parse(boqElement.dataset.boq)
  data.SheetNames.forEach(function (s, idx) {
    // create buttton
    const button = $('<button/>').attr({type: 'button', name: 'btn' + idx, text: s})
    button.append(s)
    button.addClass('btn btn-small btn-primary m-2')
    button.click(function () {
      displaySheet(boqElement, idx)
    })
    console.log(button)
    $(boqElement).after(button)
  })
}

function colWidths (index) {
  if (index === 0) {
    return 60
  } else if (index === 1) {
    return 550
  } else if (index === 2) {
    return 60
  } else if (index === 3) {
    return 60
  } else {
    return 100
  }
}

function height () {
  return window.innerHeight - (42 + 85 + 78)
}

function mergeCells (participants) {
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

function data (workBookData, sheetidx, currency, qsCompanyName, boqContractSum, participants) {
  let json = process_wb(workBookData, sheetidx)

  let objectData = [
    {
      'item': 'Item',
      'description': 'Description',
      'quantity': 'Qty',
      'unit': 'Unit',
      'rate': `Rates (${currency})`
    }
  ]

  let headerRow = {
    'rate': `<div>${qsCompanyName}<br><span class="small">${currency}${boqContractSum.toLocaleString('en', { minimumFractionDigits: 2})}</span></div>`
  }

  participants.forEach(function (participant) {
    headerRow[participant.company_name] =
      `<div>${participant.company_name} <br> <span class="small">${currency}${participant.total_bid.toLocaleString('en')}</span></div>`
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

function dataSchema (participants) {
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

function columns (participants) {
  let columns = [
    {
      data: 'item',
      renderer: itemRenderer
    },
    {
      data: 'description',
      className: 'htLeft'
    },
    {
      data: 'quantity',
      type: 'numeric'
    },
    {
      data: 'unit',
      renderer: itemRenderer
    },
    {
      data: 'rate',
      type: 'numeric',
      numericFormat: {
        pattern: '0,0.00',
        culture: 'en-US' // this is the default culture, set up for USD
      },
      allowEmpty: false
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
  const cellProperties = {}

  if (row === 0) {
    cellProperties.renderer = rowHeaderRenderer
  } else if (row === 1 && prop !== 'last') {
    cellProperties.renderer = companyHeaderRenderer
  } else if (row > 1 && col === 1) {
    cellProperties.renderer = descriptionRenderer
  }

  return cellProperties
}

function displaySheet (boqElement, sheetIndex) {
  let workbookData = JSON.parse(boqElement.dataset.boq)
  let currency = boqElement.dataset.currency
  let qsCompanyName = boqElement.dataset.qsCompanyName
  let boqContractSum = parseFloat(boqElement.dataset.boqContractSum)
  let participants = JSON.parse(boqElement.dataset.participants)

  let excelTable = new Handsontable(boqElement, {
    data: data(workbookData, sheetIndex, currency, qsCompanyName, boqContractSum, participants),
    dataSchema: dataSchema(participants),
    columns: columns(participants),
    cells: cells,
    mergeCells: mergeCells(participants),
    startRows: 100,
    colHeaders: true,
    rowHeaders: true,
    minSpareRows: 1,
    height: height(),
    fixedRowsTop: 2,
    stretchH: 'last',
    colWidths: colWidths,
    readOnly: true
  })
}

function displayBoq(boqElement) {
  displaySheet(boqElement, 0)
  make_buttons(boqElement)
}


$(document).on('turbolinks:load', function () {
  if ($('.request_for_tenders.compare_bids').length === 0) return

  let boqElement = document.getElementById('boq-excel')
  displayBoq(boqElement)
})

