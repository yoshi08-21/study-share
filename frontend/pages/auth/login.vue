<template>
  <div>
    ログイン
    <v-col>
      <v-form>
        <v-text-field v-model="email" label="メールアドレス"></v-text-field>
        <v-text-field v-model="password" label="パスワード"></v-text-field>
        <v-btn @click="login">ログイン</v-btn>
      </v-form>
      <v-spacer :style="{ height: '20px' }"></v-spacer>
      <v-btn @click="loginAsUser1">ゲストユーザーでログイン</v-btn>
      <v-spacer :style="{ height: '20px' }"></v-spacer>
      <v-btn @click="loginAsUser2">ゲストユーザー2でログイン</v-btn>
      <v-spacer :style="{ height: '20px' }"></v-spacer>
      <v-btn block @click="$router.push('/auth/signup')">新規登録はこちらから</v-btn>
    </v-col>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import { getAuth, signInWithEmailAndPassword } from "firebase/auth"
import axios from "../../plugins/axios";
import isLoggedIn from "../../middleware/isLoggedIn"

export default {
  middleware: isLoggedIn,
  data() {
    return {
      email: "",
      password: "",
      user: {},
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
    }
  },
  methods: {
    async login() {
      try {
        const auth = getAuth(this.$firebase)
        const userCredential = await signInWithEmailAndPassword(auth, this.email, this.password)
        this.$store.dispatch("auth/setLoginState", true)
        this.$store.dispatch("auth/setUserUid", userCredential.user.uid)
        this.$store.dispatch("auth/setEmail", userCredential.user.email)
        // currentUser.nameで情報が取り出せない → firebaseからのresponseが入っているため
        console.log(userCredential)
      } catch(error) {
        console.log(error)
      }

      try {
        const uid = this.$store.getters["auth/getUserUid"]
        const response = await axios.get(`/users/${uid}`)
        this.user = response.data
        this.$store.dispatch("auth/setCurrentUser", this.user)
        console.log(response)
      } catch(error) {
        console.log(error)
      }

      this.$router.push("/")
    },
    async loginAsUser1() {
      this.email = "sample@sample.com"
      this.password = "123456"
      await this.login()
    },
    async loginAsUser2() {
      this.email = "sample2@sample.com"
      this.password = "234567"
      await this.login()
    }


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

<style>

</style>
