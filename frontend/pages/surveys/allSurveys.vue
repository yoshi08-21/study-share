<template>
  <div>
    <h2>アンケート一覧</h2>

    <br>
    <v-btn @click="openDialog">新規アンケートを作成する</v-btn>

    <br><br>
    <v-flex mb-5 v-for="(survey, index) in surveys" :key="'survey_' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/surveys/${survey.id}`">
            <v-row>
              <v-col cols="10">
                <v-card-title>
                  タイトル: {{ survey.title }}
                </v-card-title>
                <v-card-text>
                  <p>{{ survey.content }}</p>
                </v-card-text>
                <v-card-actions>
                  by: {{ survey.user.name }}
                </v-card-actions>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </v-flex>

    <!-- アンケートはダイアログで作成する -->
    <!-- 選択肢はボタンを押すと追加できるようにしたい -->

    <!-- アンケート新規登録ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          <h2>新規アンケートを作成する</h2>
        </v-card-title>
        <v-card-title>
          <v-btn @click="redirectToSearchBooks" color="primary" block>登録する参考書を検索する</v-btn>
        </v-card-title>
        <v-card-text>
          <survey-form></survey-form>
        </v-card-text>
      </v-card>
    </v-dialog>


  </div>
</template>

<script>
import SurveyForm from '../../components/surveys/SurveyForm.vue'
import axios from "@/plugins/axios"

export default {
  components: { SurveyForm },
  async asyncData() {
    const response = await axios.get("/surveys")
    console.log(response.data)
    return {
      surveys: response.data
    }
  },
  data() {
    return {
      dialog: false,

    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
  methods: {
    // async createSurvey() {
    //   try {
    //     const response = await axios.post
    //   } catch (error) {

    //   }
    // },
    openDialog() {
      if(this.currentUser) {
        this.dialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },

  }
}
</script>

<style>

</style>
