// Renderers
function process_wb (wb, sheetidx) {
  last_wb = wb
  const sheet = wb.SheetNames[sheetidx || 0]
  return to_json(wb)[sheet]
}

function to_json (workbook) {
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


$(document).on('turbolinks:load', function () {
  if ($('.request_for_tenders.compare_bids').length === 0) return

})