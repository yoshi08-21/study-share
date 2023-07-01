<template>
  <div>
    <h2>ユーザー詳細ページ</h2>
    <h5>ユーザー名: {{ user.name }}</h5>
    <h5>メールアドレス: {{ user.email }}</h5>
  </div>
</template>

<script>

import checkUserExistence from '../../middleware/checkUserExistence'
import axios from "@/plugins/axios"


export default {
  middleware: checkUserExistence,
  async asyncData({ params }) {
    try {
      const response = await axios.get(`/users/show_other_user/${params.id}`)
      console.log(response.data)
      return {
        user: response.data
      }
    } catch(error) {
      console.log(error)
    }
  }
}
</script>

<style>

</style>
