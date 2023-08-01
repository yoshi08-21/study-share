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
        <v-card-text>
          <survey-form
            @submitSurvey="submitSurvey"
            @closeDialog="dialog = false"
          ></survey-form>
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
    async submitSurvey(data) {
      try {
        const response = await axios.post("/surveys", {
          survey: {
            title: data.title,
            content: data.content,
            genre: data.genre,
            option1: data.option1,
            option2: data.option2,
            option3: data.option3,
            option4: data.option4,
            status: 0,
            user_id: this.currentUser.id
          },
        })
        console.log(response.data)
        this.$router.push({ path: `/surveys/${response.data.id}`, query: { message: 'アンケートを作成しました' }  })
      } catch (error) {
        console.log(error)
        throw error
      }
    },
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
