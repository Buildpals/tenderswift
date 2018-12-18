<template>
  <div>

    <file-uploader id="project_document_document"
                   ref="documentUploader"
                   multiple
                   :save-url="`${saveUrl}`"
                   method="post"
                   name="project_document[document]"
                   :request-for-tender="requestForTender"
                   v-on:before-upload="beforeUpload"
                   v-on:after-upload="afterUpload"
                   v-on:upload-error="uploadError"/>

    <div class="row" v-if="projectDocuments.length > 0">
      <div class="col-lg-8">
        <h4>Added Documents</h4>

        <ul id="project-documents-container"
            class="list-group">

          <li class="list-group-item
                     d-flex justify-content-between align-items-center"
              v-for="projectDocument in projectDocuments">

            <template v-if="projectDocument.uploadState === STATUS_SAVING">
              <div>
                <span class="fa fa-spinner fa-spin mr-2"></span>
                <span class="mr-2">
                  {{ projectDocument.original_file_name }}
                </span>
                <span>
                  {{ projectDocument.size }}
                </span>
              </div>

              Processing...
            </template>

            <template
                v-else-if="projectDocument.uploadState === STATUS_FAILED">
              <span class="mr-2">
                {{ projectDocument.original_file_name }}
              </span>
              <span>
                {{ projectDocument.error }}
              </span>

              <button class="btn btn-light btn-sm"
                      @click="$refs.documentUploader.save(projectDocument)">
                Retry
              </button>
            </template>

            <template v-else>
              <a :href="projectDocument.document.url"
                 target="blank">
                {{projectDocument.original_file_name}}
              </a>
              <button class="btn btn-light btn-sm"
                      :disabled="projectDocument.isDeleting"
                      @click="deleteDocument(projectDocument)">
                {{ projectDocument.isDeleting ? 'Deleting...' : 'Delete' }}
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
    props: ['initialProjectDocuments', 'saveUrl', 'initialRequestForTender'],

    data () {
      return {
        projectDocuments: this.initialProjectDocuments,
        requestForTender: this.initialRequestForTender,
        STATUS_INITIAL: 0,
        STATUS_SAVING: 1,
        STATUS_SUCCESS: 2,
        STATUS_FAILED: 3,
      }
    },

    methods: {
      beforeUpload (value) {
        value.uploadState = this.STATUS_SAVING

        if (this.projectDocuments.indexOf(value) === -1) {
          this.projectDocuments.push(value)
        }

        console.log(value)
      },

      afterUpload (value) {
        value.uploadState = this.STATUS_SUCCESS
        this.projectDocuments.splice(
          this.projectDocuments.indexOf(value),
          1,
          value
        )
      },

      uploadError (value) {
        value.uploadState = this.STATUS_FAILED
        this.projectDocuments.splice(
          this.projectDocuments.indexOf(value),
          1,
          value
        )
      },

      deleteDocument (projectDocument) {
        this.$set(projectDocument, 'isDeleting', true)

        this.$http.delete(`${this.saveUrl}/${projectDocument.id}`)
          .then(response => {
            this.projectDocuments
              .splice(this.projectDocuments.indexOf(projectDocument), 1)
          })
          .catch(error => {
            console.error('error deleting document', error)
          })
          .finally(() => {
            this.$set(projectDocument, 'isDeleting', false)
          })
      }

    }
  }
</script>