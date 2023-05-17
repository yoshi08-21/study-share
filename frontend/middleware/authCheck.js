
export default function ({ store, redirect }) {
  if (!store.getters["auth/getCurrentUser"]) {
    return redirect({
      path: "/auth/login",
      query: { message: "ログインが必要です"}
    });
  }
}



