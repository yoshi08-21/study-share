<template>
  <div>
    <div style="margin-bottom: 10px;">
      <h3>参考書情報</h3>
    </div>
    <book-information :book="book"></book-information>


    <br><br><br>
    <div class="d-flex justify-space-between" style="margin-top: 50px; margin-bottom: 10px;">
      <h2>質問詳細</h2>
      <nuxt-link :to="`/books/${book.id}`">参考書詳細に戻る</nuxt-link>
    </div>
    <v-card
      elevation="8"
      style="padding-bottom: 1px;"
    >
      <v-row>
        <v-col cols="2" class="mt-8">
          <div @click="goToUser(user)" style="cursor: pointer;">
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
              <v-avatar size="100">
                <v-img :src="user.image" alt="画像" contain></v-img>
              </v-avatar>
            </v-col>
          </v-row>
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
                <span style="text-decoration: underline;">{{ $truncate(user.name, 10) }}</span>
              </v-col>
            </v-row>
          </div>
        </v-col>
        <v-col cols="8" class="mt-n2">

          <v-card-title>
            <h3>{{ question.title }}</h3>
          </v-card-title>

          <v-card-text>
            <v-textarea
              :value="question.content"
              readonly
              outlined
              rounded
              dense
              auto-grow
            >
            </v-textarea>
          </v-card-text>

          <template v-if="question.image">
            <v-row>
              <v-col class="d-flex justify-center">
                <v-img
                  @click="showFullImage = true"
                  :src="question.image"
                  alt="画像"
                  contain
                  max-height="250"
                  max-width="250"
                  style="cursor: pointer;"
                ></v-img>
              </v-col>
            </v-row>
            <v-row>
              <v-col class="d-flex justify-center">
                *画像をクリックすると拡大できます
              </v-col>
            </v-row>
          </template>

          <br>
          <v-card-actions>
            <v-row class="d-flex align-center justify-center">
              <v-col cols="4">
                <favorite-button
                  :currentUser="currentUser"
                  :user="user"
                  :isFavorite="isFavorite"
                  :favoriteCount="question.favorite_questions_count"
                  @addToFavorite="addToFavorite"
                  @removeFromFavorite="removeFromFavorite"
                ></favorite-button>
              </v-col>
              <v-col cols="4">
                <v-icon>mdi-comment-text-outline</v-icon>
                返信: {{ question.replies_count }}件
              </v-col>
              <v-col cols="4">
                <v-icon>mdi-calendar-clock</v-icon>
                {{ question.created_at }}
              </v-col>
            </v-row>
          </v-card-actions>

        </v-col>
        <v-col cols="2" class="d-flex flex-column" style="padding: 20px;">
          <template v-if="currentUser && user.id == currentUser.id">
            <v-btn @click="dialog=true" style="margin-bottom: 10px;">編集する</v-btn>
            <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
          </template>
        </v-col>
      </v-row>
    </v-card>

    <br><br>
    <content-navigator
      :content="'質問'"
      @previousContent="previousQuestion"
      @nextContent="nextQuestion"
    >
    </content-navigator>

    <br><br>
    <hr>

    <br><br><br><br>
    <v-card height="100px">
      <v-row style="height: 100%;">
        <v-col class="d-flex justify-center align-center">
          <v-btn
            @click="openReplyDialog"
            x-large
            rounded
            color="success"
            width="600px"
          >
          返信を投稿する
        </v-btn>
        </v-col>
      </v-row>
    </v-card>

    <br><br>
    <template v-if="replies.length !== 0">
      <v-row>
        <v-col class="d-flex justify-center">
          <h2>返信一覧</h2>
        </v-col>
      </v-row>
      <br>
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
      <br>
      <question-replies :replies="repliesChunk"></question-replies>
      <br>
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
    </template>
    <template v-else>
      <v-row>
        <v-col class="d-flex justify-center">
          <h2>返信一覧</h2>
        </v-col>
      </v-row>
      <v-row>
        <v-col class="d-flex justify-center">
          <v-alert
            type="info"
          >
          返信は投稿されていません
          </v-alert>
        </v-col>
      </v-row>
    </template>



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

    <!-- 大きいサイズの画像表示用のダイアログ -->
    <v-dialog v-model="showFullImage">
      <v-card
        max-height="800px"
        style="padding: 10px;"
      >
        <v-row>
          <v-col cols="6" class="d-flex justify-start">
            <v-card-title>拡大画像</v-card-title>
          </v-col>
          <v-col cols="6" class="d-flex justify-end align-center">
            <v-btn @click="showFullImage = false">閉じる</v-btn>
          </v-col>
        </v-row>
        <hr>
        <v-row style="margin-top: 10px; margin-bottom: 5px;">
          <v-col class="d-flex justify-center">
            <v-img
              :src="question.image"
              max-height="500"
              max-width="500"
              contain
            ></v-img>
          </v-col>
        </v-row>
        <v-row>
          <v-col class="d-flex justify-center">
            <v-btn @click="showFullImage = false">閉じる</v-btn>
          </v-col>
        </v-row>
      </v-card>
    </v-dialog>


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditQuestion from '../../../../components/questions/EditQuestion.vue'
import QuestionReplies from '../../../../components/replies/QuestionReplies.vue'
import ReplyForm from '../../../../components/replies/ReplyForm.vue'
import BookInformation from '../../../../components/books/BookInformation.vue'
import favoriteButton from '../../../../components/global/FavoriteButton.vue'
import ContentNavigator from '../../../../components/global/ContentNavigator.vue'
import axios from "@/plugins/axios"

export default {
  components: { EditQuestion, QuestionReplies, ReplyForm, BookInformation, favoriteButton, ContentNavigator },
  async asyncData({ params, store }) {
    try {
      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const [questionResponse, questionsResponse, repliesResponse] = await Promise.all([
        axios.get(`/books/${params.book_id}/questions/${params.id}`, {
          params: {
            current_user_id: currentUserId
          }
        }),
        axios.get(`/books/${params.book_id}/questions`),
        axios.get(`/books/${params.book_id}/questions/${params.id}/replies`)
      ])
      const questionData = questionResponse.data
      const questions = questionsResponse.data
      const replies = repliesResponse.data
      console.log(questionData)
      console.log(replies)
      console.log(questions)
      return {
        book: questionData.book,
        question: questionData.question,
        user: questionData.question_user,
        favoriteQuestionsCount: questionData.favorite_questions_count,
        questions,
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
      showFullImage: false,

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
    goToUser() {
      if(this.currentUser.id !== this.user.id ) {
        this.$router.push({ path: `/users/${this.user.id}` })
      } else {
        this.$router.push({ path: "/mypage" })
      }
    },
    async editQuestion(data) {
      const formData = new FormData()

      formData.append("question[user_id]", this.currentUser.id);
      formData.append("question[title]", data.title);
      formData.append("question[content]", data.content);
      if (data.image) {
          formData.append('question[image]', data.image);
      }

      try {
        const response = await axios.patch(`/books/${this.params.book_id}/questions/${this.question.id}`, formData)
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "質問の編集が完了しました"
        this.question.title = response.data.question.title
        this.question.content = response.data.question.content
        if (response.data.image_url) {
          this.question.image = response.data.image_url
        }
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
        this.question.favorite_questions_count +=1
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
        this.question.favorite_questions_count -=1
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
      const formData = new FormData()

      formData.append("reply[user_id]", this.currentUser.id);
      formData.append("reply[content]", data.content);
      if (data.image) {
          formData.append("reply[image]", data.image);
      }

      try {
        const response = await axios.post(`/books/${this.book.id}/questions/${this.question.id}/replies`, formData)
        console.log(response.data)
        this.$router.push({ path: `/books/${this.book.id}/questions/${this.question.id}/replies/${response.data.id}`, query: { message: '返信の投稿が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を投稿できませんでした"
      }
      this.replyDialog = false
    },
    nextQuestion() {
      const index = this.questions.findIndex(item => item.id === this.question.id)
      const nextIndex = index + 1
      const nextQuestion = this.questions[nextIndex]
      const lastItem = this.questions[this.questions.length - 1]
      if(this.question.id !== lastItem.id) {
        this.$router.push({ path: `/books/${this.book.id}/questions/${nextQuestion.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最後の質問です"
      }
    },
    previousQuestion() {
      const index = this.questions.findIndex(item => item.id === this.question.id)
      const previousIndex = index - 1
      const previousQuestion = this.questions[previousIndex]
      const firstItem = this.questions[0]
      if(this.question.id !== firstItem.id) {
        this.$router.push({ path: `/books/${this.book.id}/questions/${previousQuestion.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最初の質問です"
      }
    }
  }
}
</script>

<style>

</style>
