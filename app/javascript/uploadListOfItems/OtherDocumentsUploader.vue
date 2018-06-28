<template>
  <div id="app">

    <file-uploader id="other_document_upload_document"
                   ref="documentUploader"
                    multiple
                   :drop-box="true"
                    :save-url="`${saveUrl}`"
                    method="post"
                    name="other_document_upload[document]"
                    v-on:before-upload="beforeUpload"
                    v-on:after-upload="afterUpload"
                    v-on:upload-error="uploadError" />

    <div class="row" v-if="other_document_uploads.length > 0">
      <div class="col-md-12">
        <h4>Added Documents</h4>

        <ul id="other-document-uploads-container" class="list-group">

          <li class="list-group-item
                     d-flex justify-content-between align-items-center"
              v-for="other_document_upload in other_document_uploads">

            <template v-if="other_document_upload.uploadState === STATUS_SAVING">
              <div>
                <span class="fa fa-spinner fa-spin mr-2"></span>
                <span class="mr-2">
                  {{ other_document_upload.original_file_name }}
                </span>
                <span>
                  {{ other_document_upload.size }}
                </span>
              </div>

              Processing...
            </template>

            <template
                v-else-if="other_document_upload.uploadState === STATUS_FAILED">
              <span class="mr-2">
                {{ other_document_upload.original_file_name }}
              </span>
              <span>
                {{ other_document_upload.error }}
              </span>

              <button class="btn btn-light btn-sm"
                      @click="$refs.documentUploader.save(other_document_upload)">
                Retry
              </button>
            </template>

            <template v-else>
              <a :href="other_document_upload.document.url"
                 target="blank">
                {{other_document_upload.original_file_name}}
              </a>
              <button class="btn btn-light btn-sm"
                      :disabled="other_document_upload.isDeleting"
                      @click="deleteDocument(other_document_upload)">
                {{ other_document_upload.isDeleting ? 'Deleting...' : 'Delete' }}
              </button>
            </template>
          </li>
        </ul>

      </div>
    </div>


  </div>
</template>

<script>
  import FileUploader from './FileUploader'
  export default {
    components: {FileUploader},
    props: ['tender', 'saveUrl'],

    data () {
      return {
        other_document_uploads: this.tender.other_document_uploads,
        STATUS_INITIAL: 0,
        STATUS_SAVING: 1,
        STATUS_SUCCESS: 2,
        STATUS_FAILED: 3,
      }
    },

    methods: {
      beforeUpload (value) {
        value.uploadState = this.STATUS_SAVING

        if (this.other_document_uploads.indexOf(value) === -1) {
          this.other_document_uploads.push(value)
        }

        console.log(value)
      },

      afterUpload (value) {
        value.uploadState = this.STATUS_SUCCESS
        this.other_document_uploads.splice(
          this.other_document_uploads.indexOf(value),
          1,
          value
        )
      },

      uploadError (value) {
        value.uploadState = this.STATUS_FAILED
        this.other_document_uploads.splice(
          this.other_document_uploads.indexOf(value),
          1,
          value
        )
      },

      deleteDocument (other_document_upload) {
        this.$set(other_document_upload, 'isDeleting', true)

        this.$http.delete(`${this.saveUrl}/${other_document_upload.id}`)
          .then(response => {
            this.other_document_uploads
              .splice(this.other_document_uploads.indexOf(other_document_upload), 1)
          })
          .catch(error => {
            console.error('error deleting document', error)
          })
          .finally(() => {
            this.$set(other_document_upload, 'isDeleting', false)
          })
      }

    }
  }
</script>