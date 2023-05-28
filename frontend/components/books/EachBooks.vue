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
            <!-- <v-card-actions v-if="book.is_favorite == false">
              <v-btn @click.stop="add">お気に入りに追加する</v-btn>
            </v-card-actions>
            <v-card-actions v-else>
              <v-btn @click.stop="add">お気に入りから削除する</v-btn>
            </v-card-actions> -->
          </v-card>
        </v-col>
      </v-row>
    </v-flex>
  </div>
</template>

<script>

// import axios from "@/plugins/axios"

export default {
  props: {
    books: [],
  },

  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
  // methods: {
  //   async addToFavorites(book) {
  //     if (this.currentUser) {
  //       try {
  //         const response = await axios.post(`/books/${book.id}/favorite_books`, {
  //           user_id: this.currentUser.id,
  //         })
  //         console.log(response.data)
  //         this.isFavorite = !this.isFavorite
  //         this.favoriteBookId = response.data.favorite_book_id
  //         this.snackbar = true
  //         this.flashMessage = "お気に入りに追加しました"
  //       } catch(error) {
  //         console.log(error)
  //         console.log("すでにお気に入りに登録されています")
  //       }
  //     } else {
  //       this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
  //     }

  //   },
  //   async removeFromFavorite() {
  //     try {
  //       const response = await axios.delete(`/books/${this.params.id}/favorite_books/${this.favoriteBookId}`, {
  //         params: {
  //           user_id: this.currentUser.id,
  //           book_id: this.params.id
  //         }
  //       })
  //       console.log(response)
  //       this.isFavorite = !this.isFavorite
  //       this.snackbar = true
  //       this.flashMessage = "お気に入りから削除しました"
  //     } catch(error) {
  //       console.log(error)
  //       this.snackbarColor = "red accent-2"
  //       this.snackbar = true
  //       this.flashMessage = "気に入りに登録されていません"
  //     }
  //   },

  // }
}
</script>

<style>

</style>
