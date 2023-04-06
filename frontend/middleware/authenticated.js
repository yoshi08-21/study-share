
import { getAuth, onAuthStateChanged } from "firebase/auth"
import axios from "../plugins/axios";

const auth = ({ $firebase, store }) => {
  console.log("dispatch")
  const auth = getAuth($firebase)


  if(!store.getters["auth/getLoggedIn"]) {
    onAuthStateChanged(auth, async user => {
      if(user) {
        // ↓の処理にawaitをつけたい

      const { data } = await axios.get(`/users/${user.uid}`)

        store.dispatch("auth/addUserInfo", data)
        console.log("dispatch")
      } else {
        console.log("未ログインです")
      }
    })
  }


  // const uid = store.getters["auth/getUserUid"]
  // console.log(uid)
  // const response = await axios.get(`/users/${uid}`)
  // store.dispatch("auth/setCurrentUser", response.data)


  // console.log("middleware: currentUser")
  // // !storeだと不自然
  // if(!store.getters["auth/getLoggedIn"]) {
  //   console.log("実行中")
  //   // awaitは機能しているが、gettersがうまく行ってない
  //   // この時点でstate.userUidが空
  //   const uid = await store.state.auth.userUid
  //   // uidがセットされていない
  //   if(uid) {
  //     const response = await axios.get(`/users/${uid}`)
  //     store.dispatch("auth/setCurrentUser", response.data)
  //     console.log(uid)
  //   }
  // } else {
  //   console.log("実行できない")
  // }

}
export default auth
