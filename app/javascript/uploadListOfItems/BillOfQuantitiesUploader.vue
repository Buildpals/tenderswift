<template>
  <div>

    <div class="d-flex justify-content-center mb-5">
      <b-btn v-b-modal.uploadExcelFileModal
             variant="primary">
        Upload excel file
      </b-btn>
    </div>

    <!-- Modal Component -->
    <b-modal id="uploadExcelFileModal"
             ref="uploadExcelFileModal"
             title="Bootstrap-Vue">

      <excel-file-uploader
          :save-url="`/request_for_tenders/${this.request_for_tender.id}/excel_file`"
          v-on:after-upload="afterUpload"
          v-on:upload-error="uploadError"/>

    </b-modal>


    <workbook :request_for_tender_id="request_for_tender.id"
                          v-model="workbook"/>


  </div>
</template>

<script>
  import Workbook from '../billOfQuantities/Workbook'
  import ExcelFileUploader from './ExcelFileUploader'

  export default {
    components: {ExcelFileUploader, Workbook},

    props: [
      'request_for_tender',
    ],

    data () {
      return {
        excelFile: this.request_for_tender.excel_file,
        workbook: this.request_for_tender.list_of_items
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
      }
    }
  }
</script>

<style lang="scss">

</style>