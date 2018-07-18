import XLSX from 'xlsx';
import XLSX_CALC from 'xlsx-calc';
import formulajs from 'formulajs';

// import your calc functions lib
XLSX_CALC.import_functions(formulajs);

export function recalculateFormulas(workbook) {
  XLSX_CALC(workbook)
}


function rowHasValue (worksheet, row) {
  return worksheet[`A${row}`] ||
    worksheet[`B${row}`] ||
    worksheet[`C${row}`] ||
    worksheet[`D${row}`] ||
    worksheet[`E${row}`] ||
    worksheet[`F${row}`]
}

export function lastRowWithValues (worksheet) {
  let range = XLSX.utils.decode_range(worksheet['!ref'])
  let totalRows = range.e.r

  for (let row = totalRows; row > 0; row--) {
    if (rowHasValue(worksheet, row)) {
      return row
    }
  }
}

export function getRates (workbook) {
  let rates = {}
  workbook.SheetNames.forEach(sheetName => {
    let worksheet = workbook.Sheets[sheetName]
    let lastRow = lastRowWithValues(worksheet)
    for (let row = 0; row < lastRow; row++) {
      if (worksheet[`E${row}`] &&
        worksheet[`E${row}`].c === 'allowEditing' &&
        worksheet[`E${row}`].v) {
        rates[`${sheetName}!E${row}`] = worksheet[`E${row}`].v
      }
    }
  })
  return rates
}

export function getSheetName (cellAddress) {
  return cellAddress.split('!')[0]
}

export function getRowColumnRef (cellAddress) {
  return cellAddress.split('!')[1]
}

