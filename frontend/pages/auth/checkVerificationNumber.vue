<template>
  <div>
    <h2 style="text-align: center;">コード認証</h2>
    <br>

    <p>メールに記載されていた８桁の数字を入力してください</p>
    <v-container>
    <v-row>
      <v-col cols="9">
        <div class="ma-auto" style="max-width: 600px">
          <v-otp-input
            v-model="otp"
            :length="length"
          ></v-otp-input>
        </div>
      </v-col>

      <v-col cols="2" class="my-3">
        <v-btn block :disabled="!isActive">送信</v-btn>
      </v-col>
    </v-row>
  </v-container>
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
      otp: "",
      length: 8
    }
  },
  computed: {
    isActive () {
      return this.otp.length === this.length
    },
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
