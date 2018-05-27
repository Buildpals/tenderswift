<template>
  <div id="app">

    <div class="d-flex justify-content-center mt-2 mb-3">
      <b-form-radio-group id="uploadSelector"
                          buttons
                          button-variant="outline-primary"
                          size="sm"
                          v-model="selected"
                          :options="options"
                          name="uploadSelector"/>
    </div>


    <create-list-of-items v-show="selected === '0'"
                          :request_for_tender_id="request_for_tender.id"
                          :list_of_items="request_for_tender.list_of_items">

      <slot name="previous-link">
        <div slot="previous-link">
          <%= link_to 'Previous', previous_wizard_path %>
        </div>
      </slot>

    </create-list-of-items>

    <excel-uploader v-show="selected === '1'"
                    :request_for_tender="request_for_tender">

      <div slot="previous-link">
        <%= link_to 'Previous', previous_wizard_path %>
      </div>

      <div slot="next-link">
        <%= link_to 'Save and continue', next_wizard_path %>
      </div>

    </excel-uploader>
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