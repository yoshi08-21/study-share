<template>
  <div>
    <v-row mb-5 v-for="(book, index) in books" :key="index" class="justify-center">
      <v-col cols="10">
        <v-card
          elevation="8"
          height="240"
        >
          <v-row>
            <v-col cols="3" class="d-flex justify-center">
              <div v-if="book.image" class="d-flex justify-center" style="height: 210px;">
                <v-img
                  :src="book.image"
                  alt="画像"
                  contain
                  max-height="200"
                  max-width="180"
                >
                </v-img>
              </div>
            </v-col>
            <v-col cols="7" class="mt-n4">
              <div style="height: 107px;">
                <v-card-title>
                  <nuxt-link :to="`/books/${book.id}`">{{ $truncate(book.name, 50) }}</nuxt-link>
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
              </div>

                <v-card-text>
                <h3 style="margin-bottom: 5px;">科目: {{ book.subject }}</h3>
                <h4>出版社: {{ book.publisher }}</h4>
                <h4>著者: {{ book.author }}</h4>
              </v-card-text>

              <v-card-actions>
                <v-row class="d-flex align-center justify-center">
                  <v-col cols="4">
                    <v-icon>mdi-comment-text-outline</v-icon>
                    レビュー:{{ book.reviews_count }}件
                  </v-col>
                  <v-col cols="4">
                    <v-icon>mdi-heart-multiple</v-icon>
                    お気に入り: {{ book.favorite_books_count }}
                  </v-col>
                </v-row>
              </v-card-actions>
            </v-col>
            <v-col cols="2" class="d-flex justify-center ml-n5">
              <template v-if="currentUser">
                <v-btn v-if="book.check_favorite == 0" @click="addToFavorites(book, $event)" class="mt-8">お気に入り</v-btn>
                <v-btn v-else @click="removeFromFavorite(book, $event)" class="mt-8">お気に入り解除</v-btn>
              </template>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>

    <!-- スナックバー表示用 -->
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
          book.favorite_books_count += 1
          this.snackbarColor = "primary"
          this.snackbar = true
          this.flashMessage = "お気に入りに追加しました"
        } catch(error) {
          console.log(error)
          this.snackbarColor = "red accent-2"
          this.snackbar = true
          this.flashMessage = "すでにお気に入りに登録されています"
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
        book.favorite_books_count -= 1
        book.check_favorite = 0
        this.snackbar = true
        this.snackbarColor = "primary"
        this.flashMessage = "お気に入りから削除しました"
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "お気に入りに登録されていません"
      }
    },
  }
}
</script>

<style>

</style>
