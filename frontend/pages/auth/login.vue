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
import isLoggedIn from "../../middleware/isLoggedIn"
import flashMessage from "../../mixins/flashMessage";

import axios from "../../plugins/axios";

export default {
  middleware: isLoggedIn,
  mixins: [flashMessage],
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
      } catch(error) {
        console.error("エラーが発生しました:", error)
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
      } catch(error) {
        console.error("エラーが発生しました:", error)
      }

      this.$router.push({ path: "/mypage" , query: { message: "ログインしました"} })
    },
    async loginAsUser1() {
      if(process.env.NODE_ENV === "development") {
        this.email = "sample@sample.com"
        this.password = "123456"
        await this.login()
      } else if(process.env.NODE_ENV === "production") {
        this.email = "kanagawa369@sample.com"
        this.password = "kanakana"
        await this.login()
      }
    },
    async loginAsUser2() {
      if(process.env.NODE_ENV === "development") {
        this.email = "sample2@sample.com"
        this.password = "234567"
        await this.login()
      } else if(process.env.NODE_ENV === "production") {
        this.email = "kanagawa123@sample.com"
        this.password = "kanakana2"
        await this.login()
      }
    }
  },
}
</script>

<style>

</style>
