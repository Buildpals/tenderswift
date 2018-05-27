<template>
  <div id="app">

    <form enctype="multipart/form-data" novalidate>
      <div class="dropbox mb-5">
        <input type="file" multiple
               name="project_document[document]"
               @change="filesChange($event.target.name, $event.target.files);
                        fileCount = $event.target.files.length"
               class="input-file">
        <p>
          Drag documents here<br> or click to browse
        </p>
      </div>
    </form>

    <div class="row">
      <div class="col-lg-8">
        <h4>Added Documents</h4>

        <ul class="list-group">

          <li class="list-group-item
                     d-flex justify-content-between align-items-center"
              v-for="project_document in uploadedFiles">

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
                      @click="save(project_document)">
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
  export default {
    props: ['request_for_tender'],

    data () {
      return {
        uploadedFiles: this.request_for_tender.project_documents,
        STATUS_INITIAL: 0,
        STATUS_SAVING: 1,
        STATUS_SUCCESS: 2,
        STATUS_FAILED: 3,
      }
    },

    methods: {
      deleteDocument (project_document) {
        this.$set(project_document, 'isDeleting', true)

        this.$http.delete(
          `/request_for_tenders/${this.request_for_tender.id}`
          + `/project_documents/${project_document.id}`
        )
          .then(response => {
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

      filesChange (fieldName, fileList) {
        if (!fileList.length) return

        Array.from(fileList)
          .map(file => {
            const formData = new FormData()
            formData.append(fieldName, file, file.name)
            formData
              .append('project_document[original_file_name]', file.name)

            this.save({
              formData: formData,
              original_file_name: file.name,
              size: this.getHumanReadableSize(file)
            })
          })
      },

      save (project_document) {
        project_document.uploadState = this.STATUS_SAVING

        if (this.uploadedFiles.indexOf(project_document) === -1) {
          this.uploadedFiles.push(project_document)
        }

        this.$http.post(
          `/request_for_tenders/${this.request_for_tender.id}/`
          + `project_documents`,
          project_document.formData
        )
          .then(response => {
            this.uploadedFiles.splice(
              this.uploadedFiles.indexOf(project_document),
              1,
              response.body
            )
            project_document.uploadState = this.STATUS_SUCCESS
          })
          .catch(error => {
            console.error('error uploading file', error)
            project_document.uploadState = this.STATUS_FAILED
            if (error.status === 422) {
              project_document.error = Object.values(error.body).join(', ')
            }
          })
      },

      getHumanReadableSize (file) {
        const fSExt = ['Bytes', 'KB', 'MB', 'GB']
        let fSize = file.size
        let i = 0
        while (fSize > 900) {
          fSize /= 1024
          i++
        }
        return `${ Math.round(fSize * 100) / 100 }  ${ fSExt[i] }`
      }
    }
  }
</script>

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
