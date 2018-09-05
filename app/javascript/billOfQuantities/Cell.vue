<template>
  <td :class="{ 'p-0': !isEditable }"
      v-bind:class="{ formula: hasFormula }"
      @click="showCellContents">

    <input type="number"
           step="0.01"
           required
           :id="`${sheetName}-${rowColRef}`"
           class="form-control form-control-sm"
           v-if="isEditable"
           v-bind:value="value"
           @change="updateWorkbook">

    <div v-else>{{ formatNumber(value) }}</div>

  </td>
</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'

  import EventBus from '../EventBus'
  import { getRowColumnRef, getSheetName } from '../utils'

  export default {
    mixins: [TenderSwiftMixins],

    props: {
      cell: {
        type: Object,
        default () {
          return { v: '' }
        }
      },
      cellAddress: {
        type: String
      },
      options: {
        type: Object,
        default () {
          return {}
        }
      }
    },

    computed: {
      value () {
        return this.cell.v
      },
      sheetName () {
        return getSheetName(this.cellAddress)
      },
      rowColRef () {
        return getRowColumnRef(this.cellAddress)
      },
      hasFormula () {
        return this.cell.f
      },
      isEditable () {
        return this.allowsEditing && this.hasEditableOption
      },
      allowsEditing() {
        return this.cell.c === 'allowEditing'
      },
      hasEditableOption () {
        return this.options.editableRates
      }
    },

    methods: {
      showCellContents () {
        if (this.hasFormula) {
          this.$emit('show-cell-contents', this.cell.f)
        } else {
          this.$emit('show-cell-contents', this.cell.v)
        }
      },
      updateWorkbook (event) {
        EventBus.$emit('cell-change', {
          cellAddress: this.cellAddress,
          value: parseFloat(event.target.value)
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .formula {
    background: beige;
  }
</style>