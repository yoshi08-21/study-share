<template>
  <div v-if="currentUser">
    <h3>マイページ</h3>
    ID: {{ currentUser.id }}
    <br>
    name: {{ currentUser.name }}

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>
import authCheck from '../middleware/authCheck'


export default {
  middleware: authCheck,
  data() {
    return {
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    }
  },
  mounted() {
    if (this.$route.query.message) {
      this.snackbarColor = "primary"
      this.snackbar = true
      this.flashMessage = this.$route.query.message
      // this.$snackbar.show(this.$route.query.message)
    }
  },
}
</script>

<style>

</style>
