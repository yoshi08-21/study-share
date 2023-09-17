export default {
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  }
}
