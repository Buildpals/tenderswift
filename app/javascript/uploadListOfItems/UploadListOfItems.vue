<template>
  <div id="app">

    <div class="d-flex justify-content-center mt-2 mb-3">
      <b-form-radio-group id="uploadSelector"
                          buttons
                          button-variant="outline-dark"
                          size="sm"
                          v-model="selected"
                          :options="options"
                          name="uploadSelector"/>
    </div>

    <create-list-of-items v-show="selected === '0'"
                          :request_for_tender_id="request_for_tender.id"
                          :list_of_items="request_for_tender.list_of_items" />

    <div  v-show="selected === '1'">
      <p class="text-muted small">
        Please upload your completely FILLED Bill Of Quantities in .xls or
        .xlsx format.
        <br>
        Then right click on the cell in the bill of quantities containing the
        estimated tender figure for the project.
        <br>

        <strong>
          NB: Columns A, B, C, D, E and F should be Item, Description, Quantity,
          Unit, Rate and Amount respectively.
        </strong>
        <br>

        <strong>
          Please note that your rates and estimated tender figure are private, and
          will NEVER be displayed to any contractor.
        </strong>
      </p>

      <file-uploader ref="excelUploader"
                      :save-url="`/request_for_tenders/${this.request_for_tender.id}/excel_file`"
                      method="post"
                      name="excel_file[document]"
                      v-on:before-upload="beforeUpload"
                      v-on:after-upload="afterUpload"
                      v-on:upload-error="uploadError" />

      <div class="row">
        <div class="col-lg-8">
          <h4>Uploaded file</h4>

          <ul class="list-group" v-if="excelFile">

            <li class="list-group-item
                     d-flex justify-content-between align-items-center">

              <template v-if="excelFile.uploadState === STATUS_SAVING">
                <div>
                  <span class="fa fa-spinner fa-spin mr-2"></span>
                  <span class="mr-2">
                  {{ excelFile.original_file_name }}
                </span>
                  <span>
                  {{ excelFile.size }}
                </span>
                </div>

                Uploading...
              </template>

              <template
                  v-else-if="excelFile.uploadState === STATUS_FAILED">
              <span class="mr-2">
                {{ excelFile.original_file_name }}
              </span>
                <span>
                {{ excelFile.error }}
              </span>

                <button class="btn btn-light btn-sm"
                        @click="$refs.excelUploader.save(excelFile)">
                  Retry
                </button>
              </template>

              <template v-else>
                <a :href="excelFile.document.url"
                   target="blank">
                  {{excelFile.original_file_name}}
                </a>
                <button class="btn btn-light btn-sm"
                        :disabled="excelFile.isDeleting"
                        @click="deleteDocument(excelFile)">
                  {{ excelFile.isDeleting ? 'Deleting...' : 'Delete' }}
                </button>
              </template>
            </li>
          </ul>

        </div>
      </div>

      <pre class="mt-4">{{ excelFile }}</pre>

    </div>

  </div>
</template>

<script>
  import CreateListOfItems from './CreateListOfItems'
  import FileUploader from './FileUploader'

  export default {
    components: {FileUploader, CreateListOfItems},

    props: [
      'request_for_tender',
    ],

    data () {
      return {
        excelFile: this.request_for_tender.excel_file,
        selected: "0",
        options: {0: 'Create a list of items', 1: 'Upload an excel sheet'},
        STATUS_INITIAL: 0,
        STATUS_SAVING: 1,
        STATUS_SUCCESS: 2,
        STATUS_FAILED: 3,
      }
    },

    methods: {
      beforeUpload (value) {
        value.uploadState = this.STATUS_SAVING
        this.excelFile = value
      },

      afterUpload (value) {
        value.uploadState = this.STATUS_SUCCESS
        this.excelFile = value
      },

      uploadError (value) {
        value.uploadState = this.STATUS_FAILED
        this.excelFile = value
      },

      deleteDocument (excelFile) {
        this.$set(excelFile, 'isDeleting', true)

        this.$http.delete(
          `/request_for_tenders/${this.request_for_tender.id}/excel_file`
        )
          .then(response => {
            this.excelFile = null
          })
          .catch(error => {
            console.error('error deleting document', error)
          })
          .finally(() => {
            this.$set(excelFile, 'isDeleting', false)
          })
      }
    }
  }
</script>

<style lang="scss">

</style>