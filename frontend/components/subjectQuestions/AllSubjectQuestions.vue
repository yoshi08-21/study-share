<template>
  <div>
    <h3>質問一覧</h3>

    <br>
    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(subjectQuestion, index) in subjectQuestions" :key="index">
      <v-card :to="`/subjectQuestions/${subjectQuestion.id}`">
        <v-card-title>{{ subjectQuestion.title }}</v-card-title>
        <v-card-text>{{ subjectQuestion.content }}</v-card-text>
        <template v-if="subjectQuestion.user">
          <v-card-actions>科目:{{ subjectQuestion.subject }}</v-card-actions>
          <v-card-actions>by:{{ subjectQuestion.user.name }}</v-card-actions>
        </template>
      </v-card>
    </v-flex>

  </div>
</template>

<script>
export default {
  props: {
    subjectQuestions: [],
  }
}
</script>

<style>

</style>
