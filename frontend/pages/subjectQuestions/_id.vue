<template>
  <div>
    <h2>科目別質問：詳細ページ</h2>
    <h3>質問id: {{ this.subjectQuestion.id }}</h3>

    <br>
    <h3>質問</h3>
    <h4>タイトル:{{ this.subjectQuestion.title }}</h4>
    <p>本文:{{ this.subjectQuestion.content }}</p>
    <h4>科目:{{ this.subjectQuestion.subject }}</h4>

    <tepmplate v-if="subjectQuestion.image">
      <v-img
        :src="subjectQuestion.image"
        @click="showFullImage = true"
        max-height="200"
        max-width="200"
        contain
      ></v-img>
      *画像をクリックすると拡大して表示できます
    </tepmplate>

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

    <br>
    <v-btn @click="previousQuestion">前の「{{ subjectQuestion.subject }}」の質問</v-btn>
    <v-btn @click="nextQuestion">次の「{{ subjectQuestion.subject }}」の質問</v-btn>

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

    <!-- 大きいサイズの画像表示用のダイアログ -->
    <v-dialog v-model="showFullImage">
      <v-card>
        <h3>画像を表示する</h3>
        <v-img
          :src="subjectQuestion.image"
          max-height="400"
          max-width="400"
          contain
        ></v-img>
      </v-card>
    </v-dialog>

    <br>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
    <br>
    <each-subject-question-replies :subjectQuestionReplies="subjectQuestionReplyChunk"></each-subject-question-replies>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditSubjectQuestion from '../../components/subjectQuestions/EditSubjectQuestion.vue'
import ReplyForm from '../../components/replies/ReplyForm.vue'
import EachSubjectQuestionReplies from '../../components/subjectQuestionReplies/EachSubjectQuestionReplies.vue'
import axios from "@/plugins/axios"

export default {
  components: { EditSubjectQuestion, ReplyForm, EachSubjectQuestionReplies },
  async asyncData({ params, store }) {
    try {
      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const [subjectQuestionResponse, subjectQuestionsResponse, subjectQuestionRepliesResponse] = await Promise.all([
        axios.get(`subject_questions/${params.id}`, {
          params: {
            current_user_id: currentUserId
          }
        }),
        axios.get("/subject_questions/questions_to_specific_subject", {
          params: {
            subject_question_id: params.id
          }
        }),
        axios.get(`subject_questions/${params.id}/subject_question_replies`)
      ])
      console.log(subjectQuestionResponse.data)
      console.log(subjectQuestionsResponse.data)
      console.log(subjectQuestionRepliesResponse.data)
      return {
        subjectQuestion: subjectQuestionResponse.data.subject_question,
        favoriteSubjectQuestionsCount: subjectQuestionResponse.data.favorite_subject_questions_count,
        user: subjectQuestionResponse.data.subject_question.user,
        subjectQuestions: subjectQuestionsResponse.data,
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
      perPage: 10,
      page: 1,
      showFullImage: false,

    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    subjectQuestionReplyChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.subjectQuestionReplies.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.subjectQuestionReplies.length / this.perPage);
    },
  },
  async created() {
    try {
      let currentUserId = ""
      const currentUser = this.$store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const response = await axios.get("subject_questions/is_favorite", {
        params: {
          user_id: currentUserId,
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
      const formData = new FormData()

      formData.append("subject_question[user_id]", this.currentUser.id);
      formData.append("subject_question[title]", data.title);
      formData.append("subject_question[content]", data.content);
      formData.append("subject_question[subject]", data.subject);
      if (data.image) {
          formData.append("subject_question[image]", data.image);
      }

      try {
        const response = await axios.patch(`/subject_questions/${this.subjectQuestion.id}`, formData)
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "質問の編集が完了しました"
        this.subjectQuestion.title = response.data.title
        this.subjectQuestion.content = response.data.content
        this.subjectQuestion.subject = response.data.subject
        if (response.data.image_url) {
          this.subjectQuestion.image = response.data.image_url
        }
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
        this.$router.push({ path: `/subjectQuestions/${this.subjectQuestion.id}/subjectQuestionReplies/${response.data.id}`, query: { message: '返信の投稿が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を投稿できませんでした"
      }
      this.subjectQuestionReplyDialog = false
    },
    nextQuestion() {
      const index = this.subjectQuestions.findIndex(item => item.id === this.subjectQuestion.id)
      const nextIndex = index + 1
      const nextSubjectQuestion = this.subjectQuestions[nextIndex]
      const lastItem = this.subjectQuestions[this.subjectQuestions.length - 1]
      if(this.subjectQuestion.id !== lastItem.id) {
        this.$router.push({ path: `/subjectQuestions/${nextSubjectQuestion.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最後の質問です"
      }
    },
    previousQuestion() {
      const index = this.subjectQuestions.findIndex(item => item.id === this.subjectQuestion.id)
      const previousIndex = index - 1
      const previousSubjectQuestion = this.subjectQuestions[previousIndex]
      const firstItem = this.subjectQuestions[0]
      if(this.subjectQuestion.id !== firstItem.id) {
        this.$router.push({ path: `/subjectQuestions/${previousSubjectQuestion.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最初の質問です"
      }
    }
  },
}
</script>

<style>

</style>
