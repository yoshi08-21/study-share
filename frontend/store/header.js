export const state = () => ({
  showSpecialHeader: false
})

export const mutations = {
  setLoginState(state, isLoggedIn) {
    state.isLoggedIn = isLoggedIn
  },
  setShowSpecialHeader(state, showSpecialHeader) {
    state.showSpecialHeader = showSpecialHeader
  }
}

export const actions = {
  setShowSpecialHeader(context, payload) {
    context.commit("setShowSpecialHeader", payload)
  }
}

export const getters = {
  getShowSpecialHeader(state) {
    return state.showSpecialHeader
  }
}
