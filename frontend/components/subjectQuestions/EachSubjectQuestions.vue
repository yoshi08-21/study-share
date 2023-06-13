<template>
  <div>
    <v-flex mb-5 v-for="(subjectQuestion, index) in subjectQuestions" :key="'subjectQuestion_' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/subjectQuestions/${subjectQuestion.id}`">
            <v-row>
              <v-col cols="2">
                <template v-if="subjectQuestion.image">
                  <v-img :src="subjectQuestion.image" alt="画像"></v-img>
                </template>
              </v-col>
              <v-col cols="10">
                <v-card-title>タイトル: {{ subjectQuestion.title }}</v-card-title>
                <v-card-text>
                  <p>{{ subjectQuestion.content }}</p>
                </v-card-text>
                <v-card-actions>
                  科目: {{ subjectQuestion.subject }}
                  <v-spacer></v-spacer>
                  by: {{ subjectQuestion.user.name }}
                </v-card-actions>
                <p>
                  返信: {{ subjectQuestion.subject_question_replies_count }}件
                  いいね!: {{ subjectQuestion.favorite_subject_questions_count }}件
                </p>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </v-flex>

  </div>
</template>

<script>
export default {
  props: {
    subjectQuestions: [],
  }
}
</script>

<style>

</style>
