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
        <v-slide-group v-for="newReview in newReviews" :key="newReview.id">
          <v-card style="margin: 0 20px 0 20; width: 320px; height: 240px;">
            <v-card-title>{{ newReview.title }}</v-card-title>
            <v-card-text class="text--primary">{{ newReview.content }}</v-card-text>
          </v-card>
        </v-slide-group>v-slide-item>
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

}

</script>
