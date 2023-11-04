<template>
  <div>
    <br><br>
    <v-row>
      <v-col cols="12" class="d-flex justify-center">
        <v-card height="130px" width="85%">
          <v-card-title style="height: 100%; align-items: center;">
            <v-row>
              <v-col cols="11">
                <v-text-field
                  v-model="newKeyword"
                  filled
                  outlined
                  dense
                  label="参考書を再検索"
                >
                </v-text-field>
              </v-col>
              <v-col cols="1">
                <v-btn @click="updateQueryParams(newKeyword)">検索</v-btn>
              </v-col>
            </v-row>
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>

    <br>
    <v-row>
      <v-col class="d-flex justify-center">
        <h2>「{{ this.searchSubjectQuestionsKeyword }}」の検索結果{{ this.totalCount }}件 </h2>
      </v-col>
    </v-row>
    <br><br>

    <div v-if="searchSubjectQuestionsResult && searchSubjectQuestionsResult.length > 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
      <br>
      <each-subject-questions :subjectQuestions="subjectQuestionsChunk"></each-subject-questions>
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
    </div>
    <div v-else>
      <p>検索結果はありません</p>
    </div>
  </div>
</template>

<script>

import EachSubjectQuestions from '../../components/subjectQuestions/EachSubjectQuestions.vue'
import axios from "@/plugins/axios"

export default {
  head() {
    return {
      title: `「${this.searchSubjectQuestionsKeyword}」の検索結果(科目別質問)`,
    }
  },
  components: { EachSubjectQuestions },
  async asyncData({ route }) {
    try {
      const response = await axios.get("/subject_questions/search_subject_questions", {
        params: {
          searchSubjectQuestionsKeyword: route.query.searchSubjectQuestionsKeyword
        }
      })
      return {
        searchSubjectQuestionsResult: response.data.subject_questions,
        totalCount: response.data.subject_questions_count,
        searchSubjectQuestionsKeyword: route.query.searchSubjectQuestionsKeyword,
      }
    } catch(error) {
      console.error("エラーが発生しました:", error)
    }
  },
  watch: {
    "$route.query.searchSubjectQuestionsKeyword"(newValue, oldValue) {
      if(newValue !== oldValue) {
        this.updateSearchResult(newValue)
          .then(results => {
            this.searchSubjectQuestionsResult = results.subject_questions
            this.totalCount = results.subject_questions_count
          })
          .catch(error => {
            console.error("エラーが発生しました:", error)
          })
      }
    }
  },
  data() {
    return {
      newKeyword: "",
      perPage: 10,
      page: 1,
    }
  },
  computed: {
    subjectQuestionsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.searchSubjectQuestionsResult.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.searchSubjectQuestionsResult.length / this.perPage);
    },
  },
  methods: {
    updateQueryParams(newValue) {
      this.$router.push({ query: { searchSubjectQuestionsKeyword: newValue } })
      this.newKeyword = ""
    },
    async updateSearchResult(searchSubjectQuestionsKeyword) {
      try {
        const response = await axios.get("/subject_questions/search_subject_questions", {
          params: {
            searchSubjectQuestionsKeyword
          }
        })
        this.searchSubjectQuestionsKeyword = searchSubjectQuestionsKeyword
        this.page = 1
        return response.data
      } catch(error) {
        console.error("エラーが発生しました:", error)
      }
    },
  }
}
</script>

<style>

</style>
