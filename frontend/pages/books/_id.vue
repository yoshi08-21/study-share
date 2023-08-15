<template>
  <div>

    <div class="d-flex justify-space-between" style="margin-top: 50px; margin-bottom: 10px;">
      <h2>参考書詳細</h2>
      <nuxt-link :to="`/books/allBooks`">参考書一覧に戻る</nuxt-link>
    </div>
    <v-card
      min-height="350"
    >
      <v-row>
        <v-col cols="3" class="d-flex justify-center">
          <div v-if="book.image">
              <v-img
                :src="book.image"
                alt="画像"
                contain
                haight="230"
                width="210"
              ></v-img>
            </div>
        </v-col>
        <v-col cols="7">
          <v-card-title>
            <h3> {{ book.name }}</h3>

          </v-card-title>
          <v-card-subtitle style="margin-top: -20px;">
            <v-row class="d-flex align-center">
              <v-col cols="4">
                <v-rating
                  v-model="book.average_rating"
                  :readonly="true"
                  background-color="orange lighten-3"
                  color="orange"
                  dense
                  large
                >
                </v-rating>
              </v-col>
              <v-col cols="3">
                <h2>
                  ({{ book.average_rating }})
                </h2>
              </v-col>
            </v-row>
          </v-card-subtitle>

          <v-card-content>
            <h3 style="margin-bottom: 5px;">科目: {{ book.subject }}</h3>
            <h4>作者: {{ book.author }}</h4>
            <h4>出版社: {{ book.publisher }}</h4>
            <br>
            <tamplate v-if="book.description">
              <h4>説明</h4>
              <v-textarea
                :value="book.description"
                readonly
                outlined
                rounded
                dense
                auto-grow
              >
              </v-textarea>
            </tamplate>
          </v-card-content>
          <br><br>
          <v-card-actions>
            <v-row class="d-flex align-center">
              <v-col cols="3">
                <v-icon>mdi-comment-text-outline</v-icon>
                レビュー:{{ book.reviews_count }}件
              </v-col>
              <v-col cols="3">
                <v-icon>mdi-comment-question-outline</v-icon>
                質問:{{ book.reviews_count }}件
              </v-col>
              <v-col cols="3">
                <v-icon>mdi-heart-multiple</v-icon>
                お気に入り:{{ book.favorite_books_count }}
              </v-col>
              <v-col cols="3">
                <div v-if="!isFavorite">
                  <v-btn @click="addToFavorites" color="primary">お気に入りに追加する</v-btn>
                </div>
                <div v-else>
                  <v-btn @click="removeFromFavorite">お気に入りから削除する</v-btn>
                </div>
              </v-col>
            </v-row>
          </v-card-actions>
        </v-col>
        <v-col cols="2" class="d-flex flex-column" style="padding: 20px;">
          <template v-if="this.currentUser && this.book.user_id == this.currentUser.id">
            <v-btn @click="editBookDialog=true" style="margin-bottom: 10px;">編集する</v-btn>
            <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
          </template>
        </v-col>
      </v-row>
    </v-card>

    <br><br><br><br>
    <v-card height="100px">
      <v-row style="height: 100%;">
        <v-col cols="6" class="d-flex justify-center align-center">
          <v-btn
            @click="openDialog"
            x-large
            rounded
            color="success"
          >
          新規レビューを投稿する
        </v-btn>
        </v-col>
        <v-col cols="6" class="d-flex justify-center align-center">
          <v-btn
            @click="openQuestionDialog"
            x-large
            rounded
            color="success"
          >
            新規質問を投稿する
          </v-btn>
        </v-col>
      </v-row>
    </v-card>


    <!-- 参考書編集ダイアログ -->
    <v-dialog v-model="editBookDialog">
      <v-card>
        <v-card-title>
          参考書を編集する
        </v-card-title>
        <v-card-text>
          <edit-book
            :name="book.name"
            :author="book.author"
            :publisher="book.publisher"
            :subject="book.subject"
            :description="book.description"
            @submitBook="editBook"
            @closeDialog="editBookDialog = false"
          ></edit-book>
        </v-card-text>
      </v-card>
    </v-dialog>

        <!-- 参考書削除の確認ダイアログ -->
        <v-dialog v-model="showDeleteConfirmation">
      <v-card>
        <v-card-title>
          削除した参考書は復元できません！
        </v-card-title>
        <v-card-text>
          <strong>
            参考書を削除しますか？
          </strong>
        </v-card-text>
        <v-card-actions class="justify-content-center">
          <v-btn @click="deleteBook">削除する</v-btn>
          <v-btn @click="showDeleteConfirmation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 新規レビュー投稿ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          Dialog Title
        </v-card-title>
        <v-card-text>
          <review-form @submitReview="submitReview" @closeDialog="dialog = false"></review-form>
        </v-card-text>
      </v-card>
    </v-dialog>

        <!-- 新規質問投稿ダイアログ -->
        <v-dialog v-model="questionDialog">
      <v-card>
        <v-card-title>
          Dialog Title（質問）
        </v-card-title>
        <v-card-text>
          <question-form @submitQuestion="submitQuestion" @closeDialog="questionDialog = false"></question-form>
        </v-card-text>
      </v-card>
    </v-dialog>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>


    <br>
    <v-divider height="50"></v-divider>
    <br>
    <v-tabs
      v-model="tab"
      centered
      grow
      height="60"
    >
      <v-tab v-for="(tabItem, index) in tabs" :key="index" @click="page = 1">
          {{ tabItem.label }}
      </v-tab>
    </v-tabs>


    <template v-if="tab === 0">
      <v-pagination v-model="page" :length="reviewsTotalPages"></v-pagination>
      <br><br>
      <book-reviews :reviews="reviewsChunk"></book-reviews>
      <v-pagination v-model="page" :length="reviewsTotalPages"></v-pagination>
    </template>

    <template v-else-if="tab === 1">
      <v-pagination v-model="page" :length="questionsTotalPages"></v-pagination>
      <br><br>
      <book-questions :questions="questionsChunk"></book-questions>
      <v-pagination v-model="page" :length="questionsTotalPages"></v-pagination>
    </template>

    <br>



  </div>
</template>

<script>

import { VDialog, VDivider } from 'vuetify/lib'
import ReviewForm from '../../components/reviews/ReviewForm.vue'
import QuestionForm from '../../components/questions/QuestionForm.vue'
import BookReviews from '../../components/reviews/BookReviews.vue'
import BookQuestions from '../../components/questions/BookQuestions.vue'
import EditBook from '../../components/books/EditBook.vue'

import axios from "@/plugins/axios"



export default {
  components: {
    ReviewForm,
    QuestionForm,
    VDialog,
    VDivider,
    BookReviews,
    BookQuestions,
    EditBook
  },
  // asyncDataでデータをreturnする場合、そのデータは自動的にdataに変数としてマージされる
  async asyncData({ params, store }) {
    try {
      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const [bookResponse, reviewsResponse, questionsResponse] = await Promise.all([
        axios.get(`/books/${params.id}`, {
          params: {
            current_user_id: currentUserId
          }
        }),
        axios.get(`/books/${params.id}/reviews`),
        axios.get(`/books/${params.id}/questions`)
      ])
      const book = bookResponse.data
      const reviews = reviewsResponse.data
      const questions = questionsResponse.data
      console.log(book)
      console.log(reviews)
      console.log(questions)
      return {
        book,
        reviews,
        questions,
        params
      };
    } catch(error) {
      console.log(error)
      throw error
    }

  },
  data() {
    return {
      book: null,
      isFavorite: false,
      favoriteBookId: "",
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
      dialog: false,
      reviews: [],
      perPage: 10,
      page: 1,
      questionDialog: false,
      editBookDialog: false,
      showDeleteConfirmation: false,
      tab: 0,
      tabs: [
        { label: "レビュー" },
        { label: "質問" },
      ]

    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    reviewsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.reviews.slice(start, end)
    },
    questionsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.questions.slice(start, end)
    },
    reviewsTotalPages() {
      return Math.ceil(this.reviews.length / this.perPage);
    },
    questionsTotalPages() {
      return Math.ceil(this.questions.length / this.perPage);
    },
  },
  async created() {
    try {
      let currentUserId = ""
      const currentUser = this.$store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const response = await axios.get("books/is_favorite", {
        params: {
          user_id: currentUserId,
          book_id: this.$route.params.id
        }
      })
      console.log(response)
      this.isFavorite = response.data.is_favorite
      this.favoriteBookId = response.data.favorite_book_id
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
    async addToFavorites() {
      if (this.currentUser) {
        try {
          const response = await axios.post(`/books/${this.params.id}/favorite_books`, {
            user_id: this.currentUser.id,
            book_id: this.params.id
          })
          console.log(response.data)
          this.isFavorite = !this.isFavorite
          this.favoriteBookId = response.data.favorite_book_id
          this.snackbar = true
          this.flashMessage = "お気に入りに追加しました"
          this.book.favorite_books_count += 1
        } catch(error) {
          console.log(error)
          console.log("すでにお気に入りに登録されています")
        }
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }

    },
    async removeFromFavorite() {
      try {
        const response = await axios.delete(`/books/${this.params.id}/favorite_books/${this.favoriteBookId}`, {
          params: {
            user_id: this.currentUser.id,
            book_id: this.params.id
          }
        })
        console.log(response)
        this.isFavorite = !this.isFavorite
        this.snackbar = true
        this.flashMessage = "お気に入りから削除しました"
        this.book.favorite_books_count -= 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "お気に入りに登録されていません"
      }
    },
    async submitReview(data) {
      try {
        const response = await axios.post(`/books/${this.params.id}/reviews`, {
            user_id: this.currentUser.id,
            book_id: this.params.id,
            title: data.title,
            content: data.content,
            rating: data.rating
          }
        )
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "レビューの投稿が完了しました"
        this.$router.push({ path: `/books/${this.book.id}/reviews/${response.data.id}`, query: { message: 'レビューの投稿が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "レビューを投稿できませんでした"
      }
      this.dialog = false
    },
    async submitQuestion(data) {

      const formData = new FormData()

      formData.append("question[user_id]", this.currentUser.id);
      formData.append("question[book_id]", this.params.id);
      formData.append("question[title]", data.title);
      formData.append("question[content]", data.content);
      formData.append("question[subject]", this.book.subject);
      if (data.image) {
          formData.append("question[image]", data.image);
      }

      try {
        const response = await axios.post(`/books/${this.params.id}/questions`, formData)
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "質問の投稿が完了しました"
        this.$router.push({ path: `/books/${this.book.id}/questions/${response.data.id}`, query: { message: '質問の投稿が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を投稿できませんでした"
      }
      this.questionDialog = false
    },
    openDialog() {
      if(this.currentUser) {
        this.dialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    openQuestionDialog() {
      if(this.currentUser) {
        this.questionDialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    async editBook(data) {
      const formData = new FormData()

      formData.append("book[user_id]", this.currentUser.id);
      formData.append("book[name]", data.name);
      formData.append("book[author]", data.author);
      formData.append("book[publisher]", data.publisher);
      formData.append("book[subject]", data.subject);
      formData.append("book[description]", data.description);
      if (data.image) {
          formData.append("book[image]", data.image);
      }

      try {
        const response = await axios.patch(`/books/${this.book.id}`, formData)
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "参考書の編集が完了しました"
        this.book.name = response.data.book.name
        this.book.author = response.data.book.author
        this.book.publisher = response.data.book.publisher
        this.book.subject = response.data.book.subject
        this.book.description = response.data.book.description
        if (response.data.image_url) {
          this.book.image = response.data.image_url
        }
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を編集できませんでした"
      }
      this.editBookDialog = false
    },
    async deleteBook() {
      try {
        const response = await axios.delete(`/books/${this.book.id}`, {
          params: { current_user_id: this.currentUser.id }
        })
        console.log(response)
        this.$router.push({ path: `/books/allBooks`, query: { message: '参考書を削除しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "参考書を削除できませんでした"
        this.showDeleteConfirmation = false
      }
    },
    redirectToBooks() {
      this.$router.push({ path: `/books/allBooks` })
    },

  }
}
</script>

<style>

</style>
