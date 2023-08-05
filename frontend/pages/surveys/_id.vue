<template>
  <div>
    <h2>アンケート詳細</h2>

    <h3>アンケートタイトル: {{ survey.title }}</h3>
    <h4>アンケート本文: {{ survey.content }}</h4>

    <br><br>
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
    </template>

    <v-btn @click="existAnswer = !existAnswer">アンケート回答状態切替</v-btn>
    <v-btn @click="selectedAnswer = '2'">２を回答済みにする</v-btn>
    <v-btn @click="selectedAnswer = '3'">3を回答済みにする</v-btn>


    <!-- <v-radio-group
      v-model="row"
      column
    >
      <v-radio
        label="Option 1"
        value="radio-1"
      ></v-radio>
      <v-radio
        label="Option 2"
        value="radio-2"
      ></v-radio>
    </v-radio-group>

    <v-row>
    <v-col
      cols="12"
      sm="6"
      class="py-2"
    >
      <p>Exclusive</p>

      <v-btn-toggle v-model="toggle_exclusive" style="flex-direction: column;">
        <v-btn block>
          選択肢１
        </v-btn>

        <v-btn>
          <v-icon>mdi-format-align-center</v-icon>
        </v-btn>

        <v-btn>
          <v-icon>mdi-format-align-right</v-icon>
        </v-btn>

        <v-btn>
          <v-icon>mdi-format-align-justify</v-icon>
        </v-btn>
      </v-btn-toggle>
    </v-col>
    </v-row> -->

    <!-- アンケート作者にはreadonlyのボタンを表示する -->

    <!-- アンケートの回答後は回答数と割合が書いてあるボタンに切り替えて、メソッドも切り替える -->
    <br><br>
    <template v-if="currentUser && survey.user_id === currentUser.id && survey.status == 0">
      <v-btn @click="closeSurveyConfimation = true">アンケートを締め切る</v-btn>
    </template>

    <template v-if="currentUser && survey.user_id === currentUser.id">
      <v-btn @click="showDeleteConfirmation = true">削除する</v-btn>
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


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  async asyncData({ params }) {
    try {
      const response = await axios.get(`/surveys/${params.id}`)
      console.log(response.data)
      return {
        survey: response.data
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
        this.existAnswer = true
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
        } else if(response.status === 200) {
          this.existAnswer = true
          this.snackbarColor = "primary"
          this.snackbar = true
          this.flashMessage = "回答を変更しました"
        }
        // レスポンスで回答が返ってきたらそのまま、返ってこなければ回答後の表示を戻す
      } catch (error) {
        console.log(error)
      }
    }
  }

}
</script>

<style scoped>

.large-button {
  width: 500px;
}

</style>
