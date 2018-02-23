<template>
  <div id="app">
    <b-tabs @input="logIt">
      <b-tab :title="sheetName" v-for="(sheetName, index) in workbookData.SheetNames">
        <div id="example-container" class="wrapper" v-if="index === currentIndex">
          <HotTable :root="'test-hot'"
                    :colHeaders="true"
                    :dataSchema="dataSchema()"
                    :columns="columns()"
                    :cells="cells"
                    :mergeCells="mergeCells()"
                    :startRows="100"
                    :rowHeaders="true"
                    :minSpareRows="1"
                    :height="height()"
                    :fixedRowsTop="1"
                    :stretchH="'last'"
                    :colWidths="colWidths"
                    :formulas="true"
                    :readOnly="true"
                    :data="data(workbookData, index, currency, boqContractSum)" />
        </div>
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
  import HotTable from 'vue-handsontable-official';
  import {
    rowHeaderRenderer,
    descriptionRenderer,
    itemRenderer,
    isHeader,
    process_wb
  } from 'renderers'

  export default {
    props: [
      'workbookData',
      'currency',
      'qsCompanyName',
      'boqContractSum'
    ],
    components: {
      HotTable
    },
    data () {
      return {
        currentIndex: false
      }
    },
    methods: {
      logIt (tab_index) {
        this.currentIndex = tab_index
      },
      data (workBookData, sheetIndex, currency, boqContractSum) {
        let json = process_wb(workBookData, sheetIndex)
        console.log('workBookData', workBookData)

        let objectData = [
          {
            'item': 'Item',
            'description': 'Description',
            'quantity': 'Qty',
            'unit': 'Unit',
            'rate': `Rates (${currency})`,
            'amount': 'Amount'
          }
        ]

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

          rowData['amount'] = row[5]
          console.log('amount', rowData['amount'], typeof rowData['amount'])

          objectData.push(rowData)
        })
        return objectData
      },
      mergeCells () {
        return []
      },
      dataSchema () {
        return {
          'item': null,
          'description': null,
          'quantity': null,
          'unit': null,
          'rate': null,
          'amount': null,
          'last': null
        }
      },
      columns () {
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
            data: 'rate',
            type: 'numeric',
            numericFormat: {
              pattern: '0,0.00',
              culture: 'en-US' // this is the default culture, set up for USD
            },
            allowEmpty: false
          },
          {
            data: 'amount'
            // type: 'numeric',
            // numericFormat: {
            //   pattern: '0,0.00',
            //   culture: 'en-US' // this is the default culture, set up for USD
            // },
            // allowEmpty: false
          },
          {
            data: 'last'
          }
        ]
      },
      cells (row, col, prop) {
        const cellProperties = {}

        if (row === 0) {
          cellProperties.renderer = rowHeaderRenderer
        }  else if (row > 1 && col === 1) {
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
      height () {
        return window.innerHeight - (42 + 85 + 78)
      }
    }
  }
</script>

<style scoped>
  #test-hot {
    overflow: hidden;
  }
</style>