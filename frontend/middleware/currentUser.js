import axios from "../plugins/axios";

export default function({ store }) {
  console.log("middleware: currentUser")
  setTimeout(() => {
    console.log("wait")
  }, 1000);
  if(store.getters["auth/getLoggedIn"]) {
    const uid = store.getters["auth/getUserUid"]
    const response = axios.get(`/users/${uid}`)
    store.dispatch("auth/setCurrentUser", response.data)
}
}
