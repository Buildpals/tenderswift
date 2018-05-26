<template>
  <tr class="bg-white">

    <td>
      <span class="fa fa-arrows mr-3" v-handle></span>
      {{ index + 1}}
    </td>

    <td>
      <item-field
          v-model="item.name"
          :editing="item == editedItem"/>
    </td>

    <td>
      <item-field
          v-model="item.description"
          :editing="item == editedItem"/>
    </td>

    <td>
      <item-field
          v-model="item.quantity"
          :editing="item == editedItem"/>
    </td>

    <td>
      <item-field
          v-model="item.unit"
          :editing="item == editedItem"/>
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
      <button v-show="item != editedItem"
              type="button"
              class="close float-none"
              aria-label="Close"
              @click="$emit('delete', index)">
        <span aria-hidden="true">&times;</span>
      </button>
    </td>
  </tr>
</template>

<script>
  import { ElementMixin, HandleDirective } from 'vue-slicksort'
  import ItemField from './itemField'

  export default {
    mixins: [ElementMixin, HandleDirective],

    components: {ItemField},

    directives: {
      handle: HandleDirective,
    },

    props: [
      'item',
      'index'
    ],

    data () {
      return {
        editedItem: null
      }
    },

    methods: {

    }
  }
</script>