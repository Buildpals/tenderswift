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

      TenderSwift will determine which part of your Bill of Quantities
      contractors can edit based on the following rules:
      1. The cell is in the E column of the excel file you uploaded, and,
      2. The cell contains a <strong>number</strong>.

      This means that you should fill in all your rates in the excel file before
      uploading it, so the system can automatically pickup that those cells
      should be editable by the contractor
    </p>

    <div class="progress mb-5" v-show="processing">
      <div class="progress-bar progress-bar-striped progress-bar-animated
                  bg-secondary w-100"
           role="progressbar"
           aria-valuenow="100"
           aria-valuemin="0"
           aria-valuemax="100"></div>
    </div>

    <div class="custom-file mb-5" v-show="!processing">
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

    data () {
      return {
        processing: false
      }
    },

    methods: {
      onchange (evt) {
        this.processing = true
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
              this.processing = false
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
