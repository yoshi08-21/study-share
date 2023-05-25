<template>
  <div>
    <h2>科目別質問一覧ページ</h2>

    <v-tabs
      fixed-tabs
    >
    <v-tab to="/questions/questions">
        参考書別質問
      </v-tab>
      <v-tab to="/subjectQuestions/subjectQuestions">
        科目別質問
      </v-tab>
    </v-tabs>


    <br><br><br>
    <v-card>
      <v-card-title>
        質問一覧：検索ボックス
        <v-text-field></v-text-field><v-btn>検索</v-btn>
      </v-card-title>
      <v-card-title>
        <v-btn block>質問を投稿する</v-btn>
      </v-card-title>
    </v-card>

    <br>
    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(question, index) in questions" :key="index">
      <v-card :to="`/books/${question.book_id}/questions/${question.id}`">
        <v-card-title>{{ question.title }}</v-card-title>
        <v-card-text>{{ question.content }}</v-card-text>
        <template v-if="question.user">
          <v-card-actions>by:{{ question.user.name }}</v-card-actions>
        </template>
      </v-card>
    </v-flex>



  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
  async asyncData() {
    try {
      const responce = await axios.get("/questions/all_questions")
      console.log(responce.data)
      return {
        questions: responce.data
      }
    } catch(error) {

    }
  }
}
</script>

<style>

</style>
