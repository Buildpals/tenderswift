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
        <th style="width:90px" class="text-right">Price/Rate</th>
        <th style="width:90px" class="text-right">Amount</th>
        <th style="width:60px">
        </th>
      </tr>
      </thead>

      <tr :class="{ 'bg-dark text-white font-weight-bold': item.isHeader }"
          v-for="(item, index) in list_of_items.items"
          :key="index">

        <td>
          {{ index + 1}}
        </td>

        <template v-if="item.isHeader">
          <td>
            {{ item.name }}
          </td>

          <td>
            {{ item.description }}
          </td>

          <td class="text-right">
            {{ item.quantity }}
          </td>

          <td>
            {{ item.unit }}
          </td>

          <td>
          </td>

          <td class="text-right">
          </td>
        </template>

        <template v-else>
          <td>
            {{ item.name }}
          </td>

          <td>
            {{ item.description }}
          </td>

          <td class="text-right">
            {{ formatNumber(item.quantity) }}
          </td>

          <td>
            {{ item.unit }}
          </td>

          <td class="text-right">
            {{ formatNumber(rates[index]) }}
          </td>

          <td class="text-right">
            {{ formatNumber(item.quantity * rates[index]) }}
          </td>
        </template>


        <td class="d-flex justify-content-center">
        </td>

      </tr>

      <tr class="font-weight-bold text-right">
        <td colspan="6">Total tender figure</td>
        <td>
          {{ formatNumber(tenderFigure) }}
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'

  export default {
    mixins: [TenderSwiftMixins],

    props: [
      'tender_id',
      'list_of_items',
      'list_of_rates'
    ],

    data () {
      return {
        rates: this.list_of_rates.rates,
      }
    },

    computed: {
      tenderFigure () {
        return Object.keys(this.rates).reduce(this.amountSummer, 0)
      }
    },

    methods: {
      amountSummer (accumulator, rateKey) {
        return accumulator +
          this.list_of_items.items[rateKey].quantity * this.rates[rateKey]
      }
    }
  }
</script>