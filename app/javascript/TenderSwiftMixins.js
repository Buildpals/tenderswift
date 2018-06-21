import accounting from 'accounting'

export default {
  methods: {
    formatNumber (value) {
      return accounting.formatNumber(value, 2)
    }
  }
}