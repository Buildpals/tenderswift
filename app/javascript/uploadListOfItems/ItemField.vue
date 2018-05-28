<template>
  <div>
    <div tabindex="0"
         v-show="!editing"
         @focus="editValue">
      {{ value }}
    </div>

    <input class="form-control form-control-sm"
           type="text"
           ref="editor"
           v-show="editing"
           v-bind:value="value"
           v-on:input="$emit('input', $event.target.value)"
           @blur="doneEdit"
           @keyup.enter="doneEdit"
           @keyup.esc="cancelEdit">
  </div>
</template>

<script>
  export default {
    props: [
      'value'
    ],

    data () {
      return {
        editing: false
      }
    },

    methods: {
      editValue: function () {
        this.editing = true

        this.beforeEditCache = this.value

        this.$nextTick(() => {
          this.$refs.editor.select()
        })
      },

      doneEdit: function () {
        this.editing = false
      },

      cancelEdit: function () {
        this.editing = false
        this.value = this.beforeEditCache
      }
    }
  }
</script>