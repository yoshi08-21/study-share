<template>
  <div>
    <h2>「{{ this.searchQuestionsKeyword }}」の検索結果{{ this.totalCount }}件 </h2>

    <v-card>
      <v-card-title>
        質問を再検索する
      </v-card-title>
      <v-card-title>
        <v-text-field v-model="newKeyword"></v-text-field><v-btn @click="updateQueryParams(newKeyword)">検索</v-btn>
      </v-card-title>
    </v-card>

    <div v-if="searchQuestionsResult && searchQuestionsResult.length > 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
      <br>
      <each-questions :questions="questionsChunk"></each-questions>
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
    </div>
    <div v-else>
      <p>検索結果はありません</p>
    </div>
  </div>
</template>

<script>

import EachQuestions from '../../components/questions/EachQuestions.vue'
import axios from "@/plugins/axios"

export default {
  components: { EachQuestions },
  async asyncData({ route }) {
    try {
      const response = await axios.get("/questions/search_questions", {
        params: {
          searchQuestionsKeyword: route.query.searchQuestionsKeyword
        }
      })
      console.log(response.data)
      return {
        searchQuestionsResult: response.data.questions,
        totalCount: response.data.questions_count,
        searchQuestionsKeyword: route.query.searchQuestionsKeyword,
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  watch: {
    "$route.query.searchQuestionsKeyword"(newValue, oldValue) {
      if(newValue !== oldValue) {
        this.updateSearchResult(newValue)
          .then(results => {
            this.searchQuestionsResult = results.questions
            this.totalCount = results.questions_count
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
      perPage: 10,
      page: 1,
    }
  },
  computed: {
    questionsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.searchQuestionsResult.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.searchQuestionsResult.length / this.perPage);
    },
  },
  methods: {
    updateQueryParams(newValue) {
      this.$router.push({ query: { searchQuestionsKeyword: newValue } })
      this.newKeyword = ""
    },
    async updateSearchResult(searchQuestionsKeyword) {
      try {
        const response = await axios.get("/questions/search_questions", {
          params: {
            searchQuestionsKeyword
          }
        })
        console.log(response.data)
        this.searchQuestionsKeyword = searchQuestionsKeyword
        this.page = 1
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
