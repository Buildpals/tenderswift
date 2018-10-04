<template>
  <div>

    <p class="text-muted">
      Please upload your Bill Of Quantities in .xls or .xlsx format below.
    </p>

    <figure class="figure">
      <img src="~images/boq_screenshot.png"
           class="figure-img img-fluid rounded"
           alt="Example layout of Bill of Quantities excel file." />

      <figcaption class="figure-caption">
        <p>
          The first 6 columns should be the Item, Description, Quantity, Unit, Rate
          and Amount respectively, and the first row should contain the column
          headers as show above:
        </p>

        <p>
          TenderSwift will determine which part of your Bill of Quantities
          contractors can edit based on the following rules:
        </p>
        <ol>
          <li>The cell is in the E column of the excel file you uploaded, and,</li>
          <li>The cell contains a <strong>number</strong>.</li>
        </ol>

        <p>
          This means that you should put a number in any cell that you want the
          contractors to be able to fill with their rates before you upload the
          excel file.
        </p>
      </figcaption>
    </figure>

    <div class="progress mb-3" v-if="processing">
      <div class="progress-bar progress-bar-striped progress-bar-animated
                  bg-accent w-100"
           role="progressbar"
           aria-valuenow="100"
           aria-valuemin="0"
           aria-valuemax="100"></div>
    </div>

    <div class="mb-3" v-else>
      <div class="custom-file">
        <input type="file"
               class="custom-file-input"
               id="excelFileInput"
               accept=".xlsx, .xls" @change="onchange"/>
        <label class="btn btn-sm btn-block btn-accent" for="excelFileInput">
          Choose excel file
        </label>
      </div>
    </div>

    <div class="text-center mb-3">
      or <br>
      <a href="https://res.cloudinary.com/tenderswift/raw/upload/v1535983447/app/bil_of_quantities_1.xlsx">
        Download a template
      </a>
    </div>

    <p class="small text-center text-info">
      Please note that your rates and tender figures are confidential,
      and will <strong>not</strong> be displayed to contractors.
    </p>

  </div>
</template>

<script>
  import * as XLSX from 'xlsx'
  import 'images/boq_screenshot.png'

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
          let workbook_data = XLSX.read(binary, {type: 'binary'})

          // Only store the Sheets object and the SheetNames Array
          let workbook = {
            'Sheets': workbook_data.Sheets,
            'SheetNames': workbook_data.SheetNames
          }

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
