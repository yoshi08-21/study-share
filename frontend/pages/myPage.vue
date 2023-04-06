<template>
  <div>
    <h3>マイページ</h3>
    ID: {{ currentUser.id }}
    <br>
    name: {{ currentUser.name }}
  </div>
</template>

<script>
export default {
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    }
  },
}
</script>

<style>

</style>
