<template>
  <div>
    book_show
    <p>book_id: {{ this.$route.params.id }}</p>
    <h4>タイトル: {{ book.name }}</h4>
    <h4>作者: {{ book.author }}</h4>
    <h4>出版社: {{ book.publisher }}</h4>
    <h4>科目: {{ book.subject }}</h4>

    <div v-if="!isFavorite">
      <v-btn @click="addToFavorites">お気に入りに追加する</v-btn>
    </div>
    <div v-else>
      <v-btn @click="removeFromFavorite">お気に入りから削除する</v-btn>
    </div>
    <br>
    <v-btn @click="openDialog">新規レビューを投稿する</v-btn>

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

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

    <br>
    <v-divider height="50"></v-divider>

    <v-pagination v-model="page" :length="totalPages" @input="updateReviews"></v-pagination>
    <book-reviews :reviews="reviewsChunk" :book_id="book.id" ></book-reviews>
    <v-pagination v-model="page" :length="totalPages" @input="updateReviews"></v-pagination>
  </div>
</template>

<script>

import { VDialog, VDivider } from 'vuetify/lib'
import ReviewForm from '../../components/reviews/ReviewForm.vue'
import BookReviews from '../../components/reviews/BookReviews.vue'
import axios from "@/plugins/axios"


export default {
  components: {
    ReviewForm,
    VDialog,
    VDivider,
    BookReviews
  },
  async asyncData({ params }) {
    const book = await axios.get(`/books/${params.id}`)
    const reviews = await axios.get(`/books/${params.id}/reviews`)
    console.log(book.data)
    console.log(reviews.data)
    return {
      book: book.data,
      reviews: reviews.data,
      params
    };
    // const [reviews, questions] = await Promise.all([
    //   axios.get(`/books/${params.id}/reviews`),
    //   axios.get(`/books/${params.id}/questions`)
    // ])
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
    totalPages() {
      return Math.ceil(this.reviews.length / this.perPage);
    },
  },
  async created() {
    try {
      const response = await axios.get("books/is_favorite", {
        params: {
          user_id: this.$store.getters["auth/getCurrentUserId"],
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
        this.flashMessage = "気に入りに登録されていません"
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
    openDialog() {
      if(this.currentUser) {
        this.dialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    }
  }
}
</script>

<style>

</style>
