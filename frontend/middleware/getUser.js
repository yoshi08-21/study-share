
import axios from "../plugins/axios";

export default async function({ store }) {

  console.log("getUser")
    if(!store.getters["auth/getLoggedIn"]) {
      console.log("実行中")
      // awaitは機能しているが、gettersがうまく行ってない
      // この時点でstate.userUidが空
      const uid = await store.state.auth.userUid
      // uidがセットされていない
      const response = await axios.get(`/users/${uid}`)
      store.dispatch("auth/setCurrentUser", response.data)
      console.log(uid)
    } else {
      console.log("実行できない")
    }
}
