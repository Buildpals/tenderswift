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
        <th style="width:2rem" class="text-center"></th>
        <th style="width:3.75rem" class="text-center">A</th>
        <th style="width:34rem" class="text-center">B</th>
        <th style="width:3.75rem" class="text-center">C</th>
        <th style="width:3.75rem" class="text-center">D</th>
        <th style="width:5.62rem" class="text-center">E</th>
        <th style="width:5.62rem" class="">F</th>
      </tr>
      </thead>

      <tbody>
      <tr v-for="row in lastRowWithValues + 1">
        <td class="small bg-light text-center">
          {{ row }}
        </td>

        <cell :cell="worksheet[`A${row}`]"
              v-on:show-cell-contents="showCellContents"/>

        <cell :cell="worksheet[`B${row}`]"
              v-on:show-cell-contents="showCellContents"/>

        <cell :cell="worksheet[`C${row}`]"
              v-on:show-cell-contents="showCellContents"/>

        <cell :cell="worksheet[`D${row}`]"
              v-on:show-cell-contents="showCellContents"/>

        <cell :cell="worksheet[`E${row}`]"
              v-on:show-cell-contents="showCellContents"/>

        <cell :cell="worksheet[`F${row}`]"
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

    props: [
      'worksheet'
    ],

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

  /*.fixed_header tbody {*/
  /*display: block;*/
  /*overflow-x: auto;*/
  /*height: 30rem;*/
  /*width: 100%;*/
  /*}*/

  /*.fixed_header thead tr {*/
  /*display: block;*/
  /*}*/
</style>