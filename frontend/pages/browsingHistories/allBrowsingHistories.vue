<template>
  <div>
    <h2 style="text-align: center;">閲覧履歴一覧</h2>

    <br>
    <v-tabs v-model="tab">
      <v-tab v-for="(tabItem, index) in tabs" :key="index">
        {{ tabItem.label }}
      </v-tab>
    </v-tabs>
    <p style="margin-top: 10px;">*閲覧履歴は各10件まで保存されます</p>

    <template v-if="tab === 0">
      <br>
      <each-books :books="watchedBooks"></each-books>
    </template>

    <template v-else-if="tab === 1">
      <br>
      <each-reviews :reviews="watchedReviews"></each-reviews>
    </template>

    <template v-else-if="tab === 2">
      <br>
      <each-questions :questions="watchedQuestions"></each-questions>
    </template>

    <template v-else-if="tab === 3">
      <br>
      <each-subject-questions :subjectQuestions="watchedSubjectQuestions"></each-subject-questions>
    </template>

    <template v-else-if="tab === 4">
      <br>
      <each-replies :replies="watchedReplies"></each-replies>
    </template>

    <template v-else-if="tab === 5">
      <br>
      <each-subject-question-replies :subjectQuestionReplies="watchedSubjectQuestionReplies"></each-subject-question-replies>
    </template>

    <template v-else-if="tab === 6">
      <br>
      <each-surveys :surveys="watchedSurveys"></each-surveys>
    </template>

  </div>
</template>

<script>

import EachBooks from '../../components/books/EachBooks.vue'
import EachReviews from '../../components/reviews/EachReviews.vue'
import EachQuestions from '../../components/questions/EachQuestions.vue'
import EachReplies from '../../components/replies/EachReplies.vue'
import EachSubjectQuestions from '../../components/subjectQuestions/EachSubjectQuestions.vue'
import EachSubjectQuestionReplies from '../../components/subjectQuestionReplies/EachSubjectQuestionReplies.vue'
import authCheck from '../../middleware/authCheck'
import EachSurveys from '../../components/surveys/EachSurveys.vue'
import axios from "@/plugins/axios"


export default {
  head: {
    title: "閲覧履歴",
  },
  middleware: authCheck,
  components: { EachBooks, EachReviews, EachQuestions, EachReplies, EachSubjectQuestions, EachSubjectQuestionReplies, EachSurveys },
  async asyncData({ store }) {
    try {
      const response = await axios.get("/browsing_histories", {
        params: {
          current_user_id: store.getters["auth/getCurrentUser"].id
        }
      })
      return {
        watchedBooks: response.data.book_browsing_histories,
        watchedReviews: response.data.review_browsing_histories,
        watchedQuestions: response.data.question_browsing_histories,
        watchedSubjectQuestions: response.data.subject_question_browsing_histories,
        watchedReplies: response.data.reply_browsing_histories,
        watchedSubjectQuestionReplies: response.data.subject_question_reply_browsing_histories,
        watchedSurveys: response.data.survey_browsing_histories,
      }
    } catch(error) {
      console.error("エラーが発生しました:", error)
    }
  },
  data() {
    return {
      tab: 0,
      tabs: [
        { label: "閲覧した参考書" },
        { label: "閲覧したレビュー" },
        { label: "閲覧した質問" },
        { label: "閲覧した科目別質問" },
        { label: "閲覧した返信" },
        { label: "閲覧した返信(科目別質問)" },
        { label: "閲覧したアンケート" },
      ]
    }
  }
}
</script>

<style>

</style>
