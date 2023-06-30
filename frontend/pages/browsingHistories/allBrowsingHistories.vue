<template>
  <div>
    <h2>閲覧履歴</h2>
    <!-- 作成したコンポーネントはお気に入りと共有する -->

    <v-tabs v-model="tab">
      <v-tab v-for="(tabItem, index) in tabs" :key="index">
        {{ tabItem.label }}
      </v-tab>
    </v-tabs>

    <template v-if="tab === 0">
      <h3>閲覧した参考書（最大10件）</h3>
      <br>
      <each-books :books="watchedBooks"></each-books>
    </template>

    <template v-else-if="tab === 1">
      <h3>閲覧したレビュー（最大10件）</h3>
      <br>
      <each-reviews :reviews="watchedReviews"></each-reviews>
    </template>

    <template v-else-if="tab === 2">
      <h3>閲覧した質問（最大10件）</h3>
      <br>
      <each-questions :questions="watchedQuestions"></each-questions>
    </template>

    <template v-else-if="tab === 3">
      <h3>閲覧した科目別質問（最大10件）</h3>
      <br>
      <each-subject-questions :subjectQuestions="watchedSubjectQuestions"></each-subject-questions>
    </template>

    <template v-else-if="tab === 4">
      <h3>閲覧した返信（最大10件）</h3>
      <br>
      <each-replies :replies="watchedReplies"></each-replies>
    </template>

    <template v-else-if="tab === 5">
      <h3>閲覧した科目別質問への返信（最大10件）</h3>
      <br>
      <each-subject-question-replies :subjectQuestionReplies="watchedSubjectQuestionReplies"></each-subject-question-replies>
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
import axios from "@/plugins/axios"


export default {
  middleware: authCheck,
  components: { EachBooks, EachReviews, EachQuestions, EachReplies, EachSubjectQuestions, EachSubjectQuestionReplies },
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
        watchedSubjectQuestions: response.data.subject_question_browsing_histories,
        watchedReplies: response.data.reply_browsing_histories,
        watchedSubjectQuestionReplies: response.data.subject_question_reply_browsing_histories,
      }
    } catch(error) {
      console.log(error)
      throw error
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
        { label: "閲覧した返信（科目別質問）" },
      ]
    }
  }
}
</script>

<style>

</style>
