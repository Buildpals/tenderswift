<template>
  <div>
    <p class="text-muted small">
      Please upload your completely FILLED Bill Of Quantities in .xls or
      .xlsx format.
      <br>
      Then right click on the cell in the bill of quantities containing the
      estimated tender figure for the project.
      <br>

      <strong>
        NB: Columns A, B, C, D, E and F should be Item, Description, Quantity,
        Unit, Rate and Amount respectively.
      </strong>
      <br>

      <strong>
        Please note that your rates and estimated tender figure are private,
        and
        will NEVER be displayed to any contractor.
      </strong>
    </p>

    <input type="file"
           id="sheetjs-input"
           accept=".xlsx, .xls" @change="onchange"/>
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
