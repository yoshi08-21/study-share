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

    <v-app-bar fixed app>
      <v-row class="d-flex align-center justify-center">
        <v-col cols="1">
          <v-app-bar-nav-icon @click.stop="drawer = !drawer">
            <v-icon>mdi-menu-open</v-icon>
          </v-app-bar-nav-icon>
        </v-col>

        <v-col cols="2">
          <v-toolbar-title>
            <nuxt-link to="/">{{ title.title }}</nuxt-link>
          </v-toolbar-title>
        </v-col>

        <v-col cols="6">
          <v-row class="d-flex align-center justify-center">
            <v-col cols="10">
              <v-text-field
                v-model="searchBooksKeyword"
                label="参考書を検索"
                placeholder="キーワードを入力 例: (英語 文法)"
                filled
                dense
                outlined
                style="margin-top: 25px;"
              ></v-text-field>
            </v-col>
            <v-col cols="2">
              <v-btn @click="searchBooks">検索</v-btn>
            </v-col>
          </v-row>
        </v-col>

        <v-col cols="2">
          <v-row justify="center">
            <template v-if="!isLoggedIn">
              <v-col cols="12">
                <v-btn to="/auth/login">ログイン</v-btn>
              </v-col>
            </template>
            <template v-else>
              <v-col cols="5">
                <v-tooltip bottom>
                  <template v-slot:activator="{ on, attrs }">
                    <v-btn @click="goToFavorites" icon x-large v-bind="attrs" v-on="on">
                      <v-icon>mdi-star</v-icon>
                    </v-btn>
                  </template>
                  <span>お気に入り</span>
                </v-tooltip>
              </v-col>
              <v-col cols="5">
                <template v-if="unreadNotifications">
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn @click="goToNotifications" icon x-large v-bind="attrs" v-on="on">
                        <v-badge overlap>
                          <v-icon>mdi-bell</v-icon>
                        </v-badge>
                      </v-btn>
                    </template>
                    <span>通知一覧</span>
                  </v-tooltip>
                </template>
                <template v-else>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn @click="goToNotifications" icon x-large v-bind="attrs" v-on="on">
                        <v-icon>mdi-bell</v-icon>
                      </v-btn>
                    </template>
                    <span>通知一覧</span>
                  </v-tooltip>
                </template>
              </v-col>
            </template>
          </v-row>
        </v-col>

        <v-col cols="1">
          <template v-if="currentUser">
            <v-row justify="center">
              <v-menu
                left
                min-width="200px"
                rounded
                offset-y
                transition="slide-y-transition"
              >
                <template v-slot:activator="{ on }">
                  <v-btn icon x-large v-on="on">
                    <v-avatar size="55">
                      <v-img :src="currentUser.image"></v-img>
                    </v-avatar>
                  </v-btn>
                </template>
                <v-card>
                  <v-list-item-content class="justify-center">
                    <div class="mx-auto text-center">
                      <v-avatar size="60">
                        <v-img :src="currentUser.image"></v-img>
                      </v-avatar>
                      <h3>{{ currentUser.name }}</h3>
                      <p class="text-caption mt-1">
                        {{ currentUser.email }}
                      </p>
                      <v-divider class="my-3"></v-divider>
                      <v-btn rounded text @click="goToMypage">
                        マイページ
                      </v-btn>
                      <v-divider class="my-3"></v-divider>
                      <v-btn rounded text @click="goToBrowsingHistories">
                        閲覧履歴
                      </v-btn>
                      <v-divider class="my-3"></v-divider>
                      <v-btn rounded text @click="logout">
                        ログアウト
                      </v-btn>
                    </div>
                  </v-list-item-content>
                </v-card>
              </v-menu>
            </v-row>
          </template>
          <!-- <template v-else>

          </template> -->
        </v-col>

      </v-row>
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
import axios from "@/plugins/axios"


export default {
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
