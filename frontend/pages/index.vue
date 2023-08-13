<template>
  <div>

    <h1>Welcome To StudyShare</h1>
    <h2>このアプリは、学んだことをフィードバックできるサイトです</h2>
    <h2>参考書に対するレビューや質問を通じて、学んだことを共有しましょう！</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <h2>コンテンツ</h2>
    <br>
    <h2>新着レビュー</h2>
    <hr><br>

    <v-sheet class="mx-auto">
      <v-slide-group
        center-active
        show-arrows
        style="background-color: #edebe8;"
      >
          <v-slide-item v-for="newReview in newReviews" :key="newReview.id" v-slot="{ toggle }">
            <v-card
              height="330"
              width="450"
              outlined
              class="ma-4"
              @click="toggle"
              raised
              shaped

            >
                  <v-card-title>
                    <nuxt-link :to="`/books/${newReview.book_id}/reviews/${newReview.id}`" style="color: black;">{{ $truncate(newReview.title, 15) }}</nuxt-link>
                  </v-card-title>
                  <v-card-subtitle>
                    <v-row class="d-flex align-center">
                      <v-col cols="6">
                        <v-rating
                          v-model="newReview.rating"
                          :readonly="true"
                          background-color="orange lighten-3"
                          color="orange"
                          dense
                          large
                        >
                        </v-rating>
                      </v-col>
                      <v-col cols="2">
                        ({{ newReview.rating }})
                      </v-col>
                    </v-row>
                  </v-card-subtitle>
                  <v-card-text style="height: 135px;">
                    <v-textarea
                      :value="newReview.content"
                      readonly
                      filled
                      rounded
                      dense
                      no-resize
                    >
                    </v-textarea>
                  </v-card-text>
                  <v-card-actions>
                    <v-row class="d-flex justify-center align-center">
                      <v-col cols="6">
                        <div @click="goToUser(newReview.user)" style="padding: 10px;">
                          <v-avatar>
                            <v-img :src="newReview.user.image"></v-img>
                          </v-avatar>
                          <span style="text-decoration: underline;">{{ $truncate(newReview.user.name, 9) }}</span>
                        </div>
                      </v-col>
                      <v-col cols="6">
                        <nuxt-link :to="`/books/${newReview.book.id}`">

                          <v-icon>mdi-book-open-variant</v-icon>
                          {{ $truncate(newReview.book.name, 9)}}
                        </nuxt-link>
                      </v-col>
                    </v-row>
                  </v-card-actions>
            </v-card>
        </v-slide-item>
      </v-slide-group>
    </v-sheet>


    <br>
    <h3>みんなが使っている参考書</h3>
    <top-page-each-books :books="popularBooks"></top-page-each-books>


  <!-- <v-window v-model="model">
    <v-window-item v-for="(item, i) in items" :key="i">
      <v-row>
        <v-col v-for="(subItem, j) in getSubItems(i)" :key="j" cols="4">
          <v-card>
            <v-card-title>{{ subItem.title }}</v-card-title>
            <v-card-text>{{ subItem.text }}</v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-window-item>
  </v-window>
 -->



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
  mounted() {
    if (this.$route.query.message) {
      this.snackbarColor = "primary"
      this.snackbar = true
      this.flashMessage = this.$route.query.message
      // this.$snackbar.show(this.$route.query.message)
    }
    this.$parent.showSpecialHeader = true

  },
  created() {
    this.$store.commit("header/setShowSpecialHeader", true)
  },
  beforeDestroy() {
    this.$store.commit("header/setShowSpecialHeader", false)
  },
  methods: {
    goToUser(user) {
      if( !this.currentUser || this.currentUser.id !== user.id ) {
        this.$router.push({ path: `/users/${user.id}` })
      } else {
        this.$router.push({ path: "/mypage" })
      }
    },

  },


}

</script>

<style>
.comment-highlight {
  border: 1px solid ; /* 枠線の色と太さの設定 */
  background-color: #FFF3E0; /* 背景色の設定 */
  padding: 10px; /* 余白の設定 */
  margin: 5px 0; /* マージンの設定 */
}
</style>
