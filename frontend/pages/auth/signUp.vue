<template>
  <div>
    ユーザー登録
    <v-col>

      <v-text-field v-model="name" label="ユーザー名"></v-text-field>
      <v-text-field v-model="email" label="メールアドレス"></v-text-field>
      <v-text-field v-model="password" label="パスワード"></v-text-field>
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
      // 新規登録時にデータベースにuidを登録することまでは完了した
      // 登録したユーザーでログインすることも成功した
      // 登録後に自動的にログインする昨日はまだ実装できていない
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
      this.$router.push('/mypage')
    },
    async userSetup(userUid) {
      try {
        const response = await axios.post("/users", {
          name: this.name,
          email: this.email,
          uid: userUid
        })
        this.$store.dispatch("auth/setCurrentUser", response.data)
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
