<template>
  <div id="app" class="spreadsheet-tabs">
    Estimated Tender Figure: <strong>{{ contractSum }}</strong>
    <b-tabs end no-fade @input="logIt">
      <b-tab :title="sheetName" v-for="(sheetName, index) in workbookData.SheetNames">
        <div id="example-container" class="wrapper" v-if="index === currentIndex">
            <upload-boq-sheet v-on:setContractSumAddress="setContractSumAddress"
                              :workbook="workbook"
                              :sheet-index="index"
                              :currency="currency"
                              :boqContractSum="boqContractSum">
            </upload-boq-sheet>
        </div>
      </b-tab>
    </b-tabs>
  </div>
</template>

<script>
  import UploadBoqSheet from './uploadBoqSheet'
  import {
    recalculateFormulas
  } from '../renderers'

  export default {
    props: [
      'requestForTenderId',
      'workbookData',
      'contractSumAddress',
      'currency',
      'qsCompanyName',
      'boqContractSum'
    ],
    components: {
      UploadBoqSheet
    },
    data () {
      return {
        currentIndex: false,
        workbook: recalculateFormulas(this.workbookData),
        contractSumSheet: this.contractSumAddress ? this.contractSumAddress.sheet : false,
        contractSumCellAddress: this.contractSumAddress ? this.contractSumAddress.cellAddress : false
      }
    },
    computed: {
      contractSum () {
        if (this.contractSumSheet && this.contractSumSheet) {
          let contractSumValue = this.workbook.Sheets[this.contractSumSheet][this.contractSumCellAddress].v
            .toLocaleString('en', {minimumFractionDigits: 2})
          return `${this.currency} ${contractSumValue} (${this.contractSumSheet}!${this.contractSumCellAddress})`
        } else {
          return ''
        }
      }
    },
    methods: {
      logIt (tab_index) {
        this.currentIndex = tab_index
      },
      setContractSumAddress (sheet, row, col) {
        let columnLetter = String.fromCharCode(65 + col)
        let cellAddress = `${columnLetter}${ row + 1 }`

        this.contractSumSheet = sheet
        this.contractSumCellAddress = cellAddress
        this.saveContractSumLocation(sheet, cellAddress)
      },
      saveContractSumLocation(sheet, cellAddress) {
        console.log('saving contract_sum_address', sheet, cellAddress)
        this.saveStatus = 'saving'
        this.$http.patch(`/tender/${this.requestForTenderId}/update/contract_sum_address`, {
            request_for_tender: {
              contract_sum_address: { sheet: sheet, cellAddress: cellAddress }
            }
          })
          .then(response => {
            console.log(response)
            this.saveStatus = 'saved'
          })
          .catch(error => {
            this.saveStatus = 'not_saved'
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