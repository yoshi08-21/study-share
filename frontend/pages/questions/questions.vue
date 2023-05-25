<template>
  <div>
    <h2>質問一覧ページ</h2>

    <v-tabs
      fixed-tabs
    >
      <v-tab to="/questions/questions">
        参考書別質問
      </v-tab>
      <v-tab to="/subjectQuestions/subjectQuestions">
        科目別質問
      </v-tab>
    </v-tabs>


    <br><br><br>
    <v-card>
      <v-card-title>
        質問一覧：検索ボックス
        <v-text-field></v-text-field><v-btn>検索</v-btn>
      </v-card-title>
      <v-card-title>
        <v-btn block disabled>参考書別の質問は参考書の詳細ページから投稿できます</v-btn>
      </v-card-title>
    </v-card>

    <br>
    <all-questions :questions="questions"></all-questions>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import AllQuestions from '../../components/questions/AllQuestions.vue'
import axios from "@/plugins/axios"

export default {
  components: { AllQuestions },
  async asyncData() {
    try {
      const responce = await axios.get("/questions/all_questions")
      console.log(responce.data)
      return {
        questions: responce.data
      }
    } catch(error) {
      console.log(error)
      throw error
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
