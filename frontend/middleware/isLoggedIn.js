
export default function ({ store, redirect }) {
  if (store.getters["auth/getCurrentUser"]) {
    return redirect({
      path: "/mypage",
      query: { message: "すでにログインされています"}
    });
  }
}



