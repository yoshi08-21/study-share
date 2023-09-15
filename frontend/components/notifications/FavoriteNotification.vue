<template>
  <div>
    <v-row class="justify-center">
      <v-col cols="10">
        <v-card min-height="100px">
          <v-row>
            <v-col cols="12">
              <v-card-subtitle style="font-size: 17px;">
                <v-icon>mdi-account-heart</v-icon>
                <nuxt-link :to="`/users/${notification.action_user.id}`" class="link-text">{{ notification.action_user.name }}</nuxt-link>さんが
                <nuxt-link :to="contentUrl">あなたの{{ contentTitle }}</nuxt-link>にいいね!しました
              </v-card-subtitle>
              <v-card-actions style="justify-content: end;">
                {{ formattedTime(notification.created_at) }}
              </v-card-actions>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import moment from "moment";

export default {
  props: {
    notification: Object,
    contentUrl: String,
    contentTitle: String
  },
  methods: {
    formattedTime(datetime) {
      return moment(datetime).format("YYYY/MM/DD HH:mm");
    }
  }
}
</script>

<style>

</style>
