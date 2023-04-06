export const state = () => ({
  isLoggedIn: false,
  userUid: "",
  email: "",
  currentUser: {}
})

export const mutations = {
  setLoginState(state, isLoggedIn) {
    state.isLoggedIn = isLoggedIn
  },
  setUserUid(state, userUid) {
    state.userUid = userUid
  },
  setEmail(state, email) {
    state.email = email
  },
  setCurrentUser(state, currentUser) {
    state.currentUser = currentUser
  }
}

export const actions = {
  setLoginState(context, payload) {
    context.commit("setLoginState", payload)
  },
  setUserUid(context, payload) {
    context.commit("setUserUid", payload)
  },
  setEmail(context, payload) {
    context.commit("setEmail", payload)
  },
  addUserInfo(context, payload) {
    context.commit("setLoginState", true)
    context.commit("setUserUid", payload.uid)
    context.commit("setEmail", payload.email)
  },
  setCurrentUser(context, payload) {
    context.commit("setCurrentUser", payload)
  }

}

export const getters = {
  getLoggedIn(state) {
    // !!で真偽値を返す
    return !!state.isLoggedIn
  },
  getUserUid(state) {
    return state.userUid
  },
  getEmail(state) {
    return state.email
  },
  getCurrentUser(state) {
    return state.currentUser
  }
}
