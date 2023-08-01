<template>
  <div>
    <h2>アンケート詳細</h2>

    <h3>アンケートタイトル: {{ survey.title }}</h3>
    <h4>アンケート本文: {{ survey.content }}</h4>

    <v-btn>1. {{ survey.option1 }}</v-btn>
    <v-btn>2. {{ survey.option2 }}</v-btn>
    <v-btn v-if="survey.option3">3. {{ survey.option3 }}</v-btn>
    <v-btn v-if="survey.option4">4. {{ survey.option4 }}</v-btn>
  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  async asyncData({ params }) {
    try {
      const response = await axios.get(`/surveys/${params.id}`)
      console.log(response.data)
      return {
        survey: response.data
      }
    } catch(error) {
      console.log(error)
      throw error
    }
  }
}
</script>

<style>

</style>
