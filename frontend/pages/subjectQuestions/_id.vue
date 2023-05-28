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

    <br>
    <!-- 自分のレビューもしくは未ログイン時はいいねの件数だけ表示 -->
    <template v-if="this.currentUser && this.user.id !== this.currentUser.id">
      <template v-if="!isFavorite">
        <v-btn @click="addToFavorite">いいね！する</v-btn>
        <P>いいね！（{{ this.favoriteSubjectQuestionsCount }}件）</P>
      </template>
      <template v-else>
        <v-btn @click="removeFromFavorite">いいね！を削除する</v-btn>
        <P>いいね！（{{ this.favoriteSubjectQuestionsCount }}件）</P>
      </template>
    </template>
    <template v-else>
      <P>いいね！（{{ this.favoriteSubjectQuestionsCount }}件）</P>
    </template>



    <!-- 自分の質問のみ編集・削除ボタンを表示 -->
    <br>
    <template v-if="this.currentUser && this.user.id == this.currentUser.id">
      <v-btn @click="dialog=true">編集する</v-btn>
      <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
    </template>

    <br><br>
    <v-btn @click="redirectToSubjectQuestions">科目別質問一覧に戻る</v-btn>


    <br><br><hr>
    <v-btn @click="openSubjectQuestionReplyDialog">返信を投稿する</v-btn>

    <!-- 新規返信投稿ダイアログ -->
    <v-dialog v-model="subjectQuestionReplyDialog">
      <v-card>
        <v-card-title>
          Dialog Title
        </v-card-title>
        <v-card-text>
          <reply-form @submitReply="submitSubjectQuestionReply" @closeDialog="subjectQuestionReplyDialog = false"></reply-form>
        </v-card-text>
      </v-card>
    </v-dialog>

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
    <subject-question-replies :subjectQuestionReplies="subjectQuestionReplies"></subject-question-replies>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditSubjectQuestion from '../../components/subjectQuestions/EditSubjectQuestion.vue'
import SubjectQuestionReplies from '../../components/subjectQuestionReplies/SubjectQuestionReplies.vue'
import ReplyForm from '../../components/replies/ReplyForm.vue'
import axios from "@/plugins/axios"

export default {
  components: { EditSubjectQuestion, SubjectQuestionReplies, ReplyForm },
  async asyncData({ params }) {
    try {
      const [subjectQuestionResponse, subjectQuestionRepliesResponse] = await Promise.all([
        axios.get(`subject_questions/${params.id}`),
        axios.get(`subject_questions/${params.id}/subject_question_replies`)
      ])
      console.log(subjectQuestionResponse)
      console.log(subjectQuestionRepliesResponse)
      console.log(subjectQuestionRepliesResponse.data)
      return {
        subjectQuestion: subjectQuestionResponse.data.subject_question,
        favoriteSubjectQuestionsCount: subjectQuestionResponse.data.favorite_subject_questions_count,
        user: subjectQuestionResponse.data.subject_question.user,
        subjectQuestionReplies: subjectQuestionRepliesResponse.data,
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
      favoriteSubjectQuestionId: "",
      subjectQuestionReplyDialog: false,

    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
  async created() {
    try {
      const response = await axios.get("subject_questions/is_favorite", {
        params: {
          user_id: this.$store.getters["auth/getCurrentUserId"],
          subject_question_id: this.$route.params.id
        }
      })
      console.log(response)
      this.isFavorite = response.data.is_favorite
      this.favoriteSubjectQuestionId = response.data.favorite_subject_question_id
    } catch(error) {
      console.log("エラー文です")
      console.log(error)
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
        const response = await axios.post(`/subject_questions/${this.subjectQuestion.id}/favorite_subject_questions`, {
          user_id: this.currentUser.id
        })
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！しました"
        this.isFavorite = true
        this.favoriteSubjectQuestionId = response.data.id
        this.favoriteSubjectQuestionsCount += 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね！されています"
      }
    },
    async removeFromFavorite() {
      try {
        const response = await axios.delete(`/subject_questions/${this.subjectQuestion.id}/favorite_subject_questions/${this.favoriteSubjectQuestionId}`, {
          params: {
            user_id: this.currentUser.id
          }
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！を削除しました"
        this.isFavorite = !this.isFavorite
        this.favoriteSubjectQuestionId = null
        this.favoriteSubjectQuestionsCount -= 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね！されていません"
      }
    },
    openSubjectQuestionReplyDialog() {
      if(this.currentUser) {
        this.subjectQuestionReplyDialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    async submitSubjectQuestionReply(data) {
      try {
        const response = await axios.post(`/subject_questions/${this.subjectQuestion.id}/subject_question_replies`, {
            user_id: this.currentUser.id,
            content: data.content,
          }
        )
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "返信の投稿が完了しました"
        this.$router.push({ path: `/subjectQuestions/${this.subjectQuestion.id}/subjectQuestionReplies/${response.data.id}`, query: { message: '返信の投稿が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を投稿できませんでした"
      }
      this.subjectQuestionReplyDialog = false
    }


  },




}
</script>

<style>

</style>