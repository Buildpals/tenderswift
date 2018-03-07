<template>
    <tr>
        <td>
            <span data-toggle="tooltip" data-placement="top" :title="participant.email">
                  {{ participant.company_name }}
            </span>
        </td>
        <td class="text-right">
            {{ currency }}
            {{ participant.contract_sum.toLocaleString('en', {minimumFractionDigits: 2, maximumFractionDigits: 2}) }}
        </td>
        <td class="text-right">
            {{ currency }}
            {{ contractSumDifference(qsContractSum, participant.contract_sum).toLocaleString('en', {minimumFractionDigits: 2, maximumFractionDigits: 2}) }}
            <br>
            <small>
                {{ contractSumDifferencePercentage(qsContractSum, participant.contract_sum).toLocaleString('percent', {minimumFractionDigits: 0}) }}%
            </small>
        </td>
        <td class="text-right">
            {{ participant.rating ? participant.rating.toLocaleString('en', {minimumFractionDigits: 2, maximumFractionDigits: 2}) : 'Not rated' }}
        </td>
        <td>
            <a :href="`/bids/${participant.auth_token}`" class="btn btn-xs btn-link">View bid</a>
        </td>
        <td class="w-100 d-flex justify-content-center">
            <button class="btn btn-sm btn-light" @click="undoDisqualifyBid(participant)" v-if="participant.disqualified">Add to Shortlist</button>
            <button class="btn btn-sm btn-light" @click="disqualifyBid(participant)" v-else>Disqualify</button>
        </td>
    </tr>
</template>

<script>
  export default {
    props: [
      'participant',
      'currency',
      'qsContractSum'
    ],
    methods: {
      contractSumDifference (qsContractSum, participantsContractSum) {
        return (qsContractSum - participantsContractSum)
      },
      contractSumDifferencePercentage (qsContractSum, participantsContractSum) {
        return  (( (qsContractSum - participantsContractSum) / qsContractSum ) * 100 )
      },
      undoDisqualifyBid (participant) {
        this.$http.post(`/bids/undo_disqualify/${participant.auth_token}`, {})
          .then(response => {
            console.log(response)
            location.reload()
          })
          .catch(error => {
            console.error(error)
          })
      },
      disqualifyBid (participant) {
        this.$http.post(`/bids/disqualify/${participant.auth_token}`, {})
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