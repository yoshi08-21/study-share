<template>
  <div>
    <h2 style="text-align: center;">ログイン</h2>
    <v-col>
      <v-form>
        <v-text-field v-model="email" :rules="emailRules" label="メールアドレス" data-cy="email-field"></v-text-field>
        <v-text-field
        v-model="password"
        :rules="passwordRules"
        label="パスワード"
        :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
        :type="showPassword ? 'text' : 'password'"
        @click:append="showPassword = !showPassword"
        data-cy="password-field"
        ></v-text-field>
        <v-btn @click="login" data-cy="login-button">ログイン</v-btn>
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
  watch: {
    "$route.query.message"(newValue, oldValue) {
      if(newValue !== oldValue) {
        this.flashMessage = newValue
        this.snackbar = true
        this.snackbarColor = "red accent-2"
      }
    }
  },
  data() {
    return {
      email: "",
      password: "",
      user: {},
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
      emailRules: [
        value => !!value || "メールアドレスを入力してください",
        value => (value || '').length <= 250 || "最大入力文字数は250文字です",
        value => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value) || "正しい形式のメールアドレスを入力してください"
      ],
      passwordRules: [
        value => !!value || "パスワードを入力してください",
        value => (value || '').length <= 30 || "最大入力文字数は30文字です",
      ],
      showPassword: false,

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
        console.log(userCredential)
      } catch(error) {
        console.log(error)
        let message = ""
        if(error.code === "auth/invalid-email") {
          message = "正しいメールアドレスを入力してください"
        } else if(error.code === "auth/user-not-found") {
          message = "メールアドレスが登録されていません"
        } else if(error.code === "auth/missing-password") {
          message = "パスワードを入力してください"
        } else if(error.code === "auth/wrong-password") {
          message = "パスワードが間違っています"
        } else {
          message = "ログインエラーが発生しました"
        }
        console.log(message)
        this.$router.push({query: { message } })
        return
      }

      try {
        const uid = this.$store.getters["auth/getUserUid"]
        const response = await axios.get(`/users/find_user_by_uid/${uid}`)
        this.user = response.data
        this.$store.dispatch("auth/setCurrentUser", this.user)
        console.log(response)
      } catch(error) {
        console.log(error)
      }

      this.$router.push({ path: "/mypage" , query: { message: "ログインしました"} })
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
