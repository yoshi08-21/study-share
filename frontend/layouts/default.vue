<template>
  <v-app>
    <v-navigation-drawer
      v-model="drawer"
      :mini-variant="miniVariant"
      :clipped="clipped"
      fixed
      app
    >
      <v-list>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
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
    <v-app-bar :clipped-left="clipped" fixed app>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-toolbar-title>
        <nuxt-link to="/">{{ title.title }}</nuxt-link>
      </v-toolbar-title>
      <v-text-field
        v-model="searchBooksKeyword"
        label="参考書を検索"
        placeholder="キーワードを入力 例: (英語 文法)"
        filled
        style="margin-left: 10px;"
      ></v-text-field>
      <v-btn @click="searchBooks">検索</v-btn>
      <v-spacer />
      <template v-if="!isLoggedIn">
        <v-btn to="/auth/login">ログイン</v-btn>
      </template>
      <template v-else>
        <div>
          <v-btn @click="goToFavorites">お気に入り</v-btn>
        </div>
        <v-btn @click="goToNotifications">
          通知一覧
          <span v-if="unreadNotifications">
            <v-badge color="red" overlap>
              <template v-slot:badge>
                <v-icon>mdi-circle</v-icon>
              </template>
            </v-badge>
          </span>
        </v-btn>
      </template>
      <v-btn icon @click.stop="rightDrawer = !rightDrawer">
        <v-icon>mdi-menu</v-icon>
      </v-btn>
    </v-app-bar>
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
            persistent
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
    <v-navigation-drawer v-model="rightDrawer" :right="right" temporary fixed>
      <v-list>
        <v-list-item @click.native="right = !right">
          <v-list-item-action>
            <v-icon light> mdi-repeat </v-icon>
          </v-list-item-action>
          <v-list-item-title>Switch drawer (click me)</v-list-item-title>
        </v-list-item>
        <v-list-item v-if="this.currentUser">
          「{{ this.currentUser.name }}」でログイン中
        </v-list-item>
        <v-list-item v-if="this.currentUser">
          <v-btn @click="logout">ログアウト（デバッグ用）</v-btn>
        </v-list-item>
        <v-list-item @click="goToBrowsingHistories">
          閲覧履歴
        </v-list-item>
        <v-list-item @click="goToNotifications">
          通知一覧
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-footer :absolute="!fixed" app>
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>

import { getAuth, signOut } from "firebase/auth"
import checkNotifications from "../middleware/checkNotifications"
import axios from "@/plugins/axios"


export default {
  name: 'DefaultLayout',
  middleware: [checkNotifications],
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
      clipped: false,
      drawer: false,
      fixed: false,
      items: [
        {
          icon: 'mdi-apps',
          title: 'トップページ',
          to: '/',
        },
        {
          icon: 'mdi-chart-bubble',
          title: 'マイページ',
          to: '/mypage',
        },
        {
          title: '新規登録',
          to: '/auth/signup'
        },
        {
          title: '質問一覧',
          to: '/questions/questions'
        },
        {
          title: '科目別質問一覧',
          to: '/subjectQuestions/subjectQuestions'
        },
        {
          title: '参考書一覧',
          to: '/books/allBooks'
        },
        {
          title: '閲覧履歴',
          to: '/browsingHistories/allBrowsingHistories'
        },
        {
          title: '通知一覧',
          to: '/notifications/allNotifications'
        },
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
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
    searchBooks() {
      this.$router.push({ path: "/books/localSearchBooksResult", query: { searchBooksKeyword: this.searchBooksKeyword } })
      this.searchBooksKeyword = ""
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
