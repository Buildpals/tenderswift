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
        <th v-for="(tender, index) in tenders"
            :key="index"
            style="width:90px"
            class="text-right">
          {{ tender.contractor.company_name }}
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

          <td v-for="(tender, index) in tenders"
              :key="index">
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
            {{ formatMoney(item.quantity) }}
          </td>

          <td>
            {{ item.unit }}
          </td>

          <td v-for="(tender, index) in tenders"
              :key="index"
              class="text-right">
            {{ formatMoney(item.quantity * tender.list_of_rates.rates[index]) }}
          </td>
        </template>

      </tr>

      <tr class="font-weight-bold text-right">
        <td colspan="5">Total tender figure</td>
        <td v-for="(tender, index) in tenders"
            :key="index">
          {{ formatMoney(tenderFigure(tender)) }}
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
      'list_of_items',
      'tenders'
    ],

    methods: {
      amountSummer (accumulator, rateKey) {
        return accumulator +
          this.list_of_items.items[rateKey].quantity * this.rates[rateKey]
      },
      tenderFigure (tender) {
        return Object.keys(tender.list_of_rates.rates)
          .reduce((accumulator, rateKey) => {
            return accumulator +
              this.list_of_items.items[rateKey].quantity *
              tender.list_of_rates.rates[rateKey]
          }, 0)
      }
    }
  }
</script>