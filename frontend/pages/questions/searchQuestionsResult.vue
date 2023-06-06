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

    <div v-if="searchQuestionsResult.length > 0">
      <br>
      <each-questions :questions="searchQuestionsResult"></each-questions>
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
    }
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
