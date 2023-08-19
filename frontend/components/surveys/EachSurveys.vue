<template>
  <div>

    <!-- <template v-if="hideClosedSurvey === true && "></template> -->
    <v-row mb-5 v-for="(survey, index) in surveys" :key="'survey_' + index" class="justify-center">
      <template v-if="hideClosedSurvey === false || (hideClosedSurvey === true && survey.status === false)">
        <v-col cols="10">
          <v-card
            elevation="2"
            height="220"
          >
            <v-row>
              <v-col cols="12" class="mt-n2">
                <v-card-title>
                  <v-row>
                    <v-col cols="8">
                      <nuxt-link :to="`/surveys/${survey.id}`">{{ survey.title }}</nuxt-link>
                    </v-col>
                    <v-col cols="3">
                      <template v-if="survey.status === false">
                        <v-alert type="success" dense text border="left">
                          回答受付中
                        </v-alert>

                      </template>
                      <template v-else>
                        <v-alert type="error" dense text border="left">
                          締め切り済み
                        </v-alert>
                      </template>
                    </v-col>
                  </v-row>
                </v-card-title>
                <v-card-subtitle>
                  {{ $truncate(survey.content, 60) }}
                </v-card-subtitle>
                <v-card-text>
                  <h3>ジャンル: {{ survey.genre }}</h3>
                </v-card-text>
                <v-card-actions style="margin-top: -10px;">
                  <v-row class="d-flex align-center justify-center">
                    <v-col cols="3">
                      <div @click="goToUser(survey.user)" style="padding: 10px;">
                      <v-avatar>
                        <v-img :src="survey.user.image"></v-img>
                      </v-avatar>
                      <span style="text-decoration: underline;">{{ $truncate(survey.user.name, 9) }}</span>
                    </div>
                    </v-col>
                    <v-col cols="3">
                      <v-icon>mdi-comment-text-multiple</v-icon>
                      回答数:  {{ survey.survey_answers_count }}件
                    </v-col>
                    <v-col cols="3">
                      <v-icon>mdi-heart-multiple</v-icon>
                      いいね! ({{ survey.favorite_surveys_count }})
                    </v-col>
                    <v-col cols="3">
                      <v-icon>mdi-calendar-clock</v-icon>
                      {{ survey.created_at }}
                    </v-col>
                  </v-row>
                  <p>
                  </p>
                </v-card-actions>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </template>
    </v-row>

  </div>
</template>

<script>
export default {
  props: {
    surveys: [],
    hideClosedSurvey: Boolean,
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
  methods: {
    goToUser(user) {
      if( !this.currentUser || this.currentUser.id !== user.id ) {
        this.$router.push({ path: `/users/${user.id}` })
      } else {
        this.$router.push({ path: "/mypage" })
      }
    },

  }

}
</script>

<style>

</style>
