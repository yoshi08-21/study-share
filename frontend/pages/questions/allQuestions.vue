<template>
  <div>
    <br><br>
    <v-tabs
      grow
      elevation="6"
    >
      <v-tab to="/questions/allQuestions" >
        参考書別質問
      </v-tab>
      <v-tab to="/subjectQuestions/allSubjectQuestions">
        科目別質問
      </v-tab>
    </v-tabs>

    <br><br><br>
    <v-row>
      <v-col cols="12" class="d-flex justify-center">
        <v-card width="85%">
          <v-card-title>
            <v-row class="d-flex justify-center">
              <v-col cols="11">
                <v-text-field
                  v-model="searchQuestionsKeyword"
                  filled
                  outlined
                  dense
                  label="質問を検索"
                  data-cy="search-questions-field"
                >
                </v-text-field>
              </v-col>
              <v-col cols="1">
                <v-btn @click="searchQuestions" data-cy="search-questions-button">検索</v-btn>
              </v-col>
            </v-row>
            <v-btn
              color="primary"
              block
              rounded
              large
              disabled
            >
            参考書別の質問は参考書の詳細ページから投稿できます
          </v-btn>
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>

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
                :items="sortQuestionsOptions"
                label="並び替え"
                outlined
                chips
                clearable
                data-cy="sort-questions-select"
              ></v-select>
              </v-col>
              <v-col cols="6">
                <v-select
                v-model="selectedQuestionsSubject"
                :items="questionsSubjectOptions"
                label="科目で絞り込み"
                outlined
                chips
                clearable
                data-cy="filter-questions-select"
              ></v-select>
              </v-col>
            </v-row>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>

    <br>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
    <br>
    <each-questions :questions="questionsChunk"></each-questions>
    <br>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import EachQuestions from '../../components/questions/EachQuestions.vue'
import axios from "@/plugins/axios"

export default {
  components: { EachQuestions },
  async asyncData() {
    try {
      const responce = await axios.get("/questions/all_questions")
      console.log(responce.data)
      return {
        questions: responce.data
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      perPage: 10,
      page: 1,
      searchQuestionsKeyword: "",
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
    questionsChunk() {
      const sortedQuestions = this.sortedQuestions
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return sortedQuestions.slice(start, end)
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
    }
  },
  methods:{
    searchQuestions() {
      this.$router.push({ path: "/questions/searchQuestionsResult", query: { searchQuestionsKeyword: this.searchQuestionsKeyword } })
      this.searchQuestionsKeyword = ""
    },
    filterQuestions() {
      if(this.selectedQuestionsSubject) {
        const subjectFilteredQuestions = this.questions.filter(question => question.book.subject === this.selectedQuestionsSubject)
        this.page = 1
        return subjectFilteredQuestions
      } else {
        return this.questions
      }
    },
    sortQuestions(questions) {
      if(this.selectedSortOption === "新着順") {
        return [...questions].sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
      } else if(this.selectedSortOption === "投稿順") {
        return [...questions].sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      } else if(this.selectedSortOption === "いいね!が多い順") {
        return [...questions].sort((a, b) => b.favorite_questions_count - a.favorite_questions_count)
      } else if(this.selectedSortOption === "返信が多い順") {
        return [...questions].sort((a, b) => b.replies_count - a.replies_count)
      } else {
        return [...questions].sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      }
    }
  }
}
</script>

<style>

</style>
