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

<!-- トップページでログアウトしてもレコメンドが残り続けるバグを解消 -->

    <tepmlate v-if="currentUser">
      <template v-if="currentUser.first_choice_school">
        <br>
        <h3>{{ currentUser.first_choice_school }}を志望している人が使っている参考書</h3>
        <hr>
        <v-sheet>
          <v-slide-group multiple show-arrows>
            <v-slide-group>
              <v-slide-item v-for="firstChoiceSchoolBook in firstChoiceSchoolBooks" :key="firstChoiceSchoolBook.id">
                <v-card :to="`/books/${firstChoiceSchoolBook.id}`">
                  <v-row>
                    <v-col cols="2">
                      <template v-if="firstChoiceSchoolBook.image">
                        <v-img :src="firstChoiceSchoolBook.image" alt="画像"></v-img>
                      </template>
                    </v-col>
                    <v-col cols="10">
                      <v-card-title>タイトル: {{ firstChoiceSchoolBook.name }}</v-card-title>
                      <v-card-text>
                        <h4>著者: {{ firstChoiceSchoolBook.author }}</h4>
                        <h4>出版社: {{ firstChoiceSchoolBook.publisher }}</h4>
                        <h4>科目: {{ firstChoiceSchoolBook.subject }}</h4>
                      </v-card-text>
                    </v-col>
                  </v-row>
                  <v-card-actions>
                    レビュー:{{ firstChoiceSchoolBook.reviews_count }}件
                    平均評価:{{ firstChoiceSchoolBook.average_rating }}
                    お気に入り: {{ firstChoiceSchoolBook.favorite_books_count }}
                  </v-card-actions>
                </v-card>
              </v-slide-item>
            </v-slide-group>
          </v-slide-group>
        </v-sheet>
      </template>

      <template v-if="currentUser.second_choice_school">

        <br>
        <h3>{{ currentUser.second_choice_school }}を志望している人が使っている参考書</h3>
        <hr>
        <v-sheet>
          <v-slide-group multiple show-arrows>
            <v-slide-group>
              <v-slide-item v-for="secondChoiceSchoolBook in secondChoiceSchoolBooks" :key="secondChoiceSchoolBook.id">
                <v-card :to="`/books/${secondChoiceSchoolBook.id}`">
                  <v-row>
                    <v-col cols="2">
                      <template v-if="secondChoiceSchoolBook.image">
                        <v-img :src="secondChoiceSchoolBook.image" alt="画像"></v-img>
                      </template>
                    </v-col>
                    <v-col cols="10">
                      <v-card-title>タイトル: {{ secondChoiceSchoolBook.name }}</v-card-title>
                      <v-card-text>
                        <h4>著者: {{ secondChoiceSchoolBook.author }}</h4>
                        <h4>出版社: {{ secondChoiceSchoolBook.publisher }}</h4>
                        <h4>科目: {{ secondChoiceSchoolBook.subject }}</h4>
                      </v-card-text>
                    </v-col>
                  </v-row>
                  <v-card-actions>
                    レビュー:{{ secondChoiceSchoolBook.reviews_count }}件
                    平均評価:{{ secondChoiceSchoolBook.average_rating }}
                    お気に入り: {{ secondChoiceSchoolBook.favorite_books_count }}
                  </v-card-actions>
                </v-card>
              </v-slide-item>
            </v-slide-group>
          </v-slide-group>
        </v-sheet>
      </template>

      <template v-if="currentUser.third_choice_school">
        <br>
        <h3>{{ currentUser.third_choice_school }}を志望している人が使っている参考書</h3>
        <hr>
        <v-sheet>
          <v-slide-group multiple show-arrows>
            <v-slide-group>
              <v-slide-item v-for="thirdChoiceSchoolBook in thirdChoiceSchoolBooks" :key="thirdChoiceSchoolBook.id">
                <v-card :to="`/books/${thirdChoiceSchoolBook.id}`">
                  <v-row>
                    <v-col cols="2">
                      <template v-if="thirdChoiceSchoolBook.image">
                        <v-img :src="thirdChoiceSchoolBook.image" alt="画像"></v-img>
                      </template>
                    </v-col>
                    <v-col cols="10">
                      <v-card-title>タイトル: {{ thirdChoiceSchoolBook.name }}</v-card-title>
                      <v-card-text>
                        <h4>著者: {{ thirdChoiceSchoolBook.author }}</h4>
                        <h4>出版社: {{ thirdChoiceSchoolBook.publisher }}</h4>
                        <h4>科目: {{ thirdChoiceSchoolBook.subject }}</h4>
                      </v-card-text>
                    </v-col>
                  </v-row>
                  <v-card-actions>
                    レビュー:{{ thirdChoiceSchoolBook.reviews_count }}件
                    平均評価:{{ thirdChoiceSchoolBook.average_rating }}
                    お気に入り: {{ thirdChoiceSchoolBook.favorite_books_count }}
                  </v-card-actions>
                </v-card>
              </v-slide-item>
            </v-slide-group>
          </v-slide-group>
        </v-sheet>
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

import axios from "../plugins/axios"


export default {
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
