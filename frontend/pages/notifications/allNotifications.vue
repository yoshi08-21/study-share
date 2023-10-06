<template>
  <div>
    <h2 style="text-align: center;">通知一覧</h2>

    <br><br>
    <v-row>
      <v-col cols="12" class="d-flex justify-center">
        <v-card width="70%">
          <v-card-title>
            <v-row class="d-flex justify-center">
              <v-col cols="9">
                <!-- 本番環境では、通知送信専用のユーザーを作成する（ポートフォリオログインのユーザーとは一緒にしないように注意） -->
                <v-btn @click="createSampleNotification" block>通知サンプル作成</v-btn>
              </v-col>
            </v-row>
          </v-card-title>
          <v-card-text style="text-align: center;">
            <h4>
              ボタンを押すと通知が作成されます。通知機能の確認にお使いください。
            </h4>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <br><br>

    <v-pagination v-model="page" :length="totalPages"></v-pagination>

    <br>
    <p style="text-align: center;">
      *通知が100件を超えると古い通知から削除されます
    </p>
    <v-flex mb-5 v-for="(notification, index) in notificationsChunk" :key="'notification_' + index" data-cy="each-notifications">

      <!-- 「お気に入り」・「いいね」がされたときの通知 -->
      <div v-if="notification.action_type == 'Favorite'">

        <div v-if="notification.action_to == 'Review'">
          <favorite-notification
            :notification="notification"
            :contentUrl="`/books/${notification.review.book_id}/reviews/${notification.review.id}`"
            :contentTitle="'レビュー'"
          >
          </favorite-notification>
        </div>

        <div v-else-if="notification.action_to == 'Question'">
          <favorite-notification
            :notification="notification"
            :contentUrl="`/books/${notification.question.book_id}/questions/${notification.question.id}`"
            :contentTitle="'質問'"
          >
          </favorite-notification>
        </div>

        <div v-else-if="notification.action_to == 'Reply'">
          <favorite-notification
            :notification="notification"
            :contentUrl="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}/replies/${notification.reply.id}`"
            :contentTitle="'返信'"
          >
          </favorite-notification>
        </div>

        <div v-else-if="notification.action_to == 'SubjectQuestion'">
          <favorite-notification
            :notification="notification"
            :contentUrl="`/subjectQuestions/${notification.subject_question.id}`"
            :contentTitle="'質問(科目別)'"
          >
          </favorite-notification>
        </div>

        <div v-else-if="notification.action_to == 'SubjectQuestionReply'">
          <favorite-notification
            :notification="notification"
            :contentUrl="`/subjectQuestions/${notification.subject_question_reply.subject_question_id}/subjectQuestionReplies/${notification.subject_question_reply.id}`"
            :contentTitle="'返信(科目別)'"
          >
          </favorite-notification>
        </div>

        <div v-if="notification.action_to === 'Survey'">
          <favorite-notification
            :notification="notification"
            :contentUrl="`/surveys/${notification.survey_id}`"
            :contentTitle="'アンケート'"
          >
          </favorite-notification>
        </div>

      </div>

      <!-- 「返信」がされたときの通知 -->
      <div v-else-if="notification.action_type == 'Reply'">

        <div v-if="notification.action_to == 'Reply'">
          <reply-notification
            :notification="notification"
            :questionInNotification="notification.question"
            :replyInNotification="notification.reply"
            :questionUrl="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}`"
            :replyUrl="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}/replies/${notification.reply.id}`"
          >
          </reply-notification>
        </div>

        <div v-else-if="notification.action_to == 'SubjectQuestionReply'">
          <reply-notification
            :notification="notification"
            :questionInNotification="notification.subject_question"
            :replyInNotification="notification.subject_question_reply"
            :questionUrl="`/subjectQuestions/${notification.subject_question.id}`"
            :replyUrl="`/subjectQuestions/${notification.subject_question_reply.subject_question_id}/subjectQuestionReplies/${notification.subject_question_reply.id}`"
          >
          </reply-notification>
        </div>

      </div>

      <!-- アンケートに「回答」がされたときの通知 -->
      <div v-else-if="notification.action_type === 'SurveyAnswer'">
        <answer-to-survey-notification :notification="notification"></answer-to-survey-notification>
      </div>
    </v-flex>
    <v-pagination v-model="page" :length="totalPages"></v-pagination>
  </div>
</template>

<script>

import authCheck from '../../middleware/authCheck'
import AnswerToSurveyNotification from '../../components/notifications/AnswerToSurveyNotification.vue'
import FavoriteNotification from '../../components/notifications/FavoriteNotification.vue'
import ReplyNotification from '../../components/notifications/ReplyNotification.vue'
import userComputed from '../../mixins/userComputed'

import axios from "@/plugins/axios"

export default {
  middleware: authCheck,
  mixins: [userComputed],
  components: {
    AnswerToSurveyNotification,
    FavoriteNotification,
    ReplyNotification
  },
  async asyncData({ store }) {
    try {
      const response = await axios.get("/notifications", {
        params: {
          current_user_id: store.getters["auth/getCurrentUser"].id
        }
      })
      return {
        notifications: response.data
      }
    } catch(error) {
      console.error("エラーが発生しました:", error)
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
  },
  methods: {
    async createSampleNotification() {
      try {
        await axios.post("subject_question_replies/create_sample_notification", {
          current_user_id: this.currentUser.id,
          sample_user_id: 16,
          content: "通知確認用サンプルメッセージ"
        })
        this.$router.push({ path: "/", query: { message: "通知が作成されました" } })
      } catch(error) {
        console.error("エラーが発生しました:", error)
      }
    }

  }
}
</script>

