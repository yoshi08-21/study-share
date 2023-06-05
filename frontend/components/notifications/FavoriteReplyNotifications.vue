<template>
  <div>
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
