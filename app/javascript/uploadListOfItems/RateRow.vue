<template>
  <tr :class="{ 'bg-dark text-white font-weight-bold': item.isHeader }">

    <td>
      {{ index + 1}}
    </td>

    <template v-if="item.isHeader">
      <td>
        {{ item.name }}
      </td>

      <td>
        {{ item.description }}
      </td>

      <td class="text-right">
        {{ item.quantity }}
      </td>

      <td>
        {{ item.unit }}
      </td>

      <td>
      </td>

      <td class="text-right">
      </td>
    </template>

    <template v-else>
      <td>
        {{ item.name }}
      </td>

      <td>
        {{ item.description }}
      </td>

      <td class="text-right">
        {{ formatMoney(item.quantity) }}
      </td>

      <td>
        {{ item.unit }}
      </td>

      <td>
        <input class="form-control form-control-sm"
               type="number"
               step="0.01"
               min="0"
               v-bind:value="value"
               v-on:input="$emit('input', $event.target.value)">
      </td>

      <td class="text-right">
        {{ formatMoney(item.quantity * value) }}
      </td>
    </template>


    <td class="d-flex justify-content-center">
    </td>

  </tr>
</template>

<script>
  import TenderSwiftMixins from '../TenderSwiftMixins'

  export default {
    mixins: [TenderSwiftMixins],

    props: [
      'item',
      'value',
      'index'
    ]
  }
</script>