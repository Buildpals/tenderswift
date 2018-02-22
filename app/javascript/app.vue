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
  import Handsontable from 'handsontable';
  import Vue from 'vue';


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
        let self = this
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
            'description': self.isHeader(row) ? `<strong>${row[1]}<strong>` : row[1],
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

      rowHeaderRenderer (instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments)
        td.style.textAlign = 'center'
        td.setAttribute('style', 'font-weight: bold; vertical-align: top; text-align: center')
      },

      companyHeaderRenderer (instance, td, row, col, prop, value, cellProperties) {
        let escaped = Handsontable.helper.stringify(value)
        escaped = this.strip_tags(escaped, '<div><br><strong><span>') //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
        td.innerHTML = escaped
        td.setAttribute('style', 'vertical-align: bottom; text-align: center')
        return td
      },

      descriptionRenderer (instance, td, row, col, prop, value, cellProperties) {
        let escaped = Handsontable.helper.stringify(value)
        escaped = this.strip_tags(escaped, '<div><br><strong><span>') //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
        td.innerHTML = escaped
        return td
      },

      itemRenderer (instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments)
        td.style.textAlign = 'center'
        td.setAttribute('style', 'text-align: center')
      },

      differenceValueRenderer (instance, td, row, col, prop, value, cellProperties) {
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
      },

      strip_tags (input, allowed) {
        const tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
          commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi

        // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
        allowed = (((allowed || '') + '').toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join('')

        return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
          return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : ''
        })
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

      isHeader (row) {
        if (row.length === 2 && row[0] === undefined && typeof row[1] === 'string') {
          return true
        } else {
          return false
        }
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
        let self = this

        let columns = [
          {
            data: 'item',
            renderer: this.itemRenderer
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
            renderer: this.itemRenderer
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
              renderer: self.differenceValueRenderer
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
          cellProperties.renderer = this.rowHeaderRenderer
        } else if (row === 1 && prop !== 'last') {
          cellProperties.renderer = this.companyHeaderRenderer
        } else if (row > 1 && col === 1) {
          cellProperties.renderer = this.descriptionRenderer
        }

        return cellProperties
      }
    }
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
  #test-hot {
    overflow: hidden;
  }
</style>