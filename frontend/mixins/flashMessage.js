export default {
  data() {
    return {
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: ""
    };
  },
  mounted() {
    if (this.$route.query.message) {
      this.snackbarColor = "primary";
      this.snackbar = true;
      this.flashMessage = this.$route.query.message;
    }
  }
};
