<template>
  <div>
      <small>Please select the address of the cell with the final
        tender figure of this bill of quantity</small>
      <br/>
      <br/>
      <div class="container-fluid">
        <div class="row">
          <div class="col-md-3 ">
            <label>Sheet</label><br/>
            <select id="sheet-names" class="form-control"
                    @change="calculateTenderFigure"
                    v-model="sheetNameForExcel">
              <option v-for="sheetName in
              requestForTender.workbook.SheetNames" v-bind:value="sheetName">
                {{ sheetName }}</option>
            </select>
          </div>
          <div class="col-md-3">
            <label>Column</label><br/>
            <select id="row-address" class="form-control"
                    @change="calculateTenderFigure"
                    v-model="columnNumber">
              <option>A</option>
              <option>B</option>
              <option>C</option>
              <option>D</option>
              <option>E</option>
              <option>F</option>
            </select>
          </div>
          <div class="col-md-3">
            <label>Row</label><br/>
            <input id="cell-address" type="number" class="form-control"
                   name="column" min="0" max="99000"
                   @change="calculateTenderFigure" v-model="rowNumber">
          </div>
          <div class="col-md-3">
            <small>Tender Figure:</small>
            <strong><p id="tender-figure">{{ tenderFigure }}</p></strong>
            <button class="form-control btn btn-primary"
                    v-bind:disabled="sheetNameForExcel === '' ||
                    columnNumber === '' || rowNumber == '' "
                    @click="hideModal">
              Okay
            </button>
          </div>
        </div>
      </div>
  </div>
</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'
  import EventBus from '../EventBus'

  export default {
    mixins: [TenderSwiftMixins],

    props: [
      'initialRequestForTender'
    ],

    data () {
      return {
        requestForTender: this.initialRequestForTender,
        sheetNameForExcel: '',
        tenderFigureAddressStatus: '',
        rowNumber: '',
        columnNumber: ''
      }
    },

    computed: {
      tenderFigure () {
        let row = this.rowNumber;
        let column = this.columnNumber;
        let sheet = this.sheetNameForExcel;
        if( row != '' && column != '' && sheet != ''){
          let worksheet = this.requestForTender.workbook.Sheets[sheet]
          if (!worksheet) return undefined
          let address_of_cell = column+''+row
          let desired_cell = worksheet[address_of_cell]
          return desired_cell ? desired_cell.v : 'No value'
        }
      },
    },

    methods: {
      calculateTenderFigure (){
        let row = this.rowNumber;
        let column = this.columnNumber;
        let sheet = this.sheetNameForExcel;
        if( row != '' && column != '' && sheet != ''){
          let worksheet = this.requestForTender.workbook.Sheets[sheet]
          if (!worksheet) return undefined
          let address_of_cell = column+''+row
          let desired_cell = worksheet[address_of_cell]
          this.requestForTender.tender_figure_address =
            sheet + '!' + address_of_cell
          this.saveTenderFigureAddress()
          return desired_cell ? desired_cell.v : undefined
        }
      },

      saveTenderFigureAddress () {
        this.tenderFigureAddressStatus = 'Saving...'

        let url = `/request_for_tenders/${this.requestForTender.id}` +
          `/build/bill_of_quantities`

        this.$http.patch(url, {
          request_for_tender: {
            tender_figure_address: this.requestForTender.tender_figure_address
          }
        }).then(response => {
          this.tenderFigureAddressStatus =
            'All changes saved to TenderSwift\'s servers'
        }).catch(error => {
          this.tenderFigureAddressStatus =
            'Error saving changes'
          console.error(error)
        })
      },

      hideModal () {
        EventBus.$emit('close-modal', {
          tenderFigureAddress: this.requestForTender.tender_figure_address })
      }
    }
  }
</script>