<template>
  <div>
    <h2 style="text-align: center;">ユーザー登録</h2>
    <br>

    <v-text-field v-model="name" :rules="nameRules" label="ユーザー名"></v-text-field>
    <v-text-field v-model="email" :rules="emailRules" label="メールアドレス"></v-text-field>
    <v-text-field
      v-model="password"
      :rules="passwordRules"
      label="パスワード"
      :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
      :type="showPassword ? 'text' : 'password'"
      @click:append="showPassword = !showPassword"
    ></v-text-field>
    <v-text-field
    v-model="passwordConfirmation"
    :rules="passwordConfirmationRules"
    label="パスワード確認"
    :append-icon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
    :type="showPasswordConfirmation ? 'text' : 'password'"
    @click:append="showPasswordConfirmation = !showPasswordConfirmation"
    ></v-text-field>
    <br>
    <v-btn @click="signUp" block>登録</v-btn>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

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
      passwordConfirmation: "",
      uid: "",
      nameRules: [
        value => !!value || "ユーザー名を入力してください",
        value => (value || '').length <= 30 || "最大入力文字数は30文字です",
      ],
      emailRules: [
        value => !!value || "メールアドレスを入力してください",
        value => (value || '').length <= 250 || "最大入力文字数は250文字です",
        value => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value) || "正しい形式のメールアドレスを入力してください"
      ],
      passwordRules: [
        value => !!value || "パスワードを入力してください",
        value => (value || '').length >= 6 || "パスワードは6文字以上で設定してください",
        value => (value || '').length <= 30 || "最大入力文字数は30文字です",
      ],
      passwordConfirmationRules: [
        value => !!value || "パスワード確認を入力してください",
        value => value === this.password || "パスワードが一致していません",
        value => (value || '').length <= 30 || "最大入力文字数は30文字です",

      ],
      showPassword: false,
      showPasswordConfirmation: false,
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",


    }
  },
  methods: {
    async signUp() {
      try {
        const auth = getAuth(this.$firebase);
        const response = await createUserWithEmailAndPassword(auth, this.email, this.password)
        console.log(response)
        console.log(response.user.uid)
        this.userSetup(response.user.uid)
        this.$router.push({ path: "/", query: { message: "会員登録が完了しました。" } })
      } catch(error) {
        console.log(error)
        this.snackbar = true
        this.snackbarColor = "red accent-2"
        this.flashMessage = "入力フォームを確認してください"
      }
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
