<template>
  <div>
    <h2>質問詳細</h2>
    <h3>質問id: {{ this.question.id }}</h3>

    <h4>参考書情報</h4>
    <p>タイトル:{{  this.book.name }}</p>

    <h3>質問</h3>
    <h4>タイトル:{{ this.question.title }}</h4>
    <p>本文:{{ this.question.content }}</p>
    <h3>questioned by<span class="link-text" @click="redirectToUser"> {{ this.user.name }} </span></h3>

    <br>
    <!-- 自分のレビューもしくは未ログイン時はいいねの件数だけ表示 -->
    <template v-if="this.currentUser && this.user.id !== this.currentUser.id">
      <template v-if="!isFavorite">
        <v-btn @click="addToFavorite">いいね！する</v-btn>
        <P>いいね！（{{ this.favoriteQuestionsCount }}件）</P>
      </template>
      <template v-else>
        <v-btn @click="removeFromFavorite">いいね！を削除する</v-btn>
        <P>いいね！（{{ this.favoriteQuestionsCount }}件）</P>
      </template>
    </template>
    <template v-else>
      <P>いいね！（{{ this.favoriteQuestionsCount }}件）</P>
    </template>


    <!-- 自分の質問のみ編集・削除ボタンを表示 -->
    <br>
    <template v-if="this.currentUser && this.user.id == this.currentUser.id">
      <v-btn @click="dialog=true">編集する</v-btn>
      <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
    </template>

    <br><br>
    <v-btn @click="redirectToBook">参考書に戻る</v-btn>

    <br><br><hr>
    <v-btn @click="openReplyDialog">返信を投稿する</v-btn>

    <!-- 新規返信投稿ダイアログ -->
    <v-dialog v-model="replyDialog">
      <v-card>
        <v-card-title>
          Dialog Title
        </v-card-title>
        <v-card-text>
          <reply-form @submitReply="submitReply" @closeDialog="replyDialog = false"></reply-form>
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
          <edit-question
            :title="question.title"
            :content="question.content"
            @submitQuestion="editQuestion"
            @closeDialog="dialog = false"
          ></edit-question>
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
          <v-btn @click="deleteQuestion">削除する</v-btn>
          <v-btn @click="showDeleteConfirmation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <br>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
    <question-replies :replies="repliesChunk"></question-replies>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditQuestion from '../../../../components/questions/EditQuestion.vue'
import QuestionReplies from '../../../../components/replies/QuestionReplies.vue'
import ReplyForm from '../../../../components/replies/ReplyForm.vue'
import axios from "@/plugins/axios"

export default {
  components: { EditQuestion, QuestionReplies, ReplyForm },
  async asyncData({ params, store }) {
    try {
      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const [questionResponse, repliesResponse] = await Promise.all([
        axios.get(`/books/${params.book_id}/questions/${params.id}`, {
          params: {
            current_user_id: currentUserId
          }
        }),
        axios.get(`/books/${params.book_id}/questions/${params.id}/replies`)
      ])
      const questionData = questionResponse.data
      const replies = repliesResponse.data
      console.log(questionData)
      console.log(replies)
      return {
        book: questionData.book,
        question: questionData.question,
        user: questionData.question.user,
        favoriteQuestionsCount: questionData.favorite_questions_count,
        replies,
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
      perPage: 10,
      page: 1,

    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    repliesChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.replies.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.replies.length / this.perPage);
    },
  },
  async created() {
    try {
      let currentUserId = ""
      const currentUser = this.$store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const response = await axios.get("questions/is_favorite", {
        params: {
          user_id: currentUserId,
          question_id: this.$route.params.id
        }
      })
      console.log(response)
      this.isFavorite = response.data.is_favorite
      this.favoriteQuestionId = response.data.favorite_question_id
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
    redirectToBook() {
      this.$router.push({ path: `/books/${this.book.id}` })
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
    async editQuestion(data) {
      try {
        const response = await axios.patch(`/books/${this.params.book_id}/questions/${this.question.id}`, {
          title: data.title,
          content: data.content,
          current_user_id: this.currentUser.id
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "質問の編集が完了しました"
        this.question.title = response.data.title
        this.question.content = response.data.content

      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を編集できませんでした"
      }
      this.dialog = false
    },
    async deleteQuestion() {
      try {
        const response = await axios.delete(`/books/${this.params.book_id}/questions/${this.question.id}`, {
          params: { current_user_id: this.currentUser.id }
        })
        console.log(response)
        this.$router.push({ path: `/books/${this.book.id}`, query: { message: '質問を削除しました' } })
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
        this.$router.push({ path: `/books/${this.book.id}/questions/${this.question.id}/replies/${response.data.id}`, query: { message: '返信の投稿が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を投稿できませんでした"
      }
      this.replyDialog = false

    }
  }
}
</script>

<style>

</style>
