<template>
  <div>

    <br><br>
    <v-row>
      <v-col cols="12" class="d-flex justify-center">
        <v-card width="85%">
          <v-row>
            <v-col class="d-flex justify-center">
              <v-card-title>
                ソート機能
              </v-card-title>
            </v-col>
          </v-row>
          <v-card-actions>
            <v-row>
              <v-col cols="6">
                <v-select
                v-model="selectedSortOption"
                :items="sortsurveysOptions"
                label="並び替え"
                outlined
                chips
                clearable
              ></v-select>
              </v-col>
              <v-col cols="6">
                <v-select
                v-model="selectedSurveyGenre"
                :items="surveyGenreOptions"
                label="ジャンルで絞り込み"
                outlined
                chips
                clearable
              ></v-select>
              </v-col>
            </v-row>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>


    <br><br>
    <v-row>
      <v-col cols="12" class="d-flex justify-center">
        <v-card width="85%" height="120" class="d-flex align-center">
          <v-card-text>
            <v-btn
              @click="openDialog"
              color="primary"
              rounded
              x-large
              block
              >
            新規アンケートを作成する
          </v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>


    <br><br>
    <v-row>
      <v-col cols="6" class="d-flex justify-center">
        <v-card width="350" elevation="5" style="padding: 0 30px;">
          <v-switch
            @click="page = 1"
            v-model="hideClosedSurvey"
            label="回答受付中のアンケートのみ表示"
            color="indigo"
          ></v-switch>
        </v-card>
      </v-col>
    </v-row>

    <template v-if="!sortedSurveys.length == 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
    </template>
    <br>
    <each-surveys :surveys="surveysChunk" :hideClosedSurvey="hideClosedSurvey"></each-surveys>
    <br>
    <template v-if="!sortedSurveys.length == 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
    </template>


    <!-- アンケートはダイアログで作成する -->
    <!-- 選択肢はボタンを押すと追加できるようにしたい -->

    <!-- アンケート新規登録ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title style="justify-content: center;">
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
      hideClosedSurvey: false,
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
    activeSurveysBasedOnHideClosed() {
      if(this.hideClosedSurvey === true) {
        return this.sortedSurveys.filter(survey => survey.status === false)
      } else {
        return this.sortedSurveys
      }
    },
    surveysChunk() {
      const activeSurveysBasedOnHideClosed = this.activeSurveysBasedOnHideClosed
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return activeSurveysBasedOnHideClosed.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.activeSurveysBasedOnHideClosed.length / this.perPage);
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
      const formData = new FormData()

      formData.append("current_user_id", this.currentUser.id);
      formData.append("survey[genre]", data.genre);
      formData.append("survey[title]", data.title);
      formData.append("survey[content]", data.content);
      formData.append("survey[option1]", data.option1);
      formData.append("survey[option2]", data.option2);
      if(data.option3) {
        formData.append("survey[option3]", data.option3);
      }
      if(data.option4) {
        formData.append("survey[option4]", data.option4);
      }
      formData.append("survey[status]", 0);
      if (data.image) {
          formData.append("survey[image]", data.image);
      }

      try {
        const response = await axios.post("/surveys", formData)
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
