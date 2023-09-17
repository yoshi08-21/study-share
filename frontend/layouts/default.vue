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

    <!-- index.vueを表示する場合のみ特別なヘッダーを表示 -->
    <template v-if="showSpecialHeader === false">
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
    </template>
    <template v-else>
      <special-header
        :currentUser="currentUser"
        @toggleDrawer="drawer = !drawer"
        @searchBooks="searchBooks"
        @goToMypage="goToMypage"
        @goToFavorites="goToFavorites"
        @goToBrowsingHistories="goToBrowsingHistories"
        @goToNotifications="goToNotifications"
        @logout="logout"
      >
      </special-header>
    </template>

    <v-sheet id="scrolling-techniques-3" class="overflow-y-auto" style="height: 100vh;">
      <v-main>
        <v-container>

          <Nuxt />

          <v-btn
            v-if="currentUser"
            @click="showUserMemo = true"
            fab
            fixed
            large
            color="cyan"
            class="fab-button"
            data-cy="user-memo-button"
          >
            <v-icon dark>
              mdi-book-edit
            </v-icon>
          </v-btn>

          <div class="text-center">
            <v-bottom-sheet v-model="sheet">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  v-bind="attrs"
                  v-on="on"
                  fab
                  fixed
                  dark
                  large
                  color="teal"
                  style="position: fixed; right: 20px; bottom: 20px;"
                >
                  <v-icon dark>
                    mdi-format-list-bulleted-square
                  </v-icon>
                </v-btn>
              </template>
              <v-list>
                <v-subheader>Menu</v-subheader>
                <v-list-item
                  v-for="tile in tiles"
                  :key="tile.title"
                  :to="tile.to"
                  router
                  exact
                  @click="sheet = false"
                >
                  <v-list-item-avatar>
                    <v-icon>{{ tile.icon }}</v-icon>
                  </v-list-item-avatar>
                  <v-list-item-title>{{ tile.title }}</v-list-item-title>
                </v-list-item>
                <v-row>
                  <v-col class="d-flex justify-center">
                    <v-btn
                    @click="sheet = false"
                    color="primary"
                    width="80%"
                    >
                      閉じる
                    </v-btn>
                  </v-col>
                </v-row>
              </v-list>
            </v-bottom-sheet>
          </div>


          <br>
          <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
        </v-container>
      </v-main>
    </v-sheet>


    <!-- ユーザーメモダイアログ -->
    <v-overlay
      :value="showUserMemo"
      :z-index="zIndex"
      opacity="0"
    >
      <v-dialog
        v-model="showUserMemo"
        hide-overlay
        max-width="1000px"
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
              filled
              shaped
              rows="10"
              label="ユーザーメモ"
              counter
              data-cy="user-memo-field"
              ></v-textarea>
              <p>＊メモの内容を残したい場合は必ず「保存する」を押してください</p>
            <submit-button
              :buttonTitle="'保存する'"
              @submitForm="saveUserMemo"
              @closeDialog="showUserMemo = false"
            >
            </submit-button>
          </v-card-text>
        </v-card>
      </v-dialog>
    </v-overlay>


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
import SpecialHeader from '../components/global/SpecialHeader.vue'
import SubmitButton from '../components//global/SubmitButton.vue'
import userComputed from '../mixins/userComputed'
import axios from "@/plugins/axios"


export default {
  components: { NormalHeader, SpecialHeader, SubmitButton },
  name: 'DefaultLayout',
  middleware: [checkNotifications, redirectNotFound, checkResourceExistence],
  mixins: [userComputed],
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
        // 未ログイン時のログインページへのリダイレクトはmypage.vueのmiddlewareで行われる
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
          to: '/questions/allQuestions'
        },
        {
          icon: "mdi-comment-question-outline",
          title: '科目別質問一覧',
          to: '/subjectQuestions/allSubjectQuestions'
        },
        {
          icon: "mdi-account-search",
          title: 'アンケート',
          to: '/surveys/allSurveys'
        },
      ],
      title: {
        title: "StudyShare",
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
      userMemo: "",
      sheet: false,
      tiles: [
        { icon: "mdi-home", title: "トップページ", to: "/" },
        { icon: "mdi-account", title: "マイページ", to: "/mypage" },
        { icon: "mdi-bookshelf", title: "参考書一覧", to: "/books/allBooks" },
        { icon: "mdi-comment-question", title: "質問一覧", to: "/questions/allQuestions" },
        { icon: "mdi-comment-question-outline", title: "科目別質問一覧", to: "/subjectQuestions/allSubjectQuestions" },
        { icon: "mdi-account-search", title: "アンケート", to: "/surveys/allSurveys" },
      ],

    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.getters["auth/getLoggedIn"]
    },
    unreadNotifications() {
      return this.$store.state.notifications.unreadNotifications
    },
    showSpecialHeader() {
      return this.$store.getters["header/getShowSpecialHeader"]
    }
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
  bottom: 100px;
}

.fab-button2 {
  position: fixed;
  right: 20px;
  bottom: 40px;
}

.set-center-bottom {
  position: fixed;
  bottom: 20px;
  z-index: 100;
}

body .v-toolbar--prominent .v-toolbar__content {
    align-items: center;
}

.page-enter-active,
.page-leave-active {
  transition: all 0.4s;
}

.page-enter-from,
.page-leave-to {
  opacity: 0;
  filter: blur(1rem);
}

</style>
