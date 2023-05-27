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
    <v-row>
      <v-col cols="12" md="6"
        v-for="(book, index) in searchResults" :key="index">
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
                      label="科目"
                      dense
                      outlined
                    ></v-select>
                  </v-actions>
                </v-col>
              </v-row>
              <br>
              <v-actions>
                <v-btn>登録する</v-btn>
                <v-btn @click="bookDialog = false">戻る</v-btn>
              </v-actions>
            </v-card>
          </v-card>
        </v-col>
      </v-row>
    </v-dialog>

  </div>
</template>

<script>
export default {
  data() {
    return {
      keyword: "",
      searchResults: [],
      bookDialog: false,
      book: {},
      items: ["英語", "数学", "国語", "社会", "理科" ],
      subject: "",

    }
  },
  methods: {
    async searchBooks(keyword) {
      try {
        this.searchResults = []
        const baseUrl = "https://www.googleapis.com/books/v1/volumes?"
        const params = {
          q: `intitle:${keyword}`,
          maxResults:3
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
    }
  }
}
</script>

<style>

</style>
