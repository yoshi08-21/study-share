<template>
  <div>
    <h2>科目別質問一覧ページ</h2>

    <v-tabs
      fixed-tabs
    >
    <v-tab to="/questions/questions">
        参考書別質問
      </v-tab>
      <v-tab to="/subjectQuestions/subjectQuestions">
        科目別質問
      </v-tab>
    </v-tabs>


    <br><br><br>
    <v-card>
      <v-card-title>
        質問一覧：検索ボックス
        <v-text-field v-model="searchSubjectQuestionsKeyword"></v-text-field><v-btn @click="searchSubjectQuestions">検索</v-btn>
      </v-card-title>
      <v-card-title>
        <v-btn @click="dialog = true" block>科目別質問を投稿する</v-btn>
      </v-card-title>
    </v-card>

    <br><br><br>
    <v-card>
      <v-card-title>
        ソート機能
      </v-card-title>
      <v-row>
        <v-col cols="6">
          <v-select
          v-model="selectedSortOption"
          :items="sortQuestionsOptions"
          label="並び替え"
          dense
          outlined
        ></v-select>
        </v-col>
        <v-col cols="6">
          <v-select
          v-model="selectedQuestionsSubject"
          :items="questionsSubjectOptions"
          label="科目で絞り込み"
          dense
          outlined
        ></v-select>
        </v-col>
      </v-row>
    </v-card>

        <!-- 新規質問投稿ダイアログ -->
        <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          Dialog Title
        </v-card-title>
        <v-card-text>
          <subject-question-form @submitSubjectQuestion="submitSubjectQuestion" @closeDialog="dialog = false"></subject-question-form>
        </v-card-text>
      </v-card>
    </v-dialog>

    <br>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
    <br>
    <each-subject-questions :subjectQuestions="subjectQuestionsChunk"></each-subject-questions>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import SubjectQuestionForm from '../../components/subjectQuestions/SubjectQuestionForm.vue'
import EachSubjectQuestions from '../../components/subjectQuestions/EachSubjectQuestions.vue'
import axios from "@/plugins/axios"

export default {
  components: { SubjectQuestionForm, EachSubjectQuestions },
  async asyncData() {
    try {
      const responce = await axios.get("/subject_questions")
      console.log(responce.data)
      return {
        subjectQuestions: responce.data
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      dialog: false,
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
      perPage: 10,
      page: 1,
      searchSubjectQuestionsKeyword: "",
      sortQuestionsOptions: ["新着順", "投稿順", "いいね!が多い順", "返信が多い順"],
      questionsSubjectOptions: [
      {text:"国語", disabled: true},"現代文", "古文", "漢文",
      {text:"社会", disabled: true}, "日本史", "世界史", "地理", "倫理・政治経済",
      {text:"数学", disabled: true},"数学I・A", "数学Ⅱ・B", "数学Ⅲ・C",
      {text:"英語", disabled: true},"英文法", "英文読解", "英作文", "英単語", "リスニング",
      {text:"理科", disabled: true}, "物理", "生物", "化学", "地学",
      {text:"その他", disabled: true},"過去問", "小論文", "その他科目",
      ],
      selectedSortOption: "",
      selectedQuestionsSubject: ""
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    subjectFilteredQuestions() {
      return this.filterQuestions()
    },
    sortedQuestions() {
      return this.sortQuestions(this.subjectFilteredQuestions)
    },
    subjectQuestionsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.sortedQuestions.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.sortedQuestions.length / this.perPage);
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
    async submitSubjectQuestion(data) {
      const formData = new FormData()

      formData.append("subject_question[user_id]", this.currentUser.id);
      formData.append("subject_question[title]", data.title);
      formData.append("subject_question[content]", data.content);
      formData.append("subject_question[subject]", data.subject);
      if (data.image) {
          formData.append("subject_question[image]", data.image);
      }

      try {
        const response = await axios.post("/subject_questions", formData)
        console.log(response)
        this.$router.push({ path: `/subjectQuestions/${response.data.id}`, query: { message: '質問の投稿が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を投稿できませんでした"
      }
      this.dialog = false
    },
    searchSubjectQuestions() {
      this.$router.push({ path: "/subjectQuestions/searchSubjectQuestionsResult", query: { searchSubjectQuestionsKeyword: this.searchSubjectQuestionsKeyword } })
      this.searchSubjectQuestionsKeyword = ""
    },
    filterQuestions() {
      if(this.selectedQuestionsSubject) {
        const subjectFilteredQuestions = this.subjectQuestions.filter(subjectQuestion => subjectQuestion.subject === this.selectedQuestionsSubject)
        this.page = 1
        return subjectFilteredQuestions
      } else {
        return this.subjectQuestions
      }
    },
    sortQuestions(subjectQuestions) {
      if(this.selectedSortOption === "新着順") {
        return [...subjectQuestions].sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
      } else if(this.selectedSortOption === "投稿順") {
        return [...subjectQuestions].sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      } else if(this.selectedSortOption === "いいね!が多い順") {
        return [...subjectQuestions].sort((a, b) => b.favorite_subject_questions_count - a.favorite_subject_questions_count)
      } else if(this.selectedSortOption === "返信が多い順") {
        return [...subjectQuestions].sort((a, b) => b.subject_question_replies_count - a.subject_question_replies_count)
      } else {
        return [...subjectQuestions].sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      }
    }
  }
}
</script>

<style>

</style>
