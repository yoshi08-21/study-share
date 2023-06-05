<template>
  <div>
    <h2>検索結果</h2>
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
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      searchBooksKeyword: ""
    }
  },
  methods: {

  }
}
</script>

<style>

</style>
