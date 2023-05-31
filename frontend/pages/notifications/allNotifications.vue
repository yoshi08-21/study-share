<template>
  <div>
    <h2>通知一覧</h2>
  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  async asyncData({ store }) {
    try {
      const response = await axios.get("/notifications", {
        params: {
          current_user_id: store.getters["auth/getCurrentUser"].id
        }
      })
      console.log(response.data)
    } catch(error) {
      console.log(error)
      throw error
    }
  }
}
</script>

<style>

</style>
