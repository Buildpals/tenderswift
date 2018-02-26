<template>
  <div id="app" class="spreadsheet-tabs">
    <b-tabs small end no-fade @input="logIt">
      <b-tab :title="sheetName" v-for="(sheetName, index) in workbook.SheetNames">
        <div id="example-container" class="wrapper" v-if="index === currentIndex">
            <rate-filling-boq-sheet v-on:edit="updateWorkbook"
                                    :workbook="workbook"
                                    :sheet-index="index"
                                    :currency="currency"
                                    :boqContractSum="boqContractSum">
            </rate-filling-boq-sheet>
        </div>
      </b-tab>
      <div class="d-flex justify-content-end" slot="tabs">
        <div>
          <button class="btn btn-sm btn-primary ml-auto my-1" @click="saveRates">Save</button>
        </div>
      </div>
    </b-tabs>
  </div>
</template>

<script>
  import RateFillingBoqSheet from './rateFillingBoqSheet'
  import {
    recalculateFormulas
  } from '../renderers'

  export default {
    props: [
      'participantId',
      'workbookData',
      'rates',
      'currency',
      'qsCompanyName',
      'boqContractSum'
    ],
    components: {
      RateFillingBoqSheet
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
      this.rates.forEach(rate => {
        let cellAddress = `E${ rate.row }`
        this.workbookData.Sheets[rate.sheet][cellAddress].v = rate.value
      })
      recalculateFormulas(this.workbookData)
      this.$set(this, 'workbook', this.workbookData)
    },
    methods: {
      logIt (tab_index) {
        this.currentIndex = tab_index
      },
      updateWorkbook (sheet, row, col, oldVal, newVal) {
        let cellAddress = `E${ row + 1 }`

        let temp = Object.assign({}, this.workbook)
        temp.Sheets[sheet][cellAddress].v = newVal
        recalculateFormulas(temp)

        this.workbook = {...temp}
      },
      saveRates() {
        let rates = []
        Object.keys(this.workbook.Sheets).forEach(sheetName => {
          let sheet = this.workbook.Sheets[sheetName]

          Object.keys(sheet)
            .filter(cellAddress => {
              return cellAddress[0] === 'E' && (typeof sheet[cellAddress].v === 'number')
            })
            .forEach(cellAddress => {
                rates.push({
                  sheet: sheetName,
                  row: cellAddress.slice(1),
                  value: sheet[cellAddress].v
                })
          })
        })

        console.log('saving rates...', rates)
        this.$http.post(`/participants/save_rates/${this.participantId}`, {rates: rates})
          .then(response => {
            console.log(response)
          })
          .catch(error => {
            console.error(error.message)
          })
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