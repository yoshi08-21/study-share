<template>
  <div>
    <h2>通知一覧</h2>

    <br>
    <v-flex mb-5 v-for="(notification, index) in notifications" :key="'notification_' + index">

      <div v-if="notification.action_type == 'Favorite'">

        <div v-if="notification.action_to == 'Review'">
          <favorite-review-notification :notification="notification"></favorite-review-notification>
        </div>

        <div v-else-if="notification.action_to == 'Question'">
          <favorite-question-notification :notification="notification"></favorite-question-notification>
        </div>

        <div v-else-if="notification.action_to == 'Reply'">
          <favorite-reply-notification :notification="notification"></favorite-reply-notification>
        </div>

        <div v-else-if="notification.action_to == 'SubjectQuestion'">
          <favorite-subject-question-notification :notification="notification"></favorite-subject-question-notification>
        </div>

        <div v-else-if="notification.action_to == 'SubjectQuestionReply'">
          <favorite-subject-question-reply-notification :notification="notification"></favorite-subject-question-reply-notification>
        </div>


      </div>

      <div v-else-if="notification.action_type == 'Reply'">
        <div v-if="notification.action_to == 'Reply'">
          <reply-to-question-notification :notification="notification"></reply-to-question-notification>
        </div>

        <div v-else-if="notification.action_to == 'SubjectQuestionReply'">
          <reply-to-subject-question-notification :notification="notification"></reply-to-subject-question-notification>
        </div>

      </div>



    </v-flex>
  </div>
</template>

<script>

import FavoriteReviewNotification from '../../components/notifications/FavoriteReviewNotification.vue'
import FavoriteQuestionNotification from '../../components/notifications/FavoriteQuestionNotification.vue'
import FavoriteReplyNotification from '../../components/notifications/FavoriteReplyNotification.vue'
import FavoriteSubjectQuestionNotification from '../../components/notifications/FavoriteSubjectQuestionNotification.vue'
import FavoriteSubjectQuestionReplyNotification from '../../components/notifications/FavoriteSubjectQuestionReplyNotification.vue'
import ReplyToQuestionNotification from '../../components/notifications/ReplyToQuestionNotification.vue'
import ReplyToSubjectQuestionNotification from '../../components/notifications/ReplyToSubjectQuestionNotification.vue'
import axios from "@/plugins/axios"

export default {
  components: {
    FavoriteReviewNotification,
    FavoriteQuestionNotification,
    FavoriteReplyNotification,
    FavoriteSubjectQuestionNotification,
    FavoriteSubjectQuestionReplyNotification,
    ReplyToQuestionNotification,
    ReplyToSubjectQuestionNotification
  },
  async asyncData({ store }) {
    try {
      const response = await axios.get("/notifications", {
        params: {
          current_user_id: store.getters["auth/getCurrentUser"].id
        }
      })
      console.log(response)
      console.log(response.data)
      return {
        notifications: response.data
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
