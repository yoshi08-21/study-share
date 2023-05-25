<template>
  <div>
    <h2>科目別質問：詳細ページ</h2>
    <h3>質問id: {{ this.subjectQuestion.id }}</h3>

    <br>
    <h3>質問</h3>
    <h4>タイトル:{{ this.subjectQuestion.title }}</h4>
    <p>本文:{{ this.subjectQuestion.content }}</p>
    <h4>科目:{{ this.subjectQuestion.subject }}</h4>
    <h3>questioned by<span class="link-text" @click="redirectToUser"> {{ this.user.name }} </span></h3>


    <!-- 自分の質問のみ編集・削除ボタンを表示 -->
    <br>
    <template v-if="this.currentUser && this.user.id == this.currentUser.id">
      <v-btn @click="dialog=true">編集する</v-btn>
      <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
    </template>

    <br><br>
    <v-btn @click="redirectToSubjectQuestions">科目別質問一覧に戻る</v-btn>

    <!-- 質問編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          質問を編集する
        </v-card-title>
        <v-card-text>
          <edit-subject-question
            :title="subjectQuestion.title"
            :content="subjectQuestion.content"
            :subject="subjectQuestion.subject"
            @submitSubjectQuestion="editSubjectQuestion"
            @closeDialog="dialog = false"
          ></edit-subject-question>
        </v-card-text>
      </v-card>
    </v-dialog>

    <!-- 質問削除の確認ダイアログ -->
    <v-dialog v-model="showDeleteConfirmation">
      <v-card>
        <v-card-title>
          削除した質問は復元できません！
        </v-card-title>
        <v-card-text>
          <strong>
            質問を削除しますか？
          </strong>
        </v-card-text>
        <v-card-actions class="justify-content-center">
          <v-btn @click="deleteSubjectQuestion">削除する</v-btn>
          <v-btn @click="showDeleteConfirmation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>



    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditSubjectQuestion from '../../components/subjectQuestions/EditSubjectQuestion.vue'
import axios from "@/plugins/axios"

export default {
  components: { EditSubjectQuestion },
  async asyncData({ params }) {
    try {
      // const [questionResponse, repliesResponse] = await Promise.all([
      //   axios.get(`/books/${params.book_id}/questions/${params.id}`),
      //   axios.get(`/books/${params.book_id}/questions/${params.id}/replies`)
      // ])
      const response = await axios.get(`subject_questions/${params.id}`)
      console.log(response.data)
      return {
        subjectQuestion: response.data.subject_question,
        user: response.data.subject_question.user,
        params
      };
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      dialog: false,
      showDeleteConfirmation: false,
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
      isFavorite: false,
      favoriteQuestionId: "",
      replyDialog: false,

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
    redirectToSubjectQuestions() {
      this.$router.push({ path: "/subjectQuestions/subjectQuestions" })
    },
    redirectToUser() {
      console.log("currentUser:" + this.currentUser.id)
      console.log("user:" + this.user.id)
      if(this.currentUser.id !== this.user.id ) {
        this.$router.push({ path: `/users/${this.user.id}` })
      } else {
        this.$router.push({ path: "/mypage" })
      }
    },
    async editSubjectQuestion(data) {
      try {
        const response = await axios.patch(`/subject_questions/${this.subjectQuestion.id}`, {
          title: data.title,
          content: data.content,
          subject: data.subject,
          current_user_id: this.currentUser.id
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "質問の編集が完了しました"
        this.subjectQuestion.title = response.data.title
        this.subjectQuestion.content = response.data.content
        this.subjectQuestion.subject = response.data.subject

      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を編集できませんでした"
      }
      this.dialog = false
    },
    async deleteSubjectQuestion() {
      try {
        const response = await axios.delete(`/subject_questions/${this.subjectQuestion.id}`, {
          params: { current_user_id: this.currentUser.id }
        })
        console.log(response)
        this.$router.push({ path: `/subjectQuestions/subjectQuestions`, query: { message: '質問を削除しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を削除できませんでした"
        this.dialog = false
      }
    },
    async addToFavorite() {
      try {
        const response = await axios.post(`/questions/${this.question.id}/favorite_questions`, {
          user_id: this.currentUser.id
        })
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！しました"
        this.isFavorite = true
        this.favoriteQuestionId = response.data.id
        this.favoriteQuestionsCount += 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね！されています"
      }
    },
    async removeFromFavorite() {
      try {
        const response = await axios.delete(`/questions/${this.question.id}/favorite_questions/${this.favoriteQuestionId}`, {
          params: {
            user_id: this.currentUser.id
          }
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！を削除しました"
        this.isFavorite = !this.isFavorite
        this.favoriteQuestionId = null
        this.favoriteQuestionsCount -= 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね！されていません"
      }
    },
    openReplyDialog() {
      if(this.currentUser) {
        this.replyDialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    async submitReply(data) {
      try {
        const response = await axios.post(`/books/${this.book.id}/questions/${this.question.id}/replies`, {
            user_id: this.currentUser.id,
            content: data.content,
          }
        )
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "返信の投稿が完了しました"
        this.$router.push({ path: `/books/${this.book.id}/questions/${this.question.id}/replies/${response.data.id}`, query: { message: '返信の投稿が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を投稿できませんでした"
      }
      this.questionDialog = false

    }


  },




}
</script>

<style>

</style>
