import Vue from 'vue'
import Router from 'vue-router'
import { normalizeURL, decode } from 'ufo'
import { interopDefault } from './utils'
import scrollBehavior from './router.scrollBehavior.js'

const _02462825 = () => interopDefault(import('../pages/favorites.vue' /* webpackChunkName: "pages/favorites" */))
const _4859987d = () => interopDefault(import('../pages/myPage.vue' /* webpackChunkName: "pages/myPage" */))
const _ffdb8438 = () => interopDefault(import('../pages/auth/login.vue' /* webpackChunkName: "pages/auth/login" */))
const _d0175066 = () => interopDefault(import('../pages/auth/signUp.vue' /* webpackChunkName: "pages/auth/signUp" */))
const _0a817c20 = () => interopDefault(import('../pages/books/allBooks.vue' /* webpackChunkName: "pages/books/allBooks" */))
const _0a7c5830 = () => interopDefault(import('../pages/books/googleApiSearchBooks.vue' /* webpackChunkName: "pages/books/googleApiSearchBooks" */))
const _3b56b5ca = () => interopDefault(import('../pages/books/localSearchBooksResult.vue' /* webpackChunkName: "pages/books/localSearchBooksResult" */))
const _4723a890 = () => interopDefault(import('../pages/browsingHistories/allBrowsingHistories.vue' /* webpackChunkName: "pages/browsingHistories/allBrowsingHistories" */))
const _49b4ce96 = () => interopDefault(import('../pages/errors/errorPage.vue' /* webpackChunkName: "pages/errors/errorPage" */))
const _2a742db0 = () => interopDefault(import('../pages/notifications/allNotifications.vue' /* webpackChunkName: "pages/notifications/allNotifications" */))
const _f110b94e = () => interopDefault(import('../pages/questions/questions.vue' /* webpackChunkName: "pages/questions/questions" */))
const _76a4868e = () => interopDefault(import('../pages/questions/searchQuestionsResult.vue' /* webpackChunkName: "pages/questions/searchQuestionsResult" */))
const _1b90f6e2 = () => interopDefault(import('../pages/subjectQuestions/searchSubjectQuestionsResult.vue' /* webpackChunkName: "pages/subjectQuestions/searchSubjectQuestionsResult" */))
const _0216141d = () => interopDefault(import('../pages/subjectQuestions/subjectQuestions.vue' /* webpackChunkName: "pages/subjectQuestions/subjectQuestions" */))
const _a1309ee0 = () => interopDefault(import('../pages/surveys/allSurveys.vue' /* webpackChunkName: "pages/surveys/allSurveys" */))
const _ea3048ba = () => interopDefault(import('../pages/books/_id.vue' /* webpackChunkName: "pages/books/_id" */))
const _1b0a7764 = () => interopDefault(import('../pages/subjectQuestions/_id.vue' /* webpackChunkName: "pages/subjectQuestions/_id" */))
const _9923ee5c = () => interopDefault(import('../pages/surveys/_id.vue' /* webpackChunkName: "pages/surveys/_id" */))
const _3a7b0901 = () => interopDefault(import('../pages/users/_id.vue' /* webpackChunkName: "pages/users/_id" */))
const _368e3cc2 = () => interopDefault(import('../pages/books/_book_id/questions/_id.vue' /* webpackChunkName: "pages/books/_book_id/questions/_id" */))
const _db10b3e0 = () => interopDefault(import('../pages/books/_book_id/reviews/_id.vue' /* webpackChunkName: "pages/books/_book_id/reviews/_id" */))
const _450dcc65 = () => interopDefault(import('../pages/subjectQuestions/_subjectQuestion_id/subjectQuestionReplies/_id.vue' /* webpackChunkName: "pages/subjectQuestions/_subjectQuestion_id/subjectQuestionReplies/_id" */))
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
    path: "/books/allBooks",
    component: _0a817c20,
    name: "books-allBooks"
  }, {
    path: "/books/googleApiSearchBooks",
    component: _0a7c5830,
    name: "books-googleApiSearchBooks"
  }, {
    path: "/books/localSearchBooksResult",
    component: _3b56b5ca,
    name: "books-localSearchBooksResult"
  }, {
    path: "/browsingHistories/allBrowsingHistories",
    component: _4723a890,
    name: "browsingHistories-allBrowsingHistories"
  }, {
    path: "/errors/errorPage",
    component: _49b4ce96,
    name: "errors-errorPage"
  }, {
    path: "/notifications/allNotifications",
    component: _2a742db0,
    name: "notifications-allNotifications"
  }, {
    path: "/questions/questions",
    component: _f110b94e,
    name: "questions-questions"
  }, {
    path: "/questions/searchQuestionsResult",
    component: _76a4868e,
    name: "questions-searchQuestionsResult"
  }, {
    path: "/subjectQuestions/searchSubjectQuestionsResult",
    component: _1b90f6e2,
    name: "subjectQuestions-searchSubjectQuestionsResult"
  }, {
    path: "/subjectQuestions/subjectQuestions",
    component: _0216141d,
    name: "subjectQuestions-subjectQuestions"
  }, {
    path: "/surveys/allSurveys",
    component: _a1309ee0,
    name: "surveys-allSurveys"
  }, {
    path: "/books/:id?",
    component: _ea3048ba,
    name: "books-id"
  }, {
    path: "/subjectQuestions/:id?",
    component: _1b0a7764,
    name: "subjectQuestions-id"
  }, {
    path: "/surveys/:id?",
    component: _9923ee5c,
    name: "surveys-id"
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
    path: "/subjectQuestions/:subjectQuestion_id?/subjectQuestionReplies/:id?",
    component: _450dcc65,
    name: "subjectQuestions-subjectQuestion_id-subjectQuestionReplies-id"
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
