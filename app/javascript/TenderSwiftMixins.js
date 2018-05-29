import accounting from 'accounting'

export default {
  methods: {
    formatMoney (value) {
      return accounting.formatMoney(value, { symbol: '' })
    }
  }
}