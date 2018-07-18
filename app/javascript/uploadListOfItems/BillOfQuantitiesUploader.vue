<template>
  <div>
    <div class="d-flex justify-content-center mb-5">
      <b-btn v-b-modal.uploadExcelFileModal
             variant="primary">
        Upload an excel file
      </b-btn>
    </div>
    <b-modal id="uploadExcelFileModal"
             ref="uploadExcelFileModal"
             hide-footer
             title="Upload your Bill of Quantities">

      <excel-file-uploader
          :save-url="`/request_for_tenders/${this.request_for_tender.id}/excel_file`"
          v-on:after-upload="afterUpload"
          v-on:upload-error="uploadError"/>

    </b-modal>

    <div class="row">
      <div class="col-md-6">
        <p>
          <input class="form-control"
                 placeholder="Enter the cell address of your tender figure"
                 v-model="tenderFigureAddress"
                 name="tenderFigure"
                 @change="onchange"/>
        </p>
      </div>
      <div class="col-md-6">
        <p>
          Tender value is GHC: <span class="font-weight-bold">{{ desired_value }}</span>
        </p>
      </div>
    </div>

    <workbook :workbook="workbook"/>


  </div>
</template>

<script>
  import Workbook from '../billOfQuantities/Workbook'
  import ExcelFileUploader from './ExcelFileUploader'

  export default {
    components: {ExcelFileUploader, Workbook},

    props: [
      'request_for_tender'
    ],

    data () {
      return {
        desired_value: '',
        excelFile: this.request_for_tender.excel_file,
        workbook: this.getWorkbook(),
        tenderFigureAddress: this.request_for_tender.tender_figure_address
      }
    },

    methods: {
      getWorkbook () {
        if (this.request_for_tender.list_of_items) {
          return this.request_for_tender.list_of_items
        } else {
          return {
            Sheets: {},
            SheetNames: []
          }
        }
      },

      afterUpload (value) {
        // FIXME: the workbook is not getting set
        this.workbook = value
        this.$refs.uploadExcelFileModal.hide()
      },

      uploadError (value) {
        value.uploadState = this.STATUS_FAILED
        this.excelFile = value
      },
      onchange (event) {
        const address = event.target.value
        let address_of_cell = address.split('!')[1]
        let sheetName = address.split('!')[0]
        let worksheet = this.workbook.Sheets[sheetName]
        let desired_cell = worksheet[address_of_cell]
        this.desired_value = desired_cell ? desired_cell.v : undefined
        this.$http.patch(
          `/request_for_tenders/${this.request_for_tender.id}` +
          `/build/bill_of_quantities`,
          {
            request_for_tender: {
              tender_figure_address: address
            }
          })
          .then(response => {
            // TODO: Provide feedback to the user that the value has been saved
          })
          .catch(error => {
            console.error(error)
          })
      }
    }
  }
</script>

<style lang="scss">

</style>