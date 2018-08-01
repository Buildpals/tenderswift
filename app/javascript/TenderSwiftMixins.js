import accounting from 'accounting'

export default {
  methods: {
    formatNumber (value) {
      if (typeof value === 'number') {
        return accounting.formatNumber(value, 2)
      } else {
        return value
      }
    }
  }
}