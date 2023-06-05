<template>
  <div>
    <h2>「{{ this.searchBooksKeyword }}」の検索結果</h2>

    <div v-if="searchBooksResult.length > 0">
      <div v-for="book in searchBooksResult" :key="book.id">
        <p>{{ book.name }}</p>
      </div>
    </div>
    <div v-else>
      <p>検索結果はありません</p>
    </div>
  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  async asyncData({ route }) {
    try {
      const response = await axios.get("/books/search_books", {
        params: {
          searchBooksKeyword: route.query.searchBooksKeyword
        }
      })
      console.log(response.data)
      return {
        searchBooksResult: response.data,
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
            this.searchBooksResult = results
          })
          .catch(error => {
            console.log(error)
          })
      }
    }
  },
  data() {
    return {
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
