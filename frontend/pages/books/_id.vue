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
      favoriteBookId: ""
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
      this.favoriteBookId = response.data.favorite_book_id
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
        console.log("お気に入りに追加しました")
        this.isFavorite = !this.isFavorite
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
        console.log("お気に入りから削除しました")
        this.isFavorite = !this.isFavorite
      } catch(error) {
        console.log(error)
        console.log("お気に入りに登録されていません")
      }
    }
  }
}
</script>

<style>

</style>
