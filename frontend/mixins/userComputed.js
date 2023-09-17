export default {
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    isLoggedIn() {
      return this.$store.getters["auth/getLoggedIn"]
    },
  }
}
