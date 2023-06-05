<template>
  <div>
    <h2>通知一覧</h2>

    <br>
    <v-flex mb-5 v-for="(notification, index) in notifications" :key="'notification_' + index">

      <div v-if="notification.action_type == 'Favorite'">

        <div v-if="notification.action_to == 'Review'">
          <v-row>
            <v-col cols="10">
              <v-card>
                <v-row>
                  <v-col cols="12">
                    <p>
                      <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                      <nuxt-link :to="`/books/${notification.review.book_id}/reviews/${notification.review.id}`">あなたのレビュー</nuxt-link>にいいね!しました
                    </p>
                    <v-card-title>通知の種類: {{ notification.action_type }}</v-card-title>
                    <v-card-text>
                      <p>to: {{ notification.action_to }}</p>
                      <p>これはFavoriteに対する通知</p>
                      <p>これはReviewに対するFavorite</p>
                    </v-card-text>
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
        </div>

        <div v-else-if="notification.action_to == 'Question'">
          <v-row>
            <v-col cols="10">
              <v-card>
                <v-row>
                  <v-col cols="12">
                    <p>
                      <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                      <nuxt-link :to="`/books/${notification.question.book_id}/questions/${notification.question.id}`">あなたの質問</nuxt-link>にいいね!しました
                    </p>
                    <v-card-title>通知の種類: {{ notification.action_type }}</v-card-title>
                    <v-card-text>
                      <p>to: {{ notification.action_to }}</p>
                      <p>これはFavoriteに対する通知</p>
                      <p>これはQuestionに対するFavorite</p>
                    </v-card-text>
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
        </div>

        <div v-else-if="notification.action_to == 'Reply'">
          <v-row>
            <v-col cols="10">
              <v-card>
                <v-row>
                  <v-col cols="12">
                    <p>
                      <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                      <nuxt-link :to="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}/replies/${notification.reply.id}`">あなたの返信</nuxt-link>にいいね!しました
                    </p>
                    <v-card-title>通知の種類: {{ notification.action_type }}</v-card-title>
                    <v-card-text>
                      <p>to: {{ notification.action_to }}</p>
                      <p>これはFavoriteに対する通知</p>
                      <p>これはReplyに対するFavorite</p>
                    </v-card-text>
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
        </div>

        <div v-else-if="notification.action_to == 'SubjectQuestion'">
          <v-row>
            <v-col cols="10">
              <v-card>
                <v-row>
                  <v-col cols="12">
                    <p>
                      <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                      <nuxt-link :to="`/subjectQuestions/${notification.subject_question.id}`">あなたの質問(科目別質問)</nuxt-link>にいいね!しました
                    </p>
                    <v-card-title>通知の種類: {{ notification.action_type }}</v-card-title>
                    <v-card-text>
                      <p>to: {{ notification.action_to }}</p>
                      <p>これはFavoriteに対する通知</p>
                      <p>これはSubjectQuestionに対するFavorite</p>
                    </v-card-text>
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
        </div>

        <div v-else-if="notification.action_to == 'SubjectQuestionReply'">
          <v-row>
            <v-col cols="10">
              <v-card>
                <v-row>
                  <v-col cols="12">
                    <p>
                      <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                      <nuxt-link :to="`/subjectQuestions/${notification.subject_question_reply.subject_question_id}/subjectQuestionReplies/${notification.subject_question_reply.id}`">あなたの返信(科目別質問)</nuxt-link>にいいね!しました
                    </p>
                    <v-card-title>通知の種類: {{ notification.action_type }}</v-card-title>
                    <v-card-text>
                      <p>to: {{ notification.action_to }}</p>
                      <p>これはFavoriteに対する通知</p>
                      <p>これはSubjectQuestionReplyに対するFavorite</p>
                    </v-card-text>
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
        </div>


      </div>

      <div v-else-if="notification.action_type == 'Reply'">
        <div v-if="notification.action_to == 'Reply'">
          <v-row>
            <v-col cols="10">
              <v-card>
                <v-row>
                  <v-col cols="12">
                    <p>
                      <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                      <nuxt-link :to="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}`">あなたの質問</nuxt-link>に
                      <nuxt-link :to="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}/replies/${notification.reply.id}`">返信</nuxt-link>しました
                    </p>
                    <p>
                      →「{{ notification.reply.content }}」
                    </p>
                    <v-card-title>通知の種類: {{ notification.action_type }}</v-card-title>
                    <v-card-text>
                      <p>to: {{ notification.action_to }}</p>
                      <p>これはReplyに対する通知</p>
                      <p>これはReplyに対するReplyNotification</p>
                    </v-card-text>
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
        </div>

        <div v-else-if="notification.action_to == 'SubjectQuestionReply'">
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

      </div>



    </v-flex>
  </div>
</template>

<script>

import axios from "@/plugins/axios"

export default {
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
