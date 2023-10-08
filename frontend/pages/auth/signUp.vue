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
import isLoggedIn from "../../middleware/isLoggedIn"
import flashMessage from '../../mixins/flashMessage'
import axios from "../../plugins/axios";



export default {
  middleware: isLoggedIn,
  mixins: [flashMessage],
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
    }
  },
  methods: {
    async signUp() {
      try {
        const emailExistence = await axios.get("/users/check_email_existence", {
          params: {
            email: this.email
          }
        })
        // メールアドレスが登録されていて、アカウントの有効化が行われている場合
        if(emailExistence.data.existence === true && emailExistence.data.status === "activated") {
          this.flashMessage = "このメールアドレスはすでに登録されています。パスワードをお忘れの場合はパスワードの再設定を行ってください"
          this.snackbarColor = "info"
          this.snackbar = true
          return
        }
        // メールアドレスが登録されていて、アカウントの有効化が行われていない場合
        else if(emailExistence.data.existence === true && emailExistence.data.status === "unactivated") {
          this.flashMessage = "このメールアドレスはすでに登録されています。メールアドレス確認用のメールを再送信しましたので、メールに記載されているリンクをクリックしてユーザー登録を完了させてください。"
          this.snackbarColor = "info"
          this.snackbar = true
          return
        }

        const auth = getAuth(this.$firebase);
        const response = await createUserWithEmailAndPassword(auth, this.email, this.password)
        this.userSetup(response.user.uid)
        this.$router.push({ path: "/", query: { message: "メールアドレス確認のためのメールを送信しました。メールに記載されているリンクをクリックしてユーザー登録を完了させてください。" } })
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbar = true
        this.snackbarColor = "red accent-2"
        this.flashMessage = "エラーが発生しました。入力フォームを確認してください"
      }
    },
    async userSetup(userUid) {
      try {
        await axios.post("/users", {
          name: this.name,
          email: this.email,
          uid: userUid
        })
      } catch(error) {
        console.error("エラーが発生しました:", error)
      }
    }

  }
}
</script>

<style>

</style>
