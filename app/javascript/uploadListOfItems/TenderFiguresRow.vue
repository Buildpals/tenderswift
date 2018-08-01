<template>
  <tr>

    <td>
      <span data-toggle="tooltip"
            data-placement="top"
            :title="tender.contractors_email">
        {{  tender.contractors_company_name }}
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
      <a :href="`/bids/${tender.id}`"
         target="_blank"
         class="btn btn-sm btn-link mr-2">
        View bid
      </a>
      <button class="btn btn-sm btn-primary"
              @click="undoDisqualifyBid(tender)"
              v-if="tender.disqualified">
        Add to Shortlist
      </button>
      <button class="btn btn-sm btn-primary"
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
      'tenderFigureAddress',
      'baseTenderFigure',
      'tenderFiguresHash'
    ],

    computed: {
      tenderFigure () {
        return  this.tenderFiguresHash[this.tender.id].tenderFigure
      },

      tenderFigureDifference () {
        return  this.tenderFiguresHash[this.tender.id].difference
      },

      tenderFigurePercentageDifference () {
        return  this.tenderFiguresHash[this.tender.id].percentageDifference
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