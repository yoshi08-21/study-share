<template>
  <div>
    <h2>通知一覧</h2>

    <p>
      <!-- 本番環境では、通知送信専用のユーザーを作成する（ポートフォリオログインのユーザーとは一緒にしないように注意） -->
      <v-btn @click="createSampleNotification">通知サンプル作成</v-btn>
    </p>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>

    <br>
    <v-flex mb-5 v-for="(notification, index) in notificationsChunk" :key="'notification_' + index">

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
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
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
import authCheck from '../../middleware/authCheck'
import axios from "@/plugins/axios"

export default {
  middleware: authCheck,
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
  },
  data() {
    return {
      perPage: 10,
      page: 1,

    }
  },
  computed: {
    notificationsChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.notifications.slice(start, end)

    },
    totalPages() {
      return Math.ceil(this.notifications.length / this.perPage);
    },
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
  methods: {
    async createSampleNotification() {
      try {
        const response = await axios.post("subject_question_replies/create_sample_notification", {
          current_user_id: this.currentUser.id,
          sample_user_id: 16,
          content: "通知確認用サンプルメッセージ"
        })
        console.log(response.data)
        this.$router.push({ path: "/", query: { message: "通知が作成されました" } })
      } catch(error) {
        console.log(error)
        throw error
      }
    }

  }
}
</script>

<style>

</style>
