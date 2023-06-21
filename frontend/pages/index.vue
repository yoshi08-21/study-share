<template>
  <div>
    <p>hello</p>
    <p v-if="currentUser">
      currentUser: {{ currentUser.name }}
    </p>
    <p v-if="currentUser">
      email: {{ currentUser.email }}
    </p>
    <p v-if="isLoggedIn">ログイン中です</p>
    <p v-else>未ログインです</p>
    <div v-show="isLoggedIn">
      <p>ログイン中です</p>
    </div>
    <v-btn @click="getUser">ユーザーを取得</v-btn>

    <br>
    <h3>新着レビュー</h3>
    <hr>
    <v-sheet>
      <v-slide-group multiple show-arrows>
        <v-slide-group>
          <v-slide-item v-for="newReview in newReviews" :key="newReview.id">
            <v-card :to="`/books/${newReview.book_id}/reviews/${newReview.id}`">
              <v-row>
                <v-col cols="10">
                  <v-card-title>
                    タイトル: {{ newReview.title }}
                    評価：<v-rating v-model="newReview.rating" :readonly="true" background-color="orange lighten-3" color="orange"></v-rating>({{ newReview.rating }})
                  </v-card-title>
                  <v-card-text>
                    <p>{{ newReview.content }}</p>
                  </v-card-text>
                  <v-card-actions>
                    by: {{ newReview.user.name }}
                  </v-card-actions>
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="2">
                  to: {{ newReview.book.name }}
                  <template v-if="newReview.book.image">
                    <v-img :src="newReview.book.image" alt="画像"></v-img>
                  </template>
                </v-col>
              </v-row>
            </v-card>
          </v-slide-item>
        </v-slide-group>
      </v-slide-group>
    </v-sheet>
    <br>
    <h3>みんなが使っている参考書</h3>
    <hr>

    <v-sheet>
      <v-slide-group multiple show-arrows>
        <v-slide-group>
          <v-slide-item v-for="popularBook in popularBooks" :key="popularBook.id">
            <v-card :to="`/books/${popularBook.id}`">
              <v-row>
                <v-col cols="2">
                  <template v-if="popularBook.image">
                    <v-img :src="popularBook.image" alt="画像"></v-img>
                  </template>
                </v-col>
                <v-col cols="10">
                  <v-card-title>タイトル: {{ popularBook.name }}</v-card-title>
                  <v-card-text>
                    <h4>著者: {{ popularBook.author }}</h4>
                    <h4>出版社: {{ popularBook.publisher }}</h4>
                    <h4>科目: {{ popularBook.subject }}</h4>
                  </v-card-text>
                </v-col>
              </v-row>
              <v-card-actions>
                レビュー:{{ popularBook.reviews_count }}件
                平均評価:{{ popularBook.average_rating }}
                お気に入り: {{ popularBook.favorite_books_count }}
              </v-card-actions>
            </v-card>
          </v-slide-item>
        </v-slide-group>
      </v-slide-group>
    </v-sheet>


<!--
    <template>
  <v-row align="center">
    <v-item-group
      v-model="window"
      class="shrink mr-6"
      mandatory
      tag="v-flex"
    >
      <v-item
        v-for="n in length"
        :key="n"
        v-slot="{ active, toggle }"
      >
        <div>
          <v-btn
            :input-value="active"
            icon
            @click="toggle"
          >
            <v-icon>mdi-record</v-icon>
          </v-btn>
        </div>
      </v-item>
    </v-item-group>

    <v-col>
      <v-window
        v-model="window"
        class="elevation-1"
        vertical
      >
        <v-window-item
          v-for="n in length"
          :key="n"
        >
          <v-card flat>
            <v-card-text>
              <v-row
                class="mb-4"
                align="center"
              >
                <v-avatar
                  color="grey"
                  class="mr-4"
                ></v-avatar>
                <strong class="text-h6">Title {{ n }}</strong>
                <v-spacer></v-spacer>
                <v-btn icon>
                  <v-icon>mdi-account</v-icon>
                </v-btn>
              </v-row>

              <p>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              </p>

              <p>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              </p>

              <p>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
              </p>
            </v-card-text>
          </v-card>
        </v-window-item>
      </v-window>
    </v-col>
  </v-row>
</template> -->


    <br>
    <h3>あなたと同じ大学を志望している人が使っている参考書</h3>
    <hr>
    <h1>サンプル</h1>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>


  </div>
</template>

<script>

import axios from "../plugins/axios"


export default {
  name: 'IndexPage',
  async asyncData({ store }) {
    try {

      // let currentUserId = null
      // const currentUser = store.getters["auth/getCurrentUser"]
      // if (currentUser && currentUser.id) {
      //   currentUserId = currentUser.id
      // }

      const [newReviewsResponse, popularBooksResponse] = await Promise.all([
        axios.get("/pages/new_reviews"),
        axios.get("/pages/popular_books")
      ])
      const newReviews = newReviewsResponse.data
      const popularBooks = popularBooksResponse.data
      console.log(newReviews)
      console.log(popularBooks)
      return{
        newReviews,
        popularBooks
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      user: "",
      error: "",
      newReviews: [],
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
      length: 3,
      window: 0
    }
  },
  computed: {
    // ...mapGetters(["auth/getLoggedIn"]),
    isLoggedIn() {
      return this.$store.getters["auth/getLoggedIn"]
    },
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
  methods: {
    async getUser() {
      try {
        const uid = this.$store.getters["auth/getUserUid"]
        const response = await axios.get(`/users/${uid}`)
        this.user = response.data
        console.log(response)
      } catch(error) {
        console.log(error)
      }
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


}

</script>
