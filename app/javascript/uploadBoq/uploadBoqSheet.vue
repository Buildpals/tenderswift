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
    process_wb
  } from '../renderers'

  export default {
    props: [
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
        dataSchema: {
          'item': null,
          'description': null,
          'quantity': null,
          'unit': null,
          'rate': null,
          'amount': null,
          'last': null
        },
        columns: [
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
              culture: 'en-US'
            },
            allowEmpty: false
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
          {
            data: 'last'
          }
        ],
        height: window.innerHeight - (42 + 85 + 78),
        mergeCells: []
      }
    },
    computed: {
      sheetData () {
        return process_wb(this.workbook, this.sheetIndex)
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
            let columnLetter = String.fromCharCode(65 + c)
            let cellAddress = `${columnLetter}${ r + 1 }`
            self.selectedCellAddress = cellAddress

            let sheet = self.workbook.SheetNames[self.sheetIndex]
            let formula = self.workbook.Sheets[sheet][cellAddress].f
            let value = self.workbook.Sheets[sheet][cellAddress].v
            if (formula) {
              self.selectedCellContents = formula
            } else {
              self.selectedCellContents = value
            }
          },
          contextMenu: {
            callback: function (key, options) {
              if (key === 'set_contract_sum_address') {
                let option = options[0]
                if (option.start.row === option.end.row && option.start.col === option.end.col) {
                  let sheet = self.workbook.SheetNames[self.sheetIndex]
                  self.$emit('setContractSumAddress', sheet, option.start.row, option.start.col)
                } else {
                  setTimeout(function () {
                    // timeout is used to make sure the menu collapsed before alert is shown
                    alert("Tender figure should only be found in one cell");
                  }, 100);
                }
              }
            },
            items: {
              "set_contract_sum_address": {name: 'Set as tender figure'}
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

  .formula-bar {
    box-sizing: content-box;
    -webkit-box-sizing: content-box;
    -moz-box-sizing: content-box;

    border-right: 1px solid #CCC;
    border-top: 1px solid #CCC;
    border-left: 1px solid #CCC;
    height: 22px;
    empty-cells: show;
    line-height: 21px;
    padding: 0 4px 0 4px;
    background-color: #FFF;
    vertical-align: top;
    overflow: hidden;
    outline-width: 0;
    white-space: pre-line;
    background-clip: padding-box;

    color: #777;
  }

  .formula-bar-address {
    width: 80px;
  }

  .formula-bar-icon {
    background-color: transparent;
    border-right: transparent;
    border-left: transparent;
  }

  .formula-bar-contents {
    flex: 1 0 auto;
  }
</style>