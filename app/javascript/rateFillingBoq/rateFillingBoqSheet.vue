<template>
  <div>
    <div id="hot"></div>
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
            allowEmpty: false,
            readOnly: false
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
        height: window.innerHeight - (42 + 190),
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
        this.table = new Handsontable(this.$el, {
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
          afterChange: this.afterChange
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
      },
      afterChange (changes, source) {
        if (source === 'loadData') return

        changes.forEach((change) => {
          let row = change[0];
          let col = change[1];
          let oldVal = change[2];
          let newVal = change[3];

          this.$emit('edit', row, col, oldVal, newVal)
        })

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