<template>
  <div class="table-wrapper">
    <table class="table table-sm table-bordered mb-0">
      <tbody>
      <tr>
        <th style="width:2rem" class="text-right">
          fx
        </th>
        <td>
          {{ currentCellContents }}
        </td>
      </tr>
      </tbody>
    </table>

    <table
        class="table table-sm table-bordered table-striped mb-0 fixed_header">
      <thead>
      <tr>
        <th class="row-num     text-center"></th>
        <th class="item        text-center">A</th>
        <th class="description text-center">B</th>
        <th class="quantity    text-right ">C</th>
        <th class="unit        text-center">D</th>
        <th class="rate        text-right ">E</th>
        <th v-for="tender in tenders" 
            :key="tender.id" 
            class="amount text-right ">
            {{ tender.contractors_company_name }}
        </th>
      </tr>
      </thead>

      <tbody>
      <tr v-for="row in lastRowWithValues + 1" :key="row">
        <td class="row-num small bg-light text-center">
          {{ row }}
        </td>

        <cell class="item"
              :cell="worksheet[`A${row}`]"
              :cell-address="`${sheetAddress}!A${row}`"
              v-on:show-cell-contents="showCellContents"/>

        <cell class="description"
              :cell="worksheet[`B${row}`]"
              :cell-address="`${sheetAddress}!B${row}`"
              v-on:show-cell-contents="showCellContents"/>

        <cell class="quantity"
              :cell="worksheet[`C${row}`]"
              :cell-address="`${sheetAddress}!C${row}`"
              v-on:show-cell-contents="showCellContents"/>

        <cell class="unit"
              :cell="worksheet[`D${row}`]"
              :cell-address="`${sheetAddress}!D${row}`"
              v-on:show-cell-contents="showCellContents"/>

        <cell class="rate"
              :cell="worksheet[`E${row}`]"
              :cell-address="`${sheetAddress}!E${row}`"
              :options="options"
              v-on:show-cell-contents="showCellContents"/>


        <cell class="rate"
              :cell="worksheet[`F${row}`]"
              :cell-address="`${sheetAddress}!F${row}`"
              :options="options"
              v-on:show-cell-contents="showCellContents"/>

      </tr>
      </tbody>

    </table>
  </div>
</template>

<script>
  import XLSX from 'xlsx'
  import Cell from './Cell'
  import { lastRowWithValues, recalculateFormulas } from '../utils';

  export default {
    components: {Cell},

    props: {
    workbook: {
        type: Object,
        required: true
      },
      worksheet: {
        type: Object
      },
      sheetAddress: {
        type: String
      },
      options: {
        type: Object,
        default () {
          return {}
        }
      },
      tenders: {
          type: Array,
          default () {
            return {}
          }
      }
    },

    data () {
      return {
        currentCellContents: ''
      }
    },


    mounted () {
        let listOfNewColumns = [];
        for (let index = 1; index <= this.tenders.length; index++) {
            listOfNewColumns.push(this.numberToLetter(index));
        }

        for (let index = 1; index < this.lastRowWithValues + 1; index++) { /* loop through all rows */
            for (let j = 0; j < listOfNewColumns.length; j++) { /* go through new columns */
                let fullCellAddress = listOfNewColumns[j]+''+index;
                for (let k = 0; k < this.tenders.length; k++) { /* go through tenders */
                    this.addCellToSheet(fullCellAddress, this.tenders[k].list_of_rates[ this.sheetAddress + '!E' + index], index);
                }              
            }  
        }
    },

    computed: {
      lastRowWithValues () {
        let range = XLSX.utils.decode_range(this.worksheet['!ref'])
        let totalRows = range.e.r

        for (let row = totalRows; row > 0; row--) {
          if (this.rowHasValue(row)) {
            return row;
          }
        }
      }
    },

    methods: {
      showCellContents (cellContents) {
        this.currentCellContents = cellContents
      },
      rowHasValue (row) {
        return this.worksheet[`A${row}`] ||
          this.worksheet[`B${row}`] ||
          this.worksheet[`C${row}`] ||
          this.worksheet[`D${row}`] ||
          this.worksheet[`E${row}`] ||
          this.worksheet[`F${row}`]
      },
      getRateCell (tender, row) {
          let fullCellAddress = this.sheetAddress+'!'+`E${row}`;
          return { v: tender.list_of_rates[fullCellAddress] }
      },

    numberToLetter(columnNumber) {
          let alphabets = ['F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N','O', 
                        'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' ]
          if (columnNumber < 26) {
              return alphabets[columnNumber - 1];
          }
          else{
            var temp, letter = '';
            while (columnNumber > 0) {
                temp = (columnNumber - 1) % 26;
                letter = String.fromCharCode(temp + 65) + letter;
                columnNumber = (columnNumber - temp - 1) / 26;
            }
            return letter;
          }

     },
        
    addCellToSheet(address, value, row) {
        let e_cell = this.worksheet['E'+row];

        if ((e_cell != undefined || e_cell != null) && e_cell['f'] != undefined ) {
            console.log(e_cell['f']);
            var cell = {t:'?', v:value, f: e_cell['f'].replace('E', address.split('')[0])};
            console.log(cell);
        }else{
            var cell = {t:'?', v:value};
        }
        

        /* assign type */
        if(typeof value == "string") cell.t = 's';
        else if(typeof value == "number") cell.t = 'n';

        /* add to cell to worksheet*/
        this.worksheet[address] = cell;

        /* find the cell range */
        var range = XLSX.utils.decode_range(this.worksheet['!ref']);
        var addr = XLSX.utils.decode_cell(address);

        /* extend the range to include the new cell */
        if(range.s.c > addr.c) range.s.c = addr.c;
        if(range.s.r > addr.r) range.s.r = addr.r;
        if(range.e.c < addr.c) range.e.c = addr.c;
        if(range.e.r < addr.r) range.e.r = addr.r;

        /* update range */
        this.worksheet['!ref'] = XLSX.utils.encode_range(range);
        recalculateFormulas(this.workbook);
      }
    }
  }
</script>

<style lang="scss">
  .fixed_header {
    table-layout: fixed;
  }

  .fixed_header tbody {
    display: block;
    overflow-x: auto;
    height: 30rem;
  }

  .fixed_header thead tr {
    display: block;
  }

  .row-num {
    width: 2rem;
  }

  .item {
    width: 3.75rem;
  }

  .description {
    width: 34rem;
  }

  .quantity {
    width: 3.75rem;
  }

  .unit {
    width: 3.75rem;
  }

  .rate {
    width: 5.62rem;
  }

  .amount {
    width: 5.62rem;
  }
</style>