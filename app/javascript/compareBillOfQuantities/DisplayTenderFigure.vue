<template>
  <strong>{{ formatNumber(tenderFigure )}}</strong>
</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'
  import {
    getTenderFigure
  } from '../utils'

  export default {
    mixins: [TenderSwiftMixins],

    props: [
      'requestForTender',
      'workbook'
    ],

    computed: {
      tenderFigure() {
          return getTenderFigure(
            this.workbook,
            this.requestForTender.tender_figure_address
          )
      }
    }
  }
</script>