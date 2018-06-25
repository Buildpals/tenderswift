<template>
  <div id="app">

    <excel-uploader id="project_document_document"
                    ref="documentUploader"
                    multiple
                    :save-url="`${save_url}`"
                    method="post"
                    name="project_document[document]"
                    v-on:before-upload="beforeUpload"
                    v-on:after-upload="afterUpload"
                    v-on:upload-error="uploadError" />

    <div class="row">
      <div class="col-lg-8">
        <h4>Added Documents</h4>

        <ul id="project-documents-container"
            class="list-group">

          <li class="list-group-item
                     d-flex justify-content-between align-items-center"
              v-for="project_document in project_documents">

            <template v-if="project_document.uploadState === STATUS_SAVING">
              <div>
                <span class="fa fa-spinner fa-spin mr-2"></span>
                <span class="mr-2">
                  {{ project_document.original_file_name }}
                </span>
                <span>
                  {{ project_document.size }}
                </span>
              </div>

              Processing...
            </template>

            <template
                v-else-if="project_document.uploadState === STATUS_FAILED">
              <span class="mr-2">
                {{ project_document.original_file_name }}
              </span>
              <span>
                {{ project_document.error }}
              </span>

              <button class="btn btn-light btn-sm"
                      @click="$refs.documentUploader.save(project_document)">
                Retry
              </button>
            </template>

            <template v-else>
              <a :href="project_document.document.url"
                 target="blank">
                {{project_document.original_file_name}}
              </a>
              <button class="btn btn-light btn-sm"
                      :disabled="project_document.isDeleting"
                      @click="deleteDocument(project_document)">
                {{ project_document.isDeleting ? 'Deleting...' : 'Delete' }}
              </button>
            </template>
          </li>
        </ul>

      </div>
    </div>


  </div>
</template>

<script>
  import ExcelUploader from './FileUploader'
  export default {
    components: {ExcelUploader},
    props: ['request_for_tender', 'save_url'],

    data () {
      return {
        project_documents: this.request_for_tender.project_documents,
        STATUS_INITIAL: 0,
        STATUS_SAVING: 1,
        STATUS_SUCCESS: 2,
        STATUS_FAILED: 3,
      }
    },

    methods: {
      beforeUpload (value) {
        value.uploadState = this.STATUS_SAVING

        if (this.project_documents.indexOf(value) === -1) {
          this.project_documents.push(value)
        }

        console.log(value)
      },

      afterUpload (value) {
        value.uploadState = this.STATUS_SUCCESS
        this.project_documents.splice(
          this.project_documents.indexOf(value),
          1,
          value
        )
      },

      uploadError (value) {
        value.uploadState = this.STATUS_FAILED
        this.project_documents.splice(
          this.project_documents.indexOf(value),
          1,
          value
        )
      },

      deleteDocument (project_document) {
        this.$set(project_document, 'isDeleting', true)

        this.$http.delete(`${this.save_url}/${project_document.id}`)
          .then(response => {
            this.project_documents
              .splice(this.project_documents.indexOf(project_document), 1)
          })
          .catch(error => {
            console.error('error deleting document', error)
          })
          .finally(() => {
            this.$set(project_document, 'isDeleting', false)
          })
      }

    }
  }
</script>