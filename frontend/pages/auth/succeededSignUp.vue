<template>
  <div>
    <h2 style="text-align: center;">ユーザー登録が完了しました！</h2>
    <br>


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import flashMessage from '../../mixins/flashMessage'
import axios from "../../plugins/axios";



export default {
  mixins: [flashMessage],
  async asyncData({ route, store}) {
    try {
      const response = await axios.get("/users/find_user_by_email", {
        params: {
          email: route.query.email
        }
      })
      store.dispatch("auth/setCurrentUser", response.data)
      store.dispatch("auth/setLoginState", true)
    } catch(error) {
      console.error("エラーが発生しました", error)
    }
  },
  data() {
    return {
      name: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      uid: "",
    }
  },
}
</script>

<style>

</style>
