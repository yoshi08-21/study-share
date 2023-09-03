<template>
  <v-app-bar
    fix
    app
    shrink-on-scroll
    src="https://study-feedback-bucket.s3.ap-northeast-1.amazonaws.com/Study Share3.png"
    fade-img-on-scroll
    scroll-target="#scrolling-techniques-3"
    class="my-app-bar"
    height="400"
  >
    <template v-slot:img="{ props }">
      <v-img
        v-bind="props"
      ></v-img>
    </template>

    <v-row class="d-flex align-center justify-center" style="flex-shrink: 1;">
      <v-col cols="1">
        <v-app-bar-nav-icon @click.stop="toggleDrawer" data-cy="menu-button">
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

      <!-- ログインの有無で表示を切り替え -->
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

      <!-- プロフィール画像をクリックで開くメニュー -->
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
                <v-btn icon x-large v-on="on" data-cy="header-user-menu">
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
                    <v-btn rounded text style="color: red;" @click="logout" data-cy="header-logout-button">
                      ログアウト
                    </v-btn>
                  </div>
                </v-list-item-content>
              </v-card>
            </v-menu>
          </v-row>
        </template>
      </v-col>
    </v-row>
  </v-app-bar>



</template>

<script>
export default {
  props: {
    currentUser: Object,

  },
  data() {
    return {
      drawer: false,
      fixed: false,
      title: {
        title: "StudyShare",
        to: "/"
      },
      searchBooksKeyword: "",

    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.getters["auth/getLoggedIn"]
    },
    unreadNotifications() {
      return this.$store.state.notifications.unreadNotifications
    },
  },
  methods: {
    searchBooks() {
      this.$emit("searchBooks", { searchBooksKeyword: this.searchBooksKeyword })
    },
    goToMypage() {
      this.$emit("goToMypage")
    },
    goToFavorites() {
      this.$emit("goToFavorites")
    },
    goToBrowsingHistories() {
      this.$emit("goToBrowsingHistories")
    },
    goToNotifications() {
      this.$emit("goToNotifications")
    },
    logout() {
      this.$emit("logout")
    },
    toggleDrawer() {
      this.$emit("toggleDrawer")
    }
  }

}

</script>

<style>


</style>
