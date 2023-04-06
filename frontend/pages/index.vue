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
  </div>
</template>

<script>

import axios from "../plugins/axios"


export default {
  name: 'IndexPage',
  data() {
    return {
      user: "",
      error: ""
    }
  },
  computed: {
    // ...mapGetters(["auth/getLoggedIn"]),
    isLoggedIn() {
      return this.$store.getters["auth/getLoggedIn"]
    },
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    }
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
  // async created () {
  //     const response = await axios.get("http://localhost:3001/v1/todos")
  //     this.todos = response.data
  //   },
  // 関連する参考書を取得するのに使える

}

</script>
