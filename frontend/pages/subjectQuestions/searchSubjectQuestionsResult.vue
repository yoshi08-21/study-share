<template>
  <div>
    <h2>「{{ this.searchSubjectQuestionsKeyword }}」の検索結果{{ this.totalCount }}件 </h2>

    <v-card>
      <v-card-title>
        質問を再検索する
      </v-card-title>
      <v-card-title>
        <v-text-field v-model="newKeyword"></v-text-field><v-btn @click="updateQueryParams(newKeyword)">検索</v-btn>
      </v-card-title>
    </v-card>

    <div v-if="searchSubjectQuestionsResult.length > 0">
      <br>
      <each-subject-questions :subjectQuestions="searchSubjectQuestionsResult"></each-subject-questions>
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
  components: { EachSubjectQuestions },
  async asyncData({ route }) {
    try {
      const response = await axios.get("/subject_questions/search_subject_questions", {
        params: {
          searchSubjectQuestionsKeyword: route.query.searchSubjectQuestionsKeyword
        }
      })
      console.log(response.data)
      return {
        searchSubjectQuestionsResult: response.data.subject_questions,
        totalCount: response.data.subject_questions_count,
        searchSubjectQuestionsKeyword: route.query.searchSubjectQuestionsKeyword,
      }
    } catch(error) {
      console.log(error)
      throw error
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
            console.log(error)
          })
      }
    }
  },
  data() {
    return {
      newKeyword: "",
    }
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
        console.log(response.data)
        this.searchSubjectQuestionsKeyword = searchSubjectQuestionsKeyword
        return response.data
      } catch(error) {
        console.log(error)
        throw error
      }
    },
  }
}
</script>

<style>

</style>
