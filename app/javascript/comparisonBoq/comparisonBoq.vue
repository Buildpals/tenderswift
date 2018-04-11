<template>
  <div id="app" class="spreadsheet-tabs">
    <b-tabs end no-fade @input="logIt">
      <b-tab :title="sheetName" v-for="(sheetName, index) in workbook.SheetNames">
        <div id="example-container" class="wrapper" v-if="index === currentIndex">
            <comparison-boq-sheet v-on:edit="updateWorkbook"
                              :tenders="tenders"
                              :workbook="workbook"
                              :sheet-index="index"
                              :currency="currency"
                              :boqContractSum="boqContractSum">
            </comparison-boq-sheet>
        </div>
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
  import ComparisonBoqSheet from './comparisonBoqSheet'
  import {
    recalculateFormulas
  } from '../renderers'

  export default {
    props: [
      'tenders',
      'workbookData',
      'currency',
      'qsCompanyName',
      'boqContractSum'
    ],
    components: {
      ComparisonBoqSheet
    },
    data () {
      return {
        currentIndex: false,
        workbook: {
          SheetNames: []
        }
      }
    },
    created () {
      let i = 6
      this.tenders.forEach((tender) => {
        console.log('======================================================')

        let newRateColumn = String.fromCharCode(65 + i++)
        let newAmountColumn = String.fromCharCode(65 + i++)

        Object.keys(this.workbookData.Sheets).forEach(sheetName => {
          let sheet = this.workbookData.Sheets[sheetName]

          Object.keys(sheet)
            .forEach(cellAddress => {

              let column, row
              let result = /^([E-F])(\d+)$/.exec(cellAddress)

              if (result) {
                column = result[1]
                row = result[2]

                if (column === 'E') {
                  let newRateAddress = `${newRateColumn}${ row }`
                  let rate = tender.rates.find(r => {
                    return r.sheet === sheetName && cellAddress === `E${ r.row }`
                  })
                  if (rate) {
                    this.workbookData.Sheets[sheetName][newRateAddress] = {
                      ...this.workbookData.Sheets[sheetName][cellAddress],
                      v: rate.value
                    }
                  }  else {
                    this.workbookData.Sheets[sheetName][newRateAddress] = {...this.workbookData.Sheets[sheetName][cellAddress]}
                  }
                  if (this.workbookData.Sheets[sheetName][newRateAddress].f) {
                    this.workbookData.Sheets[sheetName][newRateAddress].f = this.workbookData.Sheets[sheetName][newRateAddress].f.replace(/(E)(\d+)/g, `${newRateColumn}$2`)
                    this.workbookData.Sheets[sheetName][newRateAddress].f = this.workbookData.Sheets[sheetName][newRateAddress].f.replace(/(F)(\d+)/g, `${newAmountColumn}$2`)
                  }
                  console.log(cellAddress, this.workbookData.Sheets[sheetName][cellAddress], 'to', newRateAddress, this.workbookData.Sheets[sheetName][newRateAddress])
                } else if (column === 'F') {
                  let newAmountAddress = `${newAmountColumn}${ row }`
                  this.workbookData.Sheets[sheetName][newAmountAddress] = { ...this.workbookData.Sheets[sheetName][cellAddress]}
                  if (this.workbookData.Sheets[sheetName][newAmountAddress].f) {
                    this.workbookData.Sheets[sheetName][newAmountAddress].f = this.workbookData.Sheets[sheetName][newAmountAddress].f.replace(/(E)(\d+)/g, `${newRateColumn}$2`)
                    this.workbookData.Sheets[sheetName][newAmountAddress].f = this.workbookData.Sheets[sheetName][newAmountAddress].f.replace(/(F)(\d+)/g, `${newAmountColumn}$2`)
                  }
                  console.log(cellAddress, this.workbookData.Sheets[sheetName][cellAddress], 'to', newAmountAddress, this.workbookData.Sheets[sheetName][newAmountAddress])
                }
              } else {
                return
              }
            })
        })
      })

      recalculateFormulas(this.workbookData)
      this.$set(this, 'workbook', this.workbookData)
    },
    methods: {
      logIt (tab_index) {
        this.currentIndex = tab_index
      },
      updateWorkbook (row, col, oldVal, newVal) {
        let cellAddress = `E${ row + 1 }`

        let temp = Object.assign({}, this.workbook)

        temp.Sheets['Sheet1'][cellAddress].v = newVal
        recalculateFormulas(temp)

        this.workbook = {...temp}
      }
    }
  }
</script>

<style lang="scss">
    .spreadsheet-tabs {
        .nav-tabs {
            /*border-bottom: 1px solid #dee2e6;*/
            /*border-top: 1px solid #dee2e6;*/
            border: 1px solid #dee2e6;
            padding-left: 0.5rem;
            padding-right: 0.5rem;
            padding-bottom: 0.2rem;
        }

        .nav-tabs .nav-item {
            margin-top: -1px;
        }

        .nav-tabs .nav-link {
            border: 1px solid transparent;

            border-top-left-radius: initial;
            border-top-right-radius: initial;

            border-bottom-left-radius: 0.15rem;
            border-bottom-right-radius: 0.15rem;
        }

        .nav-tabs .nav-link:hover, .nav-tabs .nav-link:focus {
            border-color: #e9ecef #e9ecef #dee2e6;
        }

        .nav-tabs .nav-link.active,
        .nav-tabs .nav-item.show .nav-link {
            color: #495057;
            background-color: #fff;
            border-color: #fff #dee2e6 #dee2e6;
        }
    }
</style>