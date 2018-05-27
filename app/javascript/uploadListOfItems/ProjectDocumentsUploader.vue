<!-- HTML Template -->
<template>
  <div id="app">

    <form enctype="multipart/form-data" novalidate>
      <div class="dropbox mb-5">
        <input type="file" multiple
               name="project_document[document]"
               :disabled="isSaving"
               @change="filesChange($event.target.name, $event.target.files);
                        fileCount = $event.target.files.length"
               class="input-file">
        <p v-if="isSaving">
          Uploading {{ fileCount }} files...
        </p>
        <p v-else>
          Drag documents here<br> or click to browse
        </p>
      </div>
    </form>

    <!--FAILED-->
    <div v-if="isFailed">
      <h2>Uploaded failed.</h2>
      <p>
        <a href="javascript:void(0)" @click="reset()">Try again</a>
      </p>
      <pre>{{ uploadError }}</pre>
    </div>

    <div class="row">
      <div class="col-lg-8">
        <h4>Added Documents</h4>
        <ul class="list-group">
          <li class="list-group-item
                     d-flex justify-content-between align-items-center"
              v-for="project_document in uploadedFiles">
            <a :href="project_document.document.url"
               target="blank">
              {{project_document.original_file_name}}
            </a>
            <button class="btn btn-light btn-sm"
                    :disabled="project_document.isDeleting"
                    @click="deleteDocument(project_document)">
              {{ project_document.isDeleting ? 'Deleting...' : 'Delete' }}
            </button>
          </li>
        </ul>
      </div>
    </div>


  </div>
</template>

<!-- Javascript -->
<script>
  const STATUS_INITIAL = 0, STATUS_SAVING = 1, STATUS_SUCCESS = 2,
    STATUS_FAILED = 3

  export default {
    props: ['request_for_tender'],

    data () {
      return {
        uploadedFiles: [],
        uploadError: null,
        currentStatus: null,
        uploadFieldName: 'photos'
      }
    },

    computed: {
      isInitial () {
        return this.currentStatus === STATUS_INITIAL
      },
      isSaving () {
        return this.currentStatus === STATUS_SAVING
      },
      isSuccess () {
        return this.currentStatus === STATUS_SUCCESS
      },
      isFailed () {
        return this.currentStatus === STATUS_FAILED
      }
    },

    methods: {
      reset () {
        // reset form to initial state
        this.currentStatus = STATUS_INITIAL
        this.uploadedFiles = this.request_for_tender.project_documents
        this.uploadError = null
      },
      save (formData) {
        // upload data to the server
        this.currentStatus = STATUS_SAVING

        this.$http.post(
          `/request_for_tenders/${this.request_for_tender.id}/`
          + `project_documents`,
          formData
        )
          .then(response => {
            console.log(response.body)
            this.uploadedFiles = this.uploadedFiles.concat(response.body)
            this.currentStatus = STATUS_SUCCESS
          })
          .catch(error => {
            console.error('error uploading file', error)
            this.uploadError = error
            this.currentStatus = STATUS_FAILED
          })
      },
      filesChange (fieldName, fileList) {
        // handle file changes
        const formData = new FormData()

        if (!fileList.length) return

        // append the files to FormData
        Array
          .from(Array(fileList.length).keys())
          .map(x => {
            formData.append(fieldName, fileList[x], fileList[x].name)
            formData
              .append('project_document[original_file_name]', fileList[x].name)
          })

        // save it
        this.save(formData)
      },
      deleteDocument (project_document) {
        this.$set(project_document, 'isDeleting', true)

        this.$http.delete(
          `/request_for_tenders/${this.request_for_tender.id}`
          + `/project_documents/${project_document.id}`
        )
          .then(response => {
            console.log('success deleting project_document', response.body)
            this.uploadedFiles
              .splice(this.uploadedFiles.indexOf(project_document), 1)
          })
          .catch(error => {
            console.error('error deleting document', error)
          })
          .finally(() => {
            this.$set(project_document, 'isDeleting', false)
          })
      },
    },
    mounted () {
      this.reset()
    }
  }
</script>

<!-- SASS styling -->
<style lang="scss">
  .dropbox {
    outline: 2px dashed grey; /* the dash box */
    outline-offset: -10px;
    background: lightcyan;
    color: dimgray;
    padding: 10px 10px;
    min-height: 200px; /* minimum height */
    position: relative;
    cursor: pointer;
  }

  .input-file {
    opacity: 0; /* invisible but it's there! */
    width: 100%;
    height: 200px;
    position: absolute;
    cursor: pointer;
  }

  .dropbox:hover {
    background: lightblue; /* when mouse over to the drop zone, change color */
  }

  .dropbox p {
    font-size: 1.2em;
    text-align: center;
    padding: 50px 0;
  }
</style>
