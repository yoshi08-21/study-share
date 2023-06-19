<template>
  <div>
    <v-flex mb-5 v-for="(book, index) in books" :key="index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/books/${book.id}`">
            <v-row>
              <v-col cols="2">
                <template v-if="book.image">
                  <v-img :src="book.image" alt="画像"></v-img>
                </template>
              </v-col>
              <v-col cols="10">
                <v-card-title>タイトル: {{ book.name }}</v-card-title>
                <v-card-text>
                  <h4>著者: {{ book.author }}</h4>
                  <h4>出版社: {{ book.publisher }}</h4>
                  <h4>科目: {{ book.subject }}</h4>
                </v-card-text>
              </v-col>
            </v-row>
            <v-card-actions>
              レビュー:{{ book.reviews_count }}件
              平均評価:{{ book.average_rating }}
              お気に入り: {{ book.favorite_books_count }}
              <tamplate  v-if="currentUser">
                <v-btn v-if="book.check_favorite == 0" @click="addToFavorites(book, $event)">お気に入り</v-btn>
                <v-btn v-else @click="removeFromFavorite(book, $event)">お気に入り解除</v-btn>
              </tamplate>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </v-flex>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  props: {
    books: [],
  },
  data() {
    return {
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",

    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
  methods: {
    async addToFavorites(book, event) {
      event.preventDefault();
      if (this.currentUser) {
        try {
          const response = await axios.post(`/books/${book.id}/favorite_books`, {
            user_id: this.currentUser.id,
          })
          console.log(response.data)
          book.check_favorite = 1
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
    async removeFromFavorite(book, event) {
      event.preventDefault();
      try {
        const response = await axios.delete("/favorite_books/destroy_from_item_list", {
          params: {
            user_id: this.currentUser.id,
            book_id: book.id
          }
        })
        console.log(response)
        book.check_favorite = 0
        this.snackbar = true
        this.snackbarColor = "primary"
        this.flashMessage = "お気に入りから削除しました"
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "気に入りに登録されていません"
      }
    },
  }
}
</script>

<style>

</style>
