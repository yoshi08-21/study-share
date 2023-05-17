
import firebase from "../plugins/firebase";
import axios from "../plugins/axios";

// ページのリロード時にfirebaseにアクセスしてログインの有無を確認する
// ログインが確認できたら、storeにユーザー情報をセットする

const auth = ({ $firebase, store }) => {
  if (!store.getters["auth/getLoggedIn"]) {
    return new Promise((resolve) => {
      firebase.auth().onAuthStateChanged(async user => {
        if (user) {
          const { data } = await axios.get(`/users/${user.uid}`)
          store.dispatch("auth/addUserInfo", user)
          store.dispatch("auth/setCurrentUser", data).then(() => {
            resolve()
          })
        } else {
          console.log("未ログインです")
          store.dispatch("auth/setCurrentUser", null).then(() => {
            resolve()
          })
        }
      })
    })
  }
}

export default auth;
