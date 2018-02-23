import Handsontable from 'handsontable';
import XLSX from 'xlsx';

function strip_tags (input, allowed) {
  const tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
    commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi

  // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
  allowed = (((allowed || '') + '').toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join('')

  return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
    return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : ''
  })
}

export function isHeader (row) {
  if (row.length === 2 && row[0] === undefined && typeof row[1] === 'string') {
    return true
  } else {
    return false
  }
}

export function rowHeaderRenderer (instance, td, row, col, prop, value, cellProperties) {
  Handsontable.renderers.TextRenderer.apply(this, arguments)
  td.style.textAlign = 'center'
  td.setAttribute('style', 'font-weight: bold; vertical-align: top; text-align: center')
}

export function companyHeaderRenderer (instance, td, row, col, prop, value, cellProperties) {
  let escaped = Handsontable.helper.stringify(value)
  escaped = strip_tags(escaped, '<div><br><strong><span>') //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
  td.innerHTML = escaped
  td.setAttribute('style', 'vertical-align: bottom; text-align: center')
  return td
}

export function descriptionRenderer (instance, td, row, col, prop, value, cellProperties) {
  let escaped = Handsontable.helper.stringify(value)
  escaped = strip_tags(escaped, '<div><br><strong><span>') //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
  td.innerHTML = escaped
  return td
}

export function itemRenderer (instance, td, row, col, prop, value, cellProperties) {
  Handsontable.renderers.TextRenderer.apply(this, arguments)
  td.style.textAlign = 'center'
  td.setAttribute('style', 'text-align: center')
}

export function differenceValueRenderer (instance, td, row, col, prop, value, cellProperties) {
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
  } else if (rate <= quantitySurveyorRate && rate >= fivePercentageMinus) {
    td.style.fontStyle = 'italic'
    td.className = 'make-me-green'
  } else if (rate >= fivePercentageMinus && rate >= fifteenPercentageMinus) {
    td.style.fontStyle = 'bold'
    td.className = 'make-me-orange'
  } else if (rate < fifteenPercentageMinus) {
    td.style.fontStyle = 'bold'
    td.className = 'make-me-red'
  } else if (rate == fifteenPercentageMinus || rate == fifteenPercentagePlus) {
    td.style.fontStyle = 'bold'
    td.className = 'make-me-orange'
  } else if (rate == fivePercentageMinus || rate == fivePercentagePlus) {
    td.style.fontStyle = 'bold'
    td.className = 'make-me-orange'
  }

  td.setAttribute('style', 'text-align: right')

  return td
}

export function process_wb (wb, sheetIndex) {
  const sheet = wb.SheetNames[sheetIndex || 0]
  return to_json(wb)[sheet]
}

export function to_json (workbook) {
  XLSX.SSF.load_table(workbook.SSF)
  const result = {}
  workbook.SheetNames.forEach(function (sheetName) {
    const roa = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName], {header: 1})

    /*	Get	worksheet	*/
    let worksheet = workbook.Sheets[sheetName]
    roa.forEach(function (row, rowNumber) {
      // Skip the first row in the json because it is the header row
      // and we have appended our own custom headerRow to objectData

      let address_of_cell = `F${rowNumber + 1}`
      /*	Find	desired	cell	*/
      let desired_cell = worksheet[address_of_cell]

      /*	Get	the	value	*/
      let desired_value = (desired_cell ? desired_cell.f : undefined)

      // row[5] = `=${desired_value}`
      row[5] = ' =C9*E9'
      // console.log('desired_value', desired_value, row[5])
    })

    if (roa.length > 0) result[sheetName] = roa
  })
  return result
}