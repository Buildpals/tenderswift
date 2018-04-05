<template>
    <div>
        <bids-chart :participants="participants"
                    :currency="currency"
                    :qs-company-name="qsCompanyName"
                    :qs-contract-sum="qsContractSum" />
        <div id="bids-table">
            <table class="table table-striped table-hover mb-5">
                <thead>
                <tr>
                    <th>Company</th>
                    <th class="text-right">Tender Figure</th>
                    <th class="text-right">Difference</th>
                    <th class="text-right">Rating</th>
                    <th colspan="2"></th>
                </tr>
                </thead>

                <thead class="thead-light">
                <tr>
                    <th colspan="6">Submitted</th>
                </tr>
                </thead>
                <tbody>
                <bid-row :participant="participant" :currency="currency"
                         :qs-contract-sum="qsContractSum"
                         v-for="participant in shortListParticipants" />
                <tr v-if="shortListParticipants.length === 0">
                    <td colspan="6" class="text-center">
                        There are no submitted bids
                    </td>
                </tr>
                </tbody>

                <thead class="thead-light">
                <tr>
                    <th colspan="6">Disqualified</th>
                </tr>
                </thead>
                <tbody>
                <bid-row class="text-danger"
                         :participant="participant" :currency="currency"
                         :qs-contract-sum="qsContractSum"
                         v-for="participant in disqualifiedParticipants" />
                <tr v-if="disqualifiedParticipants.length === 0">
                    <td colspan="6" class="text-center">
                        There are no disqualified bids
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script>
  import BidRow from './bidRow'
  import BidsChart from './bidsChart'
  import {
    recalculateFormulas
  } from '../renderers'

  export default {
    props: [
      'participantsData',
      'contractSumAddress',
      'workbookData',
      'currency',
      'qsCompanyName'
    ],
    components: {
      BidRow,
      BidsChart
    },
    data () {
      return {
        currentIndex: false,
        workbook: {
          SheetNames: []
        },
        participants: this.participantsData
      }
    },
    computed: {
      qsContractSum () {
        return this.workbookData.Sheets[this.contractSumAddress.sheet][this.contractSumAddress.cellAddress].v
      },
      disqualifiedParticipants () {
        return this.participants.filter(participant => participant.disqualified)
      },
      shortListParticipants () {
        return this.participants.filter(participant => !participant.disqualified)
      }
    },
    created () {
      let i = 6
      this.participants.forEach((participant) => {
        let newRateColumn = String.fromCharCode(65 + i++)
        let newAmountColumn = String.fromCharCode(65 + i++)

        Object.keys(this.workbookData.Sheets).forEach(sheetName => {
          let sheet = this.workbookData.Sheets[sheetName]

          Object.keys(sheet)
            .forEach(cellAddress => {

              let column, row
              let result = /^([E-F])(\d+)$/.exec(cellAddress)

              if (result) {
                column = result[1]
                row = result[2]

                if (column === 'E') {
                  let newRateAddress = `${newRateColumn}${ row }`
                  let rate = participant.rates.find(r => {
                    return r.sheet === sheetName && cellAddress === `E${ r.row }`
                  })
                  if (rate) {
                    this.workbookData.Sheets[sheetName][newRateAddress] = {
                      ...this.workbookData.Sheets[sheetName][cellAddress],
                      v: rate.value
                    }
                  }  else {
                    this.workbookData.Sheets[sheetName][newRateAddress] = {...this.workbookData.Sheets[sheetName][cellAddress]}
                  }
                  if (this.workbookData.Sheets[sheetName][newRateAddress].f) {
                    this.workbookData.Sheets[sheetName][newRateAddress].f = this.workbookData.Sheets[sheetName][newRateAddress].f.replace(/(E)(\d+)/g, `${newRateColumn}$2`)
                    this.workbookData.Sheets[sheetName][newRateAddress].f = this.workbookData.Sheets[sheetName][newRateAddress].f.replace(/(F)(\d+)/g, `${newAmountColumn}$2`)
                  }
                } else if (column === 'F') {
                  let newAmountAddress = `${newAmountColumn}${ row }`
                  this.workbookData.Sheets[sheetName][newAmountAddress] = { ...this.workbookData.Sheets[sheetName][cellAddress]}
                  if (this.workbookData.Sheets[sheetName][newAmountAddress].f) {
                    this.workbookData.Sheets[sheetName][newAmountAddress].f = this.workbookData.Sheets[sheetName][newAmountAddress].f.replace(/(E)(\d+)/g, `${newRateColumn}$2`)
                    this.workbookData.Sheets[sheetName][newAmountAddress].f = this.workbookData.Sheets[sheetName][newAmountAddress].f.replace(/(F)(\d+)/g, `${newAmountColumn}$2`)
                  }
                }
              } else {
                return
              }
            })
        })
      })

      recalculateFormulas(this.workbookData)

      i = 6
      this.participants.forEach((participant) => {
        let newRateColumn = String.fromCharCode(65 + i++)
        let newAmountColumn = String.fromCharCode(65 + i++)
        let sheet = this.contractSumAddress.sheet
        let cellAddress = this.contractSumAddress.cellAddress

        console.log(cellAddress, newAmountColumn)

        cellAddress = cellAddress.replace(/(E)(\d+)/g, `${newRateColumn}$2`)
        cellAddress = cellAddress.replace(/(F)(\d+)/g, `${newAmountColumn}$2`)


        participant.contract_sum = this.workbookData.Sheets[sheet][cellAddress].v
      })

      this.$set(this, 'workbook', this.workbookData)
    },
    methods: {
      logIt (tab_index) {
        this.currentIndex = tab_index
      },
      contractSumDifference (qsContractSum, participantsContractSum) {
        return (qsContractSum - participantsContractSum)
      },
      contractSumDifferencePercentage (qsContractSum, participantsContractSum) {
        return  (( (qsContractSum - participantsContractSum) / qsContractSum ) * 100 )
      }
    }
  }
</script>

<style lang="scss">
    #bids-table {
        font-size: 0.875rem;
    }
</style>