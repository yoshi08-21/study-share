<template>
  <div>
    <br>
    <v-row class="justify-center">
      <v-col cols="8">
        <v-card
          style="border-radius: 20px;"
        >

          <div style="text-align: center;">
            プロフィール
          </div>

          <hr>
          <v-card-title>
            <v-row>
              <v-col class="d-flex justify-center">
                <div v-if="user.image">
                  <v-img
                    :src="user.image"
                    alt="画像"
                    contain
                    max-height="150"
                    max-width="150"
                  >
                  </v-img>
                </div>
              </v-col>
            </v-row>
          </v-card-title>

          <v-card-subtitle style="text-align: center; margin-top: 10px;">
            <h1>{{ user.name }}</h1>
          </v-card-subtitle>

          <br><br>
          <v-row class="justify-center">
            <v-col cols="10">
              <v-card
                style="border: solid 0.1px;"
                hover
                light
              >

                <v-card-title style="justify-content: center;">
                  アクティビティ
                </v-card-title>

                <v-card-text>
                  <v-simple-table>
                    <template v-slot:default>
                      <thead>
                        <tr>
                          <th>アクティビティ</th>
                          <th>件数</th>
                          <th>獲得したいいね!</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>投稿したレビュー</td>
                          <td>{{ myReviews.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteReviewsCount }}</td>
                        </tr>
                        <tr>
                          <td>投稿した質問</td>
                          <td>{{ myQuestions.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteQuestionsCount }}</td>
                        </tr>
                        <tr>
                          <td>投稿した質問(科目別)</td>
                          <td>{{ mySubjectQuestions.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteSubjectQuestionsCount }}</td>
                        </tr>
                        <tr>
                          <td>投稿した返信</td>
                          <td>{{ myReplies.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteRepliesCount }}</td>
                        </tr>
                        <tr>
                          <td>投稿した返信(科目別)</td>
                          <td>{{ mySubjectQuestionReplies.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteSubjectQuestionRepliesCount }}</td>
                        </tr>
                        <tr>
                          <td>作成したアンケート</td>
                          <td>{{ mySurveys.length }}件</td>
                          <td><v-icon>mdi-heart-multiple</v-icon> {{ myFavoriteSurveysCount }}</td>
                        </tr>
                      </tbody>
                    </template>
                  </v-simple-table>
                </v-card-text>

              </v-card>
              <br><br>

              <h4>志望校</h4>
              <hr><br>
              <h3>第一志望: {{ user.first_choice_school }}</h3>
              <br>
              <h3>第二志望: {{ user.second_choice_school }}</h3>
              <br>
              <h3>第三志望: {{ user.third_choice_school }}</h3>
              <br><br>

              <h4>自己紹介</h4>
              <hr><br>
              <v-textarea
                :value="user.introduction"
                readonly
                outlined
                rounded
                dense
                auto-grow
              >
              </v-textarea>

              <br>
              <h4>ユーザーメニュー</h4>
              <hr><br>
              <v-row>
                <v-col>
                  <v-btn @click="goToFavorites" x-large style="height: 100px; width: 155px;">
                    <v-icon>mdi-star-outline</v-icon>
                    お気に入り
                  </v-btn>
                  <v-btn @click="goToBrowsingHistories" x-large style="height: 100px; width: 155px;">
                    <v-icon>mdi-history</v-icon>
                    閲覧履歴
                  </v-btn>
                  <v-btn @click="dialog = true" x-large style="height: 100px; width: 155px;">
                    <v-icon>mdi-account-edit-outline</v-icon>
                    ユーザー編集
                  </v-btn>
                  <v-btn @click="logout" x-large style="height: 100px; width: 155px;">
                    <v-icon>mdi-exit-run</v-icon>
                    ログアウト
                  </v-btn>
                </v-col>
              </v-row>
              <br>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>


    <br><br><br>
    <v-tabs v-model="tab" centered>
      <v-tab v-for="(tabItem, index) in tabs" :key="index">
        {{ tabItem.label }}
      </v-tab>
    </v-tabs>

    <div data-cy="tab-content">

      <template v-if="tab === 0">
        <br><br><br>
        <each-reviews :reviews="myReviews"></each-reviews>
      </template>

      <template v-else-if="tab === 1">
        <br><br><br>
        <each-questions :questions="myQuestions"></each-questions>
      </template>

      <template v-else-if="tab === 2">
        <br><br><br>
        <each-subject-questions :subjectQuestions="mySubjectQuestions"></each-subject-questions>
      </template>

      <template v-else-if="tab === 3">
        <br><br><br>
        <each-replies :replies="myReplies"></each-replies>
      </template>

      <template v-else-if="tab === 4">
        <br><br><br>
        <each-subject-question-replies :subjectQuestionReplies="mySubjectQuestionReplies"></each-subject-question-replies>
      </template>

      <template v-else-if="tab === 5">
        <br><br><br>
        <each-surveys :surveys="mySurveys"></each-surveys>
      </template>

    </div>



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
import { getAuth, deleteUser, signOut } from "firebase/auth"
import EditUser from '../components/users/EditUser.vue'
import authCheck from '../middleware/authCheck'
import EachReviews from '../components/reviews/EachReviews.vue'
import EachQuestions from '../components/questions/EachQuestions.vue'
import EachReplies from '../components/replies/EachReplies.vue'
import EachSubjectQuestions from '../components/subjectQuestions/EachSubjectQuestions.vue'
import EachSubjectQuestionReplies from '../components/subjectQuestionReplies/EachSubjectQuestionReplies.vue'
import EachSurveys from '../components/surveys/EachSurveys.vue'
import axios from "@/plugins/axios"



export default {
  components: { EditUser, EachReviews, EachQuestions, EachReplies, EachSubjectQuestions, EachSubjectQuestionReplies, EachSurveys, },
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
      return {
        user: response.data.user,
        myQuestions: response.data.my_questions,
        myReviews: response.data.my_reviews,
        myReplies: response.data.my_replies,
        mySubjectQuestions: response.data.my_subject_questions,
        mySubjectQuestionReplies: response.data.my_subject_question_replies,
        mySurveys: response.data.my_surveys,
        myFavoriteReviewsCount: response.data.my_favorite_reviews_count,
        myFavoriteQuestionsCount: response.data.my_favorite_questions_count,
        myFavoriteRepliesCount: response.data.my_favorite_replies_count,
        myFavoriteSubjectQuestionsCount: response.data.my_favorite_subject_questions_count,
        myFavoriteSubjectQuestionRepliesCount: response.data.my_favorite_subject_question_replies_count,
        myFavoriteSurveysCount: response.data.my_favorite_surveys_count,
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
      updatedUser: {},
      tab: 0,
      tabs: [
        { label: "投稿したレビュー" },
        { label: "投稿した質問" },
        { label: "投稿した科目別質問" },
        { label: "投稿した返信" },
        { label: "投稿した返信（科目別質問）" },
        { label: "作成したアンケート" },

      ]


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
      formData.append("user[second_choice_school]", data.secondChoiceSchool);
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
        this.updatedUser = response.data.user
        this.$store.dispatch("auth/setCurrentUser", this.updatedUser)
        console.log(response)
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
    },
    goToFavorites() {
      if(this.currentUser) {
        this.$router.push({ path: "/favorites" })
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" }})
      }
    },
    goToBrowsingHistories() {
      if(this.currentUser) {
        this.$router.push({ path: "/browsingHistories/allBrowsingHistories" })
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" }})
      }
    },
    async logout() {
      try {
        const auth = getAuth(this.$firebase)
        await signOut(auth)
        this.$store.dispatch("auth/setLoginState", false)
        this.$store.dispatch("auth/setUserUid", "")
        this.$store.dispatch("auth/setEmail", "")
        this.userMemo = ""
        this.$router.push({ path: "/", query: { message: "ログアウトしました" } })
      } catch(error) {
        console.log(error)
      }
    },


  }
}
</script>

<style>

</style>
