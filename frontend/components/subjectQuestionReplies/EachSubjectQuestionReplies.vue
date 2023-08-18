<template>
  <div>

    <v-row mb-5 v-for="(subjectQuestionReply, index) in subjectQuestionReplies" :key="'subjectQuestionReply_' + index" class="justify-center">
      <v-col cols="10">
        <v-card
          :to="`/subjectQuestions/${subjectQuestionReply.subject_question_id}/subjectQuestionReplies/${subjectQuestionReply.id}`"
          elevation="8"
          height="200"
        >
          <v-row>
            <v-col cols="2" class="mt-8">
              <v-row>
                <v-col class="d-flex justify-center align-center text-center">
                  <v-avatar size="80">
                    <v-img :src="subjectQuestionReply.user.image" alt="画像" contain></v-img>
                  </v-avatar>
                </v-col>
              </v-row>
              <v-row>
                <v-col class="d-flex justify-center align-center text-center">
                  <span style="text-decoration: underline;">{{ $truncate(subjectQuestionReply.user.name, 10) }}</span>
                </v-col>
              </v-row>
            </v-col>
            <v-col cols="9" class="mt-n2">
              <v-card-text>
                <v-textarea
                  :value="subjectQuestionReply.content"
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
                  <template v-if="subjectQuestionReply.image">
                    <v-col cols="3">
                      <v-icon>mdi-file-image-plus</v-icon>
                      画像
                    </v-col>
                  </template>
                  <v-col cols="3">
                    <v-icon>mdi-heart-multiple</v-icon>
                    いいね! ({{ subjectQuestionReply.favorite_subject_question_replies_count }})
                  </v-col>
                  <v-col cols="3">
                    <v-icon>mdi-calendar-clock</v-icon>
                    {{ subjectQuestionReply.created_at }}
                  </v-col>
                </v-row>
                <p>
                </p>
              </v-card-actions>
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
    subjectQuestionReplies: [],
  },
}
</script>

<style>

</style>
