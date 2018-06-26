<template>
  <div id="app">
    <form enctype="multipart/form-data" novalidate>
      <div class="dropbox mb-5">
        <input type="file"
               v-bind="$attrs"
               :name="name"
               @change="filesChange($event.target.name, $event.target.files);
                        fileCount = $event.target.files.length"
               class="input-file"
               accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" >
        <p>
          Drop your file here<br> or click to browse
        </p>
      </div>
    </form>
  </div>
</template>

<script>
  export default {
    props: [
      'saveUrl',
      'method',
      'name'
    ],

    methods: {
      filesChange (fieldName, fileList) {
        if (!fileList.length) return

        Array.from(fileList)
          .map(file => {
            const formData = new FormData()
            formData.append(fieldName, file, file.name)
            this.save({
              formData: formData,
              original_file_name: file.name,
              size: this.getHumanReadableSize(file)
            })
          })
      },

      save (resource) {
        this.$emit('before-upload', resource)

        this.$http[this.method](this.saveUrl, resource.formData)
          .then(response => {
            this.$emit('after-upload', response.body)
          })
          .catch(error => {
            console.error('error uploading file', error)
            if (error.status === 422) {
              resource.error = Object.values(error.body).join(', ')
            }
            this.$emit('upload-error', resource)
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
