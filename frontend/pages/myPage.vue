<template>
  <div>
    <h3>マイページ</h3>
    ID: {{ user.id }}
    <br>
    name: {{ user.name }}
    <br>
    自己紹介: {{ user.introduction }}
    <br>
    第一志望: {{ user.first_choice_school }}
    <br>
    第二志望: {{ user.second_choice_school }}
    <br>
    第三志望: {{ user.third_choice_school }}
    <br>
    <tepmplate v-if="user.image">
      <v-img
        :src="user.image"
        max-height="200"
        max-width="200"
        contain
      ></v-img>
    </tepmplate>


    <br><br>
    <v-btn @click="dialog = true">ユーザー情報を編集</v-btn>


    <!-- ユーザー情報の編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title style="justify-content: center;">
          <h2>ユーザー情報を編集する</h2>
        </v-card-title>
        <v-card-text>
          <edit-user
            :name="user.name"
            :introduction="user.introduction"
            :first_choice_school="user.first_choice_school"
            :second_choice_school="user.second_choice_school"
            :third_choice_school="user.third_choice_school"
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
  async asyncData({ store }) {
    try {
      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const response = await axios.get(`/users/${currentUserId}`)
      console.log(response.data)
      const user = response.data
      return {
        user,
      }
    } catch (error) {
      console.log(error)
      throw error
    }
  },
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
      const formData = new FormData()

      formData.append("user[name]", data.name);
      formData.append("user[introduction]", data.introduction);
      formData.append("user[first_choice_school]", data.firstChoiceSchool);
      formData.append("user[secont_choice_school]", data.secondChoiceSchool);
      formData.append("user[third_choice_school]", data.thirdChoiceSchool);
      if (data.image) {
          formData.append('user[image]', data.image);
      }

      try {
        const response = await axios.patch(`/users/${this.currentUser.id}`, formData)
        console.log(response.data)
        // もう一度getリクエストを送って、storeのcurrentUserにセットし直す
        this.updateUser()
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "ユーザーの編集が完了しました"
        this.user.name = response.data.user.name
        this.user.introduction = response.data.user.introduction
        this.user.first_choice_school = response.data.user.first_choice_school
        this.user.second_choice_school = response.data.user.second_choice_school
        this.user.third_choice_school = response.data.user.third_choice_school
        if (response.data.image_url) {
          this.user.image = response.data.image_url
        }
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
        const response = await axios.get(`/users/${this.user.id}`)
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
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = error.response.data.error
        this.dialog = false
      }
    }
  }
}
</script>

<style>

</style>
