<template>
  <div id="app">
    <table class="table table-sm" style="font-size: 0.9rem;">
      <thead>
      <tr>
        <th style="width:100px"></th>
        <th style="width:60px">Item</th>
        <th style="width:550px">Description</th>
        <th style="width:60px">Quantity</th>
        <th style="width:60px">Unit</th>
        <th style="width:90px">Price/Rate</th>
        <th style="width:90px">Amount</th>
        <th style="width:60px">
        </th>
      </tr>
      </thead>

      <sortable-list lockAxis="y"
                     :useDragHandle="true"
                     v-model="value">

        <item-row v-for="(item, index) in value"
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

          <td>
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

          <td class="d-flex justify-content-center">
            <button class="btn btn-sm btn-primary"
                    @click="addItem">
              Add
            </button>
          </td>
        </tr>

      </sortable-list>
    </table>
  </div>
</template>

<script>
  import ItemRow from './ItemRow'
  import SortableList from './SortableList'
  import localforage from 'localforage'

  export default {
    components: {SortableList, ItemRow},

    props: [
      'value'
    ],

    data () {
      return {
        newItem: {
          name: '',
          description: '',
          quantity: '',
          unit: ''
        }
      }
    },

    methods: {
      addItem () {
        this.value.push({...this.newItem})
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
        this.value.splice(index, 1)
      }
    }
  }
</script>

<style lang="scss">

</style>