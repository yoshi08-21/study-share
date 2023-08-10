<template>
  <div>
    ユーザー登録
    <v-col>

      <v-text-field v-model="name" label="ユーザー名"></v-text-field>
      <v-text-field v-model="email" label="メールアドレス"></v-text-field>
      <v-text-field v-model="password" label="パスワード"></v-text-field>
      <v-text-field v-model="password" label="パスワード確認"></v-text-field>
      <v-btn @click="signUp">登録</v-btn>
    </v-col>
  </div>
</template>

<script>

import { getAuth, createUserWithEmailAndPassword } from "firebase/auth"
import axios from "../../plugins/axios";
import isLoggedIn from "../../middleware/isLoggedIn"


export default {
  middleware: isLoggedIn,
  data() {
    return {
      name: "",
      email: "",
      password: "",
      uid: ""
    }
  },
  methods: {
    async signUp() {
      // 登録後はトップページに遷移
      try {
        const auth = getAuth(this.$firebase);
        const response = await createUserWithEmailAndPassword(auth, this.email, this.password)
        console.log(response)
        // response.user.uid
        console.log(response.user.uid)
        this.userSetup(response.user.uid)
      } catch(error) {
        console.log(error)
      }
      this.$router.push({ path: "/", query: { message: "会員登録が完了しました" } })
    },
    async userSetup(userUid) {
      try {
        const response = await axios.post("/users", {
          name: this.name,
          email: this.email,
          uid: userUid
        })
        this.$store.dispatch("auth/setCurrentUser", response.data)
        this.$store.dispatch("auth/setLoginState", true)
        console.log(response.data)
      } catch(error) {
        console.log(error)
      }
    }

  }
}
</script>

<style>

</style>
