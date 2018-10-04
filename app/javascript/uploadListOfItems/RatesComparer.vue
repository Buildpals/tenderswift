<template>
  <div>
    <workbook :workbook="requestForTender.compare_workbook"
              :tenders="tenders" />
  </div>

</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'
  import Workbook from '../compareBillOfQuantities/Workbook'

  export default {
    mixins: [TenderSwiftMixins],

    components: { Workbook },

    props: [
      'requestForTender',
      'list_of_items',
      'tenders'
    ]
  }
</script>