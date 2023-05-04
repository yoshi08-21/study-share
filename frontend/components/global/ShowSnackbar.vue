<template>
  <div>
    <v-snackbar v-model="snackbar" :color="color">{{ message }}</v-snackbar>
  </div>
</template>

<script>
export default {
  data() {
    return {
      snackbar: {
        show: false,
        message: "",
        timeout: 3000,
        color: ""
      }
    }
  },
  methods: {
    showSnackbar(message, color) {
      this.snackbar.show = true
      this.snackbar.message = message
      this.snackbar.color = color
    }
  }
}
</script>

<style>

</style>
