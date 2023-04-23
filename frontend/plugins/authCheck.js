import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";

const authCheck = ({ store, redirect }) => {
  // ログイン中のユーザーをfirebaseに確認
  firebase.auth().onAuthStateChanged(async user => {
    if (user) {
      // 　ユーザーがいれば、そのユーザーのuidをもとにユーザーを見つける
      const { data } = await axios.get('/v1/users', {
        params: {
          uid: user.uid,
        },
      });
      console.log("ログインしているユーザー:", data);
      console.log("authCheckが実行されています")
      // stateのcurrentUserを書き換える
      store.dispatch("auth/setUser", data)
    } else {
      store.dispatch("auth/setUser", null)
    }
  });
};

export default authCheck;
