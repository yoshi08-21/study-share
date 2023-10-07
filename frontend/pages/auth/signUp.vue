<template>
  <div>
    <h2 style="text-align: center;">ユーザー登録</h2>
    <br>

    <p>メールアドレスの認証を行います。メールを受信できるアドレスを入力して、当サイトからのメールを受信してください。</p>
    <p>*メールは（ドメイン）から送信されます。メールの受信拒否を設定している場合は、（ドメイン）からのメールを受信できるように設定を行ってください。</p>
    <v-text-field v-model="email" :rules="emailRules" label="メールアドレス"></v-text-field>
    <v-btn @click="deliverEmail" block>メールを送信</v-btn>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import isLoggedIn from "../../middleware/isLoggedIn"
import flashMessage from '../../mixins/flashMessage'
import axios from "../../plugins/axios";

export default {
  middleware: isLoggedIn,
  mixins: [flashMessage],
  data() {
    return {
      email: "",
      emailRules: [
        value => !!value || "メールアドレスを入力してください",
        value => (value || '').length <= 250 || "最大入力文字数は250文字です",
        value => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value) || "正しい形式のメールアドレスを入力してください"
      ],
    }
  },
  methods: {
    async deliverEmail() {
      try {
        const response = await axios.post("/users/user_email_confirmation", {

          user: {
            name: "sample",
            email: this.email,
          }

        })
        console.log(response.data)
        this.$router.push({ path: "/auth/inputUserInformation" })
      } catch(error) {
        console.error("エラーが発生しました", error)
      }
    }
  }
}
</script>

<style>

</style>
