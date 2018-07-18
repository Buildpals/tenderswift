<template>
  <div>
    <div class="text-center">
      {{prompt}}
    </div>
    <workbook
        :options="{editableRates: true}"
        :tender-id="tender.id"
        :workbook="tender.workbook"
        v-on:save-rates="saveRates"/>
  </div>
</template>

<script>
  import { getRates } from '../utils'
  import Workbook from '../billOfQuantities/Workbook'

  export default {
    components: {Workbook},

    props: [
      'initialTender'
    ],

    data () {
      return {
        tender: this.initialTender,
        prompt: ''
      }
    },

    methods: {
      saveRates (workbook) {
        this.tender.version_number++

        this.prompt = 'Saving...'
        let rates = getRates(workbook)

        this.$http.put(`/tenders/${this.tender.id}/build/bill_of_quantities`, {
          tender: {
            list_of_rates: rates,
            version_number: this.tender.version_number
          }
        }).then(response => {
          this.prompt = 'All changes saved to TenderSwift\'s servers'
        }).catch(error => {
          console.error(error)
        })
      }
    }
  }
</script>