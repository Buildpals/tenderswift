<template>
  <div>

    <div v-if="hasWorkbook" class="mb-4">

      <div class="d-flex justify-content-start align-items-baseline mb-2">
        Please enter the cell address of your tender figure:

        <div class="ml-2">
          <div class="input-group input-group-sm">
            <input type="text"
                   class="form-control"
                   placeholder="Tender figure address"
                   v-model.lazy="requestForTender.tender_figure_address"
                   @change="saveTenderFigureAddress">
            <div class="input-group-append">
          <span class="input-group-text amount"
                id="tenderFigure">
            {{ formatNumber(tenderFigure) }}
          </span>
            </div>
          </div>
        </div>

        <div class="ml-auto">
          <b-btn v-b-modal.uploadExcelFileModal
                 size="sm"
                 variant="primary">
            Upload new Bill of Quantities
          </b-btn>
        </div>
      </div>

      <div class="text-center mb-1">
        {{ratesStatus}}
      </div>

      <workbook :workbook="requestForTender.workbook"
                :options="{editableRates: true}"
                v-on:save-rates="saveRates"/>

    </div>

    <div v-else class="wrapper">

      <p class="centered-div text-center">

        You have not uploaded a Bill of Quantities yet,
        <br>
        click the button below to upload one.
        <br>
        <br>

        <b-btn v-b-modal.uploadExcelFileModal
               size="sm"
               variant="primary">
          Upload your Bill of Quantities
        </b-btn>

      </p>

    </div>

    <b-modal id="uploadExcelFileModal"
             ref="uploadExcelFileModal"
             hide-footer
             title="Upload your Bill of Quantities">

      <excel-file-uploader
          :save-url="`/request_for_tenders/${requestForTender.id}/excel_file`"
          v-on:after-upload="afterUpload"
          v-on:upload-error="uploadError"/>

    </b-modal>

  </div>
</template>

<script>
  import Workbook from '../billOfQuantities/Workbook'
  import ExcelFileUploader from './ExcelFileUploader'
  import { getRates } from '../utils'
  import TenderSwiftMixins from '../TenderSwiftMixins'

  export default {
    mixins: [TenderSwiftMixins],

    components: {ExcelFileUploader, Workbook},

    props: [
      'initialRequestForTender'
    ],

    data () {
      return {
        requestForTender: this.initialRequestForTender,
        ratesStatus: '',
        tenderFigureAddressStatus: ''
      }
    },

    computed: {
      tenderFigure () {
        const address = this.requestForTender.tender_figure_address
        if (!address) return '          '

        let address_of_cell = address.split('!')[1]
        let sheetName = address.split('!')[0]

        let worksheet = this.requestForTender.workbook.Sheets[sheetName]
        let desired_cell = worksheet[address_of_cell]
        return desired_cell ? desired_cell.v : undefined
      },

      hasWorkbook () {
        return this.requestForTender.workbook &&
          this.requestForTender.workbook.Sheets &&
          Object.keys(this.requestForTender.workbook.Sheets).length > 0
      }
    },

    methods: {
      afterUpload (value) {
        // FIXME: the workbook is not getting set
        console.log('after-upload', value.Sheets)
        this.requestForTender.workbook = value
        console.log('after-upload2', value.Sheets)

        this.$refs.uploadExcelFileModal.hide()
      },

      uploadError (value) {
        // TODO: Handle error
      },

      saveTenderFigureAddress () {
        this.tenderFigureAddressStatus = 'Saving...'

        let url = `/request_for_tenders/${this.requestForTender.id}` +
          `/build/bill_of_quantities`

        this.$http.patch(url, {
          request_for_tender: {
            tender_figure_address: this.requestForTender.tender_figure_address
          }
        }).then(response => {
          this.tenderFigureAddressStatus =
            'All changes saved to TenderSwift\'s servers'
        }).catch(error => {
          this.tenderFigureAddressStatus =
            'Error saving changes'
          console.error(error)
        })
      },

      saveRates (workbook) {
        this.ratesStatus = 'Saving...'

        this.requestForTender.version_number++
        let rates = getRates(workbook)

        let url = `/request_for_tenders/${this.requestForTender.id}` +
          `/build/bill_of_quantities`

        this.$http.put(url, {
          request_for_tender: {
            list_of_rates: rates,
            version_number: this.requestForTender.version_number
          }
        }).then(response => {
          this.ratesStatus = 'All changes saved to TenderSwift\'s servers'
        }).catch(error => {
          this.ratesStatus = 'Error saving changes'
          console.error(error)
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .amount {
    width: 5.62rem;
  }

  .wrapper {
    margin: 0 auto;
    height: 500px;
  }

  .centered-div {
    position: relative;
    top: 33.33%;
    transform: perspective(1px) translateY(-50%);
    padding: 30px;
  }
</style>