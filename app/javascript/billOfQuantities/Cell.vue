<template>
  <td class="cell"
      v-bind:class="{ formula: hasFormula }"
      @click="showCellContents">

    <input type="text"
           class="form-control form-control-sm cell-input"
           v-show="isEditable"
           v-model="value"
           @change="updateWorkbook">

    <div v-show="!isEditable">
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
      isEditable () {
        return this.cell && this.options && this.options.editableRates
      },
      hasFormula () {
        return this.cell && this.cell.f
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

  .cell-input {
    border-radius: 0;
  }
</style>