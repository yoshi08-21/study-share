<template>
  <div>
    <h2>科目別質問一覧ページ</h2>

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
        <v-btn @click="dialog = true" block>科目別質問を投稿する</v-btn>
      </v-card-title>
    </v-card>

        <!-- 新規質問投稿ダイアログ -->
        <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          Dialog Title
        </v-card-title>
        <v-card-text>
          <subject-question-form @submitSubjectQuestion="submitSubjectQuestion" @closeDialog="dialog = false"></subject-question-form>
        </v-card-text>
      </v-card>
    </v-dialog>


    <all-subject-questions :subjectQuestions="subjectQuestions"></all-subject-questions>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import AllSubjectQuestions from '../../components/subjectQuestions/AllSubjectQuestions.vue'
import SubjectQuestionForm from '../../components/subjectQuestions/SubjectQuestionForm.vue'
import axios from "@/plugins/axios"

export default {
  components: { AllSubjectQuestions, SubjectQuestionForm },
  async asyncData() {
    try {
      const responce = await axios.get("/subject_questions")
      console.log(responce.data)
      return {
        subjectQuestions: responce.data
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      dialog: false,
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",

    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
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
  methods: {
    async submitSubjectQuestion(data) {
      try {
        const response = await axios.post("/subject_questions", {
            user_id: this.currentUser.id,
            title: data.title,
            content: data.content,
            subject: data.subject
          }
        )
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "質問の投稿が完了しました"
        this.$router.push({ path: `/subjectQuestions/${response.data.id}`, query: { message: '質問の投稿が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を投稿できませんでした"
      }
      this.dialog = false
    },

  }
}
</script>

<style>

</style>
