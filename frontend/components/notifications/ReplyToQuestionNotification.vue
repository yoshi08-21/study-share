<template>
  <div>
    <v-row class="justify-center">
      <v-col cols="10">
        <template v-if="notification.target_user_id === notification.question.user_id">
          <!-- 通知の対象となるユーザーが、質問の作成者の場合 -->
          <v-card min-height="100px">
            <v-row>
              <v-col cols="12">
                <v-card-subtitle style="font-size: 17px;">
                  <v-icon>mdi-comment</v-icon>
                    <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                    <nuxt-link :to="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}`">あなたの質問</nuxt-link>に
                    <nuxt-link :to="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}/replies/${notification.reply.id}`">返信</nuxt-link>しました
                </v-card-subtitle>
                <v-card-text>
                  {{ $truncate(notification.reply.content, 100) }}
                </v-card-text>
                <v-card-actions style="justify-content: end;">
                  {{ notification.created_at }}
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
                  <v-icon>mdi-comment</v-icon>
                    <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                    <nuxt-link :to="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}`">あなたが返信した質問</nuxt-link>に
                    <nuxt-link :to="`/books/${notification.reply.question.book_id}/questions/${notification.reply.question_id}/replies/${notification.reply.id}`">返信</nuxt-link>しました
                </v-card-subtitle>
                <v-card-text>
                  {{ $truncate(notification.reply.content, 100) }}
                </v-card-text>
                <v-card-actions style="justify-content: end;">
                  {{ notification.created_at }}
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
export default {
  props: {
    notification: {}
  }
}
</script>

<style>

</style>
