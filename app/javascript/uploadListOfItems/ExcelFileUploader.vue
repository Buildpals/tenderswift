<template>
  <div>

    <p class="text-muted">
      Please upload your <strong>completely filled</strong>
      Bill Of Quantities in .xls or .xlsx format.
    </p>

    <p>
      The columns A, B, C, D, E and F of the excel file you upload, should be
      the Item, Description, Quantity, Unit, Rate and Amount columns
      respectively.
    </p>

    <div class="custom-file mb-5">
      <input type="file"
             class="custom-file-input"
             id="excelFileInput"
             accept=".xlsx, .xls" @change="onchange"/>
      <label class="btn btn-sm btn-block btn-secondary" for="excelFileInput">
        Choose excel file
      </label>
    </div>

    <p class="text-center">
      Please note that your rates and estimated tender figure are confidential,
      and will <strong>never</strong> be displayed to any contractor.
    </p>

  </div>
</template>

<script>
  import * as XLSX from 'xlsx'

  export default {
    props: [
      'saveUrl',
      'method',
      'name'
    ],

    methods: {
      onchange (evt) {
        let file
        let files = evt.target.files

        if (!files || files.length == 0) return

        file = files[0]

        let reader = new FileReader()
        reader.onload = (e) => {
          // pre-process data
          let binary = ''
          let bytes = new Uint8Array(e.target.result)
          let length = bytes.byteLength
          for (let i = 0; i < length; i++) {
            binary += String.fromCharCode(bytes[i])
          }

          /* read workbook */
          let workbook = XLSX.read(binary, {type: 'binary'})

          this.saveExcelFile(file, workbook)
            .then(response => {
              this.$emit('after-upload', workbook)
            })
            .catch(error => {
              this.$emit('upload-error', error)
            })
        }

        reader.readAsArrayBuffer(file)
      },

      saveExcelFile (file, workbook) {
        const formData = new FormData()
        formData.append('excel_file[document]', file, file.name)
        formData.append('csf', JSON.stringify(workbook))
        return this.$http.post(this.saveUrl, formData)
      }
    }
  }
</script>

<style lang="scss">
</style>
