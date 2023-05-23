<template>
  <div>
    <h2>お気に入り一覧</h2>
    <!-- 後でコンポーネントで置き換える -->
    <!-- 配列の空のときのメッセージも追加する -->

    <h3>お気に入りの参考書</h3>
    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(favoriteBook, index) in favoriteBooks" :key="'book_' + index">
      <v-card :to="`/books/${favoriteBook.id}`">
        <v-card-title>タイトル：{{ favoriteBook.name }}</v-card-title>
        <v-card-title>著者：{{ favoriteBook.author }}</v-card-title>
        <v-card-title>出版社：{{ favoriteBook.publisher }}</v-card-title>
        <v-card-title>科目：{{ favoriteBook.subject }}</v-card-title>
      </v-card>
    </v-flex>


    <h3>いいねしたレビュー</h3>
    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(favoriteReview, index) in favoriteReviews" :key="'review_' + index">
      <v-card :to="`/books/${favoriteReview.book_id}/reviews/${favoriteReview.id}`">
        <v-card-title>{{ favoriteReview.title }} 評価：{{ favoriteReview.rating }}</v-card-title>
        <v-card-text>{{ favoriteReview.content }}</v-card-text>
        <template v-if="favoriteReview.user">
          <v-card-actions>by:{{ favoriteReview.user.name }}</v-card-actions>
        </template>
        <template v-if="favoriteReview.book">
          <v-card-actions>to:{{ favoriteReview.book.name }}</v-card-actions>
        </template>
      </v-card>
    </v-flex>

  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  async asyncData({ store }) {
    try {
      const response = await axios.get("/favorites", {
        params: {
          user_id: store.getters["auth/getCurrentUser"].id
        }
      })
      console.log(response.data)
      return {
        favoriteBooks: response.data.favorite_books,
        favoriteReviews: response.data.favorite_reviews
      }
    } catch(error) {
      console.log(error)
    }
  },
  data() {
    return {

    }
  }
}
</script>

<style>

</style>
