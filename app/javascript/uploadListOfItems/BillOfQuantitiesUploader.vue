<template>
  <div>

    <div v-if="hasWorkbook" class="mb-4">

      <div class="row align-items-baseline mb-2">
        <div class="col-md-6">
          <div v-b-modal.chooseTenderFigureAddress
               class="t">
            Your tender figure is
            <strong>{{ formatNumber(tenderFigure) }}</strong>
            from cell address
            <strong>{{ requestForTender.tender_figure_address }}</strong>
            <span class="fa fa-pencil ml-1"></span>
          </div>
        </div>
        <div class="col-md-4 ml-auto">
          <button class="btn btn-primary btn-sm btn-block" data-step="1"
                  data-intro="Upload an excel containing a list of items in the tender"
                  v-b-modal.uploadExcelFileModal>
            Upload new Bill of Quantities
          </button>
        </div>
      </div>

      <div class="text-center mb-1">
        {{ratesStatus}}
      </div>
      <div data-step="2"
           data-intro="Your uploaded bill of quantities is displayed here.
           Note, the contractor will not see your rates but will rather insert
           their own rates">
        <workbook :workbook="requestForTender.workbook"
                  :options="{editableRates: true}"
                  v-on:save-rates="saveRates"/>
      </div>
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

    <b-modal id="chooseTenderFigureAddress"
             ref="chooseTenderFigureAddress"
             hide-footer
             title="Select tender figure">
      <choose-tender-figure-address
        :initial-request-for-tender="requestForTender" />
    </b-modal>

  </div>
</template>

<script>
  import Workbook from '../billOfQuantities/Workbook'
  import ExcelFileUploader from './ExcelFileUploader'
  import { getRates } from '../utils'
  import TenderSwiftMixins from '../TenderSwiftMixins'
  import ChooseTenderFigureAddress from './ChooseTenderFigureAddress'
  import EventBus from '../EventBus'

  export default {
    mixins: [TenderSwiftMixins],

    components: {ChooseTenderFigureAddress, ExcelFileUploader, Workbook},

    props: [
      'initialRequestForTender'
    ],

    data () {
      return {
        requestForTender: this.initialRequestForTender,
        ratesStatus: '',
        tenderFigureAddressStatus: '',
        sheetNameForExcel: '',
        rowNumber: '',
        columnNumber: '',
        reload: ''
      }
    },

    mounted () {
      EventBus.$on('close-modal', this.hideModal)
      if(this.initialRequestForTender.sample == true){
        introJs().setOptions({
          exitOnOverlayClick: false
        }).start();
      }
    },

    computed: {
      tenderFigure () {
        const address = this.requestForTender.tender_figure_address
        if (!address) return '          '
        let address_of_cell = address.split('!')[1]
        let sheetName = address.split('!')[0]
        let worksheet = this.requestForTender.workbook.Sheets[sheetName]
        if (!worksheet) return undefined
        let desired_cell = worksheet[address_of_cell]
        return desired_cell ? desired_cell.v : 'No Value'
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
        //
        this.$refs.chooseTenderFigureAddress.show()

        this.reload = true
      },

      hideModal ({ tenderFigureAddress }) {
        console.log(tenderFigureAddress)
        this.$refs.chooseTenderFigureAddress.hide()
        if( this.reload == true){
          location.reload();
        }
        this.reload = false
      },


      uploadError (value) {
        // TODO: Handle error
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

  .t:hover {
    text-decoration: underline;
    cursor: pointer;
  }
</style>