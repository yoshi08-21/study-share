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

    <nuxt-link to=/books/1/reviews/new>レビューを書く</nuxt-link>
    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" color="primary">{{ flashMessage }}</v-snackbar>


  </div>
</template>

<script>

import axios from "@/plugins/axios"


export default {
  async asyncData({ params }) {
    const response = await axios.get(`/books/${params.id}`)
    console.log(response.data)
    return { book: response.data, params};
  },
  data() {
    return {
      book: null,
      isFavorite: false,
      snackbar: false,
      flashMessage: "テストメッセージ"
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
    showSnackbar() {
      this.snackbar = !this.snackbar
    }
  }
}
</script>

<style>

</style>
