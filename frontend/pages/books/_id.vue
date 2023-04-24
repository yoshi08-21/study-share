<template>
  <div>
    book_show
    <p>id: {{ this.$route.params.id }}</p>
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
    <v-btn @click="dialog = true">新規レビューを投稿する</v-btn>

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

  </div>
</template>

<script>

import { VDialog } from 'vuetify/lib'
import ReviewForm from '../../components/ReviewForm.vue'
import axios from "@/plugins/axios"


export default {
  components: {
    ReviewForm,
    VDialog
  },
  async asyncData({ params }) {
    const response = await axios.get(`/books/${params.id}`)
    console.log(response.data)
    return { book: response.data, params};
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
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    }
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
    } catch(error) {
      console.log("エラー文です")
      console.log(error)
    }
  },
  methods: {
    async addToFavorites() {
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
        console.log("お気に入りに登録されていません")
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
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "レビューを投稿できませんでした"
      }
      this.dialog = false
    }
  }
}
</script>

<style>

</style>
