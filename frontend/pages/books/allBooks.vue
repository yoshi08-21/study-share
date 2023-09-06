<template>
  <div>

    <br><br><br>
    <v-row>
      <v-col cols="12" class="d-flex justify-center">
        <v-card width="85%">
          <v-card-title>
            <v-row class="d-flex justify-center">
              <v-col cols="11">
                <v-text-field
                  v-model="searchBooksKeyword"
                  filled
                  outlined
                  dense
                  label="参考書を検索"
                  data-cy="search-books-field"
                >
                </v-text-field>
              </v-col>
              <v-col cols="1">
                <v-btn @click="searchBooks" data-cy="search-books-button">検索</v-btn>
              </v-col>
            </v-row>
            <v-btn
              @click="openDialog"
              color="primary"
              block
              rounded
              large
            >
            新しい参考書を登録する
          </v-btn>
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>

    <br><br>
    <v-row>
      <v-col cols="12" class="d-flex justify-center">
        <v-card width="85%">
          <v-row>
            <v-col class="d-flex justify-center">
              <v-card-title>
                ソート機能
              </v-card-title>
            </v-col>
          </v-row>
          <v-card-actions>
            <v-row>
              <v-col cols="6">
                <v-select
                v-model="selectedSortOption"
                :items="sortBooksOptions"
                label="並び替え"
                outlined
                chips
                clearable
                data-cy="sort-books-select"
              ></v-select>
              </v-col>
              <v-col cols="6">
                <v-select
                v-model="selectedBooksSubject"
                :items="booksSubjectOptions"
                label="科目で絞り込み"
                outlined
                chips
                clearable
                data-cy="filter-books-select"
              ></v-select>
              </v-col>
            </v-row>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>


    <br><br>
    <template v-if="!sortedBooks.length == 0">
      <v-pagination
        v-model="page"
        :length="totalPages"
        :total-visible="10"
      >
    </v-pagination>
    </template>
    <br>
    <each-books :books="booksChunk"></each-books>
    <br>
    <template v-if="!sortedBooks.length == 0">
      <v-pagination
        v-model="page"
        :length="totalPages"
        :total-visible="10"
      >
      </v-pagination>
    </template>

    <!-- 参考書新規登録ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title style="justify-content: center;">
          <h2>参考書を登録する</h2>
        </v-card-title>
        <div style="padding: 30px;">
          <v-btn @click="redirectToSearchBooks" color="primary" block style="height: 50px;">登録する参考書を検索する</v-btn>
        </div>
        <v-card-text>
          <book-form
            @submitBook="submitBook"
            @closeDialog="dialog = false"
          ></book-form>
        </v-card-text>
      </v-card>
    </v-dialog>

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
  async asyncData({ store }) {
    try {
      const response = await axios.get("/books", {
        params: {
          current_user_id: store.getters["auth/getCurrentUserId"]
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
      sortBooksOptions: ["新着順", "投稿順", "評価が高い順", "レビューが多い順", "お気に入り登録数が多い順"],
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
    subjectFilteredBooks() {
      return this.filterBooks()
    },
    sortedBooks() {
      return this.sortBooks(this.subjectFilteredBooks)
    },
    booksChunk() {
      const sortedBooks = this.sortedBooks
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return sortedBooks.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.sortedBooks.length / this.perPage);
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
      const formData = new FormData()

      formData.append("current_user_id", this.currentUser.id);
      formData.append("book[name]", data.name);
      formData.append("book[author]", data.author);
      formData.append("book[publisher]", data.publisher);
      formData.append("book[subject]", data.subject);
      formData.append("book[description]", data.description);
      if (data.image) {
          formData.append("book[image]", data.image);
      }

      try {
        const response = await axios.post("/books", formData)
        console.log(response)
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
      this.$router.push({ path: "/books/googleApiSearchBooks" })
    },
    searchBooks() {
      this.$router.push({ path: "/books/localSearchBooksResult", query: { searchBooksKeyword: this.searchBooksKeyword } })
      this.searchBooksKeyword = ""
    },
    // selectedBookSubjectに応じてbooksの絞り込みを行う。subjectが空の場合は元の配列をそのまま返す
    filterBooks() {
      if(this.selectedBooksSubject) {
        const subjectFilteredBooks = this.books.filter(book => book.subject === this.selectedBooksSubject)
        this.page = 1
        return subjectFilteredBooks
      } else {
        return this.books
      }
    },
    sortBooks(books) {
      if(this.selectedSortOption === "新着順") {
        return [...books].sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
      } else if(this.selectedSortOption === "投稿順") {
        return [...books].sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      } else if(this.selectedSortOption === "評価が高い順") {
        return [...books].sort((a, b) => b.average_rating - a.average_rating)
      } else if(this.selectedSortOption === "レビューが多い順") {
        return [...books].sort((a, b) => b.reviews_count - a.reviews_count)
      } else if(this.selectedSortOption === "お気に入り登録数が多い順") {
        return [...books].sort((a, b) => b.favorite_books_count - a.favorite_books_count)
      } else {
        return [...books].sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
      }
    },
  }

}
</script>

<style>

</style>
