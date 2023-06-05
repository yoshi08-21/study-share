<template>
  <div>
    <v-row>
      <v-col cols="10">
        <v-card>
          <v-row>
            <v-col cols="12">
              <p>
                <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                <nuxt-link :to="`/subjectQuestions/${notification.subject_question.id}`">あなたの質問(科目別質問)</nuxt-link>に
                <nuxt-link :to="`/subjectQuestions/${notification.subject_question_reply.subject_question_id}/subjectQuestionReplies/${notification.subject_question_reply.id}`">返信</nuxt-link>しました
              </p>
              <p>
                →「{{ notification.subject_question_reply.content }}」
              </p>
              <v-card-title>通知の種類: {{ notification.action_type }}</v-card-title>
              <v-card-text>
                <p>to: {{ notification.action_to }}</p>
                <p>これはReplyに対する通知</p>
                <p>これはSubjectQuestionReplyに対するReplyNotification</p>
              </v-card-text>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
export default {
  props: {
    notification: {}
  }
}
</script>

<style>

</style>
