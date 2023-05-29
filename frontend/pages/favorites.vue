<template>
  <div>
    <h2>お気に入り一覧</h2>
    <!-- 後でコンポーネントで置き換える -->
    <!-- 配列の空のときのメッセージも追加する -->
    <!-- 作成したコンポーネントは閲覧履歴と共有する -->

    <h3>お気に入りの参考書</h3>
    <br>
    <each-books :books="favoriteBooks"></each-books>
    <each-books></each-books>


    <h3>いいねしたレビュー</h3>
    <br>
    <each-reviews :reviews="favoriteReviews"></each-reviews>


    <h3>いいねした質問</h3>
    <br>
    <each-questions :questions="favoriteQuestions"></each-questions>

    <h3>いいねした科目別質問</h3>
    <br>
    <each-subject-questions :subjectQuestions="favoriteSubjectQuestions"></each-subject-questions>

    <h3>いいねした返信</h3>
    <br>
    <each-replies :replies="favoriteReplies"></each-replies>

    <h3>いいねした科目別質問への返信</h3>
    <br>
    <each-subject-question-replies :subjectQuestionReplies="favoriteSubjectQuestionReplies"></each-subject-question-replies>


  </div>
</template>

<script>

import EachBooks from '../components/books/EachBooks.vue'
import EachReviews from '../components/reviews/EachReviews.vue'
import EachQuestions from '../components/questions/EachQuestions.vue'
import EachReplies from '../components/replies/EachReplies.vue'
import EachSubjectQuestions from '../components/subjectQuestions/EachSubjectQuestions.vue'
import EachSubjectQuestionReplies from '../components/subjectQuestionReplies/EachSubjectQuestionReplies.vue'
import axios from "@/plugins/axios"

export default {
  components: { EachBooks, EachReviews, EachQuestions, EachReplies, EachSubjectQuestions, EachSubjectQuestionReplies, },
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
