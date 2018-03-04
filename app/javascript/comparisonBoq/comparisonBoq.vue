<template>
  <div id="app" class="spreadsheet-tabs">
    <b-tabs end no-fade @input="logIt">
      <b-tab :title="sheetName" v-for="(sheetName, index) in workbook.SheetNames">
        <div id="example-container" class="wrapper" v-if="index === currentIndex">
            <comparison-boq-sheet v-on:edit="updateWorkbook"
                              :participants="participants"
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
      'participants',
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
      this.participants.forEach((participant) => {

        let ratesHash = {}

        let newRateColumn = String.fromCharCode(65 + i++)
        let newAmountColumn = String.fromCharCode(65 + i++)

        participant.rates.forEach(rate => {
          let newRateAddress = `${newRateColumn}${ rate.row }`
          let newAmountAddress = `${newAmountColumn}${ rate.row }`
          console.log('address', newRateAddress, newAmountAddress)
          this.workbookData.Sheets[rate.sheet][newRateAddress] = { ...this.workbookData.Sheets[rate.sheet][`E${rate.row}`], v: rate.value}
          this.workbookData.Sheets[rate.sheet][newAmountAddress] = { ...this.workbookData.Sheets[rate.sheet][`F${rate.row}`] }
          this.workbookData.Sheets[rate.sheet][newAmountAddress].f = this.workbookData.Sheets[rate.sheet][newAmountAddress].f.replace(/(E)(\d+)/g, `${newRateColumn}$2`)

          ratesHash[`E${rate.row}`] = rate
        })

        console.log(ratesHash)
        let rates = []
        Object.keys(this.workbook.Sheets).forEach(sheetName => {
          let sheet = this.workbook.Sheets[sheetName]

          Object.keys(sheet)
            .forEach(cellAddress => {



              if (cellAddress[0] === 'E' && (typeof sheet[cellAddress].v === 'number')) {

              } else {

              }


              rates.push({
                sheet: sheetName,
                row: cellAddress.slice(1),
                value: sheet[cellAddress].v
              })
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