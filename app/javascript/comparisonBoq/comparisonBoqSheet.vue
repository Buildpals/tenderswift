<template>
  <div id="hot">
  </div>
</template>

<script>
  import Handsontable from 'handsontable';
  import {
    rowHeaderRenderer,
    descriptionRenderer,
    itemRenderer,
    isHeader,
    process_wb_comparison
  } from '../renderers'

  export default {
    props: [
      'participants',
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
        height: window.innerHeight - (42 + 85 + 78),
        mergeCells: []
      }
    },
    computed: {
      dataSchema () {
        let participantKeys = {}
        this.participants.forEach(participant => {
          let amountKey = `amount (${participant.company_name})`
          participantKeys[amountKey] = null
        })
        return {
          'item': null,
          'description': null,
          'quantity': null,
          'unit': null,
          'amount': null,
          ...participantKeys,
          'last': null
        }
      },
      columns () {
        let participantKeys = []
        this.participants.forEach(participant => {
          let amountKey = `amount (${participant.company_name})`
          participantKeys.push({
            data: amountKey,
            type: 'numeric',
            numericFormat: {
              pattern: '0,0.00',
              culture: 'en-US'
            },
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
          ...participantKeys,
          {
            data: 'last'
          }
        ]
      },
      sheetData () {
        return process_wb_comparison(this.workbook, this.sheetIndex, this.participants)
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