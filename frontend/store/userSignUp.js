export const state = () => ({
  email: ""
})

export const mutations = {
  setEmail(state, email) {
    state.email = email
  },
}

export const actions = {
  setEmail(context, payload) {
    context.commit("setEmail", payload)
  }
}

export const getters = {
  getEmail(state) {
    return state.Email
  }
}
