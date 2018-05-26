<template>
  <div id="app" class="">

    <b-tabs>

      <b-tab title="Create a list of items" active style="min-height: 768px;">
        <table class="table table-sm">
          <thead>
          <tr>
            <th></th>
            <th>Item</th>
            <th colspan="4">Description</th>
            <th>Quantity</th>
            <th>Unit</th>
            <th>Price/Rate</th>
            <th>Amount</th>
            <th></th>
          </tr>
          </thead>

          <sortable-list lockAxis="y"
                         :useDragHandle="true"
                         v-model="items">

            <item-row v-for="(item, index) in items"
                      :item="item"
                      :index="index"
                      :key="index"
                      v-on:delete="deleteItem(index)"/>

            <tr style="background-color: #fffbe3;">
              <td>
                Add new item
              </td>

              <td>
                <input type="text"
                       autofocus autocomplete="off"
                       ref="newItemName"
                       v-model="newItem.name"
                       class='form-control form-control-sm'>
              </td>

              <td colspan="4">
                <input type="text"
                       v-model="newItem.description"
                       class='form-control form-control-sm'>
              </td>

              <td>
                <input type="text"
                       v-model="newItem.quantity"
                       class='form-control form-control-sm'>
              </td>

              <td>
                <input type="text"
                       v-model="newItem.unit"
                       class='form-control form-control-sm'>
              </td>

              <td>
                <input type="text"
                       disabled
                       class='form-control form-control-sm'>
              </td>

              <td>
                <input type="text"
                       disabled
                       class='form-control form-control-sm'>
              </td>

              <td>
                <button class="btn btn-sm btn-primary"
                        @click="addItem">
                  Add
                </button>
              </td>
            </tr>

          </sortable-list>
        </table>
      </b-tab>

      <b-tab title="Upload an excel file">
        <slot name="upload"></slot>
      </b-tab>

      <div class="align-self-center ml-auto" slot="tabs">
        <button @click="save('Back')"
               class="btn btn-primary next-button text-uppercase mb-2">
          Back
        </button>

        <button @click="save('Save')"
                class="btn btn-primary next-button text-uppercase mb-2">
          Save
        </button>

        <button @click="save('Next')"
               class="btn btn-primary next-button text-uppercase mb-2">
          Next
        </button>
      </div>
    </b-tabs>


    <hr>
    <div class="d-flex justify-content-end align-self-center ml-auto">
      <button @click="save('Back')"
              class="btn btn-primary next-button text-uppercase mr-1 mb-2">
        Back
      </button>

      <button @click="save('Save')"
              class="btn btn-primary next-button text-uppercase mr-1 mb-2">
        Save
      </button>

      <button @click="save('Next')"
              class="btn btn-primary next-button text-uppercase mb-2">
        Next
      </button>
    </div>

  </div>
</template>

<script>
  import ItemRow from './itemRow'
  import SortableList from './sortableList'
  import ExcelUploader from './excelUploader'
  import localforage from 'localforage'

  export default {
    components: {SortableList, ItemRow, ExcelUploader},

    props: [
      'request_for_tender_id',
      'list_of_items'
    ],

    data () {
      return {
        storage_key: `list_of_items_${this.request_for_tender_id}`,
        showAlertMessage: false,
        alertMessage: '',
        isSaving: false,
        items: [],
        newItem: {
          name: '',
          description: '',
          quantity: '',
          unit: ''
        }
      }
    },

    created () {
      let serverData = this.list_of_items
      localforage.getItem(this.storage_key)
        .then((localData) => {
          console.log('serverData:', serverData, 'localData:', localData)
          if (localData === null) {
            console.log('localData is null: using serverData')
            this.items = serverData.items
          } else if (serverData.updated_at > localData.updated_at) {
            console.log('serverData is newer: using serverData')
            this.items = serverData.items
          } else {
            console.log('localData is newer: using localData')
            this.items = localData.items
          }
        })
        .catch(function (error) {
          console.error('error', error)
        })
    },

    // watch items change for localStorage persistence
    watch: {
      items: {
        handler: function (items) {
          console.log('saving localData')
          localforage.setItem(this.storage_key, {
            items: items,
            updated_at: Date.now()
          })
        },
        deep: true
      }
    },

    methods: {
      addItem () {
        this.items.push({...this.newItem})
        this.newItem = {
          name: '',
          description: '',
          quantity: '',
          unit: ''
        }
        this.$nextTick(() => {
          this.$refs.newItemName.focus()
        })
      },

      deleteItem (index) {
        this.items.splice(index, 1)
      },

      save (commit) {
        this.isSaving = true
        this.$http
          .patch(
            `/create_tender/${this.request_for_tender_id}/boq`,
            {
              request_for_tender: {
                list_of_items: {
                  items: this.items,
                  updated_at: Date.now()
                }
              },
              commit: commit
            }
          )
          .then(response => {
            eval(response.body)
          })
          .catch(error => {
            console.error(error.message)
            this.showAlert('Error while saving')
          })
          .finally(() => {
            this.isSaving = false
          })
      },

      showAlert (message) {
        console.log(message)
        this.showAlertMessage = true
        this.alertMessage = message
      }
    }
  }
</script>

<style lang="scss">

</style>