<template>
  <tr class="bg-white">

    <td>
      <span class="fa fa-arrows" v-handle></span>
      {{ index + 1}}
    </td>

    <td>
      <item-field
          v-model="item.name"
          :editing="item == editedItem"/>
    </td>

    <td colspan="4">
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

    <td>
      <button v-show="item != editedItem"
              type="button"
              class="close"
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