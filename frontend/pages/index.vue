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
    <top-page-each-books :books="popularBooks"></top-page-each-books>



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

<!-- トップページでログアウトしてもレコメンドが残り続けるバグを解消 -->
<!-- 一覧ページでレビュー件数や平均評価が０の場合に、空白ではなく０を表示するように変更 -->

    <tepmlate v-if="currentUser">
      <template v-if="currentUser.first_choice_school">
        <br>
        <h3>{{ currentUser.first_choice_school }}を志望している人が使っている参考書</h3>
        <top-page-each-books :books="firstChoiceSchoolBooks"></top-page-each-books>
      </template>

      <template v-if="currentUser.second_choice_school">
        <br>
        <h3>{{ currentUser.second_choice_school }}を志望している人が使っている参考書</h3>
        <top-page-each-books :books="secondChoiceSchoolBooks"></top-page-each-books>
      </template>

      <template v-if="currentUser.third_choice_school">
        <br>
        <h3>{{ currentUser.third_choice_school }}を志望している人が使っている参考書</h3>
        <top-page-each-books :books="thirdChoiceSchoolBooks"></top-page-each-books>
      </template>

      <template v-if="currentUser.first_choice_school === null && currentUser.second_choice_school === null && currentUser.third_choice_school == null">
        <h3>あなたと同じ大学を志望している人が使っている参考書</h3>
        <p>志望大学を登録すると使用できます</p>
      </template>

    </tepmlate>
    <template v-else>
      <h3>あなたと同じ大学を志望している人が使っている参考書</h3>
      <p>ログイン後に使用できます</p>
    </template>



    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>


  </div>
</template>

<script>
import TopPageEachBooks from '../components/books/TopPageEachBooks.vue'

import axios from "../plugins/axios"


export default {
  components: { TopPageEachBooks },
  name: 'IndexPage',
  async asyncData({ store }) {
    try {

      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const promises = [axios.get("/pages/new_reviews"), axios.get("/pages/popular_books")]

      if(currentUserId !== null) {
        promises.push(axios.get("/pages/get_same_university_books", {
          params: {
            current_user_id: currentUserId
          }
        }))
      } else {
        promises.push(axios.get("/pages/get_same_university_books", {
          params: {
            current_user_id: 0
          }
        }))
      }

      const [newReviewsResponse, popularBooksResponse, sameUniversityBooksResponse] = await Promise.all(promises)
      const newReviews = newReviewsResponse.data
      const popularBooks = popularBooksResponse.data
      const sameUniversityBooks = sameUniversityBooksResponse.data
      console.log(newReviews)
      console.log(popularBooks)
      console.log(sameUniversityBooks)
      return{
        newReviews,
        popularBooks,
        firstChoiceSchoolBooks: sameUniversityBooks.first_choice_school_books,
        secondChoiceSchoolBooks: sameUniversityBooks.second_choice_school_books,
        thirdChoiceSchoolBooks: sameUniversityBooks.third_choice_school_books
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
