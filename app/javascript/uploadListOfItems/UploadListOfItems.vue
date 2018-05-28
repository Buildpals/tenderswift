<template>
  <div id="app">

    <div class="d-flex justify-content-center mt-2 mb-3">
      <b-form-radio-group id="uploadSelector"
                          buttons
                          button-variant="outline-dark"
                          size="sm"
                          v-model="selected"
                          :options="options"
                          name="uploadSelector"/>
    </div>

    <create-list-of-items v-show="selected === '0'"
                          :request_for_tender_id="request_for_tender.id"
                          :list_of_items="request_for_tender.list_of_items" />

    <excel-uploader v-show="selected === '1'"
                    :request_for_tender="request_for_tender" />
  </div>
</template>

<script>
  import CreateListOfItems from './CreateListOfItems'
  import ExcelUploader from './ExcelUploader'

  export default {
    components: {ExcelUploader, CreateListOfItems},

    props: [
      'request_for_tender',
    ],

    data () {
      return {
        selected: "0",
        options: {0: 'Create a list of items', 1: 'Upload an excel sheet'}
      }
    }
  }
</script>

<style lang="scss">

</style>