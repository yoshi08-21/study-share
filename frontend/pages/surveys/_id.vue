<template>
  <div>
    <div class="d-flex justify-space-between" style="margin-top: 50px; margin-bottom: 10px;">
      <h2>アンケート詳細</h2>
      <nuxt-link :to="'/surveys/allSurveys'">アンケート一覧に戻る</nuxt-link>
    </div>
    <v-col cols="12">
      <v-card
        elevation="2"
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
                <v-col cols="3">
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
                <v-btn
                @click="closeSurveyConfimation = true"
                  x-large
                  color="info"
                  width="300"
                >
                  アンケートを締め切る
                </v-btn>
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
            アンケートは締め切られています。
          </v-alert>
          <v-row>
            <v-col class="d-flex justify-center">
              <v-btn-toggle style="flex-direction: column;">
                <v-btn @click="createSurveyAnswer(1)" value="1" class="large-button" disabled>1. {{ survey.option1 }}</v-btn>
                <v-btn @click="createSurveyAnswer(2)" value="2" class="large-button" disabled>2. {{ survey.option2 }}</v-btn>
                <v-btn @click="createSurveyAnswer(3)" value="3" class="large-button" disabled v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
                <v-btn @click="createSurveyAnswer(4)" value="4" class="large-button" disabled v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
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
                  <v-btn @click="createSurveyAnswer(1)" value="1" class="large-button">1. {{ survey.option1 }}</v-btn>
                  <v-btn @click="createSurveyAnswer(2)" value="2" class="large-button">2. {{ survey.option2 }}</v-btn>
                  <v-btn @click="createSurveyAnswer(3)" value="3" class="large-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
                  <v-btn @click="createSurveyAnswer(4)" value="4" class="large-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
                </v-btn-toggle>
              </v-col>
            </v-row>
          </template>
          <template v-else>
            <v-row>
              <v-col class="d-flex justify-center">
                <v-btn-toggle v-model="selectedAnswer" style="flex-direction: column;">
                  <v-btn @click="changeSurveyAnswer(1)" value="1" class="large-button">1. {{ survey.option1 }}</v-btn>
                  <v-btn @click="changeSurveyAnswer(2)" value="2" class="large-button">2. {{ survey.option2 }}</v-btn>
                  <v-btn @click="changeSurveyAnswer(3)" value="3" class="large-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
                  <v-btn @click="changeSurveyAnswer(4)" value="4" class="large-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
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
                <v-btn @click="createSurveyAnswer(1)" value="1" class="large-button" disabled>1. {{ survey.option1 }}</v-btn>
                <v-btn @click="createSurveyAnswer(2)" value="2" class="large-button" disabled>2. {{ survey.option2 }}</v-btn>
                <v-btn @click="createSurveyAnswer(3)" value="3" class="large-button" disabled v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
                <v-btn @click="createSurveyAnswer(4)" value="4" class="large-button" disabled v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
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
          <v-btn-toggle style="flex-direction: column;">
            <v-btn @click="redirectToLogin" value="1" class="large-button">1. {{ survey.option1 }}</v-btn>
            <v-btn @click="redirectToLogin" value="2" class="large-button">2. {{ survey.option2 }}</v-btn>
            <v-btn @click="redirectToLogin" value="3" class="large-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
            <v-btn @click="redirectToLogin" value="4" class="large-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
          </v-btn-toggle>
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
    <v-dialog v-model="closeSurveyConfimation">
      <v-card>
        <v-card-title>
          アンケートを締め切ると、以降は回答ができなくなります。
        </v-card-title>
        <v-card-text>
          <strong>
            アンケートを締め切りますか？
          </strong>
        </v-card-text>
        <v-card-actions class="justify-content-center">
          <v-btn @click="closeSurvey">アンケートを締め切る</v-btn>
          <v-btn @click="closeSurveyConfimation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- アンケート削除の確認ダイアログ -->
    <v-dialog v-model="showDeleteConfirmation">
      <v-card>
        <v-card-title>
          削除したアンケートは復元できません！
        </v-card-title>
        <v-card-text>
          <strong>
            アンケートを削除しますか？
          </strong>
        </v-card-text>
        <v-card-actions class="justify-content-center">
          <v-btn @click="deleteSurvey">削除する</v-btn>
          <v-btn @click="showDeleteConfirmation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- 大きいサイズの画像表示用のダイアログ -->
    <v-dialog v-model="showFullImage">
      <v-card
        max-height="800px"
        style="padding: 10px;"
      >
        <v-row>
          <v-col cols="6" class="d-flex justify-start">
            <v-card-title>拡大画像</v-card-title>
          </v-col>
          <v-col cols="6" class="d-flex justify-end align-center">
            <v-btn @click="showFullImage = false">閉じる</v-btn>
          </v-col>
        </v-row>
        <hr>
        <v-row style="margin-top: 10px; margin-bottom: 5px;">
          <v-col class="d-flex justify-center">
            <v-img
              :src="survey.image"
              max-height="500"
              max-width="500"
              contain
            ></v-img>
          </v-col>
        </v-row>
        <v-row>
          <v-col class="d-flex justify-center">
            <v-btn @click="showFullImage = false">閉じる</v-btn>
          </v-col>
        </v-row>
      </v-card>
    </v-dialog>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import SurveyResultLinears from '../../components/surveys/SurveyResultLinears.vue'
import FavoriteButton from '../../components/global/FavoriteButton.vue'
import ContentNavigator from '../../components/global/ContentNavigator.vue'
import axios from "@/plugins/axios"

export default {
  components: { SurveyResultLinears, FavoriteButton, ContentNavigator },
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
            user_id: currentUserId
          }
        }),
        axios.get(`/surveys/${params.id}/survey_answers/get_survey_answers`),
        axios.get("/surveys")
      ])
      const survey = surveyResponse.data
      const surveyAnswers = surveyAnswersResponse.data
      const surveys = surveysResponse.data
      console.log(survey)
      console.log(surveyAnswers)
      console.log(surveys)
      return {
        survey: survey.survey,
        surveyUser: survey.survey_user,
        surveyAnswers,
        surveys
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
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
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
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
            user_id: currentUserId,
            survey_id: this.$route.params.id
          }
        }),
        axios.get(`/surveys/${this.$route.params.id}/is_favorite`, {
          params: {
            user_id: currentUserId,
          }
        })
      ])

      console.log(currentUserAnswerResponse.status)
      console.log(currentUserAnswerResponse.data)
      console.log(isFavoriteResponse.data)
      if(currentUserAnswerResponse.status === 200) {
        this.existAnswer = true
        this.selectedAnswer = currentUserAnswerResponse.data.selected_option.toString()
      } else if(currentUserAnswerResponse.status === 204) {
        this.existAnswer = false
      }
      this.isFavorite = isFavoriteResponse.data
      this.favoriteSurveyId = isFavoriteResponse.data.favorite_survey_id
    } catch (error) {
      console.log(error)
    }
  },
  mounted() {
    if (this.$route.query.message) {
      this.snackbarColor = "primary"
      this.snackbar = true
      this.flashMessage = this.$route.query.message
      // this.$snackbar.show(this.$route.query.message)
    }
  },
  methods: {
    async deleteSurvey() {
      try {
        const response = await axios.delete(`surveys/${this.survey.id}`, {
          params: {
            user_id: this.currentUser.id
          }
        })
        console.log(response.data)
        this.$router.push({ path: "/surveys/allSurveys", query: { message: "アンケートを削除しました" } })
      } catch (error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "アンケートを削除できませんでした"
        this.showDeleteConfirmation = false
      }
    },
    async closeSurvey() {
      try {
        const response = await axios.patch(`/surveys/${this.survey.id}/close_survey`, {
          user_id: this.currentUser.id
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "アンケートを締め切りました"
        this.closeSurveyConfimation = false
        this.survey.status = 1
      } catch (error) {
        console.log(error)
      }
    },
    async createSurveyAnswer(selectedOption) {
      try {
        const response = await axios.post(`/surveys/${this.survey.id}/survey_answers`, {
          survey_answer: {
            selected_option: selectedOption,
            user_id: this.currentUser.id,
            survey_id: this.survey.id
          }
        })
        console.log(response.data)
        this.surveyAnswers.push(response.data)
        console.log(this.surveyAnswers)
        this.existAnswer = true
        this.snackbar = true
        this.flashMessage = "アンケートに回答しました"
      } catch (error) {
        console.log(error)
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
            user_id: this.currentUser.id,
            survey_id: this.survey.id
          }
        })
        console.log(response.data)
        // レスポンスで処理を切り替える
        if(response.status === 204) {
          this.existAnswer = false
          this.snackbarColor = "primary"
          this.snackbar = true
          this.flashMessage = "回答を取り消しました"
          this.removeSurveyAnswersReponse(this.currentUser.id)
          console.log(this.surveyAnswers)
        } else if(response.status === 200) {
          this.existAnswer = true
          this.snackbarColor = "primary"
          this.snackbar = true
          this.flashMessage = "回答を変更しました"
          this.changeSurveyAnswersResponse(this.currentUser.id, selectedOption)
          console.log(this.surveyAnswers)
        }
        // 該当の部分
      } catch (error) {
        console.log(error)
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
          user_id: this.currentUser.id
        })
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！しました"
        this.isFavorite = true
        this.favoriteSurveyId = response.data.id
        this.survey.favorite_surveys_count += 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね！されています"
      }
    },
    async removeFromFavorite() {
      try {
        const response = await axios.delete(`/surveys/${this.survey.id}/favorite_surveys/${this.favoriteSurveyId}`, {
          params: {
            user_id: this.currentUser.id
          }
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！を削除しました"
        this.isFavorite = !this.isFavorite
        this.favoriteQuestionId = null
        this.survey.favorite_surveys_count -= 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね！されていません"
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
    goToUser(user) {
      if( !this.currentUser || this.currentUser.id !== user.id ) {
        this.$router.push({ path: `/users/${user.id}` })
      } else {
        this.$router.push({ path: "/mypage" })
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
