<template>
  <td class="cell"
      v-bind:class="{ formula: hasFormula }"
      @click="showCellContents">

    <input type="number"
           class="form-control form-control-sm rounded-0"
           v-if="isEditable"
           v-model="value"
           @change="updateWorkbook">

    <div v-else>
      {{ value }}
    </div>

  </td>
</template>

<script>
  import EventBus from '../EventBus'

  export default {
    props: [
      'cell',
      'cellAddress',
      'options'
    ],

    data () {
      return {
        value: ''
      }
    },

    mounted () {
      if (this.cell && this.cell.v) {
        this.value = this.cell.v
      }
    },

    computed: {
      hasFormula () {
        return this.cell && this.cell.f
      },
      isEditable () {
        return this.allowsEditing && this.hasEditableOption
      },
      allowsEditing() {
        return this.cell && this.cell.c === 'allowEditing'
      },
      hasEditableOption () {
        return this.options && this.options.editableRates
      }
    },

    methods: {
      showCellContents () {
        if (this.cell && this.cell.f) {
          this.$emit('show-cell-contents', this.cell.f)
        } else if (this.cell && this.cell.v) {
          this.$emit('show-cell-contents', this.cell.v)
        } else {
          this.$emit('show-cell-contents', '')
        }
      },
      updateWorkbook (event) {
        EventBus.$emit('cell-change', {
          cellAddress: this.cellAddress,
          value: event.target.value
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .formula {
    background: beige;
  }

  .cell {
    padding: 0rem !important;
  }
</style>