<template>
  <div>
    <div class="px-4 mb-2">Tender figures bar chart</div>

    <div class="card mb-4">
      <div class="card-body">
        <tender-figures-chart
            class="mb-5"
            :tenders="tenders"
            :tender-figures-hash="tenderFiguresHash"
            :tender-figure-address="requestForTender.tender_figure_address"
            :base-tender-figure="baseTenderFigure"/>
      </div>
    </div>


    <div class="d-flex w-100 justify-content-between align-items-baseline mb-2">
      <div class="px-4 mb-2">
        Shortlisted tenders ({{ shortListParticipants.length }})
      </div>

      <a :href="`/request_for_tenders/${requestForTender.id}/compare_boq`"
         target="_blank"
         class="btn btn-sm btn-accent">
        Compare Rates
      </a>
    </div>

    <div class="card mb-4">
      <table class="table table-hover mb-0"
             style="font-size: 0.9rem;">

        <thead>
        <tr>
          <th class="border-top-0">Company</th>
          <th class="border-top-0 text-right">Tender figure</th>
          <th class="border-top-0 text-right">Difference</th>
          <th class="border-top-0 text-right">% Difference</th>
          <th class="border-top-0 text-right">Rating</th>
          <th class="border-top-0"></th>
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


        <tbody>
        <tender-figures-row
            v-for="tender in shortListParticipants"
            :key="tender.id"
            :tender="tender"
            :tender-figures-hash="tenderFiguresHash"
            :tender-figure-address="requestForTender.tender_figure_address"
            :base-tender-figure="baseTenderFigure"
            @contextmenu.prevent="$refs.ctxMenu.open($event, {tender: tender})"
        />
        </tbody>

      </table>
    </div>

    <div class="px-4 mb-2">
      Disqualified tenders ({{ disqualifiedParticipants.length }})
    </div>

    <div class="card mb-4">
      <table class="table table-hover mb-0"
             style="font-size: 0.9rem;">

        <thead>
        <tr>
          <th class="border-top-0">Company</th>
          <th class="border-top-0 text-right">Tender Figure</th>
          <th class="border-top-0 text-right">Difference</th>
          <th class="border-top-0 text-right">% Difference</th>
          <th class="border-top-0 text-right">Rating</th>
          <th class="border-top-0"></th>
        </tr>
        </thead>

        <tbody>
        <tender-figures-row
            v-for="tender in disqualifiedParticipants"
            :key="tender.id"
            :tender="tender"
            :tender-figures-hash="tenderFiguresHash"
            :tender-figure-address="requestForTender.tender_figure_address"
            :base-tender-figure="baseTenderFigure"
            @contextmenu.prevent="$refs.ctxMenu.open($event, {tender: tender})"
        />
        </tbody>

      </table>
    </div>
  </div>
</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'
  import TenderFiguresRow from './TenderFiguresRow'
  import TenderFiguresChart from './TenderFiguresChart'
  import {
    getTenderFigure
  } from '../utils'

  const newMenuData = () => ({tender: null})

  export default {
    mixins: [TenderSwiftMixins],

    components: {TenderFiguresChart, TenderFiguresRow},

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
      tenderFiguresHash () {
        console.log('calling tenderFiguresHash')

        let hash = {}

        this.tenders.forEach(tender => {
          let tenderFigure = getTenderFigure(
            tender.workbook,
            this.requestForTender.tender_figure_address
          )

          let difference = tenderFigure - this.baseTenderFigure
          let percentageDifference = (difference / this.baseTenderFigure) * 100

          hash[tender.id] = {
            company: tender.contractors_company_name,
            tenderFigure: tender.tender_figure,
            difference: difference,
            percentageDifference: percentageDifference,
            tender: tender
          }
        })

        return hash
      },
      disqualifiedParticipants () {
        return this.tenders.filter(tender => tender.disqualified)
      },
      shortListParticipants () {
        return this.tenders.filter(tender => !tender.disqualified)
      },
      baseTenderFigure () {
        console.log('calling baseTenderFigure')

        return getTenderFigure(
          this.requestForTender.workbook,
          this.requestForTender.tender_figure_address
        )
      }
    }
  }
</script>