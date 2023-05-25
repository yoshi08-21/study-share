<template>
  <div>
    <h3>質問一覧</h3>

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
export default {
  props: {
    questions: [],
  }
}
</script>

<style>

</style>
