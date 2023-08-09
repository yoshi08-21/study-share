<template>
  <div>
    book_show
    <v-row>
      <v-col cols="10">
        <v-row>
          <v-col cols="4">
            <template v-if="book.image">
              <v-img :src="book.image" alt="画像"></v-img>
            </template>
          </v-col>
          <v-col cols="8">
            <p>book_id: {{ this.$route.params.id }}</p>
            <h4>タイトル: {{ book.name }}</h4>
            <h4>作者: {{ book.author }}</h4>
            <h4>出版社: {{ book.publisher }}</h4>
            <h4>科目: {{ book.subject }}</h4>
          </v-col>
        </v-row>

      </v-col>
    </v-row>
    <!-- 自分が投稿した参考書のみ編集・削除ボタンを表示 -->
    <br>
    <template v-if="this.currentUser && this.book.user_id == this.currentUser.id">
      <v-btn @click="editBookDialog=true">編集する</v-btn>
      <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
    </template>


    <br><br>
    <div v-if="!isFavorite">
      <v-btn @click="addToFavorites">お気に入りに追加する</v-btn>
    </div>
    <div v-else>
      <v-btn @click="removeFromFavorite">お気に入りから削除する</v-btn>
    </div>

    <br>
    <v-btn @click="redirectToBooks">参考書一覧に戻る</v-btn>

    <!-- 以下のボタンをそれぞれのコンポーネントに設置することも検討 -->
    <br><br>
    <v-btn @click="openDialog">新規レビューを投稿する</v-btn>
    <br><br>
    <v-btn @click="openQuestionDialog">新規質問を投稿する</v-btn>


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

    <v-pagination v-model="page" :length="totalPages"></v-pagination>
    <book-reviews :reviews="reviewsChunk" :book_id="book.id" ></book-reviews>
    <book-questions :questions="questionsChunk" :book_id="book.id"></book-questions>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
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
    totalPages() {
      return Math.ceil(this.reviews.length / this.perPage);
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
      try {
        const response = await axios.patch(`/books/${this.book.id}`, {
          name: data.name,
          author: data.author,
          publisher: data.publisher,
          subject: data.subject,
          current_user_id: this.currentUser.id
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "参考書の編集が完了しました"
        this.book.name = response.data.name
        this.book.author = response.data.author
        this.book.publisher = response.data.publisher
        this.book.subject = response.data.subject
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
