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
      <br>
      <each-books :books="searchBooksResult"></each-books>
    </div>
    <div v-else>
      <p>検索結果はありません</p>
    </div>
  </div>
</template>

<script>

import EachBooks from '../../components/books/EachBooks.vue'
import axios from "@/plugins/axios"

export default {
  components: { EachBooks },
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

    }
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
