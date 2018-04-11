<template>
    <tr>
        <td>
            <span data-toggle="tooltip" data-placement="top" :title="tender.contractor.email">
                  {{ tender.company_name }}
            </span>
        </td>
        <td class="text-right">
            {{ currency }}
            {{ tender.contract_sum.toLocaleString('en', {minimumFractionDigits: 2, maximumFractionDigits: 2}) }}
        </td>
        <td class="text-right">
            {{ currency }}
            {{ contractSumDifference(qsContractSum, tender.contract_sum).toLocaleString('en', {minimumFractionDigits: 2, maximumFractionDigits: 2}) }}
            <br>
            <small>
                {{ contractSumDifferencePercentage(qsContractSum, tender.contract_sum).toLocaleString('percent', {minimumFractionDigits: 0}) }}%
            </small>
        </td>
        <td class="text-right">
            {{ tender.rating ? tender.rating.toLocaleString('en', {minimumFractionDigits: 2, maximumFractionDigits: 2}) : 'Not rated' }}
        </td>
        <td>
            <a :href="`/bids/${tender.auth_token}`" class="btn btn-xs btn-link">View bid</a>
        </td>
        <td class="w-100 d-flex justify-content-center">
            <button class="btn btn-sm btn-light" @click="undoDisqualifyBid(tender)" v-if="tender.disqualified">Add to Shortlist</button>
            <button class="btn btn-sm btn-light" @click="disqualifyBid(tender)" v-else>Disqualify</button>
        </td>
    </tr>
</template>

<script>
  export default {
    props: [
      'tender',
      'currency',
      'qsContractSum'
    ],
    methods: {
      contractSumDifference (qsContractSum, tendersContractSum) {
        return (qsContractSum - tendersContractSum)
      },
      contractSumDifferencePercentage (qsContractSum, tendersContractSum) {
        return  (( (qsContractSum - tendersContractSum) / qsContractSum ) * 100 )
      },
      undoDisqualifyBid (tender) {
        this.$http.post(`/bids/undo_disqualify/${tender.auth_token}`, {})
          .then(response => {
            console.log(response)
            location.reload()
          })
          .catch(error => {
            console.error(error)
          })
      },
      disqualifyBid (tender) {
        this.$http.post(`/bids/disqualify/${tender.auth_token}`, {})
          .then(response => {
            console.log(response)
            location.reload()
          })
          .catch(error => {
            console.error(error)
          })
      }
    }
  }
</script>

<style lang="scss">
</style>