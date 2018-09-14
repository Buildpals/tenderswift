<template>
  <form method="POST" enctype="multipart/form-data"
        :id="`required_document-${requiredDocumentUpload.required_document.id}`">
    <div class="form-row d-flex justify-content-between align-items-center">
      <div class="col-md-7 mb-1 mb-md-0">
        <a :href="requiredDocumentUpload.document.url"
           target="blank">
          {{ requiredDocumentUpload.required_document.title }}
        </a>
      </div>

      <div class="col-md-5">
        <span v-if="uploading" class="fa fa-spinner fa-spin"></span>
        <div v-else>
          <input type="file"
                 class="input-file"
                 :name="`required_document_upload[${requiredDocumentUpload.required_document.id}][document]`"
                 :id="`required_document_upload_${requiredDocumentUpload.required_document.id}`"
                 @change="filesChange($event.target.name, $event.target.files, requiredDocumentUpload.id)"
                 accept=".pdf, .jpeg, .jpg, .png">
          <label class="btn btn-sm btn-block"
                 :class="{
                   'btn-outline-primary': requiredDocumentUpload.document.url,
                   'btn-primary': !requiredDocumentUpload.document.url
                 }"
                 :for="`required_document_upload_${requiredDocumentUpload.required_document.id}`">
            {{ requiredDocumentUpload.document.url ? 'Replace' : 'Upload file'}}
          </label>
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
      filesChange (fieldName, fileList, id) {
        if (!fileList.length) return
        Array.from(fileList)
          .map(file => this.updateRequiredDocumentUpload(file, id))
      },

      updateRequiredDocumentUpload: function (file, id) {
        this.uploading = true
        const formData = new FormData()
        formData.append('required_document_upload[document]', file)
        formData.append(
          'required_document_upload[required_document_id]',
          this.requiredDocumentUpload.required_document_id
        )

        let url = `/tenders/${this.requiredDocumentUpload.tender_id}/required_document_uploads`
        let method = 'post'
        if (id) {
          url =
            `/tenders/${this.requiredDocumentUpload.tender_id}/required_document_uploads/${id}`
          method = 'put'
        }
        this.$http[method](url, formData)
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

<style>
  .input-file {
    opacity: 0; /* invisible but it's there! */
    width: 0.1px;
    height: 0.1px;
    position: absolute;
    cursor: pointer;
  }

</style>