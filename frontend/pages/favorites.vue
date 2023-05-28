<template>
  <div>
    <h2>お気に入り一覧</h2>
    <!-- 後でコンポーネントで置き換える -->
    <!-- 配列の空のときのメッセージも追加する -->
    <!-- 作成したコンポーネントは閲覧履歴と共有する -->

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


    <h3>いいねした質問</h3>
    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(favoriteQuestion, index) in favoriteQuestions" :key="'question_' + index">
      <v-card :to="`/books/${favoriteQuestion.book_id}/questions/${favoriteQuestion.id}`">
        <v-card-title>{{ favoriteQuestion.title }} </v-card-title>
        <v-card-text>{{ favoriteQuestion.content }}</v-card-text>
        <template v-if="favoriteQuestion.user">
          <v-card-actions>by:{{ favoriteQuestion.user.name }}</v-card-actions>
        </template>
        <template v-if="favoriteQuestion.book">
          <v-card-actions>to:{{ favoriteQuestion.book.name }}</v-card-actions>
        </template>
      </v-card>
    </v-flex>

    <h3>いいねした返信</h3>
    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(favoriteReply, index) in favoriteReplies" :key="'reply_' + index">
      <v-card :to="`/books/${favoriteReply.question.book_id}/questions/${favoriteReply.question_id}/replies/${favoriteReply.id}`">
        <v-card-text>{{ favoriteReply.content }}</v-card-text>
        <template v-if="favoriteReply.user">
          <v-card-actions>by:{{ favoriteReply.user.name }}</v-card-actions>
        </template>
        <template v-if="favoriteReply.question">
          <v-card-actions>to:{{ favoriteReply.question.title }}</v-card-actions>
        </template>
      </v-card>
    </v-flex>

    <h3>いいねした科目別質問</h3>
    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(favoriteSubjectQuestion, index) in favoriteSubjectQuestions" :key="'subjectQuestion_' + index">
      <v-card :to="`/subjectQuestions/${favoriteSubjectQuestion.id}`">
        <v-card-title>{{ favoriteSubjectQuestion.title }} </v-card-title>
        <v-card-text>{{ favoriteSubjectQuestion.content }}</v-card-text>
        <template v-if="favoriteSubjectQuestion.user">
          <v-card-actions>科目:{{ favoriteSubjectQuestion.subject }}</v-card-actions>
          <v-card-actions>by:{{ favoriteSubjectQuestion.user.name }}</v-card-actions>
        </template>
      </v-card>
    </v-flex>

    <h3>いいねした科目別質問への返信</h3>
    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(favoriteSubjectQuestionReply, index) in favoriteSubjectQuestionReplies" :key="'subjectQuestionReply_' + index">
      <v-card :to="`/subjectQuestions/${favoriteSubjectQuestionReply.subject_question_id}/subjectQuestionReplies/${favoriteSubjectQuestionReply.id}`">
        <v-card-text>{{ favoriteSubjectQuestionReply.content }}</v-card-text>
        <template v-if="favoriteSubjectQuestionReply.user">
          <v-card-actions>by:{{ favoriteSubjectQuestionReply.user.name }}</v-card-actions>
        </template>
        <template v-if="favoriteSubjectQuestionReply.question">
          <v-card-actions>to:{{ favoriteSubjectQuestionReply.question.title }}</v-card-actions>
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
        favoriteReviews: response.data.favorite_reviews,
        favoriteQuestions: response.data.favorite_questions,
        favoriteReplies: response.data.favorite_replies,
        favoriteSubjectQuestions: response.data.favorite_subject_questions,
        favoriteSubjectQuestionReplies: response.data.favorite_subject_question_replies

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
