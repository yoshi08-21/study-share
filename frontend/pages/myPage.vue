<template>
  <div v-if="currentUser">
    <h3>マイページ</h3>
    ID: {{ currentUser.id }}
    <br>
    name: {{ currentUser.name }}
  </div>
</template>

<script>
import authCheck from '../middleware/authCheck'


export default {
  middleware: authCheck,
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    }
  },
  beforeRouteUpdate(to, from, next) {
    const currentUser = this.$store.getters["auth/getCurrentUser"]
    if(currentUser) {
      next("/auth/login")
      // this.$router.push({ path: "/login" })
    } else {
      next("/login")
    }
  },
}
</script>

<style>

</style>
