<template>
  <div>
    <br><br>
    <template v-if="!currentUser">
      <div>
        <h1 style="text-align: center;">Welcome To StudyShare!</h1>
        <br>
        <h2><v-icon color="green">mdi-information-box-outline</v-icon> StudyShareは学習に関するあらゆる情報を共有できるサイトです</h2>
        <br><br>
        <h3><v-icon color="green">mdi-information-box-outline</v-icon> 参考書へのレビューを投稿することができます</h3>
        <h4>・自分が使ったことのある参考書へのレビューを投稿したり、他ユーザーのレビューを見たりして、自分に合った最高の参考書を見つけましょう!</h4>
        <br><br>
        <h3><v-icon color="green">mdi-information-box-outline</v-icon> 参考書への質問や科目別の質問、アンケートを投稿することができます</h3>
        <h4>・参考書に対して気になることや、勉強をする中でわからないことがあればどんどん質問しましょう!</h4>
        <h4>・参考書選びや大学選びなどで迷うことがあれば、アンケートを作成して他ユーザーに意見を求めましょう!</h4>
        <br><br>
        <h3><v-icon color="green">mdi-information-box-outline</v-icon> 投稿されている質問で回答できるものがあれば、ぜひ回答してください</h3>
        <h4>・質問に返信することは質問者を助けるだけでなく、アウトプットを通じてあなたの知識の整理にも必ず役立ちます!</h4>
        <br><br>
        <h1 style="text-align: center;"><v-icon color="red">mdi-fire</v-icon> StudyShareで賢く勉強を進め、志望する大学に合格しましょう! <v-icon color="red">mdi-fire</v-icon></h1>
      </div>
    </template>
    <template v-else>
      <h1 style="text-align: center;">Welcome To StudyShare!</h1>
      <br><br><br><br><br><br><br><br><br><br><br><br><br><br>
    </template>

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
                  <h2>

                    ({{ newReview.rating }})
                  </h2>
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
    <h2>みんなが使っている参考書</h2>
    <hr><br>
    <top-page-each-books :books="popularBooks"></top-page-each-books>

    <br>
    <tepmlate v-if="currentUser">
      <template v-if="currentUser.first_choice_school">
        <br>
        <h2>{{ currentUser.first_choice_school }}を志望している人が使っている参考書</h2>
        <hr><br>
        <top-page-each-books :books="firstChoiceSchoolBooks"></top-page-each-books>
      </template>

      <template v-if="currentUser.second_choice_school">
        <br>
        <h2>{{ currentUser.second_choice_school }}を志望している人が使っている参考書</h2>
        <hr><br>
        <top-page-each-books :books="secondChoiceSchoolBooks"></top-page-each-books>
      </template>

      <template v-if="currentUser.third_choice_school">
        <br>
        <h2>{{ currentUser.third_choice_school }}を志望している人が使っている参考書</h2>
        <hr><br>
        <top-page-each-books :books="thirdChoiceSchoolBooks"></top-page-each-books>
      </template>

      <template v-if="currentUser.first_choice_school === null || currentUser.first_choice_school === '' && currentUser.second_choice_school === null || currentUser.second_choice_school === '' && currentUser.third_choice_school === null || currentUser.third_choice_school === ''">
        <h2>あなたと同じ大学を志望している人が使っている参考書</h2>
        <p>志望大学を登録すると使用できます</p>
      </template>

    </tepmlate>
    <template v-else>
      <h2>あなたと同じ大学を志望している人が使っている参考書</h2>
      <hr><br>
        <v-row>
          <v-col class="d-flex justify-center">
            <v-alert
              type="info"
            >
            ログイン後に使用できます
            </v-alert>
          </v-col>
        </v-row>
    </template>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>


  </div>
</template>

<script>

import { getAuth, signOut } from "firebase/auth"
import TopPageEachBooks from '../components/books/TopPageEachBooks.vue'
import userComputed from '../mixins/userComputed'
import flashMessage from '../mixins/flashMessage'
import navigationMethods from '../mixins/navigationMethods'

import axios from "@/plugins/axios"


export default {
  components: { TopPageEachBooks },
  mixins: [userComputed, flashMessage, navigationMethods],
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
      return{
        newReviews,
        popularBooks,
        firstChoiceSchoolBooks: sameUniversityBooks.first_choice_school_books,
        secondChoiceSchoolBooks: sameUniversityBooks.second_choice_school_books,
        thirdChoiceSchoolBooks: sameUniversityBooks.third_choice_school_books
      }
    } catch(error) {
      console.error("エラーが発生しました", error)
      console.log(t.t0)
    }
  },
  data() {
    return {
      user: "",
      error: "",
      newReviews: [],
      length: 3,
      window: 0,
      cypressUser: {},
    }
  },
  mounted() {
    this.$parent.showSpecialHeader = true
  },
  created() {
    this.$store.commit("header/setShowSpecialHeader", true)
  },
  beforeDestroy() {
    this.$store.commit("header/setShowSpecialHeader", false)
  },
  async logout() {
      try {
        const auth = getAuth(this.$firebase)
        await signOut(auth)
        this.$store.dispatch("auth/setLoginState", false)
        this.$store.dispatch("auth/setUserUid", "")
        this.$store.dispatch("auth/setEmail", "")
        this.userMemo = ""
        this.$router.push({ path: "/", query: { message: "ログアウトしました" } })
      } catch(error) {
        console.error("エラーが発生しました:", error)
      }
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
