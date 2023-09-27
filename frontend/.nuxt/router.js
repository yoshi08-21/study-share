import Vue from 'vue'
import Router from 'vue-router'
import { normalizeURL, decode } from 'ufo'
import { interopDefault } from './utils'
import scrollBehavior from './router.scrollBehavior.js'

const _4d18237d = () => interopDefault(import('../pages/favorites.vue' /* webpackChunkName: "pages/favorites" */))
const _44011c25 = () => interopDefault(import('../pages/myPage.vue' /* webpackChunkName: "pages/myPage" */))
const _e100a4e8 = () => interopDefault(import('../pages/auth/login.vue' /* webpackChunkName: "pages/auth/login" */))
const _7634dd25 = () => interopDefault(import('../pages/auth/signUp.vue' /* webpackChunkName: "pages/auth/signUp" */))
const _9dc6c4d0 = () => interopDefault(import('../pages/books/allBooks.vue' /* webpackChunkName: "pages/books/allBooks" */))
const _26eaf390 = () => interopDefault(import('../pages/books/googleApiSearchBooks.vue' /* webpackChunkName: "pages/books/googleApiSearchBooks" */))
const _ae970a7a = () => interopDefault(import('../pages/books/localSearchBooksResult.vue' /* webpackChunkName: "pages/books/localSearchBooksResult" */))
const _3cdae790 = () => interopDefault(import('../pages/browsingHistories/allBrowsingHistories.vue' /* webpackChunkName: "pages/browsingHistories/allBrowsingHistories" */))
const _6f9aaa5d = () => interopDefault(import('../pages/errors/errorPage.vue' /* webpackChunkName: "pages/errors/errorPage" */))
const _4f958d50 = () => interopDefault(import('../pages/notifications/allNotifications.vue' /* webpackChunkName: "pages/notifications/allNotifications" */))
const _98aeeb10 = () => interopDefault(import('../pages/questions/allQuestions.vue' /* webpackChunkName: "pages/questions/allQuestions" */))
const _fdf62034 = () => interopDefault(import('../pages/questions/searchQuestionsResult.vue' /* webpackChunkName: "pages/questions/searchQuestionsResult" */))
const _563e0504 = () => interopDefault(import('../pages/subjectQuestions/allSubjectQuestions.vue' /* webpackChunkName: "pages/subjectQuestions/allSubjectQuestions" */))
const _5ff2263a = () => interopDefault(import('../pages/subjectQuestions/searchSubjectQuestionsResult.vue' /* webpackChunkName: "pages/subjectQuestions/searchSubjectQuestionsResult" */))
const _0a420f90 = () => interopDefault(import('../pages/surveys/allSurveys.vue' /* webpackChunkName: "pages/surveys/allSurveys" */))
const _548c520a = () => interopDefault(import('../pages/books/_id.vue' /* webpackChunkName: "pages/books/_id" */))
const _3d3ec1f6 = () => interopDefault(import('../pages/subjectQuestions/_id.vue' /* webpackChunkName: "pages/subjectQuestions/_id" */))
const _dca2e3ac = () => interopDefault(import('../pages/surveys/_id.vue' /* webpackChunkName: "pages/surveys/_id" */))
const _f565f74e = () => interopDefault(import('../pages/users/_id.vue' /* webpackChunkName: "pages/users/_id" */))
const _0623db2c = () => interopDefault(import('../pages/books/_book_id/questions/_id.vue' /* webpackChunkName: "pages/books/_book_id/questions/_id" */))
const _82be7490 = () => interopDefault(import('../pages/books/_book_id/reviews/_id.vue' /* webpackChunkName: "pages/books/_book_id/reviews/_id" */))
const _7d7bba05 = () => interopDefault(import('../pages/books/_book_id/reviews/_id.test 2.js' /* webpackChunkName: "pages/books/_book_id/reviews/_id.test 2" */))
const _e49a5486 = () => interopDefault(import('../pages/subjectQuestions/_subjectQuestion_id/subjectQuestionReplies/_id.vue' /* webpackChunkName: "pages/subjectQuestions/_subjectQuestion_id/subjectQuestionReplies/_id" */))
const _5922f579 = () => interopDefault(import('../pages/books/_book_id/questions/_question_id/replies/_id.vue' /* webpackChunkName: "pages/books/_book_id/questions/_question_id/replies/_id" */))
const _61153910 = () => interopDefault(import('../pages/index.vue' /* webpackChunkName: "pages/index" */))

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
    component: _4d18237d,
    name: "favorites"
  }, {
    path: "/myPage",
    component: _44011c25,
    name: "myPage"
  }, {
    path: "/auth/login",
    component: _e100a4e8,
    name: "auth-login"
  }, {
    path: "/auth/signUp",
    component: _7634dd25,
    name: "auth-signUp"
  }, {
    path: "/books/allBooks",
    component: _9dc6c4d0,
    name: "books-allBooks"
  }, {
    path: "/books/googleApiSearchBooks",
    component: _26eaf390,
    name: "books-googleApiSearchBooks"
  }, {
    path: "/books/localSearchBooksResult",
    component: _ae970a7a,
    name: "books-localSearchBooksResult"
  }, {
    path: "/browsingHistories/allBrowsingHistories",
    component: _3cdae790,
    name: "browsingHistories-allBrowsingHistories"
  }, {
    path: "/errors/errorPage",
    component: _6f9aaa5d,
    name: "errors-errorPage"
  }, {
    path: "/notifications/allNotifications",
    component: _4f958d50,
    name: "notifications-allNotifications"
  }, {
    path: "/questions/allQuestions",
    component: _98aeeb10,
    name: "questions-allQuestions"
  }, {
    path: "/questions/searchQuestionsResult",
    component: _fdf62034,
    name: "questions-searchQuestionsResult"
  }, {
    path: "/subjectQuestions/allSubjectQuestions",
    component: _563e0504,
    name: "subjectQuestions-allSubjectQuestions"
  }, {
    path: "/subjectQuestions/searchSubjectQuestionsResult",
    component: _5ff2263a,
    name: "subjectQuestions-searchSubjectQuestionsResult"
  }, {
    path: "/surveys/allSurveys",
    component: _0a420f90,
    name: "surveys-allSurveys"
  }, {
    path: "/books/:id?",
    component: _548c520a,
    name: "books-id"
  }, {
    path: "/subjectQuestions/:id?",
    component: _3d3ec1f6,
    name: "subjectQuestions-id"
  }, {
    path: "/surveys/:id?",
    component: _dca2e3ac,
    name: "surveys-id"
  }, {
    path: "/users/:id?",
    component: _f565f74e,
    name: "users-id"
  }, {
    path: "/books/:book_id?/questions/:id?",
    component: _0623db2c,
    name: "books-book_id-questions-id"
  }, {
    path: "/books/:book_id?/reviews/:id?",
    component: _82be7490,
    name: "books-book_id-reviews-id"
  }, {
    path: "/books/:book_id?/reviews/:id.test%202?",
    component: _7d7bba05,
    name: "books-book_id-reviews-id.test 2"
  }, {
    path: "/subjectQuestions/:subjectQuestion_id?/subjectQuestionReplies/:id?",
    component: _e49a5486,
    name: "subjectQuestions-subjectQuestion_id-subjectQuestionReplies-id"
  }, {
    path: "/books/:book_id?/questions/:question_id?/replies/:id?",
    component: _5922f579,
    name: "books-book_id-questions-question_id-replies-id"
  }, {
    path: "/",
    component: _61153910,
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
