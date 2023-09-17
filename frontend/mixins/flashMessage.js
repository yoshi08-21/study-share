export default {
  data() {
    return {
      snackbar: false,
      snackbarColor: "",
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
