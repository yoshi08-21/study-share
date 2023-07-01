import axios from "@/plugins/axios"

export default async function({ route, redirect }) {
  const response = await axios.get(`/users/show_other_user/${route.params.id}`)
  if(response.status === 204 ) {
    return redirect({
      path: "/",
      query: { message: "存在しないユーザーです" }
    })
  }
}
