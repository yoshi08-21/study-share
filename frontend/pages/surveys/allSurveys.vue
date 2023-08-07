<template>
  <div>
    <h2>アンケート一覧</h2>

    <br><br><br>
    <v-card>
      <v-card-title>
        ソート機能
      </v-card-title>
      <v-row>
        <v-col cols="6">
          <v-select
          v-model="selectedSortOption"
          :items="sortsurveysOptions"
          label="並び替え"
          dense
          outlined
        ></v-select>
        </v-col>
        <v-col cols="6">
          <v-select
          v-model="selectedSurveyGenre"
          :items="surveyGenreOptions"
          label="ジャンルで絞り込み"
          dense
          outlined
        ></v-select>
        </v-col>
      </v-row>
    </v-card>


    <br>
    <v-btn @click="openDialog">新規アンケートを作成する</v-btn>

    <br><br>
    <template v-if="!sortedSurveys.length == 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
    </template>
    <br>
    <each-surveys :surveys="surveysChunk"></each-surveys>
    <br>
    <template v-if="!sortedSurveys.length == 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
    </template>


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


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>
import SurveyForm from '../../components/surveys/SurveyForm.vue'
import EachSurveys from '../../components/surveys/EachSurveys.vue'
import axios from "@/plugins/axios"

export default {
  components: { SurveyForm, EachSurveys },
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
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
      sortsurveysOptions: ["新着順", "投稿順", "回答が多い順", "いいね!が多い順"],
      surveyGenreOptions: ["国語", "社会", "数学", "英語", "理科", "参考書", "進路・大学", "その他"],
      selectedSortOption: "",
      selectedSurveyGenre: "",
      page: 1,
      perPage: 10,
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    genreFilteredSurveys() {
      return this.filterSurveys()
    },
    sortedSurveys() {
      return this.sortSurveys(this.genreFilteredSurveys)
    },
    surveysChunk() {
      const sortedsurveys = this.sortedSurveys
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return sortedsurveys.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.sortedSurveys.length / this.perPage);
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
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "アンケートを作成できませんでした"
      }
      this.dialog = false
    },
    openDialog() {
      if(this.currentUser) {
        this.dialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    filterSurveys() {
      if(this.selectedSurveyGenre) {
        const genreFilteredSurveys = this.surveys.filter(survey => survey.genre === this.selectedSurveyGenre)
        this.page = 1
        return genreFilteredSurveys
      } else {
        return this.surveys
      }
    },
    sortSurveys(surveys) {
      if(this.selectedSortOption === "新着順") {
        return [...surveys].sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
      } else if(this.selectedSortOption === "投稿順") {
        return [...surveys].sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      } else if(this.selectedSortOption === "回答が多い順") {
        return [...surveys].sort((a, b) => b.survey_answers_count - a.survey_answers_count)
      } else if(this.selectedSortOption === "いいね!が多い順") {
        return [...surveys].sort((a, b) => b.favorite_surveys_count - a.favorite_surveys_count)
      } else {
        return [...surveys].sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      }
    },


  }
}
</script>

<style>

</style>
