<template>
  <div>
    <v-row mb-5 v-for="(subjectQuestion, index) in subjectQuestions" :key="'subjectQuestion_' + index" class="justify-center" data-cy="each-subject-questions">
      <v-col cols="10">
        <v-card
          elevation="8"
          height="250"
        >
          <v-row>
            <v-col cols="2" class="mt-8">
              <div @click="goToUser(subjectQuestion.user)" style="cursor: pointer;">
              <v-row>
                <v-col class="d-flex justify-center align-center text-center">
                  <v-avatar size="100">
                    <v-img :src="subjectQuestion.user.image" alt="画像" contain></v-img>
                  </v-avatar>
                </v-col>
              </v-row>
              <v-row>
                <v-col class="d-flex justify-center align-center text-center">
                    <span style="text-decoration: underline;">{{ $truncate(subjectQuestion.user.name, 10) }}</span>
                  </v-col>
                </v-row>
              </div>
            </v-col>
            <v-col cols="8" class="mt-n2">
              <v-card-title>
                <nuxt-link :to="`/subjectQuestions/${subjectQuestion.id}`">{{ $truncate(subjectQuestion.title, 20) }}</nuxt-link>
              </v-card-title>
              <v-card-text >
                <v-textarea
                  :value="subjectQuestion.content"
                  readonly
                  filled
                  rounded
                  dense
                  no-resize
                  rows="4"
                  style="height: 125px;"
                >
                </v-textarea>

              </v-card-text>
              <v-card-actions>

                <v-row class="d-flex align-center justify-center">
                  <v-col cols="4">
                    <v-icon>mdi-comment-text-outline</v-icon>
                    返信: {{ subjectQuestion.subject_question_replies_count }}件
                  </v-col>
                  <v-col cols="4">
                    <v-icon>mdi-heart-multiple</v-icon>
                    いいね! ({{ subjectQuestion.favorite_subject_questions_count }})
                  </v-col>
                  <v-col cols="4">
                    <v-icon>mdi-calendar-clock</v-icon>
                    {{ subjectQuestion.created_at }}
                  </v-col>
                </v-row>
                <p>
                </p>
              </v-card-actions>
            </v-col>
            <v-col cols="2" class="d-flex align-center">
              <v-card>
                <v-card-subtitle>科目・ジャンル</v-card-subtitle>
                <div @click="selectSubject(subjectQuestion.subject)" style="cursor: pointer; text-decoration: underline;">
                  <v-card-title class="justify-center">{{ subjectQuestion.subject }}</v-card-title>
                </div>
              </v-card>
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
    subjectQuestions: [],
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
    selectSubject(subject) {
      this.$emit("selectSubject", subject)
    }

  }

}
</script>

<style>

</style>
