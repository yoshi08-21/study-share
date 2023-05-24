import Vue from 'vue'
import Router from 'vue-router'
import { normalizeURL, decode } from 'ufo'
import { interopDefault } from './utils'
import scrollBehavior from './router.scrollBehavior.js'

const _02462825 = () => interopDefault(import('../pages/favorites.vue' /* webpackChunkName: "pages/favorites" */))
const _4859987d = () => interopDefault(import('../pages/myPage.vue' /* webpackChunkName: "pages/myPage" */))
const _ffdb8438 = () => interopDefault(import('../pages/auth/login.vue' /* webpackChunkName: "pages/auth/login" */))
const _d0175066 = () => interopDefault(import('../pages/auth/signUp.vue' /* webpackChunkName: "pages/auth/signUp" */))
const _ea3048ba = () => interopDefault(import('../pages/books/_id.vue' /* webpackChunkName: "pages/books/_id" */))
const _3a7b0901 = () => interopDefault(import('../pages/users/_id.vue' /* webpackChunkName: "pages/users/_id" */))
const _368e3cc2 = () => interopDefault(import('../pages/books/_book_id/questions/_id.vue' /* webpackChunkName: "pages/books/_book_id/questions/_id" */))
const _db10b3e0 = () => interopDefault(import('../pages/books/_book_id/reviews/_id.vue' /* webpackChunkName: "pages/books/_book_id/reviews/_id" */))
const _dbcd9bbe = () => interopDefault(import('../pages/books/_book_id/questions/_question_id/replies/_id.vue' /* webpackChunkName: "pages/books/_book_id/questions/_question_id/replies/_id" */))
const _2a6ffc20 = () => interopDefault(import('../pages/index.vue' /* webpackChunkName: "pages/index" */))

const emptyFn = () => {}

Vue.use(Router)

export const routerOptions = {
  mode: 'history',
  base: '/',
  linkActiveClass: 'nuxt-link-active',
  linkExactActiveClass: 'nuxt-link-exact-active',
  scrollBehavior,

  routes: [{
    path: "/favorites",
    component: _02462825,
    name: "favorites"
  }, {
    path: "/myPage",
    component: _4859987d,
    name: "myPage"
  }, {
    path: "/auth/login",
    component: _ffdb8438,
    name: "auth-login"
  }, {
    path: "/auth/signUp",
    component: _d0175066,
    name: "auth-signUp"
  }, {
    path: "/books/:id?",
    component: _ea3048ba,
    name: "books-id"
  }, {
    path: "/users/:id?",
    component: _3a7b0901,
    name: "users-id"
  }, {
    path: "/books/:book_id?/questions/:id?",
    component: _368e3cc2,
    name: "books-book_id-questions-id"
  }, {
    path: "/books/:book_id?/reviews/:id?",
    component: _db10b3e0,
    name: "books-book_id-reviews-id"
  }, {
    path: "/books/:book_id?/questions/:question_id?/replies/:id?",
    component: _dbcd9bbe,
    name: "books-book_id-questions-question_id-replies-id"
  }, {
    path: "/",
    component: _2a6ffc20,
    name: "index"
  }],

  fallback: false
}

export function createRouter (ssrContext, config) {
  const base = (config._app && config._app.basePath) || routerOptions.base
  const router = new Router({ ...routerOptions, base  })

  // TODO: remove in Nuxt 3
  const originalPush = router.push
  router.push = function push (location, onComplete = emptyFn, onAbort) {
    return originalPush.call(this, location, onComplete, onAbort)
  }

  const resolve = router.resolve.bind(router)
  router.resolve = (to, current, append) => {
    if (typeof to === 'string') {
      to = normalizeURL(to)
    }
    return resolve(to, current, append)
  }

  return router
}
