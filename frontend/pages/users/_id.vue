<template>
  <div>
    <br>
    <v-row class="justify-center">
      <v-col cols="8">
        <v-card
          style="border-radius: 20px;"
        >

          <div style="text-align: center;">
            プロフィール
          </div>

          <hr>
          <v-card-title>
            <v-row>
              <v-col class="d-flex justify-center">
                <div v-if="user.image">
                  <v-img
                    :src="user.image"
                    alt="画像"
                    contain
                    max-height="150"
                    max-width="150"
                  >
                  </v-img>
                </div>
              </v-col>
            </v-row>
          </v-card-title>

          <v-card-subtitle style="text-align: center; margin-top: 10px;">
            <h1>{{ user.name }}</h1>
          </v-card-subtitle>

          <br><br>
          <v-row class="justify-center">
            <v-col cols="10">
              <v-card
                style="border: solid 0.1px;"
                hover
                light
              >

                <v-card-title style="justify-content: center;">
                  {{ user.name }}さんのアクティビティ
                </v-card-title>

                <v-card-text>
                  <v-simple-table>
                    <template v-slot:default>
                      <thead>
                        <tr>
                          <th>アクティビティ</th>
                          <th>件数</th>
                          <th>獲得したいいね!</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>投稿したレビュー</td>
                          <td>{{ myReviews.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteReviewsCount }}</td>
                        </tr>
                        <tr>
                          <td>投稿した質問</td>
                          <td>{{ myQuestions.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteQuestionsCount }}</td>
                        </tr>
                        <tr>
                          <td>投稿した質問(科目別)</td>
                          <td>{{ mySubjectQuestions.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteSubjectQuestionsCount }}</td>
                        </tr>
                        <tr>
                          <td>投稿した返信</td>
                          <td>{{ myReplies.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteRepliesCount }}</td>
                        </tr>
                        <tr>
                          <td>投稿した返信(科目別)</td>
                          <td>{{ mySubjectQuestionReplies.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteSubjectQuestionRepliesCount }}</td>
                        </tr>
                        <tr>
                          <td>作成したアンケート</td>
                          <td>{{ mySurveys.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteSurveysCount }}</td>
                        </tr>
                      </tbody>
                    </template>
                  </v-simple-table>
                </v-card-text>

              </v-card>
              <br><br>

              <h4>志望校</h4>
              <hr><br>
              <h3>第一志望: {{ user.first_choice_school }}</h3>
              <br>
              <h3>第二志望: {{ user.second_choice_school }}</h3>
              <br>
              <h3>第三志望: {{ user.third_choice_school }}</h3>
              <br><br>

              <h4>自己紹介</h4>
              <hr><br>
              <v-textarea
                :value="user.introduction"
                readonly
                outlined
                rounded
                dense
                auto-grow
              >
              </v-textarea>

              <br>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>

    <br><br><br>
    <v-tabs v-model="tab" centered>
      <v-tab v-for="(tabItem, index) in tabs" :key="index" @click="page = 1">
        {{ tabItem.label }}
      </v-tab>
    </v-tabs>

    <div data-cy="tab-content">

      <template v-if="tab === 0">
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
              レビューは投稿されていません
              </v-alert>
            </v-col>
          </v-row>
        </template>
      </template>

      <template v-else-if="tab === 1">
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
              質問は投稿されていません
              </v-alert>
            </v-col>
          </v-row>
        </template>
      </template>

      <template v-else-if="tab === 2">
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
              科目別質問は投稿されていません
              </v-alert>
            </v-col>
          </v-row>
        </template>
      </template>

      <template v-else-if="tab === 3">
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
              返信は投稿されていません
              </v-alert>
            </v-col>
          </v-row>
        </template>
      </template>

      <template v-else-if="tab === 4">
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
              返信(科目別質問)は投稿されていません
              </v-alert>
            </v-col>
          </v-row>
        </template>
      </template>

      <template v-else-if="tab === 5">
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
              アンケートは作成されていません
              </v-alert>
            </v-col>
          </v-row>
        </template>
      </template>

    </div>
  </div>
</template>

<script>

import EachReviews from '../../components/reviews/EachReviews.vue'
import EachQuestions from '../../components/questions/EachQuestions.vue'
import EachReplies from '../../components/replies/EachReplies.vue'
import EachSubjectQuestions from '../../components/subjectQuestions/EachSubjectQuestions.vue'
import EachSubjectQuestionReplies from '../../components/subjectQuestionReplies/EachSubjectQuestionReplies.vue'
import EachSurveys from '../../components/surveys/EachSurveys.vue'
import axios from "@/plugins/axios"


export default {
  head() {
    return {
      title: `${this.user.name}さんのマイページ`,
    }
  },
  components: { EachReviews, EachQuestions, EachReplies, EachSubjectQuestions, EachSubjectQuestionReplies, EachSurveys, },
  async asyncData({ params }) {
    try {
      const response = await axios.get(`/users/show_other_user/${params.id}`)
      return {
        user: response.data.user,
        myQuestions: response.data.my_questions,
        myReviews: response.data.my_reviews,
        myReplies: response.data.my_replies,
        mySubjectQuestions: response.data.my_subject_questions,
        mySubjectQuestionReplies: response.data.my_subject_question_replies,
        mySurveys: response.data.my_surveys,
        myFavoriteReviewsCount: response.data.my_favorite_reviews_count,
        myFavoriteQuestionsCount: response.data.my_favorite_questions_count,
        myFavoriteRepliesCount: response.data.my_favorite_replies_count,
        myFavoriteSubjectQuestionsCount: response.data.my_favorite_subject_questions_count,
        myFavoriteSubjectQuestionRepliesCount: response.data.my_favorite_subject_question_replies_count,
        myFavoriteSurveysCount: response.data.my_favorite_surveys_count,
      }
    } catch(error) {
      console.error("エラーが発生しました:", error)
    }
  },
  data() {
    return {
      tab: 0,
      tabs: [
        { label: "投稿したレビュー" },
        { label: "投稿した質問" },
        { label: "投稿した科目別質問" },
        { label: "投稿した返信" },
        { label: "投稿した返信(科目別質問)" },
        { label: "作成したアンケート" },
      ],
      perPage: 10,
      page: 1,
    }
  },
  computed: {
    reviewsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.myReviews.slice(start, end)
    },
    questionsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.myQuestions.slice(start, end)
    },
    repliesChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.myReplies.slice(start, end)
    },
    subjectQuestionsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.mySubjectQuestions.slice(start, end)
    },
    subjectQuestionRepliesChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.mySubjectQuestionReplies.slice(start, end)
    },
    surveysChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.mySurveys.slice(start, end)
    },
    reviewsTotalPages() {
      return Math.ceil(this.myReviews.length / this.perPage);
    },
    questionsTotalPages() {
      return Math.ceil(this.myQuestions.length / this.perPage);
    },
    repliesTotalPages() {
      return Math.ceil(this.myReplies.length / this.perPage);
    },
    subjectQuestionsTotalPages() {
      return Math.ceil(this.mySubjectQuestions.length / this.perPage);
    },
    subjectQuestionRepliesTotalPages() {
      return Math.ceil(this.mySubjectQuestionReplies.length / this.perPage);
    },
    surveysTotalPages() {
      return Math.ceil(this.mySurveys.length / this.perPage);
    },
  },
}
</script>

<style>

</style>
