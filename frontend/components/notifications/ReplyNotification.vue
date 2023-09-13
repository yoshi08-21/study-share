<template>
  <div>
    <v-row class="justify-center">
      <v-col cols="10">
        <template v-if="notification.target_user_id === questionInNotification.user_id">
          <!-- 通知の対象となるユーザーが、質問の作成者の場合 -->
          <v-card min-height="100px">
            <v-row>
              <v-col cols="12">
                <v-card-subtitle style="font-size: 17px;">
                  <v-icon>mdi-comment-account-outline</v-icon>
                    <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                    <nuxt-link :to="questionUrl">あなたの質問</nuxt-link>に
                    <nuxt-link :to="replyUrl">返信</nuxt-link>しました
                </v-card-subtitle>
                <v-card-text>
                  {{ $truncate(replyInNotification.content, 100) }}
                </v-card-text>
                <v-card-actions style="justify-content: end;">
                  {{ formattedTime(notification.created_at) }}
                </v-card-actions>
              </v-col>
            </v-row>
          </v-card>
        </template>

        <template v-else>
          <!-- 通知の対象となるユーザーが、質問の作成者ではない場合 -->
          <v-card min-height="100px">
            <v-row>
              <v-col cols="12">
                <v-card-subtitle style="font-size: 17px;">
                  <v-icon>mdi-comment-account-outline</v-icon>
                    <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                    <nuxt-link :to="questionUrl">あなたが返信した質問</nuxt-link>に
                    <nuxt-link :to="replyUrl" data-cy="notification-reply-link">返信</nuxt-link>しました
                </v-card-subtitle>
                <v-card-text>
                  {{ $truncate(replyInNotification.content, 100) }}
                </v-card-text>
                <v-card-actions style="justify-content: end;">
                  {{ formattedTime(notification.created_at) }}
                </v-card-actions>
              </v-col>
            </v-row>
          </v-card>
        </template>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import moment from 'moment';

export default {
  props: {
    notification: Object,
    questionInNotification: Object,
    replyInNotification: Object,
    questionUrl: String,
    replyUrl: String
  },
  methods: {
    formattedTime(datetime) {
      return moment(datetime).format('YYYY/MM/DD HH:mm');
    }
  }

}
</script>

<style>

</style>
