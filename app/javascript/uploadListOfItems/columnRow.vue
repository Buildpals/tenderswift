<template>
  <div class="form-row border-bottom py-2 bg-white">
    <div class="col-1" v-handle>
      <span class="fa fa-arrows"></span>
    </div>
    <div class="col-3">
      <input type="text"
             @change="$emit('edit', item_property)"
             :disabled="item_property.isDeletingColumn"
             v-model="item_property.column_name"
             class='form-control form-control-sm'>
    </div>
    <div class="col-2">
      <select v-model="item_property.filled_in_by"
              @change="$emit('edit', item_property)"
              :disabled="item_property.isDeletingColumn"
              class='form-control form-control-sm'>
        <option value="buyer_input">Buyer Input</option>
        <option value="supplier_input">Supplier Input</option>
        <option value="formula">Formula</option>
      </select>
    </div>
    <div class="col-2">
      <select v-model="item_property.field_type"
              @change="$emit('edit', item_property)"
              :disabled="item_property.isDeletingColumn || item_property.filled_in_by !== 'supplier_input'"
              class='form-control form-control-sm'>
        <option value="text">Text</option>
        <option value="money">Money</option>
        <option value="yes_no">Yes/No</option>
      </select>
    </div>
    <div class="col-1 d-flex justify-content-center align-items-center">
      <input type="checkbox"
             @change="$emit('edit', item_property)"
             :disabled="item_property.isDeletingColumn || item_property.filled_in_by === 'buyer_input'  || item_property.filled_in_by === 'formula'"
             v-model="item_property.required">
    </div>
    <div class="col-1 d-flex justify-content-center align-items-center">
      <input type="checkbox"
             @change="$emit('edit', item_property)"
             :disabled="item_property.isDeletingColumn || item_property.filled_in_by === 'buyer_input'"
             v-model="item_property.sum_up">
    </div>
    <div class="col-1 d-flex justify-content-end align-items-center">
      <div v-if="item_property.isDeletingColumn">
        Deleting...
      </div>
      <div v-else-if="item_property.isSavingColumn">
        Saving...
      </div>
      <button v-else
              @click="$emit('delete', index)"
              class="btn close float-none">
        <span aria-hidden="true" >&times;</span>
      </button>
    </div>
    <template v-if="item_property.filled_in_by === 'formula'">
      <div class="col-11 my-2">
                  <textarea placeholder="Write the formula here"
                            v-model="item_property.formula"
                            class='form-control form-control-sm'>
                  </textarea>
      </div>
      <div class="col-1 my-2">
        <button class="btn btn-sm btn-light">
          Insert field
        </button>
      </div>
    </template>
  </div>
</template>

<script>
  import { ElementMixin, HandleDirective } from 'vue-slicksort'

  export default {
    mixins: [ElementMixin, HandleDirective],
    directives: { handle: HandleDirective },
    props: [
      'item_property',
      'index'
    ],
    data () {
      return {
      }
    }
  }
</script>

<style lang="scss">

</style>