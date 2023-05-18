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
      <v-spacer />
      <div v-if="!isLoggedIn">
        <v-btn to="/auth/login">ログイン</v-btn>
      </div>
      <div v-else>
        <v-btn @click="logout">ログアウト</v-btn>
      </div>
      <v-btn icon @click.stop="rightDrawer = !rightDrawer">
        <v-icon>mdi-menu</v-icon>
      </v-btn>
    </v-app-bar>
    <v-main>
      <v-container>
        <Nuxt />
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
        <v-list-item>
          「{{ this.currentUser.name }}」でログイン中
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
// import axios from "../plugins/axios"


export default {
  name: 'DefaultLayout',
  // middleware: "getUser",
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
          title: 'books/1',
          to: '/books/1',
        },
        {
          title: '新規登録',
          to: '/auth/signup'
        },
        {
          title: 'sample6詳細ページ',
          to: '/users/4'
        },

      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: {
        title: "StudyFeedback",
        to: "/"
      },
      user: {}
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.getters["auth/getLoggedIn"]
    },
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    }

  },
  methods: {
    async logout() {
      try {
        const auth = getAuth(this.$firebase)
        await signOut(auth)
        this.$store.dispatch("auth/setLoginState", false)
        this.$store.dispatch("auth/setUserUid", "")
        this.$router.push("/")
        this.$store.dispatch("auth/setEmail", "")
      } catch(error) {
        console.log(error)
      }
    }

  }
}
</script>

<style>
.v-main {
  background-color: #edebe8;
}
</style>
