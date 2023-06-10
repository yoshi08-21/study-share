export const state = () => ({
  unreadNotifications: false
})

export const mutations = {
  setUnreadNotifications(state, unreadNotifications) {
    state.unreadNotifications = unreadNotifications
  }
}

export const actions = {
  setUnreadNotifications(context, payload) {
    context.commit("setUnreadNotifications", payload)
  }
}

export const getters = {
  getUnreadNotifications(state) {
    return state.unreadNotifications
  }
}
