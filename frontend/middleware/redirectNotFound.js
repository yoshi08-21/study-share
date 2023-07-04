
export default function({ route, redirect }) {
  if(route.matched.length === 0) {
    return redirect({
      path: "/errors/errorPage",
    })
  }
}
