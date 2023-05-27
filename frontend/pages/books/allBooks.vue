<template>
  <div>
    <h2>参考書一覧</h2>

    <br><br><br>
    <v-card>
      <v-card-title>
        参考書：検索ボックス
        <v-text-field></v-text-field><v-btn>検索</v-btn>
      </v-card-title>
      <v-card-title>
        <v-btn @click="dialog = true" block>新しい参考書を登録する</v-btn>
      </v-card-title>
    </v-card>

    <br><br>
    <each-books :books="books"></each-books>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EachBooks from '../../components/books/EachBooks.vue'
import axios from "@/plugins/axios"

export default {
  components: { EachBooks },
  async asyncData() {
    try {
      const response = await axios.get("/books")
      console.log(response.data)
      return {
        books: response.data
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",

    }
  },
  mounted() {
    if (this.$route.query.message) {
      this.snackbarColor = "primary"
      this.snackbar = true
      this.flashMessage = this.$route.query.message
      // this.$snackbar.show(this.$route.query.message)
    }
  },

}
</script>

<style>

</style>
