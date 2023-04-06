<template>
  <div>
    ログイン
    <v-col>

      <v-text-field v-model="email" label="メールアドレス"></v-text-field>
      <v-text-field v-model="password" label="パスワード"></v-text-field>
      <v-btn @click="login">ログイン</v-btn>
    </v-col>
  </div>
</template>

<script>

import { getAuth, signInWithEmailAndPassword } from "firebase/auth"
import axios from "../../plugins/axios";

export default {
  data() {
    return {
      email: "",
      password: "",
      user: {}
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
    }

  }
}
</script>

<style>

</style>
