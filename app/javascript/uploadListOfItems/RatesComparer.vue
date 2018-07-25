<template>
  <div id="app">
    <workbook :workbook="requestForTender.compare_workbook"
              :tenders="tenders" />
  </div>

</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'
  import Workbook from '../compareBillOfQuantities/Workbook'

  export default {
    mixins: [TenderSwiftMixins],

    components: { Workbook },

    props: [
      'requestForTender',
      'list_of_items',
      'tenders'
    ],

    methods: {
      amountSummer (accumulator, rateKey) {
        return accumulator +
          this.list_of_items.items[rateKey].quantity * this.rates[rateKey]
      },
      /*tenderFigure (tender) {
        return Object.keys(tender.list_of_rates.rates)
          .reduce((accumulator, rateKey) => {
            return accumulator +
              this.list_of_items.items[rateKey].quantity *
              tender.list_of_rates.rates[rateKey]
          }, 0)
      } */
    }
  }
</script>