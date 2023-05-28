<template>
  <div>
    <h2>参考書検索</h2>

    <v-card>
      <v-card-title>
        参考書：検索ボックス
        <v-text-field v-model="keyword"></v-text-field>
        <!-- <input type="text" v-model="keyword"> -->
        <v-btn @click="searchBooks(keyword)">検索</v-btn>
      </v-card-title>
    </v-card>

    <br><br>
    <template v-if="searchResults.length !== 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
      <br>
      <v-row>
        <v-col cols="12" md="6"
          v-for="(book, index) in booksChunk" :key="index">
          <v-card class="mx-auto" max-height="250">
            <v-row>
              <v-col cols="3">
                <v-img :src="book.image"></v-img>
              </v-col>
              <v-col cols="8">
                <v-card-title>{{ book.name }}</v-card-title>
                {{ book.description }}
                <v-spacer></v-spacer>
                <v-card-actions>
                  <v-btn @click="openBookDialog(book)">参考書を登録する</v-btn>
                </v-card-actions>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
      <br>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
  </template>


    <!-- 選択した参考書の確認ダイアログ -->
    <v-dialog v-model="bookDialog" max-width="1000px">
      <v-row>
        <v-col cols="12">
          <v-card v-if="book">
            <v-card-title>
              <h2>この参考書を登録します</h2>
            </v-card-title>
            <v-card class="mx-auto">
              <v-row>
                <v-col cols="2">
                  <v-abatar size="10px">
                    <v-img :src="book.image"></v-img>
                  </v-abatar>
                </v-col>
                <v-col cols="10">
                  <v-card-title>
                    タイトル: {{ book.name }}
                  </v-card-title>
                  <v-card-text>
                    <p>著者: {{ book.author }}</p>
                    <p>出版社: {{ book.publisher }}</p>
                    <p>説明文: {{ book.description }}</p>
                  </v-card-text>
                </v-col>
              </v-row>
              <br>
              <v-row>
                <v-col cols="4">
                  <v-actions>
                    科目を選択してください（必須）
                    <v-select
                      v-model="subject"
                      :items="items"
                      label="科目（必須）"
                      dense
                      outlined
                    ></v-select>
                  </v-actions>
                </v-col>
              </v-row>
              <br>
              <v-actions>
                <template v-if="subject == ''">
                  <v-btn @click="submitBook(book)" disabled>登録する</v-btn>
                </template>
                <template v-else>
                  <v-btn @click="submitBook(book)" color="primary">登録する</v-btn>
                </template>
                <v-btn @click="bookDialog = false">戻る</v-btn>
              </v-actions>
            </v-card>
          </v-card>
        </v-col>
      </v-row>
    </v-dialog>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  data() {
    return {
      keyword: "",
      searchResults: [],
      bookDialog: false,
      book: {},
      items: ["英語", "数学", "国語", "社会", "理科" ],
      subject: "",
      perPage: 10,
      page: 1,
      cleanedErrorMessage: "",


    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    booksChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.searchResults.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.searchResults.length / this.perPage);
    },
  },
  methods: {
    async searchBooks(keyword) {
      try {
        this.searchResults = []
        const baseUrl = "https://www.googleapis.com/books/v1/volumes?"
        const params = {
          q: `intitle:${keyword}`,
          maxResults: 40
        }
        const queryParams = new URLSearchParams(params)
        const response = await fetch(baseUrl + queryParams)
        .then(response => response.json())
        console.log(response.items)
        for (const book of response.items) {
          const name = book.volumeInfo.title
          const author = book.volumeInfo.author
          const publisher = book.volumeInfo.publisher
          const image = book.volumeInfo.imageLinks
          const description = book.volumeInfo.description
          this.searchResults.push({
            name: name || "不明",
            author: author || "不明",
            publisher: publisher || "不明",
            image : image ? image.thumbnail : "",
            description: description ? description.slice(0, 40) : ""
          })

        }
      } catch(error) {
        console.log(error)
        throw error
      }
    },
    openBookDialog(book) {
      this.book = book
      this.bookDialog = true
    },
    async submitBook(book) {
      try {
        const response = await axios.post("/books", {
          user_id: this.currentUser.id,
          book: {
            name: book.name,
            author: book.author,
            publisher: book.publisher,
            subject: this.subject,
            image: book.image
          }
        })
        console.log(response)
        this.$router.push({ path: `/books/${response.data.id}`, query: { message: '参考書の登録が完了しました' } })
      } catch(error) {
        if (error.response && error.response.data) {
          console.log(error)
          console.log(error.response)
          console.log(error.response.data)
          const errors = error.response.data.errors
          for (const error of errors) {
            if (error.includes("Name")) {
              this.cleanedErrorMessage = error.replace("Name ", "")
            }
          }
          console.log(this.cleanedErrorMessage); // エラーメッセージを表示
          this.snackbarColor = "red accent-2"
          this.snackbar = true
          this.flashMessage = this.cleanedErrorMessage
        } else {
          console.log('リクエストエラー:', error);
        }
      }
      this.bookDialog = false
    }
  }
}
</script>

<style>

</style>
