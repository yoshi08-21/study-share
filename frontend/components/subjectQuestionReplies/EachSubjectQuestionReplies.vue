<template>
  <div>

    <v-flex mb-5 v-for="(subjectQuestionReply, index) in subjectQuestionReplies" :key="'subject_question_reply' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/subjectQuestions/${subjectQuestionReply.subject_question_id}/subjectQuestionReplies/${subjectQuestionReply.id}`">
            <v-row>
              <v-col cols="10">
                <v-card-text>
                  <p>{{ subjectQuestionReply.content }}</p>
                </v-card-text>
                <v-card-actions>
                  by: {{ subjectQuestionReply.user.name }}
                  <template v-if="subjectQuestionReply.image">
                    <h5>画像</h5>
                    <v-icon>mdi-image-plus</v-icon>
                  </template>
                  <v-spacer></v-spacer>
                  to: {{ subjectQuestionReply.subject_question.title }}
                </v-card-actions>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </v-flex>

</div>
</template>

<script>
export default {
  props: {
    subjectQuestionReplies: [],
  },
}
</script>

<style>

</style>
