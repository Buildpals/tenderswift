import accounting from 'accounting'

export default {
  methods: {
    formatNumber (value) {
      if (typeof value === 'number') {
        return accounting.formatNumber(value, 2)
      } else {
        return value
      }
    },

    getTenderFigure (listOfItems, listOfRates) {
      return Object.keys(listOfItems.items)
        .reduce((currentSum, uuid) => {
          let quantity = listOfItems.items[uuid].quantity
          let rate = listOfRates.rates[uuid].value

          if (rate) {
            return currentSum + getAmount(rate, quantity)
          } else {
            return NaN
          }
        }, 0)
    },

    getAmount (rate, quantity) {
      if (quantity) {
        return rate * quantity
      } else {
        return rate
      }
    },

    convertExcelFileToListOfItems (ExcelFile) {
      let reader = new FileReader()

      reader.onload = function (e) {
        let data = e.target.result

        let workbook = XLSX.read(
          new Uint8Array(data),
          {
            cellFormula: true,
            cellStyles: true,
            type: 'array'
          }
        )
      }

      reader.readAsArrayBuffer(ExcelFile)
    },

    convertListOfItemsToExcelFile () {

    },

    saveListOfItems (listOfItems, requestForTenderId) {
      listOfItems.versionNumber++

      return this.$http.put(
        `/request_for_tenders/${this.requestForTenderId}/build/bill_of_quantities`,
        {
          request_for_tender: {
            list_of_items: listOfItems
          }
        }
      )
    },

    saveListOfRates (listOfRates, parentId, isRequestForTender = false) {
      listOfRates.versionNumber++

      let url

      if (isRequestForTender) {
        url = `/tenders/${this.parentId}/build/bill_of_quantities`
      } else {
        url = `/request_for_tenders/${this.parentId}/build/bill_of_quantities`
      }

      return this.$http.patch(
        url,
        {
          tender: {
            list_of_rates: listOfRates
          }
        }
      )
    }
  }
}