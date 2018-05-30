<template>
  <div>
    <div class="w-100 d-flex justify-content-start">
      <div class="formula-bar formula-bar-address">{{ selectedCellAddress }}</div>
      <div class="formula-bar formula-bar-icon px-3">fx</div>
      <div class="formula-bar formula-bar-contents">{{ selectedCellContents }}</div>
    </div>
    <div ref="hot"></div>
  </div>
</template>

<script>
  import Handsontable from 'handsontable';
  import {
    rowHeaderRenderer,
    descriptionRenderer,
    itemRenderer,
    isHeader,
    differenceValueRenderer,
    process_wb_comparison
  } from '../renderers'

  export default {
    props: [
      'tenders',
      'workbook',
      'sheetIndex',
      'currency',
      'boqContractSum'
    ],
    mounted () {
      this.initTable()
    },
    beforeDestroy () {
      this.table.destroy()
    },
    watch: {
      'workbook': 'updateTable'
    },
    data () {
      return {
        selectedCellAddress: "",
        selectedCellContents: "",
        height: window.innerHeight - (42 + 85 + 78),
        mergeCells: []
      }
    },
    computed: {
      dataSchema () {
        let tenderKeys = {}
        this.tenders.forEach(tender => {
          let amountKey = `amount (${tender.company_name})`
          tenderKeys[amountKey] = null
        })
        return {
          'item': null,
          'description': null,
          'quantity': null,
          'unit': null,
          'amount': null,
          ...tenderKeys,
          'last': null
        }
      },
      columns () {
        let tenderKeys = []
        this.tenders.forEach(tender => {
          let amountKey = `amount (${tender.company_name})`
          tenderKeys.push({
            data: amountKey,
            type: 'numeric',
            numericFormat: {
              pattern: '0,0.00',
              culture: 'en-US'
            },
            renderer: differenceValueRenderer,
            allowEmpty: false
          })
        })
        return [
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
            data: 'amount',
            type: 'numeric',
            numericFormat: {
              pattern: '0,0.00',
              culture: 'en-US'
            },
            allowEmpty: false
          },
          ...tenderKeys,
          {
            data: 'last'
          }
        ]
      },
      sheetData () {
        return process_wb_comparison(this.workbook, this.sheetIndex, this.tenders)
      }
    },
    methods: {
      initTable () {
        let self = this
        this.table = new Handsontable(this.$refs.hot, {
          data: this.sheetData,
          dataSchema: this.dataSchema,
          columns: this.columns,
          cells: this.cells,
          mergeCells: this.mergeCells,
          startRows: 100,
          colHeaders: true,
          rowHeaders: true,
          minSpareRows: 1,
          height: this.height,
          stretchH: 'last',
          colWidths: this.colWidths,
          readOnly: true,
          afterSelection: function (r, c, r2, c2, preventScrolling, selectionLayerLevel) {
            let columnLetter, cellAddress
            if(c > 3) {
              columnLetter = String.fromCharCode(65 + c)
              cellAddress = `${columnLetter}${ r + 1 }`
            } else {
              columnLetter = String.fromCharCode(65 + c)
              cellAddress = `${columnLetter}${ r + 1 }`
            }

            self.selectedCellAddress = cellAddress

            let sheet = self.workbook.SheetNames[self.sheetIndex]
            let formula = self.workbook.Sheets[sheet][cellAddress].f
            let value = self.workbook.Sheets[sheet][cellAddress].v
            if (formula) {
              self.selectedCellContents = formula
            } else {
              self.selectedCellContents = value
            }
          }
        })
      },
      updateTable () {
        this.table.updateSettings({data: this.sheetData})
      },
      cells (row, col, prop) {
        const cellProperties = {}

        if (row === 0) {
          cellProperties.renderer = rowHeaderRenderer
        } else if (row > 0 && col === 1) {
          cellProperties.renderer = descriptionRenderer
        }

        return cellProperties
      },
      colWidths (index) {
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
    }
  }
</script>

<style>
  /* @import "handsontable/dist/handsontable.full.css"; */

  #test-hot {
    overflow: hidden;
  }
</style>