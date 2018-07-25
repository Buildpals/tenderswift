<template>
  <div id="app">
    <tender-figures-chart
        class="mb-5"
        :tenders="tenders"
        :tender-figure-address="requestForTender.tender_figure_address"
        :base-tender-figure="baseTenderFigure"/>

    <table class="table table-striped table-hover mb-5"
           style="font-size: 0.9rem;">

      <thead>
      <tr>
        <th>Company</th>
        <th class="text-right">Tender Figure</th>
        <th class="text-right">Difference</th>
        <th class="text-right">% Difference</th>
        <th class="text-right">Rating</th>
        <th width="60px"></th>
      </tr>
      </thead>

      <tbody>
      <tr>

        <td>
          <span data-toggle="tooltip"
                data-placement="top"
                :title="requestForTender.project_owners_email">
            {{  requestForTender.project_owners_company_name }}
          </span>
        </td>

        <td class="text-right">
          {{ formatNumber( baseTenderFigure ) }}
        </td>

        <td class="text-right">

        </td>

        <td class="text-right">

        </td>

        <td class="text-right">

        </td>

        <td class="d-flex justify-content-center">
        </td>

      </tr>
      </tbody>

      <thead class="thead-light">
      <tr>
        <th colspan="6">Submitted</th>
      </tr>
      </thead>

      <tbody>
      <tender-figures-row
          v-for="tender in shortListParticipants"
          :key="tender.id"
          :tender="tender"
          :tender-figure-address="requestForTender.tender_figure_address"
          :base-tender-figure="baseTenderFigure"
          @contextmenu.prevent="$refs.ctxMenu.open($event, {tender: tender})"
      />
      </tbody>


      <thead class="thead-light">
      <tr>
        <th colspan="6">Disqualified</th>
      </tr>
      </thead>

      <tbody>
      <tender-figures-row
          v-for="tender in disqualifiedParticipants"
          :key="tender.id"
          :tender="tender"
          :tender-figure-address="requestForTender.tender_figure_address"
          :base-tender-figure="baseTenderFigure"
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
  import {
    getTenderFigure
  } from '../utils'

  const newMenuData = () => ({tender: null})

  export default {
    mixins: [TenderSwiftMixins],

    components: {TenderFiguresChart, TenderFiguresRow, ContextMenu},

    props: [
      'requestForTender',
      'tenders'
    ],

    data () {
      return {
        menuData: newMenuData(),
      }
    },

    computed: {
      disqualifiedParticipants () {
        return this.tenders.filter(tender => tender.disqualified)
      },
      shortListParticipants () {
        return this.tenders.filter(tender => !tender.disqualified)
      },
      baseTenderFigure () {
        return getTenderFigure(
          this.requestForTender.workbook,
          this.requestForTender.tender_figure_address
        )
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