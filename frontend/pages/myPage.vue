<template>
  <div v-if="currentUser">
    <h3>マイページ</h3>
    ID: {{ currentUser.id }}
    <br>
    name: {{ currentUser.name }}
    <br>
    自己紹介: {{ currentUser.introduction }}
    <br>
    第一志望: {{ currentUser.first_choice_school }}
    <br>
    第二志望: {{ currentUser.second_choice_school }}
    <br>
    第三志望: {{ currentUser.third_choice_school }}

    <br><br>
    <v-btn @click="dialog = true">ユーザー情報を編集</v-btn>


    <!-- ユーザー情報の編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          ユーザー情報を編集する
        </v-card-title>
        <v-card-text>
          <edit-user
            :name="currentUser.name"
            :introduction="currentUser.introduction"
            :first_choice_school="currentUser.first_choice_school"
            :second_choice_school="currentUser.second_choice_school"
            :third_choice_school="currentUser.third_choice_school"
            @editUser="editUser"
            @deleteUser="deleteLocalUser"
            @closeDialog="dialog = false"
          ></edit-user>
        </v-card-text>
      </v-card>
    </v-dialog>


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>
import { getAuth, deleteUser } from "firebase/auth"
import EditUser from '../components/users/EditUser.vue'
import authCheck from '../middleware/authCheck'
import axios from "@/plugins/axios"



export default {
  components: { EditUser },
  middleware: authCheck,
  data() {
    return {
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
      dialog: false,
      updatedUser: {}

    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
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
  methods: {
    async editUser(data) {
      try {
        const response = await axios.patch(`/users/${this.currentUser.id}`, {
          name: data.name,
          introduction: data.introduction,
          first_choice_school: data.firstChoiceSchool,
          second_choice_school: data.secondChoiceSchool,
          third_choice_school: data.thirdChoiceSchool,
        })
        console.log(response.data)
        // もう一度getリクエストを送って、storeのcurrentUserにセットし直す
        this.updateUser()
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "ユーザーの編集が完了しました"
        this.dialog = false
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "ユーザーを編集できませんでした"
        this.dialog = false
      }
    },
    async updateUser() {
      try {
        const response = await axios.get(`/users/${this.currentUser.uid}`)
        this.updatedUser = response.data
        this.$store.dispatch("auth/setCurrentUser", this.updatedUser)
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "ユーザーを編集できませんでした"
      }
    },
    async deleteLocalUser() {
      try {
        const response = await axios.delete(`/users/${this.currentUser.id}`)
        console.log(response.data)
        this.$store.dispatch("auth/setCurrentUser", null)
        this.$store.dispatch("auth/setLoginState", false)
        const auth = getAuth(this.$firebase)
        const user = auth.currentUser;
        deleteUser(user).then(() => {
          console.log("ユーザーを削除しました")
        }).catch((error) => {
          console.log(error)
        });
        this.$router.push({ path: "/", query: { message: "ユーザーを削除しました。またのご利用をお待ちしています。" } })
      } catch(error) {
        console.log(error)
        console.log(error.response.data.error)
      }
    }
  }
}
</script>

<style>

</style>
