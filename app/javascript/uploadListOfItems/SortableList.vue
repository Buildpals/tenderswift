<template>
  <tbody class="bg-light">
    <slot />
  </tbody>
</template>

<script>
  import { ContainerMixin } from 'vue-slicksort'

  export default {
    mixins: [ContainerMixin]
  }
</script>

<style lang="scss">

</style>