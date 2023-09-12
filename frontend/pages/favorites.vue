<template>
  <div>
    <h2 style="text-align: center;">お気に入り一覧</h2>

    <br>
    <v-tabs v-model="tab">
      <v-tab v-for="(tabItem, index) in tabs" :key="index">
        {{ tabItem.label }}
      </v-tab>
    </v-tabs>

    <template v-if="tab === 0">
      <br><br><br>
      <each-books :books="favoriteBooks"></each-books>
    </template>

    <template v-else-if="tab === 1">
      <br><br><br>
      <each-reviews :reviews="favoriteReviews"></each-reviews>
    </template>

    <template v-else-if="tab === 2">
      <br><br><br>
      <each-questions :questions="favoriteQuestions"></each-questions>
    </template>

    <template v-else-if="tab === 3">
      <br><br><br>
      <each-subject-questions :subjectQuestions="favoriteSubjectQuestions"></each-subject-questions>
    </template>

    <template v-else-if="tab === 4">
      <br><br><br>
      <each-replies :replies="favoriteReplies"></each-replies>
    </template>

    <template v-else-if="tab === 5">
      <br><br><br>
      <each-subject-question-replies :subjectQuestionReplies="favoriteSubjectQuestionReplies"></each-subject-question-replies>
    </template>

    <template v-else-if="tab === 6">
      <br><br><br>
      <each-surveys :surveys="favoriteSurveys"></each-surveys>

    </template>


  </div>
</template>

<script>

import EachBooks from '../components/books/EachBooks.vue'
import EachReviews from '../components/reviews/EachReviews.vue'
import EachQuestions from '../components/questions/EachQuestions.vue'
import EachReplies from '../components/replies/EachReplies.vue'
import EachSubjectQuestions from '../components/subjectQuestions/EachSubjectQuestions.vue'
import EachSubjectQuestionReplies from '../components/subjectQuestionReplies/EachSubjectQuestionReplies.vue'
import authCheck from '../middleware/authCheck'
import EachSurveys from '../components/surveys/EachSurveys.vue'
import axios from "@/plugins/axios"

export default {
  middleware: authCheck,
  components: { EachBooks, EachReviews, EachQuestions, EachReplies, EachSubjectQuestions, EachSubjectQuestionReplies, EachSurveys, },
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
        favoriteSubjectQuestionReplies: response.data.favorite_subject_question_replies,
        favoriteSurveys: response.data.favorite_surveys

      }
    } catch(error) {
      console.log(error)
    }
  },
  data() {
    return {
      tab: 0,
      tabs: [
        { label: "お気に入りの参考書" },
        { label: "いいね!したレビュー" },
        { label: "いいね!した質問" },
        { label: "いいね!した科目別質問" },
        { label: "いいね!した返信" },
        { label: "いいね!した返信（科目別質問）" },
        { label: "いいね!したアンケート" },

      ]

    }
  }
}
</script>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>
