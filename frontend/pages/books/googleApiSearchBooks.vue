<template>
  <div>
    <h2>参考書検索</h2>

    <v-card>
      <v-card-title>
        新規登録する参考書を検索
        <v-text-field v-model="keyword"></v-text-field>
        <!-- <input type="text" v-model="keyword"> -->
        <v-btn @click="searchBooks(keyword)">検索</v-btn>
      </v-card-title>
    </v-card>

    <br><br>
    <!-- 取得した参考書の一覧表示 -->
    <template v-if="searchResults.length !== 0">
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
      <br>
      <v-row>
        <v-col cols="12" md="6"
          v-for="(book, index) in booksChunk" :key="index">
          <v-card class="mx-auto" max-height="250">
            <v-row>
              <v-col cols="3">
                <v-img :src="book.imageUrl"></v-img>
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
                    <v-img :src="book.imageUrl"></v-img>
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
                    <v-btn @click="selectSubjectDialog = true">科目を選択する</v-btn>
                  </v-actions>
                </v-col>
                <h3 v-if="subject">選択された科目：{{ subject }}</h3>
              </v-row>
              <br>
              <v-actions>
                <template v-if="subject == ''">
                  <v-btn @click="submitBook(book)" disabled>登録する</v-btn>
                </template>
                <template v-else>
                  <v-btn @click="submitBook(book)" color="primary">登録する</v-btn>
                </template>
                <v-btn @click="closeBookDialog">戻る</v-btn>
              </v-actions>
            </v-card>
          </v-card>
        </v-col>
      </v-row>
    </v-dialog>

        <!-- 科目選択ダイアログ -->
        <v-dialog v-model="selectSubjectDialog" max-width="500px">
      <v-card>
        <v-card-title class="headline">科目選択</v-card-title>
        <v-card-text>
          <v-radio-group v-model="subject">
            <template v-for="category in categories">
              <p :key="category.name">{{ category.name }}</p>
              <v-radio v-for="subcategory in category.subcategories" :key="subcategory" :label="subcategory" :value="subcategory"></v-radio>
            </template>
          </v-radio-group>
        </v-card-text>
        <h3>選択された科目:{{ subject }}</h3>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn @click="selectSubjectDialog = false" color="primary" block>閉じる</v-btn>
        </v-card-actions>
      </v-card>
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
      selectSubjectDialog: false,
      categories: [
        {
          name: "国語",
          subcategories: ["現代文", "古文", "漢文"]
        },
        {
          name: "社会",
          subcategories: ["日本史", "世界史", "地理", "倫理・政治経済"]
        },
        {
          name: "数学",
          subcategories: ["数学I・A", "数学Ⅱ・B", "数学Ⅲ・C"]
        },
        {
          name: "英語",
          subcategories: ["英文法", "英文読解", "英作文", "英単語", "リスニング"]
        },
        {
          name: "理科",
          subcategories: ["物理", "生物", "化学", "地学"]
        },
        {
          name: "その他",
          subcategories: ["過去問", "小論文", "その他科目"]
        },
      ],


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
        const data = await response.json()

        console.log(data)
        console.log(response)
        for (const book of data.items) {
          const name = book.volumeInfo.title
          const author = book.volumeInfo.author
          const publisher = book.volumeInfo.publisher
          const imageUrl = book.volumeInfo.imageLinks
          const description = book.volumeInfo.description
          this.searchResults.push({
            name: name || "不明",
            author: author || "不明",
            publisher: publisher || "不明",
            imageUrl : imageUrl ? imageUrl.thumbnail : "",
            description: description ? description.slice(0, 40) : ""
          })
        }
        this.page = 1
      } catch(error) {
        console.log(error)
        throw error
      }
    },
    openBookDialog(book) {
      this.book = book
      this.subject = ""
      this.bookDialog = true
    },
    async downloadImageFromUrl(url) {
      const response = await fetch(url);
      const blob = await response.blob();
      return new File([blob], "downloaded-image.jpg", { type: blob.type });
    },
    async submitBook(book) {
      const formData = new FormData()

      formData.append("book[user_id]", this.currentUser.id);
      formData.append("book[name]", book.name);
      formData.append("book[author]", book.author);
      formData.append("book[publisher]", book.publisher);
      formData.append("book[subject]", this.subject);
      if (book.imageUrl) {
        const encodedUrl = encodeURIComponent(book.imageUrl);
        const response = await axios.get(`/books/download_book_image?image_url=${encodedUrl}`, {
          responseType: 'blob'
        });
        console.log(response)
        const imageBlob = new Blob([response.data], { type: response.headers['content-type'] });
        formData.append("book[image]", imageBlob, "downloaded-image.jpg");
      }
      try {
        const response = await axios.post("/books", formData)
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
    },
    closeBookDialog() {
      this.bookDialog = false
      this.subject = ""
    }
  }
}
</script>

<style>

</style>
