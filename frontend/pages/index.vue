<template>
  <div>
    <p>hello</p>
    <p v-if="currentUser">
      currentUser: {{ currentUser.name }}
    </p>
    <p>
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
    <h1>サンプル</h1>
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
      const response = await axios.get("/reviews")
      this.newReviews = response.data
    },

}

</script>
