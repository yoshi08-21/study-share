<template>
  <div>
    <h2 style="text-align: center;">お気に入り一覧</h2>

    <br>
    <v-tabs v-model="tab">
      <v-tab v-for="(tabItem, index) in tabs" :key="index" @click="page = 1">
        {{ tabItem.label }}
      </v-tab>
    </v-tabs>

    <template v-if="tab === 0">
      <br><br><br>
      <template v-if="booksChunk.length > 0">
        <v-pagination v-model="page" :length="booksTotalPages"></v-pagination>
        <br>
        <each-books :books="booksChunk"></each-books>
        <br>
        <v-pagination v-model="page" :length="booksTotalPages"></v-pagination>
      </template>
      <template v-else>
        <br>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-alert
                type="info"
                >
                お気に入りの参考書はありません
              </v-alert>
            </v-col>
          </v-row>
      </template>
    </template>

    <template v-else-if="tab === 1">
      <br><br><br>
      <template v-if="reviewsChunk.length > 0">
        <v-pagination v-model="page" :length="reviewsTotalPages"></v-pagination>
        <br>
        <each-reviews :reviews="reviewsChunk"></each-reviews>
        <br>
        <v-pagination v-model="page" :length="reviewsTotalPages"></v-pagination>
      </template>
      <template v-else>
        <br>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-alert
                type="info"
              >
              いいねしたレビューはありません
              </v-alert>
            </v-col>
          </v-row>
      </template>
    </template>

    <template v-else-if="tab === 2">
      <br><br><br>
      <template v-if="questionsChunk.length > 0">
        <v-pagination v-model="page" :length="questionsTotalPages"></v-pagination>
        <br>
        <each-questions :questions="questionsChunk"></each-questions>
        <br>
        <v-pagination v-model="page" :length="questionsTotalPages"></v-pagination>
      </template>
      <template v-else>
        <br>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-alert
                type="info"
              >
              いいねした質問はありません
              </v-alert>
            </v-col>
          </v-row>
      </template>
    </template>

    <template v-else-if="tab === 3">
      <br><br><br>
      <template v-if="subjectQuestionsChunk.length > 0">
        <v-pagination v-model="page" :length="subjectQuestionsTotalPages"></v-pagination>
        <br>
        <each-subject-questions :subjectQuestions="subjectQuestionsChunk"></each-subject-questions>
        <br>
        <v-pagination v-model="page" :length="subjectQuestionsTotalPages"></v-pagination>
      </template>
      <template v-else>
        <br>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-alert
                type="info"
              >
              いいねした科目別質問はありません
              </v-alert>
            </v-col>
          </v-row>
      </template>
    </template>

    <template v-else-if="tab === 4">
      <br><br><br>
      <template v-if="repliesChunk.length > 0">
        <v-pagination v-model="page" :length="repliesTotalPages"></v-pagination>
        <br>
        <each-replies :replies="repliesChunk"></each-replies>
        <br>
        <v-pagination v-model="page" :length="repliesTotalPages"></v-pagination>
      </template>
      <template v-else>
        <br>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-alert
                type="info"
              >
              いいねした返信はありません
              </v-alert>
            </v-col>
          </v-row>
      </template>
    </template>

    <template v-else-if="tab === 5">
      <br><br><br>
      <template v-if="subjectQuestionRepliesChunk.length > 0">
        <v-pagination v-model="page" :length="subjectQuestionRepliesTotalPages"></v-pagination>
        <br>
        <each-subject-question-replies :subjectQuestionReplies="subjectQuestionRepliesChunk"></each-subject-question-replies>
        <br>
        <v-pagination v-model="page" :length="subjectQuestionRepliesTotalPages"></v-pagination>
      </template>
      <template v-else>
        <br>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-alert
                type="info"
              >
              いいねした返信(科目別質問)はありません
              </v-alert>
            </v-col>
          </v-row>
      </template>
    </template>

    <template v-else-if="tab === 6">
      <br><br><br>
      <template v-if="surveysChunk.length > 0">
        <v-pagination v-model="page" :length="surveysTotalPages"></v-pagination>
        <br>
        <each-surveys :surveys="surveysChunk"></each-surveys>
        <br>
        <v-pagination v-model="page" :length="surveysTotalPages"></v-pagination>
      </template>
      <template v-else>
        <br>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-alert
                type="info"
              >
              いいねしたアンケートはありません
              </v-alert>
            </v-col>
          </v-row>
      </template>
    </template>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import EachBooks from '../components/books/EachBooks.vue'
import EachReviews from '../components/reviews/EachReviews.vue'
import EachQuestions from '../components/questions/EachQuestions.vue'
import EachReplies from '../components/replies/EachReplies.vue'
import EachSubjectQuestions from '../components/subjectQuestions/EachSubjectQuestions.vue'
import EachSubjectQuestionReplies from '../components/subjectQuestionReplies/EachSubjectQuestionReplies.vue'
import EachSurveys from '../components/surveys/EachSurveys.vue'
import authCheck from '../middleware/authCheck'
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
        { label: "いいね!した返信(科目別質問)" },
        { label: "いいね!したアンケート" },
      ],
      perPage: 10,
      page: 1,
    }
  },
  computed: {
    booksChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.favoriteBooks.slice(start, end)
    },
    reviewsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.favoriteReviews.slice(start, end)
    },
    questionsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.favoriteQuestions.slice(start, end)
    },
    repliesChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.favoriteReplies.slice(start, end)
    },
    subjectQuestionsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.favoriteSubjectQuestions.slice(start, end)
    },
    subjectQuestionRepliesChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.favoriteSubjectQuestionReplies.slice(start, end)
    },
    surveysChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.favoriteSurveys.slice(start, end)
    },
    booksTotalPages() {
      return Math.ceil(this.favoriteBooks.length / this.perPage);
    },
    reviewsTotalPages() {
      return Math.ceil(this.favoriteReviews.length / this.perPage);
    },
    questionsTotalPages() {
      return Math.ceil(this.favoriteQuestions.length / this.perPage);
    },
    repliesTotalPages() {
      return Math.ceil(this.favoriteReplies.length / this.perPage);
    },
    subjectQuestionsTotalPages() {
      return Math.ceil(this.favoriteSubjectQuestions.length / this.perPage);
    },
    subjectQuestionRepliesTotalPages() {
      return Math.ceil(this.favoriteSubjectQuestionReplies.length / this.perPage);
    },
    surveysTotalPages() {
      return Math.ceil(this.favoriteSurveys.length / this.perPage);
    },

  },
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
