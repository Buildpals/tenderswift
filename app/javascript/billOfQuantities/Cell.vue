<template>
  <td class="cell" v-bind:class="{ formula: cell && cell.f }">
    <div :contenteditable="options && options.editableRates"
         @click="showCellContents"
         @blur="update">
      {{ cell && cell.w }}
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

    methods: {
      showCellContents () {
        if (this.cell && this.cell.f) {
          this.$emit('show-cell-contents', this.cell.f)
        } else if (this.cell && this.cell.w) {
          this.$emit('show-cell-contents', this.cell.w)
        } else {
          this.$emit('show-cell-contents', '')
        }
      },
      update (event) {        
        let rate = event.target.innerText
        EventBus.$emit('cell-change', { cellAddress: this.cellAddress, rate });
      }
    }
  }
</script>

<style lang="scss">
  .formula {
    background: beige;
  }

  .cell {
    padding: 0rem !important;
  }
</style>