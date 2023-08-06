<template>
  <div>
    <h2>アンケート詳細</h2>

    <h3>アンケートタイトル: {{ survey.title }}</h3>
    <h4>アンケート本文: {{ survey.content }}</h4>

    <br><br>
    <template v-if="currentUser && currentUser.id !== survey.user_id">
      <!-- current_userがいる ＆ current_userがアンケートの作成者ではない -->
      <template v-if="existAnswer === false">
        <p>アンケート回答前ボタン</p>
        <v-btn-toggle v-model="selectedAnswer" style="flex-direction: column;">
          <v-btn @click="createSurveyAnswer(1)" value="1" class="large-button">1. {{ survey.option1 }}</v-btn>
          <v-btn @click="createSurveyAnswer(2)" value="2" class="large-button">2. {{ survey.option2 }}</v-btn>
          <v-btn @click="createSurveyAnswer(3)" value="3" class="large-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
          <v-btn @click="createSurveyAnswer(4)" value="4" class="large-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
        </v-btn-toggle>
      </template>

      <template v-else>
        <p>アンケート回答後ボタン</p>
        <v-btn-toggle v-model="selectedAnswer" style="flex-direction: column;">
          <v-btn @click="changeSurveyAnswer(1)" value="1" class="large-button">1. {{ survey.option1 }}</v-btn>
          <v-btn @click="changeSurveyAnswer(2)" value="2" class="large-button">2. {{ survey.option2 }}</v-btn>
          <v-btn @click="changeSurveyAnswer(3)" value="3" class="large-button" v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
          <v-btn @click="changeSurveyAnswer(4)" value="4" class="large-button" v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
        </v-btn-toggle>
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
      </template>
    </template>

    <template v-else-if="currentUser && survey.status === true">
      <!-- current_userがいる ＆ アンケートが締め切られている -->
      <v-alert type="error" dense text prominent border="left">
        アンケートは締め切られています。
      </v-alert>
      <v-btn-toggle style="flex-direction: column;">
        <v-btn @click="createSurveyAnswer(1)" value="1" class="large-button" disabled>1. {{ survey.option1 }}</v-btn>
        <v-btn @click="createSurveyAnswer(2)" value="2" class="large-button" disabled>2. {{ survey.option2 }}</v-btn>
        <v-btn @click="createSurveyAnswer(3)" value="3" class="large-button" disabled v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
        <v-btn @click="createSurveyAnswer(4)" value="4" class="large-button" disabled v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
      </v-btn-toggle>
      <br>
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
    </template>

    <template v-else-if="currentUser && currentUser.id === survey.user_id">
      <!-- current_userがいる ＆ current_userがアンケートの作成者である -->
      <p>*自分のアンケートには回答ができません</p>
      <v-btn-toggle style="flex-direction: column;">
        <v-btn @click="createSurveyAnswer(1)" value="1" class="large-button" disabled>1. {{ survey.option1 }}</v-btn>
        <v-btn @click="createSurveyAnswer(2)" value="2" class="large-button" disabled>2. {{ survey.option2 }}</v-btn>
        <v-btn @click="createSurveyAnswer(3)" value="3" class="large-button" disabled v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
        <v-btn @click="createSurveyAnswer(4)" value="4" class="large-button" disabled v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
      </v-btn-toggle>
      <br>
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

      <v-btn @click="showDeleteConfirmation = true">削除する</v-btn>
      <template v-if="survey.status == 0">
      <v-btn @click="closeSurveyConfimation = true">アンケートを締め切る</v-btn>
    </template>


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

    <!-- アンケートの回答結果を表示する -->
    <!-- 回答を切り替えた際に、回答数と割合がリアルタイムで変更されるようにする -->

    <!-- responseからフィルタリングを行ってcomputedに格納する。 -->


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import SurveyResultLinears from '../../components/surveys/SurveyResultLinears.vue'
import axios from "@/plugins/axios"

export default {
  components: { SurveyResultLinears },
  async asyncData({ params }) {
    try {
      const [surveyResponse, surveyAnswersResponse] = await Promise.all([
        axios.get(`/surveys/${params.id}`),
        axios.get(`/surveys/${params.id}/survey_answers/get_survey_answers`)
      ])
      const survey = surveyResponse.data
      const surveyAnswers = surveyAnswersResponse.data
      console.log(survey)
      console.log(surveyAnswers)
      return {
        survey,
        surveyAnswers
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

      const response = await axios.get(`/surveys/${this.$route.params.id}/survey_answers/check_current_user_answer`, {
        params: {
          user_id: currentUserId,
          survey_id: this.$route.params.id
        }
      })
      console.log(response.status)
      console.log(response.data)
      if(response.status === 200) {
        this.existAnswer = true
        this.selectedAnswer = response.data.selected_option.toString()
      } else if(response.status === 204) {
        this.existAnswer = false
      }
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
    }
  }

}
</script>

<style scoped>

.large-button {
  width: 500px;
}

</style>
