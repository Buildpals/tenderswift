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
      <tr v-for="row in range.e.r">
        <td class="small bg-light text-center">
          {{ row }}
        </td>

        <cell-object v-model="sheet[`A${row}`]"
                     v-on:show-cell-contents="showCellContents"/>

        <cell-object v-model="sheet[`B${row}`]"
                     v-on:show-cell-contents="showCellContents"/>

        <cell-object v-model="sheet[`C${row}`]"
                     v-on:show-cell-contents="showCellContents"/>

        <cell-object v-model="sheet[`D${row}`]"
                     v-on:show-cell-contents="showCellContents"/>

        <cell-object v-model="sheet[`E${row}`]"
                     v-on:show-cell-contents="showCellContents"/>

        <cell-object v-model="sheet[`F${row}`]"
                     v-on:show-cell-contents="showCellContents"/>
      </tr>
      </tbody>

    </table>
  </div>
</template>

<script>
  import XLSX from 'xlsx'
  import CellObject from './CellObject'

  export default {
    components: {CellObject},

    props: [
      'value'
    ],

    data () {
      return {
        sheet: this.value,
        currentCellContents: ''
      }
    },

    computed: {
      range () {
        return XLSX.utils.decode_range(this.sheet['!ref'])
      }
    },

    methods: {
      showCellContents (cellContents) {
        this.currentCellContents = cellContents
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