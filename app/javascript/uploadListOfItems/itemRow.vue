<template>
  <tr :class="{ 'bg-dark text-white': item.isHeader }"
      @contextmenu.prevent="$refs.ctxMenu.open">

    <td>
      <span class="fa fa-arrows mr-3" v-handle></span>
      <span class="mr-2">
        <input type="checkbox"
               v-model="item.checked">
      </span>
      {{ index + 1}}
    </td>

    <template v-if="item.isHeader">
      <td class="font-weight-bold">
        {{ item.name }}
      </td>

      <td class="font-weight-bold">
        {{ item.description }}
      </td>

      <td class="font-weight-bold">
        {{ item.quantity }}
      </td>

      <td class="font-weight-bold">
        {{ item.unit }}
      </td>

      <td class="font-weight-bold">
      </td>

      <td class="font-weight-bold">
      </td>
    </template>

    <template v-else>
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
    </template>


    <td class="d-flex justify-content-center">
      <button v-show="item != editedItem"
              tabindex="-1"
              type="button"
              class="close float-none"
              aria-label="Close"
              @click="$emit('delete', index)">
        <span aria-hidden="true">&times;</span>
      </button>
    </td>



    <context-menu id="context-menu" ref="ctxMenu">
      <li class="px-1" @click="setAsHeader">Set as header</li>
      <li class="px-1" @click="setAsItem">Set as item</li>
    </context-menu>
  </tr>
</template>

<script>
  import { ElementMixin, HandleDirective } from 'vue-slicksort'
  import ItemField from './itemField'
  import ContextMenu from 'vue-context-menu'

  export default {
    mixins: [ElementMixin, HandleDirective],

    components: {ItemField, ContextMenu},

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
      setAsHeader() {
        this.$set(this.item, 'isHeader', true)
      },
      setAsItem() {
        this.$set(this.item, 'isHeader', false)
      }
    }
  }
</script>