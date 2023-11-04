<template>
  <div>
    <div class="d-flex justify-space-between" style="margin-top: 50px; margin-bottom: 10px;">
      <h2>アンケート詳細</h2>
      <nuxt-link :to="'/surveys/allSurveys'">アンケート一覧に戻る</nuxt-link>
    </div>
    <v-col cols="12">
      <v-card
        elevation="2"
        data-cy="survey-detail"
      >
        <v-row>
          <v-col cols="12" class="mt-n2">
            <v-card-title>
              <v-row>
                <v-col cols="12">
                  {{ survey.title }}
                </v-col>
              </v-row>
            </v-card-title>

            <v-card-subtitle style="margin-top: 10px;">
              <v-row class="d-flex justify-space-between align-center">
                <v-col cols="4">
                  <h3>ジャンル: {{ survey.genre }}</h3>
                </v-col>
                <v-col cols="4">
                  <template v-if="survey.status === false">
                    <v-alert type="success" text border="left">
                      回答受付中
                    </v-alert>
                  </template>
                  <template v-else>
                    <v-alert type="error" dense text border="left">
                      締め切り済み
                    </v-alert>
                  </template>
                </v-col>
              </v-row>
            </v-card-subtitle>

            <v-card-text>
              <v-textarea
              :value="survey.content"
              readonly
              outlined
              rounded
              dense
              auto-grow
            >
            </v-textarea>
            </v-card-text>

            <template v-if="survey.image">
            <v-row>
              <v-col class="d-flex justify-center">
                <v-img
                  @click="showFullImage = true"
                  :src="survey.image"
                  alt="画像"
                  contain
                  max-height="250"
                  max-width="250"
                  style="cursor: pointer;"
                ></v-img>
              </v-col>
            </v-row>
            <v-row>
              <v-col class="d-flex justify-center">
                *画像をクリックすると拡大できます
              </v-col>
            </v-row>
          </template>

            <v-card-actions>
              <v-row class="d-flex align-center justify-center">
                <v-col cols="3">
                  <div @click="goToUser(surveyUser)" style="padding: 10px; cursor: pointer;">
                  <v-avatar>
                    <v-img :src="surveyUser.image"></v-img>
                  </v-avatar>
                  <span style="text-decoration: underline;">{{ $truncate(surveyUser.name, 9) }}</span>
                </div>
                </v-col>
                <v-col cols="3" data-cy="survey-answer-section">
                  <v-icon>mdi-comment-text-multiple</v-icon>
                  回答数:  {{ survey.survey_answers_count }}件
                </v-col>
                <v-col cols="3">
                  <favorite-button
                    :currentUser="currentUser"
                    :user="surveyUser"
                    :isFavorite="isFavorite"
                    :favoriteCount="survey.favorite_surveys_count"
                    @addToFavorite="addToFavorite"
                    @removeFromFavorite="removeFromFavorite"
                  ></favorite-button>
                </v-col>
                <v-col cols="3">
                  <v-icon>mdi-calendar-clock</v-icon>
                  {{ survey.created_at }}
                </v-col>
              </v-row>
            </v-card-actions>
          </v-col>
        </v-row>
      </v-card>
    </v-col>

    <!-- アンケート締め切り・削除ボタン -->
    <br><br>
    <template v-if="currentUser && currentUser.id === survey.user_id">
      <v-row class="d-flex justify-center">
        <v-col cols="10">
          <v-card height="150px">
            <v-row style="height: 100%;">
              <v-col cols="6" class="d-flex justify-center align-center">
                <template v-if="survey.status === false">
                  <v-btn
                    @click="closeSurveyConfimation = true"
                    x-large
                    color="info"
                    width="300"
                  >
                    アンケートを締め切る
                  </v-btn>
                </template>
                <template v-else>
                  <v-btn
                    @click="closeSurveyConfimation = true"
                    x-large
                    color="info"
                    width="300"
                    disabled
                  >
                    アンケートを締め切る
                  </v-btn>
                </template>
              </v-col>
              <v-col cols="6" class="d-flex justify-center align-center">
                <v-btn
                  @click="showDeleteConfirmation = true"
                  x-large
                  color="blue-grey"
                  width="300"
                >
                  削除する
                </v-btn>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </template>


    <!-- アンケートの回答ボタン -->
    <br><br>
    <v-card>

      <v-card-title class="d-flex justify-center">
        <h3>回答</h3>
      </v-card-title>

        <template v-if="currentUser && survey.status === true">
          <!-- current_userがいる ＆ アンケートが締め切られている -->
          <v-alert type="error" dense text prominent border="left">
            アンケートは締め切られています
          </v-alert>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-btn-toggle style="flex-direction: column;">
                <v-btn @click="createSurveyAnswer(1)" value="1" class="large-button" disabled data-cy="option1-button">1. {{ survey.option1 }}</v-btn>
                <v-btn @click="createSurveyAnswer(2)" value="2" class="large-button" disabled data-cy="option2-button">2. {{ survey.option2 }}</v-btn>
                <v-btn @click="createSurveyAnswer(3)" value="3" class="large-button" disabled data-cy="option3-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
                <v-btn @click="createSurveyAnswer(4)" value="4" class="large-button" disabled data-cy="option4-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
              </v-btn-toggle>
            </v-col>
          </v-row>
          <br><br>
          <v-row>
            <v-col class="text-center">
              <h3>アンケート回答結果</h3>
              <survey-result-linears
                :survey="survey"
                :selectedOption1Count="selectedOption1Count"
                :selectedOption2Count="selectedOption2Count"
                :selectedOption3Count="selectedOption3Count"
                :selectedOption4Count="selectedOption4Count"
                :option1Percentage="option1Percentage"
                :option2Percentage="option2Percentage"
                :option3Percentage="option3Percentage"
                :option4Percentage="option4Percentage"
              ></survey-result-linears>
            </v-col>
          </v-row>
        </template>


        <template v-else-if="currentUser && currentUser.id !== survey.user_id">
          <!-- current_userがいる ＆ current_userがアンケートの作成者ではない -->
          <template v-if="existAnswer === false">
            <v-row>
              <v-col class="d-flex justify-center">
                <v-btn-toggle v-model="selectedAnswer" style="flex-direction: column;">
                  <v-btn @click="createSurveyAnswer(1)" value="1" class="large-button" data-cy="option1-button">1. {{ survey.option1 }}</v-btn>
                  <v-btn @click="createSurveyAnswer(2)" value="2" class="large-button" data-cy="option2-button">2. {{ survey.option2 }}</v-btn>
                  <v-btn @click="createSurveyAnswer(3)" value="3" class="large-button" data-cy="option3-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
                  <v-btn @click="createSurveyAnswer(4)" value="4" class="large-button" data-cy="option4-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
                </v-btn-toggle>
              </v-col>
            </v-row>
          </template>
          <template v-else>
            <v-row>
              <v-col class="d-flex justify-center">
                <v-btn-toggle v-model="selectedAnswer" style="flex-direction: column;">
                  <v-btn @click="changeSurveyAnswer(1)" value="1" class="large-button" data-cy="option1-button">1. {{ survey.option1 }}</v-btn>
                  <v-btn @click="changeSurveyAnswer(2)" value="2" class="large-button" data-cy="option2-button">2. {{ survey.option2 }}</v-btn>
                  <v-btn @click="changeSurveyAnswer(3)" value="3" class="large-button" data-cy="option3-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
                  <v-btn @click="changeSurveyAnswer(4)" value="4" class="large-button" data-cy="option4-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
                </v-btn-toggle>
              </v-col>
            </v-row>
            <br><br>
            <v-row>
              <v-col class="text-center">
                <h3>アンケート回答結果</h3>
                <survey-result-linears
                  :survey="survey"
                  :selectedOption1Count="selectedOption1Count"
                  :selectedOption2Count="selectedOption2Count"
                  :selectedOption3Count="selectedOption3Count"
                  :selectedOption4Count="selectedOption4Count"
                  :option1Percentage="option1Percentage"
                  :option2Percentage="option2Percentage"
                  :option3Percentage="option3Percentage"
                  :option4Percentage="option4Percentage"
                ></survey-result-linears>
              </v-col>
            </v-row>
          </template>
        </template>


        <template v-else-if="currentUser && currentUser.id === survey.user_id">
          <!-- current_userがいる ＆ current_userがアンケートの作成者である -->
          <v-alert type="info" dense text prominent border="left">
            自分のアンケートには回答ができません
          </v-alert>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-btn-toggle style="flex-direction: column;">
                <v-btn @click="createSurveyAnswer(1)" value="1" class="large-button" disabled data-cy="option1-button">1. {{ survey.option1 }}</v-btn>
                <v-btn @click="createSurveyAnswer(2)" value="2" class="large-button" disabled data-cy="option2-button">2. {{ survey.option2 }}</v-btn>
                <v-btn @click="createSurveyAnswer(3)" value="3" class="large-button" disabled data-cy="option3-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
                <v-btn @click="createSurveyAnswer(4)" value="4" class="large-button" disabled data-cy="option4-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
              </v-btn-toggle>
            </v-col>
          </v-row>
          <br><br>
          <v-row>
            <v-col class="text-center">
              <h3>アンケート回答結果</h3>
              <survey-result-linears
                :survey="survey"
                :selectedOption1Count="selectedOption1Count"
                :selectedOption2Count="selectedOption2Count"
                :selectedOption3Count="selectedOption3Count"
                :selectedOption4Count="selectedOption4Count"
                :option1Percentage="option1Percentage"
                :option2Percentage="option2Percentage"
                :option3Percentage="option3Percentage"
                :option4Percentage="option4Percentage"
              ></survey-result-linears>
            </v-col>
          </v-row>
        </template>


        <template v-else-if="!currentUser">
          <!-- current_userがいない(未ログイン状態) -->
          <v-row>
            <v-col class="d-flex justify-center">
              <v-btn-toggle style="flex-direction: column;">
                <v-btn @click="redirectToLogin" value="1" class="large-button" data-cy="option1-button">1. {{ survey.option1 }}</v-btn>
                <v-btn @click="redirectToLogin" value="2" class="large-button" data-cy="option2-button">2. {{ survey.option2 }}</v-btn>
                <v-btn @click="redirectToLogin" value="3" class="large-button" data-cy="option3-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
                <v-btn @click="redirectToLogin" value="4" class="large-button" data-cy="option4-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
              </v-btn-toggle>
            </v-col>
          </v-row>
        </template>
    </v-card>


    <br><br>
    <content-navigator
      :content="'アンケート'"
      @previousContent="previousSurvey"
      @nextContent="nextSurvey"
    >
    </content-navigator>


    <!-- アンケート締め切りの確認ダイアログ -->
    <v-dialog
    v-model="closeSurveyConfimation"
    width="800"
  >
    <v-card height="300">
      <v-row class="d-flex justify-center">
        <v-col>
          <v-card-title style="height: 120px;">
            <v-alert type="info" dense text prominent border="left" width="100%">
              アンケートを締め切ると、以降は回答ができなくなります
            </v-alert>
          </v-card-title>
          <v-card-text style="text-align: center; height: 90px;">
            <h1>
              アンケートを締め切りますか？
            </h1>
          </v-card-text>
          <v-card-actions>
            <v-row>
              <v-col cols="6" class="d-flex justify-center">
                <v-btn
                @click="closeSurvey"
                large
                width="300"
                color="error"
                dark
                data-cy="close-survey-confirmation-button"
                >
                  アンケートを締め切る
                </v-btn>
              </v-col>
              <v-col cols="6" class="d-flex justify-center">
                <v-btn
                @click="closeSurveyConfimation = false"
                large
                width="300"

                >
                  戻る
                </v-btn>
              </v-col>
            </v-row>
          </v-card-actions>
        </v-col>
      </v-row>
    </v-card>
  </v-dialog>



    <!-- アンケート削除の確認ダイアログ -->
    <delete-confirmation-dialog
      :showDeleteConfirmation="showDeleteConfirmation"
      :contentTitle="'アンケート'"
      @deleteContent="deleteSurvey"
      @closeDeleteConfirmation="showDeleteConfirmation = false"
    >
    </delete-confirmation-dialog>


    <!-- 大きいサイズの画像表示用のダイアログ -->
    <show-full-image-dialog
      :showFullImage="showFullImage"
      :image="survey.image"
      @closeShowFullImage="showFullImage = false"
    >
    </show-full-image-dialog>


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import SurveyResultLinears from '../../components/surveys/SurveyResultLinears.vue'
import FavoriteButton from '../../components/global/FavoriteButton.vue'
import ContentNavigator from '../../components/global/ContentNavigator.vue'
import DeleteConfirmationDialog from '../../components/global/DeleteConfirmationDialog.vue'
import ShowFullImageDialog from '../../components/global/ShowFullImageDialog.vue'
import userComputed from '../../mixins/userComputed'
import flashMessage from '../../mixins/flashMessage'
import navigationMethods from '../../mixins/navigationMethods'

import axios from "@/plugins/axios"

export default {
  head: {
    title: "アンケート詳細",
  },
  components: { SurveyResultLinears, FavoriteButton, ContentNavigator, DeleteConfirmationDialog, ShowFullImageDialog },
  mixins: [userComputed, flashMessage, navigationMethods],
  async asyncData({ params, store }) {
    try {

      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const [surveyResponse, surveyAnswersResponse, surveysResponse] = await Promise.all([
        axios.get(`/surveys/${params.id}`, {
          params: {
            current_user_id: currentUserId
          }
        }),
        axios.get(`/surveys/${params.id}/survey_answers/get_survey_answers`),
        axios.get("/surveys")
      ])
      const survey = surveyResponse.data
      const surveyAnswers = surveyAnswersResponse.data
      const surveys = surveysResponse.data
      return {
        survey: survey.survey,
        surveyUser: survey.survey_user,
        surveyAnswers,
        surveys
      }
    } catch(error) {
      console.error("エラーが発生しました:", error)
    }
  },
  data() {
    return {
      showDeleteConfirmation: false,
      closeSurveyConfimation: false,
      existAnswer: false,
      selectedAnswer: "",
      isFavorite: false,
      favoriteSurveyId: "",
      showFullImage: false,
    }
  },
  computed: {
    totalAnswersCount() {
      return this.surveyAnswers.length
    },
    selectedOption1Count() {
      return this.surveyAnswers.filter(surverAnswer => surverAnswer.selected_option === 1).length
    },
    selectedOption2Count() {
      return this.surveyAnswers.filter(surverAnswer => surverAnswer.selected_option === 2).length
    },
    selectedOption3Count() {
      return this.surveyAnswers.filter(surverAnswer => surverAnswer.selected_option === 3).length
    },
    selectedOption4Count() {
      return this.surveyAnswers.filter(surverAnswer => surverAnswer.selected_option === 4).length
    },
    option1Percentage() {
      if(this.totalAnswersCount === 0) {
        return 0
      } else {
        return (this.selectedOption1Count / this.totalAnswersCount) * 100
      }
    },
    option2Percentage() {
      if(this.totalAnswersCount === 0) {
        return 0
      } else {
        return (this.selectedOption2Count / this.totalAnswersCount) * 100
      }
    },
    option3Percentage() {
      if(this.totalAnswersCount === 0) {
        return 0
      } else {
        return (this.selectedOption3Count / this.totalAnswersCount) * 100
      }
    },
    option4Percentage() {

      if(this.totalAnswersCount === 0) {
        return 0
      } else {
        return (this.selectedOption4Count / this.totalAnswersCount) * 100
      }
    },

  },
  async created() {
    try {
      let currentUserId = ""
      const currentUser = this.$store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const [currentUserAnswerResponse, isFavoriteResponse] = await Promise.all([
        axios.get(`/surveys/${this.$route.params.id}/survey_answers/check_current_user_answer`, {
          params: {
            current_user_id: currentUserId,
            survey_id: this.$route.params.id
          }
        }),
        axios.get(`/surveys/${this.$route.params.id}/is_favorite`, {
          params: {
            current_user_id: currentUserId,
          }
        })
      ])
      if(currentUserAnswerResponse.status === 200) {
        this.existAnswer = true
        this.selectedAnswer = currentUserAnswerResponse.data.selected_option.toString()
      } else if(currentUserAnswerResponse.status === 204) {
        this.existAnswer = false
      }
      this.isFavorite = isFavoriteResponse.data
      this.favoriteSurveyId = isFavoriteResponse.data.favorite_survey_id
    } catch (error) {
      console.error("エラーが発生しました:", error)
    }
  },
  methods: {
    async deleteSurvey() {
      try {
        await axios.delete(`surveys/${this.survey.id}`, {
          params: {
            current_user_id: this.currentUser.id
          }
        })
        this.$router.push({ path: "/surveys/allSurveys", query: { message: "アンケートを削除しました" } })
      } catch (error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "アンケートを削除できませんでした"
        this.showDeleteConfirmation = false
      }
    },
    async closeSurvey() {
      try {
        await axios.patch(`/surveys/${this.survey.id}/close_survey`, {
          current_user_id: this.currentUser.id
        })
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "アンケートを締め切りました"
        this.closeSurveyConfimation = false
        this.survey.status = true
      } catch (error) {
        console.error("エラーが発生しました:", error)
      }
    },
    async createSurveyAnswer(selectedOption) {
      try {
        const response = await axios.post(`/surveys/${this.survey.id}/survey_answers`, {
          survey_answer: {
            selected_option: selectedOption,
            survey_id: this.survey.id
          },
          current_user_id: this.currentUser.id,
        })
        this.surveyAnswers.push(response.data)
        this.existAnswer = true
        this.snackbar = true
        this.flashMessage = "アンケートに回答しました"
      } catch (error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでに回答済みです"
      }
    },
    async changeSurveyAnswer(selectedOption) {
      try {
        const response = await axios.patch(`/surveys/${this.survey.id}/survey_answers/change_survey_answer`, {
          survey_answer: {
            selected_option: selectedOption,
            survey_id: this.survey.id,
          },
          current_user_id: this.currentUser.id,
        })
        // レスポンスで処理を切り替える
        if(response.status === 204) {
          this.existAnswer = false
          this.snackbarColor = "primary"
          this.snackbar = true
          this.flashMessage = "回答を取り消しました"
          this.removeSurveyAnswersReponse(this.currentUser.id)
        } else if(response.status === 200) {
          this.existAnswer = true
          this.snackbarColor = "primary"
          this.snackbar = true
          this.flashMessage = "回答を変更しました"
          this.changeSurveyAnswersResponse(this.currentUser.id, selectedOption)
        }
      } catch (error) {
        console.error("エラーが発生しました:", error)
      }
    },
    // 回答が取り消された場合に、surveyAnswersの配列から該当の回答を削除する
    removeSurveyAnswersReponse(userId) {
      const index = this.surveyAnswers.findIndex(surveyAnswer => surveyAnswer.user_id === userId)
      if(index !== -1) {
        this.surveyAnswers.splice(index, 1)
      }
    },
    // 回答が変更された場合に、surveyAnswersの配列該当の回答を変更する
    changeSurveyAnswersResponse(userId, newSelectedOption) {
      const index = this.surveyAnswers.findIndex(surverAnswer => surverAnswer.user_id === userId)
      if(index !== -1) {
        this.surveyAnswers[index].selected_option = newSelectedOption
      }
    },
    redirectToLogin() {
      this.$router.push({ path: "/auth/login", query: { message: "アンケート機能をご利用いただくにはログインが必要です" } })
    },
    async addToFavorite() {
      try {
        const response = await axios.post(`/surveys/${this.survey.id}/favorite_surveys`, {
          current_user_id: this.currentUser.id
        })
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね!しました"
        this.isFavorite = true
        this.favoriteSurveyId = response.data.id
        this.survey.favorite_surveys_count += 1
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね!されています"
      }
    },
    async removeFromFavorite() {
      try {
        await axios.delete(`/surveys/${this.survey.id}/favorite_surveys/${this.favoriteSurveyId}`, {
          params: {
            current_user_id: this.currentUser.id
          }
        })
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね!を削除しました"
        this.isFavorite = !this.isFavorite
        this.favoriteQuestionId = null
        this.survey.favorite_surveys_count -= 1
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね!されていません"
      }
    },
    nextSurvey() {
      const index = this.surveys.findIndex(item => item.id === this.survey.id)
      const nextIndex = index + 1
      const nextSurvey = this.surveys[nextIndex]
      const lastItem = this.surveys[this.surveys.length - 1]
      if(this.survey.id !== lastItem.id) {
        this.$router.push({ path: `/surveys/${nextSurvey.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最後のアンケートです"
      }
    },
    previousSurvey() {
      const index = this.surveys.findIndex(item => item.id === this.survey.id)
      const previousIndex = index - 1
      const previousSurvey = this.surveys[previousIndex]
      const firstItem = this.surveys[0]
      if(this.survey.id !== firstItem.id) {
        this.$router.push({ path: `/surveys/${previousSurvey.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最初のアンケートです"
      }
    },
  }

}
</script>

<style scoped>

.large-button {
  width: 900px;
}

</style>
