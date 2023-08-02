<template>
  <div>
    <h2>アンケート詳細</h2>

    <h3>アンケートタイトル: {{ survey.title }}</h3>
    <h4>アンケート本文: {{ survey.content }}</h4>

    <v-btn>1. {{ survey.option1 }}</v-btn>
    <v-btn>2. {{ survey.option2 }}</v-btn>
    <v-btn v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
    <v-btn v-if="survey.option4">4. {{ survey.option4 }}</v-btn>

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
        const responce = await axios.delete(`surveys/${this.survey.id}`, {
          params: {
            user_id: this.currentUser.id
          }
        })
        console.log(responce.data)
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
    }
  }

}
</script>

<style>

</style>
