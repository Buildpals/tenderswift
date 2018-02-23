<template>
  <div id="app">
    <b-tabs @input="logIt">
      <b-tab :title="sheetName" v-for="(sheetName, index) in workbookData.SheetNames">
        <div id="example-container" class="wrapper" v-if="index === currentIndex">
          <HotTable :root="'test-hot'"
                    :colHeaders="true"
                    :dataSchema="dataSchema(participants)"
                    :columns="columns(participants)"
                    :cells="cells"
                    :mergeCells="mergeCells(participants)"
                    :startRows="100"
                    :rowHeaders="true"
                    :minSpareRows="1"
                    :height="height()"
                    :fixedRowsTop="2"
                    :stretchH="'last'"
                    :colWidths="colWidths"
                    :formulas="true"
                    :readOnly="true"
                    :data="data(workbookData, 0, currency, qsCompanyName, boqContractSum, participants)" />
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
    differenceValueRenderer,
    companyHeaderRenderer,
    isHeader,
    process_wb
  } from 'renderers'

  export default {
    props: [
      'workbookData',
      'currency',
      'qsCompanyName',
      'boqContractSum',
      'participants'
    ],
    components: {
      HotTable
    },
    data () {
      return {
        message: "Hello Vue!",
        currentIndex: false
      }
    },
    methods: {
      logIt (tab_index) {
        this.currentIndex = tab_index
      },
      data (workBookData, sheetidx, currency, qsCompanyName, boqContractSum, participants) {
        let json = process_wb(workBookData, sheetidx)
        console.log('workBookData', workBookData)

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
          'rate': `<div>${qsCompanyName}<br><span class="small">${currency}${boqContractSum.toLocaleString('en', {minimumFractionDigits: 2})}</span></div>`
        }

        if (participants.length === 0) {
          headerRow['amount'] =
            `<div>Amount<br><span class="small">${currency}${boqContractSum.toLocaleString('en', {minimumFractionDigits: 2})}</span></div>`
        } else {
          participants.forEach(function (participant) {
            headerRow[participant.company_name] =
              `<div>${participant.company_name} <br> <span class="small">${currency}${(100001).toLocaleString('en')}</span></div>`
          })
        }

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

          if (participants.length === 0) {
            rowData['amount'] = row[5]
            console.log('amount', rowData['amount'], typeof rowData['amount'])
          } else {
            participants.forEach(function (participant) {
              let rate = participant.rates.find(function (rate) {
                return (rate.row_number - 1) === rowNumber
                  && rate.sheet_name === workBookData.SheetNames[sheetidx]
              })

              if (rate) {
                rowData[participant.company_name] = rate.value
              }
            })
          }

          objectData.push(rowData)
        })
        return objectData
      },
      mergeCells (participants) {
        return [
          {row: 0, col: 0, rowspan: 2, colspan: 1},
          {row: 0, col: 1, rowspan: 2, colspan: 1},
          {row: 0, col: 2, rowspan: 2, colspan: 1},
          {row: 0, col: 3, rowspan: 2, colspan: 1},
          {row: 0, col: 4, rowspan: 1, colspan: participants.length + 1}
        ]
      },
      dataSchema (participants) {
        let dataSchema = {
          'item': null,
          'description': null,
          'quantity': null,
          'unit': null,
          'rate': null
        }

        if (participants.length === 0) {
          dataSchema['amount'] = null
        } else {
          participants.forEach(participant => dataSchema[participant.company_name] = null)
        }

        dataSchema['last'] = null
        return dataSchema
      },
      columns (participants) {
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

        if (participants.length === 0) {
          columns.push({
            data: 'amount'
            // type: 'numeric',
            // numericFormat: {
            //   pattern: '0,0.00',
            //   culture: 'en-US' // this is the default culture, set up for USD
            // },
            // allowEmpty: false
          })
        } else {
          participants.forEach(participant => {
            columns.push({
              data: participant.company_name,
              renderer: differenceValueRenderer
            })
          })
        }

        columns.push({
          data: 'last'
        })
        return columns
      },
      cells (row, col, prop) {
        const cellProperties = {}

        if (row === 0) {
          cellProperties.renderer = rowHeaderRenderer
        } else if (row === 1 && prop !== 'last') {
          cellProperties.renderer = companyHeaderRenderer
        } else if (row > 1 && col === 1) {
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