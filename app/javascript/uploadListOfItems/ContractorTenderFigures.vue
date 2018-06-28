<template>
  <div id="app">
    <tender-figures-chart class="mb-5"
                          :tenders="tenders"
                          :list_of_items="list_of_items" />

    <table class="table table-striped table-hover mb-5"
           style="font-size: 0.9rem;">

      <thead>
      <tr>
        <th>Company</th>
        <th class="text-right">Tender Figure</th>
      </tr>
      </thead>

      <tbody>
      <contractor-tender-figures-row
          :tender="tender"
          :list_of_items="list_of_items"
          :baseTenderFigure="baseTenderFigure"
          v-for="(tender, index) in shortListParticipants"
          :key="index"
          @contextmenu.prevent="$refs.ctxMenu.open($event, {tender: tender})"
      />
      </tbody>

    </table>

    <context-menu id="context-menu" ref="ctxMenu" @ctx-open="onCtxOpen"
                  @ctx-cancel="resetCtxLocals" @ctx-close="onCtxClose">
      <li class="px-1" @click="baseTenderFigure = totalSum(menuData.tender)">
        Compare difference
      </li>
    </context-menu>
  </div>
</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'
  import ContextMenu from 'vue-context-menu'
  import TenderFiguresRow from './TenderFiguresRow'
  import TenderFiguresChart from './TenderFiguresChart'
  import ContractorTenderFiguresRow from './ContractorTenderFiguresRow'


  const newMenuData = () => ({tender: null})

  export default {
    mixins: [TenderSwiftMixins],

    components: {
      ContractorTenderFiguresRow,
      TenderFiguresChart, TenderFiguresRow, ContextMenu},

    props: [
      'list_of_items',
      'tenders'
    ],

    data () {
      return {
        menuData: newMenuData(),
        baseTenderFigure: this.tenderFigure(this.tenders[0]),
      }
    },

    computed: {
      disqualifiedParticipants () {
        return this.tenders.filter(tender => tender.disqualified)
      },
      shortListParticipants () {
        return this.tenders.filter(tender => !tender.disqualified)
      }
    },

    methods: {
      tenderFigure (tender) {
        console.log(tender.list_of_rates.rates)

        return Object.keys(tender.list_of_rates.rates).reduce((accumulator, rateKey) => {
          return accumulator +
            this.list_of_items.items[rateKey].quantity * tender.list_of_rates.rates[rateKey]
        }, 0)
      },

      onCtxOpen (locals) {
        console.log('open', locals)
        this.menuData = locals
      },
      onCtxClose (locals) {
        console.log('close', locals)
      },
      resetCtxLocals () {
        this.menuData = newMenuData()
      },
    }
  }
</script>