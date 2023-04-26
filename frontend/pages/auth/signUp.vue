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

export default {
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
      try {
        const auth = getAuth(this.$firebase);
        const response = await createUserWithEmailAndPassword(auth, this.email, this.password)
        console.log(response)
        this.uid = response.user.uid

      } catch(error) {
        console.log(error)
      }

      setTimeout(() => {
        console.log("wait")
      }, 1000);

      try {
        const user = {
          name: this.name,
          email: this.email,
          uid: this.uid
        }
        const response = await axios.post("/users", {
          user
        })
        console.log(response.data)
      } catch(error) {
        console.log(error)
      }
      this.$router.push('/mypage')
    }

  }
}
</script>

<style>

</style>
