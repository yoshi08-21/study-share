<template>
  <v-app>
    <v-navigation-drawer
      v-model="drawer"
      fixed
      temporary
    >
      <v-list rounded>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
          color="primary"
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>



    <normal-header
      :currentUser="currentUser"
      @toggleDrawer="drawer = !drawer"
      @searchBooks="searchBooks"
      @goToMypage="goToMypage"
      @goToFavorites="goToFavorites"
      @goToBrowsingHistories="goToBrowsingHistories"
      @goToNotifications="goToNotifications"
      @logout="logout"
    >
    </normal-header>


    <v-main>
      <v-container>
        <Nuxt />
        <v-btn v-if="currentUser" @click="showUserMemo = true" fab fixed large color="cyan" class="fab-button">
          <v-icon dark>
            mdi-book-edit
          </v-icon>
        </v-btn>
        <v-overlay
          :value="showUserMemo"
          :z-index="zIndex"
          opacity="0"
        >
          <v-dialog
            v-model="showUserMemo"
            hide-overlay
            max-width="800px"
            transition="dialog-bottom-transition"
          >
            <v-card
            >
              <v-card-title>
                ユーザーメモ
              </v-card-title>
              <v-card-text>
                気になったことや覚えておきたいことなどをメモして保存できます（最大１万文字）
                <v-textarea
                  v-model="userMemo"
                  auto-grow
                  filled
                  shaped
                  rows="10"
                  label="ユーザーメモ"
                  counter
                  ></v-textarea>
                  <p>＊メモの内容を残したい場合は必ず「保存する」を押してください</p>
                <v-btn @click="saveUserMemo" color="primary">保存する</v-btn>
                <v-btn @click="showUserMemo = false">閉じる</v-btn>
              </v-card-text>
            </v-card>
          </v-dialog>
        </v-overlay>
        <br>
        <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
      </v-container>
    </v-main>

    <v-footer :absolute="!fixed" app>
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>

  </v-app>
</template>

<script>

import { getAuth, signOut } from "firebase/auth"
import checkNotifications from "../middleware/checkNotifications"
import redirectNotFound from "../middleware/redirectNotFound"
import checkResourceExistence from "../middleware/checkResourceExistence"
import NormalHeader from '../components/global/NormalHeader.vue'
import axios from "@/plugins/axios"


export default {
  components: { NormalHeader },
  name: 'DefaultLayout',
  middleware: [checkNotifications, redirectNotFound, checkResourceExistence],
  // ログアウト→ログイン時にユーザーメモが更新されるようにする
  watch: {
    "currentUser"(newValue, oldValue) {
      if(newValue !== oldValue) {
        if(this.currentUser) {
          this.userMemo = this.currentUser.memo
        } else {
          this.userMemo = ""
        }
      }
    }
  },
  data() {
    return {
      drawer: false,
      fixed: false,
      items: [
        {
          icon: 'mdi-home',
          title: 'トップページ',
          to: '/',
        },
        {
          icon: 'mdi-account',
          title: 'マイページ',
          to: '/mypage',
        },
        {
          icon: "mdi-bookshelf",
          title: '参考書一覧',
          to: '/books/allBooks'
        },
        {
          icon: "mdi-comment-question",
          title: '質問一覧',
          to: '/questions/questions'
        },
        {
          icon: "mdi-comment-question-outline",
          title: '科目別質問一覧',
          to: '/subjectQuestions/subjectQuestions'
        },
        {
          icon: "mdi-account-search",
          title: 'アンケート',
          to: '/surveys/allSurveys'
        },
      ],
      title: {
        title: "StudyFeedback",
        to: "/"
      },
      user: {},
      searchBooksKeyword: "",
      showUserMemo: false,
      overlay: false,
      zIndex: 0,
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
      userMemo: ""
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.getters["auth/getLoggedIn"]
    },
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
    unreadNotifications() {
      return this.$store.state.notifications.unreadNotifications
    },
  },
  created() {
    if(this.currentUser) {
      this.userMemo = this.currentUser.memo
    }
  },
  methods: {
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
    searchBooks(data) {
      this.$router.push({ path: "/books/localSearchBooksResult", query: { searchBooksKeyword: data.searchBooksKeyword } })
      this.searchBooksKeyword = ""
    },
    goToMypage() {
      if(this.currentUser) {
        this.$router.push({ path: "/mypage" })
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" }})
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
    goToNotifications() {
      if(this.currentUser) {
        this.$router.push({ path: "/notifications/allNotifications" })
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" }})
      }
    },
    async saveUserMemo() {
      try {
        const response = await axios.patch("/users/save_user_memo", {
          current_user_id: this.currentUser.id,
          memo: this.userMemo
        })
        console.log(response.data)
        this.snackbar = true
        this.flashMessage = "メモを保存しました"
      } catch(error) {
        console.log(error)
        throw error
      }
    }
  }
}
</script>

<style>
.v-main {
  background-color: #edebe8;
}

.fab-button {
  position: fixed;
  right: 20px;
  bottom: 20px;
}

.set-right-bottom {
  position: fixed;
  right: 20;
  bottom: 20;
}
</style>
