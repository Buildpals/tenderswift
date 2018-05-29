<template>
  <div id="app">
    <table class="table table-sm" style="font-size: 0.9rem;">
      <thead>
      <tr>
        <th style="width:100px"></th>
        <th style="width:60px">Item</th>
        <th style="width:550px">Description</th>
        <th style="width:60px" class="text-right">Quantity</th>
        <th style="width:60px">Unit</th>
        <th style="width:90px">Price/Rate</th>
        <th style="width:90px">Amount</th>
        <th style="width:60px">
          <button class="btn btn-sm btn-secondary"
                  @click="save">
            Save
          </button>
        </th>
      </tr>
      </thead>

      <rate-row v-for="(item, index) in list_of_items.items"
                :item="item"
                v-model="rates[index]"
                :index="index"
                :key="index"/>

      <tr class="font-weight-bold text-right">
        <td colspan="6">Total tender figure</td>
        <td>
          {{ formatMoney(tenderFigure) }}
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
  import RateRow from './RateRow'
  import localforage from 'localforage'
  import TenderSwiftMixins from '../TenderSwiftMixins'

  export default {
    mixins: [TenderSwiftMixins],

    components: {RateRow},

    props: [
      'tender_id',
      'list_of_items',
      'list_of_rates'
    ],

    data () {
      return {
        storage_key: `rates_${this.tender_id}`,
        isSaving: false,
        rates: {},
      }
    },

    computed: {
      tenderFigure () {
        return Object.keys(this.rates).reduce(this.amountSummer, 0)
      }
    },

    created () {
      let serverData = this.list_of_rates
      localforage.getItem(this.storage_key)
        .then((localData) => {
          console.log('serverData:', serverData, 'localData:', localData)
          if (localData === null) {
            console.log('localData is null: using serverData')
            this.rates = serverData.rates
          } else if (serverData.updated_at > localData.updated_at) {
            console.log('serverData is newer: using serverData')
            this.rates = serverData.rates
          } else {
            console.log('localData is newer: using localData')
            this.rates = localData.rates
          }
        })
        .catch(function (error) {
          console.error('error', error)
        })
    },

    // watch rates change for localStorage persistence
    watch: {
      rates: {
        handler: function (rates) {
          console.log('saving localData')
          localforage.setItem(this.storage_key, {
            rates: rates,
            updated_at: Date.now()
          })
        },
        deep: true
      }
    },

    methods: {
      amountSummer (accumulator, rateKey) {
        return accumulator +
          this.list_of_items.items[rateKey].quantity * this.rates[rateKey]
      },

      save () {
        this.isSaving = true
        this.$http
          .put(
            `/tenders/${this.tender_id}`,
            {
              tender: {
                list_of_rates: {
                  rates: this.rates,
                  updated_at: Date.now()
                }
              }
            }
          )
          .then(response => {
            eval(response.body)
          })
          .catch(error => {
            console.error(error.message)
            this.showAlert('Error while saving')
          })
          .finally(() => {
            this.isSaving = false
          })
      }
    }
  }
</script>

<style lang="scss">

</style>