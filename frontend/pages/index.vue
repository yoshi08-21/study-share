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
    <h1>サンプル</h1>
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
  data() {
    return {
      user: "",
      error: "",
      newReviews: [],
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
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
  async created () {
      const response = await axios.get("/reviews/new_reviews")
      // コントローラーを改良する必要あり
      this.newReviews = response.data
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
