<template>
  <tr>

    <td>
      <span data-toggle="tooltip"
            data-placement="top"
            :title="tender.contractor.email">
        {{  tender.contractor.company_name }}
      </span>
    </td>

    <td class="text-right">
      {{ formatNumber(tenderFigure) }}
    </td>

    <td class="text-right">
      {{ formatNumber(tenderFigureDifference) }}
    </td>

    <td class="text-right">
      {{ formatNumber(tenderFigurePercentageDifference) }}%
    </td>

    <td class="text-right">
      {{ tender.rating ? formatNumber(tender.rating) : 'Not rated' }}
    </td>

    <td class="d-flex justify-content-center">
      <a :href="`/bids/${tender.id}`" class="btn btn-xs btn-link">View bid</a>
      <button class="btn btn-sm btn-light"
              @click="undoDisqualifyBid(tender)"
              v-if="tender.disqualified">
        Add to Shortlist
      </button>
      <button class="btn btn-sm btn-light"
              @click="disqualifyBid(tender)"
              v-else>
        Disqualify
      </button>
    </td>

  </tr>
</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'

  export default {
    mixins: [TenderSwiftMixins],

    props: [
      'tender',
      'baseTenderFigure',
      'list_of_items'
    ],

    computed: {
      tenderFigure () {
        return Object.keys(this.tender.list_of_rates.rates)
          .reduce((accumulator, rateKey) => {
            return accumulator +
              this.list_of_items.items[rateKey].quantity * this.tender.list_of_rates.rates[rateKey]
          }, 0)
      },

      tenderFigureDifference () {
        return this.tenderFigure - this.baseTenderFigure
      },

      tenderFigurePercentageDifference () {
        return (this.tenderFigureDifference / this.baseTenderFigure) * 100
      },
    },

    methods: {
      undoDisqualifyBid (tender) {
        this.$http.patch(`/bids/${tender.id}/undo_disqualify`, {})
          .then(response => {
            eval(response.body)
          })
          .catch(error => {
            console.error(error)
          })
      },

      disqualifyBid (tender) {
        this.$http.patch(`/bids/${tender.id}/disqualify`, {})
          .then(response => {
            eval(response.body)
          })
          .catch(error => {
            console.error(error)
          })
      }
    }
  }
</script>