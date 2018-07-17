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
              @change="onchange" />
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
        workbook: {
          Sheets: {},
          SheetNames: []
        },
        tenderFigureAddress: this.request_for_tender.tender_figure_address
      }
    },

    mounted () {
      if (this.request_for_tender.list_of_items) {
        this.workbook = this.request_for_tender.list_of_items
      }
    },

    methods: {
      afterUpload (value) {
        this.workbook = value
        this.$refs.uploadExcelFileModal.hide()
      },

      uploadError (value) {
        value.uploadState = this.STATUS_FAILED
        this.excelFile = value
      },
      onchange (evt) { 
        const address = document.querySelector("input[name=tenderFigure]").value
        let address_of_cell =  address.split("!")[1];
        let sheetName = address.split("!")[0];
        let worksheet = this.workbook.Sheets[sheetName];
        let desired_cell = worksheet[address_of_cell]; 
        this.desired_value = (desired_cell ? desired_cell.w : undefined);
        this.$http.patch(`/request_for_tenders/${this.request_for_tender.id}/build/bill_of_quantities`, 
        {
          request_for_tender: {
            tender_figure_address: address
          }
        })
          .then(response => {
            //console.log()
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