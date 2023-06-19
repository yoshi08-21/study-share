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

    <div v-if="searchBooksResult && searchBooksResult.length > 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
      <br>
      <each-books :books="booksChunk"></each-books>
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
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
  async asyncData({ route, store }) {
    try {
      const response = await axios.get("/books/search_books", {
        params: {
          searchBooksKeyword: route.query.searchBooksKeyword,
          // currentUserがnullの場合、デフォルト値の０が返ってくる
          current_user_id: store.getters["auth/getCurrentUserId"]
        }
      })
      console.log(response.data)
      console.log(response.data.books[0].check_favorite)
      console.log(response.data.books[1].check_favorite)
      console.log(response.data.books[2].check_favorite)
      console.log(response.data.books[3].check_favorite)
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
            searchBooksKeyword,
            current_user_id: this.$store.getters["auth/getCurrentUserId"]
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
