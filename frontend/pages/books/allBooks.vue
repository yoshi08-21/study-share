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

    <!-- 参考書新規登録ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          参考書を登録する
        </v-card-title>
        <v-card-text>
          <book-form
            @submitBook="submitBook"
            @closeDialog="dialog = false"
          ></book-form>
        </v-card-text>
      </v-card>
    </v-dialog>

    <br><br>
    <each-books :books="books"></each-books>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EachBooks from '../../components/books/EachBooks.vue'
import BookForm from '../../components/books/BookForm.vue'
import axios from "@/plugins/axios"

export default {
  components: { EachBooks, BookForm },
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
      dialog: false,

    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
  mounted() {
    if (this.$route.query.message) {
      this.snackbarColor = "primary"
      this.snackbar = true
      this.flashMessage = this.$route.query.message
      // this.$snackbar.show(this.$route.query.message)
    }
  },
  methods: {
    async submitBook(data) {
      try {
        const response = await axios.post("/books", {
            user_id: this.currentUser.id,
            name: data.name,
            author: data.author,
            publisher: data.publisher,
            subject: data.subject
          }
        )
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.$router.push({ path: `/books/${response.data.id}`, query: { message: '参考書の登録が完了しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "参考書を登録できませんでした"
      }
      this.dialog = false
    },
  }

}
</script>

<style>

</style>
