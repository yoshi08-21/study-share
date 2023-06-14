<template>
  <div>
    <h2>「{{ this.searchBooksKeyword }}」の検索結果{{ this.totalCount }}件 </h2>

    <v-card>
      <v-card-title>
        参考書を再検索する
      </v-card-title>
      <v-card-title>
        <v-text-field v-model="newKeyword"></v-text-field><v-btn @click="updateQueryParams(newKeyword)">検索</v-btn>
      </v-card-title>
    </v-card>

    <div v-if="searchBooksResult.length > 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
      <br>
      <each-local-search-result :books="booksChunk"></each-local-search-result>
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
    </div>
    <div v-else>
      <p>検索結果はありません</p>
    </div>
  </div>
</template>

<script>

import EachLocalSearchResult from '../../components/books/EachLocalSearchResult.vue'
import axios from "@/plugins/axios"

export default {
  components: { EachLocalSearchResult },
  async asyncData({ route }) {
    try {
      const response = await axios.get("/books/search_books", {
        params: {
          searchBooksKeyword: route.query.searchBooksKeyword
        }
      })
      console.log(response.data)
      return {
        searchBooksResult: response.data.books,
        totalCount: response.data.books_count,
        searchBooksKeyword: route.query.searchBooksKeyword
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  watch: {
    "$route.query.searchBooksKeyword"(newValue, oldValue) {
      if(newValue !== oldValue) {
        this.updateSearchResult(newValue)
          .then(results => {
            this.searchBooksResult = results.books
            this.totalCount = results.books_count
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
    booksChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.searchBooksResult.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.searchBooksResult.length / this.perPage);
    },
  },
  methods: {
    async updateSearchResult(searchBooksKeyword) {
      try {
        const response = await axios.get("/books/search_books", {
          params: {
            searchBooksKeyword
          }
        })
        console.log(response.data)
        this.searchBooksKeyword = searchBooksKeyword
        this.page = 1
        return response.data
      } catch(error) {
        console.log(error)
        throw error
      }
    },
    updateQueryParams(newValue) {
      this.$router.push({ query: { searchBooksKeyword: newValue } })
      this.newKeyword = ""
    },
  }
}
</script>

<style>

</style>
