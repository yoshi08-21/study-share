<template>
  <div>
    <h2>参考書一覧</h2>

    <br><br><br>
    <v-card>
      <v-card-title>
        参考書：検索ボックス
        <v-text-field v-model="searchBooksKeyword"></v-text-field><v-btn @click="searchBooks">検索</v-btn>
      </v-card-title>
      <v-card-title>
        <v-btn @click="openDialog" block>新しい参考書を登録する</v-btn>
      </v-card-title>
    </v-card>

    <br><br><br>
    <v-card>
      <v-card-title>
        ソート機能
      </v-card-title>
      <v-row>
        <v-col cols="6">
          <v-select
          v-model="selectedSortOption"
          :items="sortBooksOptions"
          label="並び替え"
          dense
          outlined
        ></v-select>
        </v-col>
        <v-col cols="6">
          <v-select
          v-model="selectedBooksSubject"
          :items="booksSubjectOptions"
          label="科目で絞り込み"
          dense
          outlined
        ></v-select>
        </v-col>
      </v-row>
    </v-card>

    <!-- 参考書新規登録ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          <h2>参考書を登録する</h2>
        </v-card-title>
        <v-card-title>
          <v-btn @click="redirectToSearchBooks" color="primary" block>登録する参考書を検索する</v-btn>
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
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
    <br>
    <each-books :books="booksChunk"></each-books>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>

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
  async asyncData(context) {
    try {
      // const currentUser = await context.store.getters["auth/getCurrentUser"]
      const response = await axios.get("/books", {
        params: {
          current_user_id: 1
        }
      })
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
      // 参考書登録の空データ送信用。S3の利用時には削除可
      image: "",
      perPage: 10,
      page: 1,
      searchBooksKeyword: "",
      sortBooksOptions: ["新着順", "投稿順", "評価が高い順", "レビューが多い順"],
      booksSubjectOptions: [
      {text:"国語", disabled: true},"現代文", "古文", "漢文",
      {text:"社会", disabled: true}, "日本史", "世界史", "地理", "倫理・政治経済",
      {text:"数学", disabled: true},"数学I・A", "数学Ⅱ・B", "数学Ⅲ・C",
      {text:"英語", disabled: true},"英文法", "英文読解", "英作文", "英単語", "リスニング",
      {text:"理科", disabled: true}, "物理", "生物", "化学", "地学",
      {text:"その他", disabled: true},"過去問", "小論文", "その他科目",
      ],
      selectedSortOption: "",
      selectedBooksSubject: ""
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    sortedBooks() {
      return this.sortBooks()
    },
    booksChunk() {
      const sortedBooks = this.sortedBooks
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return sortedBooks.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.books.length / this.perPage);
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
            subject: data.subject,
            image: this.image
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
    openDialog() {
      if(this.currentUser) {
        this.dialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    redirectToSearchBooks() {
      this.$router.push({ path: "/books/searchBooks" })
    },
    searchBooks() {
      this.$router.push({ path: "/books/searchBooksResult", query: { searchBooksKeyword: this.searchBooksKeyword } })
      this.searchBooksKeyword = ""
    },
    sortBooks() {
      if(this.selectedSortOption === "新着順") {
        return this.books.sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
      } else if(this.selectedSortOption === "投稿順") {
        return this.books.sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      } else {
        return this.books.sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      }
    }
  }

}
</script>

<style>

</style>
