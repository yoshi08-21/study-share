<template>
  <div>
    <v-row>
      <v-col cols="10">
        <v-card>
          <v-row>
            <v-col cols="12">
              <p>
                <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                <nuxt-link :to="`/surveys/${notification.survey_id}`">あなたのアンケート</nuxt-link>に回答しました
              </p>
              <v-card-title>通知の種類: {{ notification.action_type }}</v-card-title>
              <v-card-text>
                <p>to: {{ notification.action_to }}</p>
                <p>これはSurveyAnswerに対する通知</p>
                <p>これはSurveyAnswerに対するSurveyAnswerNotification</p>
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
