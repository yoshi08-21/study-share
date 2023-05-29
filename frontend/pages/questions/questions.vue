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
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
    <all-questions :questions="questionsChunk"></all-questions>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>


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
  data() {
    return {
      perPage: 10,
      page: 1,
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    questionsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.questions.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.questions.length / this.perPage);
    },
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
