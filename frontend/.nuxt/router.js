import Vue from 'vue'
import Router from 'vue-router'
import { normalizeURL, decode } from 'ufo'
import { interopDefault } from './utils'
import scrollBehavior from './router.scrollBehavior.js'

const _4859987d = () => interopDefault(import('../pages/myPage.vue' /* webpackChunkName: "pages/myPage" */))
const _ffdb8438 = () => interopDefault(import('../pages/auth/login.vue' /* webpackChunkName: "pages/auth/login" */))
const _d0175066 = () => interopDefault(import('../pages/auth/signUp.vue' /* webpackChunkName: "pages/auth/signUp" */))
const _ea3048ba = () => interopDefault(import('../pages/books/_id.vue' /* webpackChunkName: "pages/books/_id" */))
const _1e9a1ec0 = () => interopDefault(import('../pages/books/_id/reviews/new.vue' /* webpackChunkName: "pages/books/_id/reviews/new" */))
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
    name: "books-id",
    children: [{
      path: "reviews/new",
      component: _1e9a1ec0,
      name: "books-id-reviews-new"
    }]
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
