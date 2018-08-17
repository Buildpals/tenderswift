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
        <th class="amount      text-right ">F</th>
      </tr>
      </thead>

      <tbody>
      <tr v-for="row in lastRowWithValues + 1">
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

        <cell class="amount"
              :cell="worksheet[`F${row}`]"
              :cell-address="`${sheetAddress}!F${row}`"
              v-on:show-cell-contents="showCellContents"/>
      </tr>
      </tbody>

    </table>
  </div>
</template>

<script>
  import XLSX from 'xlsx'
  import Cell from './Cell'

  export default {
    components: {Cell},

    props: {
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
      }
    },

    data () {
      return {
        currentCellContents: ''
      }
    },

    computed: {
      lastRowWithValues () {
        let range = XLSX.utils.decode_range(this.worksheet['!ref'])
        let totalRows = range.e.r

        for (let row = totalRows; row > 0; row--) {
          if (this.rowHasValue(row)) {
            return row
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
    white-space: pre-wrap;
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