<template>
  <form method="POST"  enctype="multipart/form-data">
    <div class="form-row d-flex justify-content-between align-items-center">
      <div class="col-md-7 mb-1 mb-md-0">
        <a :href="requiredDocumentUpload.document.url"
           target="blank">
          {{ requiredDocumentUpload.required_document.title }}
        </a>
      </div>

      <div class="col-md-5">
        <span v-if="uploading" class="fa fa-spinner fa-spin"></span>
        <a v-else-if="requiredDocumentUpload.document.url"
           :href="requiredDocumentUpload.document.url" target="_blank">
          View
        </a>

        <div v-else>
          <b-form-file
              small
              :state="Boolean(errors == false)"
              v-model="file"
              v-on:input="fileChanged"
              class="required_document_upload_file_input"
              placeholder="Choose a file..."></b-form-file>
          <div v-for="error in errors">
            {{ error }}
          </div>
        </div>

      </div>
    </div>
  </form>
</template>

<script>
  export default {
    props: [
      'required_document_upload',
    ],

    data () {
      return {
        requiredDocumentUpload: this.required_document_upload,
        file: null,
        uploading: false,
        errors: false
      }
    },

    methods: {
      fileChanged (file) {
        this.updateRequiredDocumentUpload(file)
      },

      updateRequiredDocumentUpload: function (file) {
        this.uploading = true
        const formData = new FormData()
        formData.append('required_document_upload[document]',  file)
        formData.append(
          'required_document_upload[required_document_id]',
          this.requiredDocumentUpload.required_document_id
        )

        this.$http.post(
          `/tenders/${this.requiredDocumentUpload.tender_id}/required_document_uploads`,
          formData)
          .then(response => {
            this.requiredDocumentUpload.document.url =
              response.body.document.url
          })
          .catch(error => {
            this.errors = Object.keys(error.body).map(key => {
              return `${key} ${error.body[key].join(', ')}`
            })
          })
          .finally(() => {
            this.uploading = false
          })
      }
    }
  }
</script>