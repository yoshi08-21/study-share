<template>
  <div>
    <h2>アンケート詳細</h2>

    <h3>アンケートタイトル: {{ survey.title }}</h3>
    <h4>アンケート本文: {{ survey.content }}</h4>

    <v-btn>1. {{ survey.option1 }}</v-btn>
    <v-btn>2. {{ survey.option2 }}</v-btn>
    <v-btn v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
    <v-btn v-if="survey.option4">4. {{ survey.option4 }}</v-btn>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  async asyncData({ params }) {
    try {
      const response = await axios.get(`/surveys/${params.id}`)
      console.log(response.data)
      return {
        survey: response.data
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
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
