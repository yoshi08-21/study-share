<template>
  <div>
    <h3>返信一覧</h3>

    <v-flex v-for="(subjectQuestionReply, index) in subjectQuestionReplies" :key="index" xs12 sm6 md4 lg3 mb-5>
      <v-card :to="`/subjectQuestions/${subjectQuestionReply.subject_question_id}/subjectQuestionReplies/${subjectQuestionReply.id}`">
        <v-card-text>{{ subjectQuestionReply.content }}</v-card-text>
        <template v-if="subjectQuestionReply.user">
          <v-card-actions>by:{{ subjectQuestionReply.user.name }}</v-card-actions>
        </template>
      </v-card>
    </v-flex>
  </div>
</template>

<script>
export default {
  props: {
    subjectQuestionReplies: [],
  },
  created() {
    console.log()
  }
}
</script>

<style>

</style>
