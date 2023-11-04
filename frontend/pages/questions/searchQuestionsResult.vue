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
                  label="質問を再検索"
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
        <h2>「{{ searchQuestionsKeyword }}」の検索結果{{ totalCount }}件 </h2>
      </v-col>
    </v-row>
    <br><br>


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
  head() {
    return {
      title: `「${this.searchQuestionsKeyword}」の検索結果（質問）`,
    }
  },
  components: { EachQuestions },
  async asyncData({ route }) {
    try {
      const response = await axios.get("/questions/search_questions", {
        params: {
          searchQuestionsKeyword: route.query.searchQuestionsKeyword
        }
      })
      return {
        searchQuestionsResult: response.data.questions,
        totalCount: response.data.questions_count,
        searchQuestionsKeyword: route.query.searchQuestionsKeyword,
      }
    } catch(error) {
      console.error("エラーが発生しました:", error)
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
        this.searchQuestionsKeyword = searchQuestionsKeyword
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
