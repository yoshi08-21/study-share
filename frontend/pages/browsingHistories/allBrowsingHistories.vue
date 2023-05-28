<template>
  <div>
    <h2>閲覧履歴</h2>
    <!-- 作成したコンポーネントはお気に入りと共有する -->

    <h3>閲覧した参考書（最大10件）</h3>
    <br>
    <v-flex mb-5 v-for="(watchedBook, index) in watchedBooks" :key="'book_' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/books/${watchedBook.id}`">
            <v-row>
              <v-col cols="2">
                <template v-if="watchedBook.image">
                  <v-img :src="watchedBook.image" alt="画像"></v-img>
                </template>
              </v-col>
              <v-col cols="10">
                <v-card-title>タイトル: {{ watchedBook.name }}</v-card-title>
                <v-card-text>
                  <h4>著者: {{ watchedBook.author }}</h4>
                  <h4>出版社: {{ watchedBook.publisher }}</h4>
                  <h4>科目: {{ watchedBook.subject }}</h4>
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

    <h3>閲覧したレビュー（最大10件）</h3>
    <br>
    <v-flex mb-5 v-for="(watchedReview, index) in watchedReviews" :key="'review_' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/books/${watchedReview.book_id}/reviews/${watchedReview.id}`">
            <v-row>
              <v-col cols="2">
                <template v-if="watchedReview.image">
                  <v-img :src="watchedReview.image" alt="画像"></v-img>
                </template>
              </v-col>
              <v-col cols="10">
                <v-card-title>タイトル: {{ watchedReview.title }}</v-card-title>
                <v-card-text>
                  <p>{{ watchedReview.content }}</p>
                </v-card-text>
                <v-card-actions>
                  by: {{ watchedReview.user.name }}
                </v-card-actions>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </v-flex>

    <h3>閲覧した質問（最大10件）</h3>
    <br>
    <v-flex mb-5 v-for="(watchedQuestion, index) in watchedQuestions" :key="'question_' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/books/${watchedQuestion.book_id}/questions/${watchedQuestion.id}`">
            <v-row>
              <v-col cols="2">
                <template v-if="watchedQuestion.image">
                  <v-img :src="watchedQuestion.image" alt="画像"></v-img>
                </template>
              </v-col>
              <v-col cols="10">
                <v-card-title>タイトル: {{ watchedQuestion.title }}</v-card-title>
                <v-card-text>
                  <p>{{ watchedQuestion.content }}</p>
                </v-card-text>
                <v-card-actions>
                  by: {{ watchedQuestion.user.name }}
                  <v-spacer></v-spacer>
                  to: {{ watchedQuestion.book.name }}
                </v-card-actions>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </v-flex>

  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  async asyncData({ store }) {
    try {
      const response = await axios.get("/browsing_histories", {
        params: {
          current_user_id: store.getters["auth/getCurrentUser"].id
        }
      })
      console.log(response.data)
      return {
        watchedBooks: response.data.book_browsing_histories,
        watchedReviews: response.data.review_browsing_histories,
        watchedQuestions: response.data.question_browsing_histories,
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  }
}
</script>

<style>

</style>
